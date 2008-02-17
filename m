Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbYBQOWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbYBQOWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbYBQOVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:21:54 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:58743 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951AbYBQOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:21:53 -0500
Message-Id: <5BDDEEF9-D2AC-4112-83EB-43D02E8C4E6C@tranquility.fsbusiness.co.uk>
From: Andrew Smith <asmith@tranquility.fsbusiness.co.uk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: PROBLEM: Corruption problems in pata_via for Via NanoBook owners (Cloudbook, EasyNote XS etc.)
Date: Sun, 17 Feb 2008 14:21:45 +0000
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One Line : Changes in 2.24 have rendered the ide handling on the Via  
NanoBook unstable resulting in data loss under heavy load.

Keywords : modules, pata_via, viac82xxxx

Kernel version : 2.24

Environment : Packard Bell Easynote XS - based on Via Nanobook  
reference platform. (same as Everex Cloudbook in the USA).

Detail:

In v2.23 Kernel the following patch could be applied to viac82xxxx  
(see end of document), this works stably.

In 2.24 the device ID 0x581 for Vendor VIA was added to the pata_via  
driver causing some problems.

It builds fine and seems to start up OK, however, on large IOs then  
the kernel starts to throw errors about MULTICMDs (I think that was  
the term) returning an invalid response.

I have lost 2 builds so far (disk corruption) and have reverted to  
2.23 with the attached patch which does work fine (and gives UDMA133).

Suggestions:

Re-implement 0x581 handling in via82xxxx based on patch shown below.

Drop 0x581 support from pata_ide unless it is known to work with other  
hardware variants reliably.

If 0x581 is more desirable in pata_ide then make the via82cxxxx and  
pata_ide drivers mutually exclusive in a kernel configuration.


Regards,

-Andy Smith

*** linux-2.6.23/drivers/ide/pci/via82cxxx.c	2007-10-09  
22:31:38.000000000 +0200
--- linux-2.6.23-via-patch/drivers/ide/pci/via82cxxx.c	2007-11-02  
01:03:57.000000000 +0100
***************
*** 61,66 ****
--- 61,68 ----
   #define VIA_NO_UNMASK		0x08 /* Doesn't work with IRQ unmasking on */
   #define VIA_BAD_ID		0x10 /* Has wrong vendor ID (0x1107) */
   #define VIA_BAD_AST		0x20 /* Don't touch Address Setup Timing */
+ #define PCI_DEVICE_ID_VIA_CX700 0x8324
+ #define PCI_DEVICE_ID_VIA_CX700_IDE 0x0581

   /*
    * VIA SouthBridge chips.
***************
*** 545,550 ****
--- 547,553 ----
   	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C576_1, PCI_ANY_ID,  
PCI_ANY_ID, 0, 0, 0},
   	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1, PCI_ANY_ID,  
PCI_ANY_ID, 0, 0, 0},
   	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_6410,     PCI_ANY_ID,  
PCI_ANY_ID, 0, 0, 1},
+ 	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700_IDE, PCI_ANY_ID,  
PCI_ANY_ID, 0, 0, 0},
   	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_SATA_EIDE,     PCI_ANY_ID,  
PCI_ANY_ID, 0, 0, 1},
   	{ 0, },
   };

