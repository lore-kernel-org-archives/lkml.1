Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZAIQZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZAIQZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZAIQUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:20:44 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:32087 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZAIQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:19:44 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KD7PCH-03-IWV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/16] dma-debug: add Kconfig entry
Date: Fri, 9 Jan 2009 17:19:15 +0100
Message-ID: <1231517970-20288-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jan 2009 16:19:30.0574 (UTC) FILETIME=[0CF32AE0:01C97276]
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
index 2e13aa2..068554c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -103,3 +103,5 @@ config HAVE_CLK
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
 
+config HAVE_DMA_API_DEBUG
+	bool
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2e75478..cba5778 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -899,6 +899,17 @@ config DYNAMIC_PRINTK_DEBUG
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


