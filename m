Return-Path: <linux-kernel-owner+w=401wt.eu-S933482AbZIDJqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbZIDJqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933565AbZIDJpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:45:42 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:49524 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556AbZIDJpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:45:40 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXRW-01-4S5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/8] x86/amd-iommu: Dump illegal command on ILLEGAL_COMMAND_ERROR
Date: Fri, 4 Sep 2009 11:44:36 +0200
Message-ID: <1252057482-32207-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
References: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:44:45.0195 (UTC) FILETIME=[55ADA5B0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to dump the command which caused an
ILLEGAL_COMMAND_ERROR raised by the IOMMU hardware.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 364c6de..e62b35f 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -147,6 +147,15 @@ static void dump_dte_entry(u16 devid)
 			amd_iommu_dev_table[devid].data[i]);
 }
 
+static void dump_command(unsigned long phys_addr)
+{
+	struct iommu_cmd *cmd = phys_to_virt(phys_addr);
+	int i;
+
+	for (i = 0; i < 4; ++i)
+		pr_err("AMD-Vi: CMD[%d]: %08x\n", i, cmd->data[i]);
+}
+
 static void iommu_print_event(void *__evt)
 {
 	u32 *event = __evt;
@@ -186,6 +195,7 @@ static void iommu_print_event(void *__evt)
 		break;
 	case EVENT_TYPE_ILL_CMD:
 		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		dump_command(address);
 		break;
 	case EVENT_TYPE_CMD_HARD_ERR:
 		printk("COMMAND_HARDWARE_ERROR address=0x%016llx "
-- 
1.6.3.3


