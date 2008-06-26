Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbYFZT3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbYFZT3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760089AbYFZT2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:30 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:24102 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760018AbYFZT22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:28 -0400
X-BigFish: VPS4(z1039oz18c1K655Oc8kzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K334QX-04-UN3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/34] AMD IOMMU: add generic defines and structures for mapping code
Date: Thu, 26 Jun 2008 21:27:53 +0200
Message-ID: <1214508490-29683-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0840 (UTC) FILETIME=[C5928400:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds generic stuff used by the mapping and unmapping code for the
AMD IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/amd_iommu.c

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
new file mode 100644
index 0000000..90392c7
--- /dev/null
+++ b/arch/x86/kernel/amd_iommu.c
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *         Leo Duran <leo.duran@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/pci.h>
+#include <linux/gfp.h>
+#include <linux/bitops.h>
+#include <linux/scatterlist.h>
+#include <linux/iommu-helper.h>
+#include <asm/proto.h>
+#include <asm/gart.h>
+#include <asm/amd_iommu_types.h>
+
+#define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
+
+#define to_pages(addr, size) \
+	 (round_up(((addr) & ~PAGE_MASK) + (size), PAGE_SIZE) >> PAGE_SHIFT)
+
+static DEFINE_RWLOCK(amd_iommu_devtable_lock);
+
+struct command {
+	u32 data[4];
+};
+
+
-- 
1.5.3.7


