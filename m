Return-Path: <linux-kernel-owner+w=401wt.eu-S934460AbYETP1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbYETP1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934190AbYETP0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:26:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933937AbYETP0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:26:49 -0400
Date: Tue, 20 May 2008 11:06:04 -0400
From: Dave Jones <davej@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: aperture_64: use symbolic constants
Message-ID: <20080520150604.GD4843@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20080519123952.GA23118@elf.ucw.cz> <20080519125425.GD13546@elte.hu> <20080520142717.GA22794@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520142717.GA22794@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 04:27:17PM +0200, Pavel Machek wrote:


 > +static inline int aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
 > +{
 > +	if (!aper_base)
 > +		return 0;
 > +
 > +	if (aper_base + aper_size > 0x100000000ULL) {
 > +		printk(KERN_ERR "Aperture beyond 4GB. Ignoring.\n");
 > +		return 0;
 > +	}
 > +	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RAM)) {
 > +		printk(KERN_ERR "Aperture pointing to e820 RAM. Ignoring.\n");
 > +		return 0;
 > +	}
 > +	if (aper_size < min_size) {
 > +		printk(KERN_ERR "Aperture too small (%d MB) than (%d MB)\n",
 > +				 aper_size>>20, min_size>>20);
 > +		return 0;
 > +	}
 > +
 > +	return 1;
 > +}

Instead of making this an inline, we could add it to the agpgart code
and export it, and have the gart-iommu code call it.
You can't build the IOMMU code without agpgart anyway, and having this inlined
in both places seems a bit wasteful.
Additionally, it would mean not having a function in a header file,
which always strikes me as a wrong thing to do.

	Dave

-- 
http://www.codemonkey.org.uk
