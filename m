Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXGNFxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXGNFxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 01:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXGNFxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 01:53:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:29480 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXGNFxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 01:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mdoVm9nXpHjdyurvZgi2eotPjWPrXIwGonbkOs1CMseww9qwdg0RTm9DvjCDb0vHEqmddafpTQmwrO686xeHEEp/WMXEJPUQv5Y8LmwvhYcq7HPHRk94P2D5W57IE2QrQjPvN82d2fT5WLVwlFgIwTT/Z5TMgZ8JXki01s18rpc=
Message-ID: <469864DC.7040305@gmail.com>
Date: Sat, 14 Jul 2007 07:53:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: LKML <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 12/12] drivers/isdn/hisax/w6692.c: replace pci_find_device
 with pci_get_device
References: <200707140144.58514.caglar@pardus.org.tr>
In-Reply-To: <200707140144.58514.caglar@pardus.org.tr>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur napsal(a):
> Following patch replaces pci_find_device with pci_get_device to avoid 
> following compiliation warning;
> 
> drivers/isdn/hisax/w6692.c: In function `setup_w6692':
> drivers/isdn/hisax/w6692.c:1014: warning: `pci_find_device' is deprecated 
> (declared at include/linux/pci.h:478)
> 
> and also removes trailing whitespaces at the ends of lines and converts 
> smarttabs/whitespaces into real tabs
> 
> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
> 
> ---
>  drivers/isdn/hisax/w6692.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/drivers/isdn/hisax/w6692.c
> ===================================================================
> --- linux-2.6.orig/drivers/isdn/hisax/w6692.c
> +++ linux-2.6/drivers/isdn/hisax/w6692.c
> @@ -1011,7 +1011,7 @@ setup_w6692(struct IsdnCard *card)
>  		return (0);
>  #ifdef CONFIG_PCI
>  	while (id_list[id_idx].vendor_id) {
> -		dev_w6692 = pci_find_device(id_list[id_idx].vendor_id,
> +		dev_w6692 = pci_get_device(id_list[id_idx].vendor_id,
>  					    id_list[id_idx].device_id,
>  					    dev_w6692);
>  		if (dev_w6692) {
> @@ -1031,7 +1031,7 @@ setup_w6692(struct IsdnCard *card)
>  		/* USR ISDN PCI card TA need some special handling */
>  		if (cs->subtyp == W6692_WINBOND) {
>  			if ((W6692_SV_USR == dev_w6692->subsystem_vendor) &&
> -			    (W6692_SD_USR == dev_w6692->subsystem_device)) {
> +				(W6692_SD_USR == dev_w6692->subsystem_device)) {
>  				cs->subtyp = W6692_USR;
>  			}
>  		}
> @@ -1043,11 +1043,11 @@ setup_w6692(struct IsdnCard *card)
>  	cs->irq = pci_irq;
>  	if (!cs->irq) {
>  		printk(KERN_WARNING "W6692: No IRQ for PCI card found\n");
> -		return (0);
> +		goto dev_w6692_cleanup;
>  	}
>  	if (!pci_ioaddr) {
>  		printk(KERN_WARNING "W6692: NO I/O Base Address found\n");
> -		return (0);
> +		goto dev_w6692_cleanup;
>  	}
>  	cs->hw.w6692.iobase = pci_ioaddr;
>  	printk(KERN_INFO "Found: %s %s, I/O base: 0x%x, irq: %d\n",
> @@ -1059,7 +1059,7 @@ setup_w6692(struct IsdnCard *card)
>  		       id_list[cs->subtyp].card_name,
>  		       cs->hw.w6692.iobase,
>  		       cs->hw.w6692.iobase + 255);
> -		return (0);
> +		goto dev_w6692_cleanup;
>  	}
>  #else
>  	printk(KERN_WARNING "HiSax: W6692 and NO_PCI_BIOS\n");
> @@ -1089,5 +1089,10 @@ setup_w6692(struct IsdnCard *card)
>  	printk(KERN_INFO "W6692 D_EXIR=0x%X\n", ReadW6692(cs, W_D_EXIR));
>  	printk(KERN_INFO "W6692 D_EXIM=0x%X\n", ReadW6692(cs, W_D_EXIM));
>  	printk(KERN_INFO "W6692 D_RSTA=0x%X\n", ReadW6692(cs, W_D_RSTA));
> +	pci_dev_put(dev_w6692);

Why do you release a reference here when you use the card all the time module is
loaded?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
