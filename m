Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZBDAjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZBDAjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZBDAjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:39:11 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:62135 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZBDAjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:39:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=wlDj/j//BonR2Pvyt/8H6Et5sxrMifFkRBBRhrnsnQ//zve6qrBsryBbBJ2RVT3aQC
         GlraTKf6MidMAX0CCL3cOjK7ixWXaWhGmSR4csFxugyDVSr5CrEhPwfRQbyaauiElYOx
         AsNHuTPW1y3y362lW+zF1h2Mo+KsxDAKs6fJw=
Date: Tue, 3 Feb 2009 19:38:59 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-laptop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <200902032315.27113.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0902031937070.7758@parag-laptop>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200902031029.30739.rjw@sisk.pl> <alpine.DEB.2.00.0902031622070.5481@parag-desktop> <200902032315.27113.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:

> 
> Can you also test this one instead and tell me if it still works?
> 

Removing Linus' patch and applying the below one works as well.

Parag
 
> ---
>  drivers/pci/pcie/portdrv_pci.c |   16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
> 
> Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
> +++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
> @@ -55,25 +55,13 @@ static int pcie_portdrv_suspend(struct p
>  
>  }
>  
> -static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
> -{
> -	return pci_save_state(dev);
> -}
> -
> -static int pcie_portdrv_resume_early(struct pci_dev *dev)
> -{
> -	return pci_restore_state(dev);
> -}
> -
>  static int pcie_portdrv_resume(struct pci_dev *dev)
>  {
> -	pcie_portdrv_restore_config(dev);
> +	pci_set_master(dev);
>  	return pcie_port_device_resume(dev);
>  }
>  #else
>  #define pcie_portdrv_suspend NULL
> -#define pcie_portdrv_suspend_late NULL
> -#define pcie_portdrv_resume_early NULL
>  #define pcie_portdrv_resume NULL
>  #endif
>  
> @@ -292,8 +280,6 @@ static struct pci_driver pcie_portdriver
>  	.remove		= pcie_portdrv_remove,
>  
>  	.suspend	= pcie_portdrv_suspend,
> -	.suspend_late	= pcie_portdrv_suspend_late,
> -	.resume_early	= pcie_portdrv_resume_early,
>  	.resume		= pcie_portdrv_resume,
>  
>  	.err_handler 	= &pcie_portdrv_err_handler,
> 
> 
