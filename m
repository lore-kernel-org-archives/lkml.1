Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZIXMef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZIXMef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZIXMec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:34:32 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:29602 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZIXMe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:34:28 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KQH6WZ-02-6ID-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 01/10] amd64_edac: convert cpumask_t to struct cpumask ptr
Date: Thu, 24 Sep 2009 14:32:39 +0200
Message-ID: <1253795568-9877-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:32.0085 (UTC) FILETIME=[3A096E50:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4e551e6..53e617f 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2633,7 +2633,7 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
 	struct msr msrs[cpumask_weight(cpumask)];
 	u32 value;
@@ -2709,7 +2709,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 
 static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 {
-	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
 	struct msr msrs[cpumask_weight(cpumask)];
 	u32 value;
@@ -2742,7 +2742,7 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, int nid)
 {
 	int cpu;
 
@@ -2754,7 +2754,7 @@ static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
 /* check MCG_CTL on all the cpus on this node */
 static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 {
-	cpumask_t mask;
+	struct cpumask mask;
 	struct msr *msrs;
 	int cpu, nbe, idx = 0;
 	bool ret = false;
-- 
1.6.3.3


