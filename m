Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYD2EOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYD2EOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 00:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbYD2EOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 00:14:32 -0400
Received: from mail.suse.de ([195.135.220.2]:37675 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbYD2EOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:14:31 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 14:14:46 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18454.41142.654638.785292@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bernd Schubert <bernd-schubert@gmx.de>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 008 of 9] md: md: raid5 rate limit error printk
In-Reply-To: message from Andrew Morton on Monday April 28
References: <20080429133104.20146.patches@notabene>
	<1080429033534.20399@suse.de>
	<20080428205522.28dce527.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 28, akpm@linux-foundation.org wrote:
> On Tue, 29 Apr 2008 13:35:34 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > +			printk_rl(KERN_WARNING "raid5:%s: read error NOT corrected!! "
> > +				  "(sector %llu on %s).\n",
> > +				  mdname(conf->mddev),
> > +				  (unsigned long long)(sh->sector + rdev->data_offset),
> > +				  bdn);
> >  		else if (atomic_read(&rdev->read_errors)
> >  			 > conf->max_nr_stripes)
> >  			printk(KERN_WARNING
> > 
> > diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
> > --- .prev/include/linux/raid/md_k.h	2008-04-29 12:25:24.000000000 +1000
> > +++ ./include/linux/raid/md_k.h	2008-04-29 12:27:58.000000000 +1000
> > @@ -368,6 +368,9 @@ static inline void safe_put_page(struct 
> >  	if (p) put_page(p);
> >  }
> >  
> > +#define printk_rl  printk_ratelimit() ?: printk
> 
> (boggle)

You don't like the "?:" operator?

Maybe
   printk_ratelimit() && printk
?

> 
> Isn't this backwards?  Should be !printk_ratelimit()?

Arggg.. Did I do that?  Bother.

> 
> open-coding the printk_ratelimit() at each callsite would be more
> conventional.

True, but it can get noisy, adding an extra level of indent where it
isn't really needed (and the printk lines tend to be fairly long
already).

NeilBrown
