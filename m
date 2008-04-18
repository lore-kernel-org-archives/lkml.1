Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbYDRVV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbYDRVV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYDRVVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:21:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60265 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYDRVVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:21:46 -0400
Date: Fri, 18 Apr 2008 23:21:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: mingo@elte.hu
cc: airlied@linux.ie, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Make CONFIG_ARP=m under x86_64
Message-ID: <alpine.LNX.1.10.0804182304040.26385@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The way it is written, CONFIG_AGP is always y for x86_64 - not so nice 
when you want to use nvagp instead which requries agpgart to be 
unloadable.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6c70fed..1b2ce6c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -429,12 +429,17 @@ config HPET_EMULATE_RTC
 	def_bool y
 	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
+config GART_IOMMU
+	bool
+
+# Hack to make AGP selectable as module
+config GART_IOMMU_SELECTOR
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
-config GART_IOMMU
-	bool "GART IOMMU support" if EMBEDDED
-	default y
+	tristate "GART IOMMU support" if EMBEDDED
+	default m
 	select SWIOTLB
+	select GART_IOMMU_BASE
 	select AGP
 	depends on X86_64 && PCI
 	help

