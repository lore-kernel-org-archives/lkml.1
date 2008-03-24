Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbYCXDPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbYCXDPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 23:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYCXDO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 23:14:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48289 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYCXDO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 23:14:56 -0400
Date: Sun, 23 Mar 2008 20:08:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.25-rc6-git2] drm: fix printk format warning
Message-Id: <20080323200841.bffe46db.randy.dunlap@oracle.com>
In-Reply-To: <20080318141411.201fa1a1.randy.dunlap@oracle.com>
References: <20080318141411.201fa1a1.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping.


On Tue, 18 Mar 2008 14:14:11 -0700 Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix gcc printk format warning:
> drivers/char/drm/ati_pcigart.c:125: warning: format '%08X' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
> 
> but doesn't the %08 leave room for truncation?
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/char/drm/ati_pcigart.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.25-rc6-git2.orig/drivers/char/drm/ati_pcigart.c
> +++ linux-2.6.25-rc6-git2/drivers/char/drm/ati_pcigart.c
> @@ -122,8 +122,9 @@ int drm_ati_pcigart_init(struct drm_devi
>  	} else {
>  		address = gart_info->addr;
>  		bus_address = gart_info->bus_addr;
> -		DRM_DEBUG("PCI: Gart Table: VRAM %08X mapped at %08lX\n",
> -			  bus_address, (unsigned long)address);
> +		DRM_DEBUG("PCI: Gart Table: VRAM %08llX mapped at %08lX\n",
> +			  (unsigned long long)bus_address,
> +			  (unsigned long)address);
>  	}
>  
>  	pci_gart = (u32 *) address;
> --

---
~Randy
