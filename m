Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYGIUlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYGIUlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYGIUl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:41:29 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35257 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753144AbYGIUl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:41:28 -0400
From: John Keller <jpk@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, John Keller <jpk@sgi.com>,
       takayoshi.kochi@gmail.com
Message-Id: <20080709204127.1458.5727.77728@attica.americas.sgi.com>
Subject: [PATCH] x86: Allow MMCONFIG above 4GB on x86_64
Date: Wed,  9 Jul 2008 15:41:27 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SGI UV will have MMCFG base addresses that are greater than 4GB (32 bits).

Signed-off-by: John Keller <jpk@sgi.com>
---

A similar patch was submitted over a year ago, but apparently was not
merged in.

   http://marc.info/?l=linux-acpi&m=117283388212912&w=2


Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c	2008-07-09 13:02:54.000000000 -0500
+++ linux-2.6/arch/x86/kernel/acpi/boot.c	2008-07-09 15:25:32.000000000 -0500
@@ -200,6 +200,7 @@ int __init acpi_parse_mcfg(struct acpi_t
 	}
 
 	memcpy(pci_mmcfg_config, &mcfg[1], config_size);
+#ifndef CONFIG_X86_64
 	for (i = 0; i < pci_mmcfg_config_num; ++i) {
 		if (pci_mmcfg_config[i].address > 0xFFFFFFFF) {
 			printk(KERN_ERR PREFIX
@@ -209,6 +210,7 @@ int __init acpi_parse_mcfg(struct acpi_t
 			return -ENODEV;
 		}
 	}
+#endif
 
 	return 0;
 }
