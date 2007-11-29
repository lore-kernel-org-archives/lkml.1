Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbXLFMnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbXLFMnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXLFMmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:31 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53681 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbXLFMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:41:51 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <77d5816c68f53fb45d3da63f62480bad15500efd.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 17:24:10 +0100
Subject: [PATCH 07/47] Add L2 cache initialization code.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/mm/l2cache.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)
 create mode 100644 arch/cris/arch-v32/mm/l2cache.c

diff --git a/arch/cris/arch-v32/mm/l2cache.c b/arch/cris/arch-v32/mm/l2cache.c
new file mode 100644
index 0000000..332ff10
--- /dev/null
+++ b/arch/cris/arch-v32/mm/l2cache.c
@@ -0,0 +1,29 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <memmap.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/l2cache_defs.h>
+#include <asm/io.h>
+
+#define L2CACHE_SIZE 64
+
+int __init l2cache_init(void)
+{
+	reg_l2cache_rw_ctrl ctrl = {0};
+	reg_l2cache_rw_cfg cfg = {.en = regk_l2cache_yes};
+
+	ctrl.csize = L2CACHE_SIZE;
+	ctrl.cbase = L2CACHE_SIZE / 4 + (L2CACHE_SIZE % 4 ? 1 : 0);
+	REG_WR(l2cache, regi_l2cache, rw_ctrl, ctrl);
+
+	/* Flush the tag memory */
+	memset((void *)(MEM_INTMEM_START | MEM_NON_CACHEABLE), 0, 2*1024);
+
+	/* Enable the cache */
+	REG_WR(l2cache, regi_l2cache, rw_cfg, cfg);
+
+	return 0;
+}
+
-- 
1.5.3.6.970.gd25430

