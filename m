Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYJIVTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYJIVTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYJIVSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:18:51 -0400
Received: from colo.lackof.org ([198.49.126.79]:38368 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbYJIVSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:18:50 -0400
Date: Thu, 9 Oct 2008 15:18:37 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
Message-ID: <20081009211837.GC18444@colo.lackof.org>
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 04:02:23PM -0700, Yinghai Lu wrote:
> so can find out what is DMA mask is used for pci devices in addition to
> default setting.

I like the idea. I don't like the additional boot time output.

But I'm thinking this could be an option to lspci.
lspci already knows about the /sys tree. Can PCI export the two masks
(dma_mask and dma_consistent_mask) and something like "lspci -td"
would dump those in a nice way?

Anyone else agree?

thanks,
grant

> 
> got:
> ehci_hcd 0000:00:02.1: using 31bit consistent DMA mask
> e1000 0000:0b:01.0: using 64bit DMA mask
> e1000 0000:0b:01.0: using 64bit consistent DMA mask
> e1000e 0000:04:00.0: using 64bit DMA mask
> e1000e 0000:04:00.0: using 64bit consistent DMA mask
> ixgb 0000:0c:01.0: using 64bit DMA mask
> ixgb 0000:0c:01.0: using 64bit consistent DMA mask
> aacraid 0000:86:00.0: using 32bit DMA mask
> aacraid 0000:86:00.0: using 32bit consistent DMA mask
> aacraid 0000:86:00.0: using 64bit DMA mask
> aacraid 0000:86:00.0: using 64bit consistent DMA mask
> qla2xxx 0000:0c:02.0: using 64bit consistent DMA mask
> qla2xxx 0000:0c:02.1: using 64bit consistent DMA mask
> lpfc 0000:06:00.0: using 64bit DMA mask
> lpfc 0000:06:00.1: using 64bit DMA mask
> pata_amd 0000:00:06.0: using 32bit DMA mask
> pata_amd 0000:00:06.0: using 32bit consistent DMA mask
> mptsas 0000:0c:04.0: using 64bit DMA mask
> mptsas 0000:0c:04.0: using 64bit consistent DMA mask
> 
> forcedeth 0000:00:08.0: using 39bit DMA mask
> forcedeth 0000:00:08.0: using 39bit consistent DMA mask
> niu 0000:02:00.0: using 44bit DMA mask
> niu 0000:02:00.0: using 44bit consistent DMA mask
> sata_nv 0000:00:05.0: using 32bit DMA mask
> sata_nv 0000:00:05.0: using 32bit consistent DMA mask
> ib_mthca 0000:03:00.0: using 64bit DMA mask
> ib_mthca 0000:03:00.0: using 64bit consistent DMA mask
> 
> wondering why: qlogic qla2xxx only set consistent to 64bit,
> 	       emulex lpfc not set consistent to 64bit
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/pci.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -1660,6 +1660,8 @@ pci_set_dma_mask(struct pci_dev *dev, u6
>  		return -EIO;
>  
>  	dev->dma_mask = mask;
> +	dev_printk(KERN_DEBUG, &dev->dev, "using %dbit DMA mask\n",
> +		 fls64(mask));
>  
>  	return 0;
>  }
> @@ -1671,6 +1673,8 @@ pci_set_consistent_dma_mask(struct pci_d
>  		return -EIO;
>  
>  	dev->dev.coherent_dma_mask = mask;
> +	dev_printk(KERN_DEBUG, &dev->dev, "using %dbit consistent DMA mask\n",
> +		 fls64(mask));
>  
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
