Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbXIFMG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbXIFMG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbXIFMGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:06:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:59747 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200AbXIFMGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:06:16 -0400
Subject: Re: [PATCH 4/4] radeonfb: use PCI device Id in hex for name string
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: aherrman@arcor.de
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070904110050.GH7320@devil>
References: <20070904110050.GH7320@devil>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 15:48:07 +0200
Message-Id: <1188913688.5972.155.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-04 at 13:00 +0200, aherrman@arcor.de wrote:
> .. instead of potentially using nonprintable characters.
> 
> I guess the former (odd) concatenation was used to construct name strings
> that match the  "*_ATI_RADEON_??" macros in include/linux/pci_ids.h
> 
> The PCI Id in hex is much more convenient to use. E.g. it can easily be
> verified against "lspci -nn" output.
> 
> Signed-off-by: Andreas Herrmann <aherrman@arcor.de>

Well... ATI used to have printable characters and those were commonly
used to identify the cards. I'm not sure we want to unilateraly switch
to hex here...

Ben.

> ---
>  drivers/video/aty/radeon_base.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
> index 71b0c17..e6229b4 100644
> --- a/drivers/video/aty/radeon_base.c
> +++ b/drivers/video/aty/radeon_base.c
> @@ -2184,9 +2184,8 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
>  	rinfo->lvds_timer.function = radeon_lvds_timer_func;
>  	rinfo->lvds_timer.data = (unsigned long)rinfo;
>  
> -	strcpy(rinfo->name, "ATI Radeon XX ");
> -	rinfo->name[11] = ent->device >> 8;
> -	rinfo->name[12] = ent->device & 0xFF;
> +	snprintf(rinfo->name, sizeof(rinfo->name),
> +		 "ATI Radeon %x", ent->device & 0xffff);
>  	rinfo->family = ent->driver_data & CHIP_FAMILY_MASK;
>  	rinfo->chipset = pdev->device;
>  	rinfo->has_CRTC2 = (ent->driver_data & CHIP_HAS_CRTC2) != 0;

