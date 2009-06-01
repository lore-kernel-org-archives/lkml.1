Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZFAKTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZFAKTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZFAKT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:19:27 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:42835 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZFAKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=FlYQys9U1SbTgIerVa8ScWvZn8NLOj568h9BDM/mhe9M12820tAi9LJVa4l5dTz3X0
         qqAtUMqiMwWP25pPfLhae6ziIyeyarnmKM2Sa6sEwcvro3Kd+8UXGM++Tn3Ds+HJozcD
         Xbwl6dLt+ZGPa+uKIWP+ZSQHMtr+H/3Z/780Q=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: paul@pwsan.com, khilman@deeprootsystems.com, gregkh@suse.de, rjw@sisk.pl,
       stern@rowland.harvard.edu, Magnus Damm <magnus.damm@gmail.com>,
       linux-pm@lists.linux-foundation.org
Date: Mon, 01 Jun 2009 19:16:14 +0900
Message-Id: <20090601101614.10720.93804.sendpatchset@rx1.opensource.se>
Subject: [PATCH] Driver Core: Add platform device arch data V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Allow architecture specific data in struct platform_device V2.
The structure pdev_archdata is added to struct platform_device,
similar to struct dev_archdata in struct device.

Useful for architecture code that needs to keep extra data
associated with each platform device. This data shall not
be accessed by platform drivers, only architecture code.

Needed for platform device runtime PM.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Applies to next-20090529.

 Changes since V1:
 - post to lkml, keep linux-pm cc:ed
 - add struct pdev_archdata to asm-generic
 - add struct pdev_archdata to non-generic architectures
 - drop Kconfig bits

 arch/arm/include/asm/device.h        |    3 +++
 arch/ia64/include/asm/device.h       |    3 +++
 arch/microblaze/include/asm/device.h |    3 +++
 arch/powerpc/include/asm/device.h    |    3 +++
 arch/sparc/include/asm/device.h      |    3 +++
 arch/x86/include/asm/device.h        |    3 +++
 include/asm-generic/device.h         |    3 +++
 include/linux/platform_device.h      |    3 +++
 8 files changed, 24 insertions(+)

--- 0001/arch/arm/include/asm/device.h
+++ work/arch/arm/include/asm/device.h	2009-06-01 12:19:51.000000000 +0900
@@ -12,4 +12,7 @@ struct dev_archdata {
 #endif
 };
 
+struct pdev_archdata {
+};
+
 #endif
--- 0001/arch/ia64/include/asm/device.h
+++ work/arch/ia64/include/asm/device.h	2009-06-01 12:18:11.000000000 +0900
@@ -15,4 +15,7 @@ struct dev_archdata {
 #endif
 };
 
+struct pdev_archdata {
+};
+
 #endif /* _ASM_IA64_DEVICE_H */
--- 0001/arch/microblaze/include/asm/device.h
+++ work/arch/microblaze/include/asm/device.h	2009-06-01 12:19:32.000000000 +0900
@@ -16,6 +16,9 @@ struct dev_archdata {
 	struct device_node	*of_node;
 };
 
+struct pdev_archdata {
+};
+
 #endif /* _ASM_MICROBLAZE_DEVICE_H */
 
 
--- 0001/arch/powerpc/include/asm/device.h
+++ work/arch/powerpc/include/asm/device.h	2009-06-01 12:16:28.000000000 +0900
@@ -30,4 +30,7 @@ dev_archdata_get_node(const struct dev_a
 	return ad->of_node;
 }
 
+struct pdev_archdata {
+};
+
 #endif /* _ASM_POWERPC_DEVICE_H */
--- 0001/arch/sparc/include/asm/device.h
+++ work/arch/sparc/include/asm/device.h	2009-06-01 12:18:57.000000000 +0900
@@ -32,4 +32,7 @@ dev_archdata_get_node(const struct dev_a
 	return ad->prom_node;
 }
 
+struct pdev_archdata {
+};
+
 #endif /* _ASM_SPARC_DEVICE_H */
--- 0001/arch/x86/include/asm/device.h
+++ work/arch/x86/include/asm/device.h	2009-06-01 12:17:28.000000000 +0900
@@ -13,4 +13,7 @@ struct dma_map_ops *dma_ops;
 #endif
 };
 
+struct pdev_archdata {
+};
+
 #endif /* _ASM_X86_DEVICE_H */
--- 0001/include/asm-generic/device.h
+++ work/include/asm-generic/device.h	2009-06-01 12:16:20.000000000 +0900
@@ -9,4 +9,7 @@
 struct dev_archdata {
 };
 
+struct pdev_archdata {
+};
+
 #endif /* _ASM_GENERIC_DEVICE_H */
--- 0001/include/linux/platform_device.h
+++ work/include/linux/platform_device.h	2009-06-01 12:14:43.000000000 +0900
@@ -22,6 +22,9 @@ struct platform_device {
 	struct resource	* resource;
 
 	struct platform_device_id	*id_entry;
+
+	/* arch specific additions */
+	struct pdev_archdata	archdata;
 };
 
 #define platform_get_device_id(pdev)	((pdev)->id_entry)
