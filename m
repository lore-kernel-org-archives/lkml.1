Return-Path: <linux-kernel-owner+w=401wt.eu-S934135AbYETPf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135AbYETPf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbYETPbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:31:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58029 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933788AbYETPbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:31:17 -0400
Date: Tue, 20 May 2008 17:32:15 +0200
From: Pavel Machek <pavel@suse.cz>
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: aperture_64: use symbolic constants
Message-ID: <20080520153215.GA5368@elf.ucw.cz>
References: <20080519123952.GA23118@elf.ucw.cz> <20080519125425.GD13546@elte.hu> <20080520142717.GA22794@elf.ucw.cz> <20080520150604.GD4843@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520150604.GD4843@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  > +static inline int aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
>  > +{
>  > +	if (!aper_base)
>  > +		return 0;
>  > +
>  > +	if (aper_base + aper_size > 0x100000000ULL) {
>  > +		printk(KERN_ERR "Aperture beyond 4GB. Ignoring.\n");
>  > +		return 0;
>  > +	}
>  > +	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RAM)) {
>  > +		printk(KERN_ERR "Aperture pointing to e820 RAM. Ignoring.\n");
>  > +		return 0;
>  > +	}
>  > +	if (aper_size < min_size) {
>  > +		printk(KERN_ERR "Aperture too small (%d MB) than (%d MB)\n",
>  > +				 aper_size>>20, min_size>>20);
>  > +		return 0;
>  > +	}
>  > +
>  > +	return 1;
>  > +}
> 
> Instead of making this an inline, we could add it to the agpgart code
> and export it, and have the gart-iommu code call it.
> You can't build the IOMMU code without agpgart anyway, and having this inlined
> in both places seems a bit wasteful.
> Additionally, it would mean not having a function in a header file,
> which always strikes me as a wrong thing to do.

Can you elaborate? Yes, it would be nicer if this went to .c
somewhere, but aperture_64.c seems unsuitable (we need it on 32-bit,
too, right?)... plus it was __init in one place, and __devinit in the
other, so I figured out "inline it so that it works automagically".

Plus, I don't think it should go into drivers/agp, as iommu code in
arch/x86/kernel seems to be able to work without that...?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
