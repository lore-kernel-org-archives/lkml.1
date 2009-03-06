Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZCFNcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZCFNcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZCFNau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:50 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25149 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZCFNaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:46 -0500
X-BigFish: VPS1(zzzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KG36UU-01-JKW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/18] dma-debug: add Kconfig entry
Date: Fri, 6 Mar 2009 14:30:12 +0100
Message-ID: <1236346229-6618-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0011 (UTC) FILETIME=[B7D60CB0:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a Kconfig entry for DMA-API debugging

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/Kconfig      |    2 ++
 lib/Kconfig.debug |   11 +++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 550dab2..830c16a 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -106,3 +106,5 @@ config HAVE_CLK
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
 
+config HAVE_DMA_API_DEBUG
+	bool
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1bcf9cd..d9cbada 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -902,6 +902,17 @@ config DYNAMIC_PRINTK_DEBUG
 	  debugging for all modules. This mode can be turned off via the above
 	  disable command.
 
+config DMA_API_DEBUG
+	bool "Enable debugging of DMA-API usage"
+	depends on HAVE_DMA_API_DEBUG
+	help
+	  Enable this option to debug the use of the DMA API by device drivers.
+	  With this option you will be able to detect common bugs in device
+	  drivers like double-freeing of DMA mappings or freeing mappings that
+	  were never allocated.
+	  This option causes a performance degredation.  Use only if you want
+	  to debug device drivers. If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
-- 
1.5.6.4


