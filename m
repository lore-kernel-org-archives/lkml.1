Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbXCYO55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbXCYO55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXCYO55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:57:57 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34032 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbXCYO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:57:55 -0400
Date: Sun, 25 Mar 2007 16:58:00 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] drivers/eisa/pci_eisa.c:pci_eisa_init() should be init
Message-ID: <20070325145800.GG16477@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at the following section error:

<--  snip  -->

WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:eisa_root_register from .text between 'pci_eisa_init' (at offset 0xabf670) and 'virtual_eisa_release'

<--  snip  -->

AFAIK a PCI to EISA bridge isn't anything hotpluggable, so 
pci_eisa_init() can become __init.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc4-mm1/drivers/eisa/pci_eisa.c.old	2007-03-25 15:51:01.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/eisa/pci_eisa.c	2007-03-25 15:51:17.000000000 +0200
@@ -19,8 +19,8 @@
 /* There is only *one* pci_eisa device per machine, right ? */
 static struct eisa_root_device pci_eisa_root;
 
-static int __devinit pci_eisa_init (struct pci_dev *pdev,
-				    const struct pci_device_id *ent)
+static int __init pci_eisa_init(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
 {
 	int rc;
 

