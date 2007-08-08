Return-Path: <linux-kernel-owner+w=401wt.eu-S938436AbXHHVhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938436AbXHHVhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936322AbXHHVgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:36:51 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2295 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935604AbXHHVgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:36:47 -0400
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
	added to -mm tree
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com,
       jeff@garzik.org
In-Reply-To: <Pine.LNX.4.64.0708082237210.10387@fbirervta.pbzchgretzou.qr>
References: <tI4NY5SL.1186153543.0764100.khali@localhost>
	 <1186179369.13852.36.camel@localhost>
	 <20070807131949.fa060048.akpm@linux-foundation.org>
	 <20070808220226.1dc03a67@hyperion.delvare>
	 <1186605086.11897.67.camel@localhost>
	 <Pine.LNX.4.64.0708082237210.10387@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 14:36:16 -0700
Message-Id: <1186608977.3073.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 22:39 +0200, Jan Engelhardt wrote:
> I fail to see what problem these are trying to fix. 

Any code that does the equivalent of printk(KERN_foo "\n message");

egrep -r "printk[[:space:]]*\([[:space:]]*KERN.*\\\n[A-JL-Za-jl-z[:space:]" --include=*.[ch] *

At least 61 instances right now.

> Please post some broken code that would 'benefit' from pr_halleluja,
> and why printk(level ) could not do the same.

"Could" most always leads to an interesting argument.

Future minimization of introduced error is a benefit
not an absolute.

Adding the ability to log higher priority KERN_<level>
without removing printk altogether for embedded systems
seems useful.  You could leave out say just KERN_INFO,
KERN_NOTICE and KERN_WARN levels.

Worth the churn is another question, though git seems to
allow most everyone to resync to tree wide changes pretty
easily.

If new pr_<level> defines aren't accepted, I suggest
removing the current ~200 uses of pr_info.

> >8 Minimization/elimination of interleaved log messages
> 
> This is a separate, and worthwhile, thing to do, yes.
> And it can be done without deviating from the regular printk().

I'm not sure how.  Maybe you have an idea you could share?

Maybe an external tool to reassemble complete messages from
prefixed {{cookie}} message logs would be fine for awhile.

Perhaps something like:

cookie = printk_block_start()
printk_block[s](cookie)
printk_block_end(cookie)?

where printk_block emits cookie when multiple cookies
are active.

cheers,  Joe

