Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYCMWiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYCMWiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbYCMWiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:38:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51587 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbYCMWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:38:08 -0400
Date: Thu, 13 Mar 2008 23:38:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       len.brown@intel.com, stable@kernel.org
Subject: Re: fix aperture vs. suspend problem
Message-ID: <20080313223845.GC8115@elf.ucw.cz>
References: <20080313100531.GA3399@elf.ucw.cz> <20080313153248.f43bbce3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313153248.f43bbce3.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-13 15:32:48, Andrew Morton wrote:
> On Thu, 13 Mar 2008 11:05:31 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > 
> > aperture_64.c takes a piece of memory and makes it into iommu
> > window... but such window may not be saved by swsusp -- that leads to
> > oops during suspend.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> > index 608152a..88747f3 100644
> > --- a/arch/x86/kernel/aperture_64.c
> > +++ b/arch/x86/kernel/aperture_64.c
> > @@ -18,6 +18,7 @@ #include <linux/pci_ids.h>
> >  #include <linux/pci.h>
> >  #include <linux/bitops.h>
> >  #include <linux/ioport.h>
> > +#include <linux/suspend.h>
> >  #include <asm/e820.h>
> >  #include <asm/io.h>
> >  #include <asm/gart.h>
> > @@ -76,6 +77,7 @@ static u32 __init allocate_aperture(void
> >  	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
> >  			aper_size >> 10, __pa(p));
> >  	insert_aperture_resource((u32)__pa(p), aper_size);
> > +	register_nosave_region((u32)__pa(p) >> PAGE_SHIFT, (u32)__pa(p+aper_size) >> PAGE_SHIFT);
> >  
> >  	return (u32)__pa(p);
> >  }
> > 
> 
> This is also needed in 2.6.24, perhaps earlier?

It seems to only trigger on >3GB boxes, during swsusp. People are not
normally suspending those big boxes. I do not think this is worth
backporting.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
