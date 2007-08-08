Return-Path: <linux-kernel-owner+w=401wt.eu-S1765018AbXHHWWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765018AbXHHWWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759496AbXHHWWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:22:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2334 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646AbXHHWWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:22:17 -0400
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
	added to -mm tree
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com,
       jeff@garzik.org
In-Reply-To: <Pine.LNX.4.64.0708082345320.10387@fbirervta.pbzchgretzou.qr>
References: <tI4NY5SL.1186153543.0764100.khali@localhost>
	 <1186179369.13852.36.camel@localhost>
	 <20070807131949.fa060048.akpm@linux-foundation.org>
	 <20070808220226.1dc03a67@hyperion.delvare>
	 <1186605086.11897.67.camel@localhost>
	 <Pine.LNX.4.64.0708082237210.10387@fbirervta.pbzchgretzou.qr>
	 <1186608977.3073.30.camel@localhost>
	 <Pine.LNX.4.64.0708082345320.10387@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 15:21:53 -0700
Message-Id: <1186611713.3073.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 23:57 +0200, Jan Engelhardt wrote:
> fs/freevxfs/vxfs_bmap.c:line 169 (near "case VXFS_TYPED_DATA_DEV4")
> 
>                         printk(KERN_INFO "\n\nTYPED_DEV4 detected!\n");
> Seems normal.

The second output log line of the first printk isn't prefixed
with KERN_INFO.  It's output with log_level_unknown.

> So it looks like your regex has some false positives.
> (which nothing can be done about - the 61 must be hand-sorted)

Must have copy/pasted the wrong regex

$ egrep -r "printk[[:space:]]*\([[:space:]]*KERN.*\\\n[A-JL-Za-jl-z[:space:]]" --include=*.[ch] * | wc -l
61

> [My idea is above]

Any sequence of printks can be interleaved.  I don't see
how your suggestion changes that.

> >Maybe an external tool to reassemble complete messages from
> >prefixed {{cookie}} message logs would be fine for awhile.
> >
> >Perhaps something like:
> >
> >cookie = printk_block_start()
> >printk_block[s](cookie)
> >printk_block_end(cookie)?
> >
> >where printk_block emits cookie when multiple cookies
> >are active.
> 
> How is this supposed to work? Are you suggesting that the printk buffer is
> locked?

No, just another identifier placed into logs that allow messages
to be reassembled into something readable when multiple printk_block's
are active.

> Now, if you hold the output of a printk block until it's _end()
> counterpart is executed, the user does not get any output when the
> machine locks up during the for loop.

External tool scans logs.  No blocking or delay in output.

cheers,  Joe

