Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZASOrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZASOrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZASOrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:16 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:38550 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZASOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:15 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QC-02-0B7-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/16] dma-debug: add Kconfig entry
Date: Mon, 19 Jan 2009 15:46:48 +0100
Message-ID: <1232376423-11067-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:03.0766 (UTC) FILETIME=[CAECEF60:01C97A44]
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
index 4c9ae60..92120f7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -906,6 +906,17 @@ config DYNAMIC_PRINTK_DEBUG
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


