Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbYFZT3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbYFZT3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759818AbYFZT22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:28 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:23754 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245AbYFZT21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:27 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K334QX-04-UN6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/34] AMD IOMMU: add data structures to manage the IOMMUs in the system
Date: Thu, 26 Jun 2008 21:27:40 +0200
Message-ID: <1214508490-29683-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0527 (UTC) FILETIME=[C562C170:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the data structures which will contain the information read
from the ACPI table.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 6fce5ab..0ad8cf9 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -99,3 +99,20 @@ struct ivmd_header {
 	u64 range_length;
 } __attribute__((packed));
 
+static int __initdata amd_iommu_disable;
+
+u16 amd_iommu_last_bdf;
+struct list_head amd_iommu_unity_map;
+unsigned amd_iommu_aperture_order = 26;
+int amd_iommu_isolate;
+
+struct list_head amd_iommu_list;
+struct dev_table_entry *amd_iommu_dev_table;
+u16 *amd_iommu_alias_table;
+struct amd_iommu **amd_iommu_rlookup_table;
+struct protection_domain **amd_iommu_pd_table;
+unsigned long *amd_iommu_pd_alloc_bitmap;
+
+static u32 dev_table_size;
+static u32 alias_table_size;
+static u32 rlookup_table_size;
-- 
1.5.3.7


