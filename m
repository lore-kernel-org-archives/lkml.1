Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbXGDNql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbXGDNql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbXGDNqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:46:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:60974 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758188AbXGDNqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:46:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,497,1175497200"; 
   d="scan'208";a="246522368"
Subject: Re: [PATCH 2.6.21 3/3] x86_64 EFI64 support Try #2
From: "Huang, Ying" <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de,
       "Antonino A. Daplas" <adaplas@pol.net>
In-Reply-To: <20070703163125.21114ad2.akpm@linux-foundation.org>
References: <20070702170614.769378000@em64tdvp.jf.intel.com>
	 <20070702170708.062695000@em64tdvp.jf.intel.com>
	 <20070703163125.21114ad2.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Jul 2007 21:45:37 +0000
Message-Id: <1183585537.16719.31.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 04 Jul 2007 13:46:28.0789 (UTC) FILETIME=[B8EAB650:01C7BE41]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 16:31 -0700, Andrew Morton wrote:
> On Mon, 02 Jul 2007 10:06:17 -0700
> Chandramouli Narayanan <mouli@linux.intel.com> wrote:
> 
> > EFI x86_64 support Patch 3 of 3 (try #2)
> > ----------------------------------------
> > - Fixed redundant check in efifb_init().
> > 
> > This patch depends on the EFI x86_64 patches 1/3 and 2/3.
> > 
> > This patch adds Graphics Output Protocol support to the kernel.
> > x86_64 systems with UEFI2.0 firmware conform to UEFI 2.0 specification.
> > UEFI2.0 spec deprecates Universal Graphics Adapter (UGA) protocol and
> > only Graphics Output Protocol (GOP) is produced. Therefore, the boot loader
> > needs to query the UEFI firmware with appropriate Output Protocol and
> > pass the video information to the kernel. As a result of GOP
> > protocol, an EFI framebuffer driver is needed for displaying console messages.
> > Patch 3 of 3 adds a EFI framebuffer driver. The EFI frame buffer driver in this
> > patch is based on the Intel Mac framebuffer driver.
> > 
> > The x86_64 ELILO bootloader takes care of passing the video information
> > as appropriate for EFI firmware. 
> > 
> 
> That's more like a changelog.
> 
> Please cc linux-fbdev-devel@lists.sourceforge.net and "Antonino A.  Daplas"
> <adaplas@pol.net> on framebuffer driver patches.

Ok, will cc them.

> >  
> > +config FB_EFI
> > +	bool "EFI-based Framebuffer Support"
> > +	depends on (FB = y) && X86 && EFI
> 
> So this is selectable on i386 as well.  Has it been tested there?

I will test it.

> > +
> > +#include <linux/delay.h>
> > +#include <linux/errno.h>
> > +#include <linux/fb.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/ioport.h>
> > +#include <linux/mm.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/screen_info.h>
> > +#include <linux/slab.h>
> > +#include <linux/string.h>
> > +#include <linux/dmi.h>
> > +#include <linux/efi.h>
> > +
> > +#include <asm/io.h>
> 
> checkpatch.pl will save me work.

Sorry, the next version will be checked with checkpatch.pl firstly.

> > +#ifndef __i386__
> > +	//screen_info.imacpm_seg = 0;
> > +#endif
> 
> hmm.
> 
> > +
> > +	if (!request_mem_region(efifb_fix.smem_start, size_total, "efifb")) {
> > +		printk(KERN_WARNING
> > +		       "efifb: cannot reserve video memory at 0x%lx\n",
> > +			efifb_fix.smem_start);
> 
> KERN_ERR?
> 
> 
Best Regards,
Huang, Ying
