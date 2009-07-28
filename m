Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZG1RSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZG1RSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbZG1RSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:38 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:39003 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZG1RSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:08 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DR-03-BM3-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 19/26] x86/oprofile: Modify initialization of num_virt_counters
Date: Tue, 28 Jul 2009 19:07:19 +0200
Message-ID: <1248800846-25422-20-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:50.0478 (UTC) FILETIME=[55AC22E0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Models that do not yet support counter multiplexing have to setup
num_virt_counters. This patch implements the setup from num_counters
if num_virt_counters is not set. Thus, num_virt_counters must be setup
only for multiplexing support.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |    3 +++
 arch/x86/oprofile/op_model_p4.c   |    2 --
 arch/x86/oprofile/op_model_ppro.c |    1 -
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 826f391..82ee295 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -674,6 +674,9 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	if (ret)
 		return ret;
 
+	if (!model->num_virt_counters)
+		model->num_virt_counters = model->num_counters;
+
 	init_sysfs();
 	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 0a4f2de..ac6b354 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -698,7 +698,6 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 struct op_x86_model_spec op_p4_ht2_spec = {
 	.num_counters		= NUM_COUNTERS_HT2,
 	.num_controls		= NUM_CONTROLS_HT2,
-	.num_virt_counters	= NUM_COUNTERS_HT2,
 	.fill_in_addresses	= &p4_fill_in_addresses,
 	.setup_ctrs		= &p4_setup_ctrs,
 	.check_ctrs		= &p4_check_ctrs,
@@ -711,7 +710,6 @@ struct op_x86_model_spec op_p4_ht2_spec = {
 struct op_x86_model_spec op_p4_spec = {
 	.num_counters		= NUM_COUNTERS_NON_HT,
 	.num_controls		= NUM_CONTROLS_NON_HT,
-	.num_virt_counters	= NUM_COUNTERS_NON_HT,
 	.fill_in_addresses	= &p4_fill_in_addresses,
 	.setup_ctrs		= &p4_setup_ctrs,
 	.check_ctrs		= &p4_check_ctrs,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 753a02a..4899215 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -206,7 +206,6 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 struct op_x86_model_spec op_ppro_spec = {
 	.num_counters		= 2,
 	.num_controls		= 2,
-	.num_virt_counters	= 2,
 	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	.setup_ctrs		= &ppro_setup_ctrs,
-- 
1.6.3.3


