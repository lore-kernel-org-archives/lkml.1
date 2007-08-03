Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbXHCHi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbXHCHi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXHCHiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:38:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbXHCHiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:38:20 -0400
Date: Fri, 3 Aug 2007 00:37:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Keith Owens <kaos@ocs.com.au>
Cc: vgoyal@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Takenori Nagano <t-nagano@ah.jp.nec.com>, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] add kdump_after_notifier
Message-Id: <20070803003743.1de639b3.akpm@linux-foundation.org>
In-Reply-To: <2462.1186122844@kao2.melbourne.sgi.com>
References: <20070802232502.b93f4ea0.akpm@linux-foundation.org>
	<2462.1186122844@kao2.melbourne.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 16:34:04 +1000 Keith Owens <kaos@ocs.com.au> wrote:

> Andrew Morton (on Thu, 2 Aug 2007 23:25:02 -0700) wrote:
> >On Fri, 03 Aug 2007 14:05:47 +1000 Keith Owens <kaos@sgi.com> wrote:
> 
> Switching to kaos@ocs.com.au, I just resigned from SGI.
> 
> >> I have pretty well given up on RAS code in the Linux kernel.  Everybody
> >> has different ideas, there is no overall plan and little interest from
> >> Linus in getting RAS tools into the kernel.  We are just thrashing.
> >
> >Lots of different groups, little commonality in their desired funtionality,
> >little interest in sharing infrastructure or concepts.  Sometimes people
> >need a bit of motivational help.
> >
> >In this case that motivation would come from the understanding that all the
> >RAS tools would be *required* to use such infrastructure if it was merged. 
> >Going off and open-coding your own stuff would henceforth not be acceptable.
> >If it turns out that it really was unsuitable for a particular group's RAS
> >feature, and we merged it anyway, well, that mismatch is that group's
> >fault.
> >
> >It was a sizeable mistake to send those patches to a few obscure mailing
> >lists - this is the first I've heard of it, for example.
> 
> linux-arch is obscure?? 

Exceedingly.  It's a way of contacting arch maintainers, that's all.  It
isn't really a place to discuss new infrastructural concepts which affect
multiple features.

> Where else do you send patches that affect
> multiple architectures?

This should have gone to linux-kernel.

> >So.  Please, send it all again, copy the correct lists and people, make sure
> >that at least one client of the infrastructure is wired up and working (ideally,
> >all such in-kernel clients should be wired up) and let's take a look at it.
> 
> Already tried that.  The only RAS tool that is currently in the kernel is
> kexec/kdump and they insist on doing things their own way.  That makes
> it impossible to put a common RAS structure in place, because kexec
> will not use it.

eh, write the patch for them, let's look at how much impact it is likely to
have.

> Sorry to keep beating on this drum, but kexec insist that their code
> must have priority and that they do not trust the rest of the kernel.
> Until that changes, there is no point is discussing how to make kexec
> coexist with other RAS tools.  If kexec change their mind then we can
> look at using a common RAS interface, otherwise it is a waste of time
> and I have better things to do with my life.

I saw one email from Vivek expressing on-general-principle concerns.  It
was hardly thorough or irreconcilable-looking.

Let's drag this thing into the daylight and poke at it a bit.
