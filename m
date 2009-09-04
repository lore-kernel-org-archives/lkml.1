Return-Path: <linux-kernel-owner+w=401wt.eu-S933468AbZIDJpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468AbZIDJpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbZIDJpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:45:14 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:27499 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbZIDJpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:45:13 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXR6-03-O41-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/8] x86/amd-iommu: Dump fault entry on DTE error
Date: Fri, 4 Sep 2009 11:44:35 +0200
Message-ID: <1252057482-32207-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
References: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:44:45.0163 (UTC) FILETIME=[55A8C3B0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to dump the content of the device table
entry which caused an ILLEGAL_DEV_TABLE_ENTRY error from the
IOMMU hardware.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6c99f50..364c6de 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -138,6 +138,15 @@ static int iommu_has_npcache(struct amd_iommu *iommu)
  *
  ****************************************************************************/
 
+static void dump_dte_entry(u16 devid)
+{
+	int i;
+
+	for (i = 0; i < 8; ++i)
+		pr_err("AMD-Vi: DTE[%d]: %08x\n", i,
+			amd_iommu_dev_table[devid].data[i]);
+}
+
 static void iommu_print_event(void *__evt)
 {
 	u32 *event = __evt;
@@ -155,6 +164,7 @@ static void iommu_print_event(void *__evt)
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_IO_FAULT:
 		printk("IO_PAGE_FAULT device=%02x:%02x.%x "
-- 
1.6.3.3


