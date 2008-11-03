Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYKCUm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYKCUm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYKCUmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:42:47 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:47154 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbYKCUmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:42:45 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: stable@kernel.org
Subject: Re: [patch] fix 64-vbit prefetchable memory resource BARs
Date: Mon, 3 Nov 2008 14:42:10 -0600
User-Agent: KMail/1.9.10
Cc: Peter Chubb <peterc@gelato.unsw.edu.au>, matthew@wil.cx,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <8763nx1fr3.wl%peter@chubb.wattle.id.au>
In-Reply-To: <8763nx1fr3.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031342.11018.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 October 2008 06:49:04 pm Peter Chubb wrote:
> Since patch 6ac665c63dcac8fcec534a1d224ecbb8b867ad59
> my infiniband controller hasn't worked.  This is because it has
> 64-bit prefetchable memory, which was mistakenly being  taken to be
> 32-bit memory.  The resource flags in this case are
> PCI_BASE_ADDRESS_MEM_TYPE_64|PCI_BASE_ADDRESS_MEM_PREFETCH.
> 
> This patch checks only for the PCI_BASE_ADDRESS_MEM_TYPE_64 bit; thus
> whether the region is prefetchable or not is ignored.  This fixes my
> Infiniband.

I think this patch needs to be put in a 2.6.27-stable release.

Without it, we ignore the upper bits of 64-bit prefetchable BARs.

This is commit e354597cce8d219d135d65e585dc4f30323486b9 in Linus's
tree.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e354597cce8d219d135d65e585dc4f30323486b9

> Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
> 
> Index: linux-2.6-git/drivers/pci/probe.c
> ===================================================================
> --- linux-2.6-git.orig/drivers/pci/probe.c	2008-10-13 10:49:46.012798465 +1100
> +++ linux-2.6-git/drivers/pci/probe.c	2008-10-13 11:35:43.016329442 +1100
> @@ -219,7 +219,7 @@
>  
>  	res->flags = bar & ~PCI_BASE_ADDRESS_MEM_MASK;
>  
> -	if (res->flags == PCI_BASE_ADDRESS_MEM_TYPE_64)
> +	if (res->flags & PCI_BASE_ADDRESS_MEM_TYPE_64)
>  		return pci_bar_mem64;
>  	return pci_bar_mem32;
>  }
> 
> 
> --
> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
> http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


