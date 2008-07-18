Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbYGRMoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbYGRMoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYGRMnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:43:53 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30812 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYGRMnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:43:53 -0400
Message-Id: <4880AC40.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:44:16 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: reduce forbid_dac's visibility
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not used anywhere outside its declaring file.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/pci-dma.c     |    3 +--
 include/asm-x86/dma-mapping.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.26/arch/x86/kernel/pci-dma.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-forbid-dac/arch/x86/kernel/pci-dma.c	2008-07-15 14:51:28.000000000 +0200
@@ -8,8 +8,7 @@
 #include <asm/gart.h>
 #include <asm/calgary.h>
 
-int forbid_dac __read_mostly;
-EXPORT_SYMBOL(forbid_dac);
+static int forbid_dac __read_mostly;
 
 const struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
--- linux-2.6.26/include/asm-x86/dma-mapping.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-forbid-dac/include/asm-x86/dma-mapping.h	2008-07-17 10:29:09.000000000 +0200
@@ -14,7 +14,6 @@ extern dma_addr_t bad_dma_address;
 extern int iommu_merge;
 extern struct device fallback_dev;
 extern int panic_on_overflow;
-extern int forbid_dac;
 extern int force_iommu;
 
 struct dma_mapping_ops {



