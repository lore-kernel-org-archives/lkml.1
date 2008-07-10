Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbYGJRvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbYGJRvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbYGJRvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:51:38 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46849 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758323AbYGJRvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:51:37 -0400
From: John Keller <jpk@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, John Keller <jpk@sgi.com>
Message-Id: <20080710175137.27587.78276.99330@attica.americas.sgi.com>
Subject: [RESEND] [PATCH] x86: Allow MMCONFIG above 4GB on x86_64
Date: Thu, 10 Jul 2008 12:51:37 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SGI UV will have MMCFG base addresses that are greater than 4GB (32 bits).

Signed-off-by: John Keller <jpk@sgi.com>
---

Resend #1: Use CONFIG_RESOURCES_64BIT instead of CONFIG_X86_64.


A similar patch was submitted over a year ago, but apparently was not
merged in.

   http://marc.info/?l=linux-acpi&m=117283388212912&w=2


Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c	2008-07-09 13:02:54.000000000 -0500
+++ linux-2.6/arch/x86/kernel/acpi/boot.c	2008-07-10 10:19:28.000000000 -0500
@@ -200,6 +200,7 @@ int __init acpi_parse_mcfg(struct acpi_t
 	}
 
 	memcpy(pci_mmcfg_config, &mcfg[1], config_size);
+#ifndef CONFIG_RESOURCES_64BIT
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
