Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbYGKPSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbYGKPSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbYGKPPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:65107 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbYGKPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:05 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K3UL0F-03-1OR-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/16] AMD IOMMU: rename struct command to iommu_cmd
Date: Fri, 11 Jul 2008 17:14:28 +0200
Message-ID: <1215789275-20975-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0180 (UTC) FILETIME=[D4874D40:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gives the struct command a more descriptive and not so generic name.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 7fa2d5d..dec10e1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -39,7 +39,7 @@ static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 /*
  * general struct to manage commands send to an IOMMU
  */
-struct command {
+struct iommu_cmd {
 	u32 data[4];
 };
 
@@ -62,7 +62,7 @@ static int iommu_has_npcache(struct amd_iommu *iommu)
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command. Must be called with iommu->lock held.
  */
-static int __iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
+static int __iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 {
 	u32 tail, head;
 	u8 *target;
@@ -83,7 +83,7 @@ static int __iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
  * General queuing function for commands. Takes iommu->lock and calls
  * __iommu_queue_command().
  */
-static int iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
+static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 {
 	unsigned long flags;
 	int ret;
@@ -105,7 +105,7 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
 static int iommu_completion_wait(struct amd_iommu *iommu)
 {
 	int ret;
-	struct command cmd;
+	struct iommu_cmd cmd;
 	volatile u64 ready = 0;
 	unsigned long ready_phys = virt_to_phys(&ready);
 	unsigned long i = 0;
@@ -139,7 +139,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
  */
 static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 {
-	struct command cmd;
+	struct iommu_cmd cmd;
 
 	BUG_ON(iommu == NULL);
 
@@ -158,7 +158,7 @@ static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 		u64 address, u16 domid, int pde, int s)
 {
-	struct command cmd;
+	struct iommu_cmd cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
 	address &= PAGE_MASK;
-- 
1.5.3.7


