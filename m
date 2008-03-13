Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYCMUcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYCMUcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbYCMUcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:32:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50177 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbYCMUb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:31:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: fix aperture vs. suspend problem
Date: Thu, 13 Mar 2008 21:31:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ak@suse.de, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080313100531.GA3399@elf.ucw.cz>
In-Reply-To: <20080313100531.GA3399@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132131.10848.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of March 2008, Pavel Machek wrote:
> 
> aperture_64.c takes a piece of memory and makes it into iommu
> window... but such window may not be saved by swsusp -- that leads to
> oops during suspend.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>

> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 608152a..88747f3 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -18,6 +18,7 @@ #include <linux/pci_ids.h>
>  #include <linux/pci.h>
>  #include <linux/bitops.h>
>  #include <linux/ioport.h>
> +#include <linux/suspend.h>
>  #include <asm/e820.h>
>  #include <asm/io.h>
>  #include <asm/gart.h>
> @@ -76,6 +77,7 @@ static u32 __init allocate_aperture(void
>  	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
>  			aper_size >> 10, __pa(p));
>  	insert_aperture_resource((u32)__pa(p), aper_size);
> +	register_nosave_region((u32)__pa(p) >> PAGE_SHIFT, (u32)__pa(p+aper_size) >> PAGE_SHIFT);
>  
>  	return (u32)__pa(p);
>  }
> 
