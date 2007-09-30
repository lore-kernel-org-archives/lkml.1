Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbXI3KMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbXI3KMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 06:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbXI3KL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 06:11:58 -0400
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:63565 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750946AbXI3KL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 06:11:57 -0400
Date: Sun, 30 Sep 2007 12:11:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Message-ID: <20070930121153.28dafb08@hyperion.delvare>
In-Reply-To: <20070929035156.cd6fe860.akpm@linux-foundation.org>
References: <20070929122530.5c45f743@hyperion.delvare>
	<20070929035156.cd6fe860.akpm@linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sat, 29 Sep 2007 03:51:56 -0700, Andrew Morton wrote:
> On Sat, 29 Sep 2007 12:25:30 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Remove a not particularly relevant rule from CodingStyle.
> > Sometimes, printing numbers in parentheses doesn't add value, but in
> > some (most?) cases it makes the message easier to read. As a matter of
> > fact, this practice is widely used in the kernel:
> > 
> > linux-2.6.23-rc8$ quilt grep -I '(%l*[du])' | wc -l
> > 3166
> > linux-2.6.23-rc8$
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > ---
> >  Documentation/CodingStyle |    2 --
> >  1 file changed, 2 deletions(-)
> > 
> > --- linux-2.6.23-rc8.orig/Documentation/CodingStyle	2007-07-23 16:44:32.000000000 +0200
> > +++ linux-2.6.23-rc8/Documentation/CodingStyle	2007-09-28 23:53:23.000000000 +0200
> > @@ -638,8 +638,6 @@ concise, clear, and unambiguous.
> >  
> >  Kernel messages do not have to be terminated with a period.
> >  
> > -Printing numbers in parentheses (%d) adds no value and should be avoided.
> > -
> >  There are a number of driver model diagnostic macros in <linux/device.h>
> >  which you should use to make sure messages are matched to the right device
> >  and driver, and are tagged with the right level:  dev_err(), dev_warn(),
> 
> I wonder how that got there.
> 
> Printing something like
> 
> 	bytes remaining: 0x12 (18)
> 
> is a quite logical thing to do, although pretty darm pointless.
> 
> 
> otoh, looking at the various instances, we have lots of stuff like this:
> 
> 
>   printk(KERN_ERR "seq-oss: unable to delete queue %d (%d)\n", queue, rc);
> 
> which I would argue is wrong and is inconsistent with most other error
> reporting.  It should be
> 
> 	unable to delete queue %d: %d

I disagree. Reporting an error code is precisely the case where I think
(%d) is valuable. A colon suggests that an understandable explanation
follows, while an error code isn't that understandable. What I expect
as a user is:

	Read failed: I/O error

but:

	Read failed (-5)

And I thought this was the usual convention, too, but you seem to
disagree.

> And this:
> 
> 	printk(KERN_ERR "%s:  context size (%u) exceeds payload "
> 
> doesn't need the parens

Agreed.

> Here:
> 
> 	printk("hardirqs last  enabled at (%u): ", curr->hardirq_enable_event);
> 	print_ip_sym(curr->hardirq_enable_ip);
> 	printk("hardirqs last disabled at (%u): ", curr->hardirq_disable_event);
> 	print_ip_sym(curr->hardirq_disable_ip);
> 	printk("softirqs last  enabled at (%u): ", curr->softirq_enable_event);
> 	print_ip_sym(curr->softirq_enable_ip);
> 	printk("softirqs last disabled at (%u): ", curr->softirq_disable_event);
> 	print_ip_sym(curr->softirq_disable_ip);
> 
> all the parens are just illogical and should be removed.

Agreed.

> Here:
> 
> 		xlog_warn("XFS: %s: unrecognised log version (%d).",
> 			__FUNCTION__, INT_GET(rhead->h_version, ARCH_CONVERT));
> 
> should use "unrecognised log version: %d"

I'm fine both ways.

> This:
> 
> 		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n",
> 		       cmp_id, ocu_i->u_name);
> 
> should use colon as well.
> 
> 
> So in fact a large number of the instances I see in there are illogical and
> basically gramatically wrong and should be converted to use a colon.

I would be fine having one or more explicit rules in CodingStyle on how
log messages should be formatted, if you think it adds value. But a
general statement "don't do foo" when it's sometimes just fine to do
foo, doesn't add any value IMHO.

-- 
Jean Delvare
