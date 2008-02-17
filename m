Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYBQRKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYBQRKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYBQRKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:10:31 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:57712 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYBQRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Q0uzdft80BNET/g3eA4se+9eWq2q0dZ74VMXBhaLWEcNQA2IajK5Kx8FpgS9CqN/N+Rlf5kpjgIl+EO4FiC2ouqR68/CVgtiFgwWd8mo5RwFoYVvgyhvUW9gzpz6SASWyKIeYKyuMjoRv2NpWJvmFE+HJFWGTew+Nn8dBPanEPw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Smith <asmith@tranquility.fsbusiness.co.uk>
Subject: Re: PROBLEM: Corruption problems in pata_via for Via NanoBook owners (Cloudbook, EasyNote XS etc.)
Date: Sun, 17 Feb 2008 17:59:54 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <5BDDEEF9-D2AC-4112-83EB-43D02E8C4E6C@tranquility.fsbusiness.co.uk>
In-Reply-To: <5BDDEEF9-D2AC-4112-83EB-43D02E8C4E6C@tranquility.fsbusiness.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802171759.55089.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 17 February 2008, Andrew Smith wrote:
> One Line : Changes in 2.24 have rendered the ide handling on the Via  
> NanoBook unstable resulting in data loss under heavy load.
> 
> Keywords : modules, pata_via, viac82xxxx
> 
> Kernel version : 2.24
> 
> Environment : Packard Bell Easynote XS - based on Via Nanobook  
> reference platform. (same as Everex Cloudbook in the USA).
> 
> Detail:
> 
> In v2.23 Kernel the following patch could be applied to viac82xxxx  
> (see end of document), this works stably.
> 
> In 2.24 the device ID 0x581 for Vendor VIA was added to the pata_via  
> driver causing some problems.
> 
> It builds fine and seems to start up OK, however, on large IOs then  
> the kernel starts to throw errors about MULTICMDs (I think that was  
> the term) returning an invalid response.
> 
> I have lost 2 builds so far (disk corruption) and have reverted to  
> 2.23 with the attached patch which does work fine (and gives UDMA133).
> 
> Suggestions:
> 
> Re-implement 0x581 handling in via82xxxx based on patch shown below.

Thank you for reporting it (I was unaware that via82cxxx misses some ids).

I ported your patch over 2.6.25-rc2 and merged it.

> Drop 0x581 support from pata_ide unless it is known to work with other  
> hardware variants reliably.

Added Jeff/Alan to cc: so they can follow up on this.

> If 0x581 is more desirable in pata_ide then make the via82cxxxx and  
> pata_ide drivers mutually exclusive in a kernel configuration.
> 
> 
> Regards,
> 
> -Andy Smith
> 
> *** linux-2.6.23/drivers/ide/pci/via82cxxx.c	2007-10-09  
> 22:31:38.000000000 +0200
> --- linux-2.6.23-via-patch/drivers/ide/pci/via82cxxx.c	2007-11-02  
> 01:03:57.000000000 +0100
> ***************
> *** 61,66 ****
> --- 61,68 ----
>    #define VIA_NO_UNMASK		0x08 /* Doesn't work with IRQ unmasking on */
>    #define VIA_BAD_ID		0x10 /* Has wrong vendor ID (0x1107) */
>    #define VIA_BAD_AST		0x20 /* Don't touch Address Setup Timing */
> + #define PCI_DEVICE_ID_VIA_CX700 0x8324
> + #define PCI_DEVICE_ID_VIA_CX700_IDE 0x0581
> 
>    /*
>     * VIA SouthBridge chips.
> ***************
> *** 545,550 ****
> --- 547,553 ----
>    	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C576_1, PCI_ANY_ID,  
> PCI_ANY_ID, 0, 0, 0},
>    	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1, PCI_ANY_ID,  
> PCI_ANY_ID, 0, 0, 0},
>    	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_6410,     PCI_ANY_ID,  
> PCI_ANY_ID, 0, 0, 1},
> + 	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700_IDE, PCI_ANY_ID,  
> PCI_ANY_ID, 0, 0, 0},
>    	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_SATA_EIDE,     PCI_ANY_ID,  
> PCI_ANY_ID, 0, 0, 1},
>    	{ 0, },
>    };

2.6.25-rc2 version:

From: Andrew Smith <asmith@tranquility.fsbusiness.co.uk>
Subject: [PATCH] via82cxxx: add new PCI id for cx700

[bart: manually ported it over via82cxxx changes]

From: Andrew Smith <asmith@tranquility.fsbusiness.co.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/via82cxxx.c |    1 +
 include/linux/pci_ids.h     |    1 +
 2 files changed, 2 insertions(+)

Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -479,6 +479,7 @@ static int __devinit via_init_one(struct
 static const struct pci_device_id via_pci_tbl[] = {
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C576_1),  0 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C586_1),  0 },
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_CX700_IDE), 0 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_6410),      1 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_SATA_EIDE), 1 },
 	{ 0, },
Index: b/include/linux/pci_ids.h
===================================================================
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1351,6 +1351,7 @@
 #define PCI_DEVICE_ID_VIA_8231_4	0x8235
 #define PCI_DEVICE_ID_VIA_8365_1	0x8305
 #define PCI_DEVICE_ID_VIA_CX700		0x8324
+#define PCI_DEVICE_ID_VIA_CX700_IDE	0x0581
 #define PCI_DEVICE_ID_VIA_VX800		0x8353
 #define PCI_DEVICE_ID_VIA_8371_1	0x8391
 #define PCI_DEVICE_ID_VIA_82C598_1	0x8598
