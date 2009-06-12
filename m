Return-Path: <linux-kernel-owner+w=401wt.eu-S1764626AbZFLNEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764626AbZFLNEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761692AbZFLM7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:35 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:11204
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762766AbZFLM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:33 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KL4MQP-03-HWC-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 21/23] x86/oprofile: remove some local variables in MSR save/restore functions
Date: Fri, 12 Jun 2009 14:35:38 +0200
Message-ID: <1244810140-20595-22-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:08.0967 (UTC) FILETIME=[93210370:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes some local variables in these functions.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 3b84b78..80b63d5 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -71,18 +71,16 @@ static int profile_exceptions_notify(struct notifier_block *self,
 
 static void nmi_cpu_save_registers(struct op_msrs *msrs)
 {
-	unsigned int const nr_ctrs = model->num_counters;
-	unsigned int const nr_ctrls = model->num_controls;
 	struct op_msr *counters = msrs->counters;
 	struct op_msr *controls = msrs->controls;
 	unsigned int i;
 
-	for (i = 0; i < nr_ctrs; ++i) {
+	for (i = 0; i < model->num_counters; ++i) {
 		if (counters[i].addr)
 			rdmsrl(counters[i].addr, counters[i].saved);
 	}
 
-	for (i = 0; i < nr_ctrls; ++i) {
+	for (i = 0; i < model->num_controls; ++i) {
 		if (controls[i].addr)
 			rdmsrl(controls[i].addr, controls[i].saved);
 	}
@@ -191,18 +189,16 @@ static int nmi_setup(void)
 
 static void nmi_restore_registers(struct op_msrs *msrs)
 {
-	unsigned int const nr_ctrs = model->num_counters;
-	unsigned int const nr_ctrls = model->num_controls;
 	struct op_msr *counters = msrs->counters;
 	struct op_msr *controls = msrs->controls;
 	unsigned int i;
 
-	for (i = 0; i < nr_ctrls; ++i) {
+	for (i = 0; i < model->num_controls; ++i) {
 		if (controls[i].addr)
 			wrmsrl(controls[i].addr, controls[i].saved);
 	}
 
-	for (i = 0; i < nr_ctrs; ++i) {
+	for (i = 0; i < model->num_counters; ++i) {
 		if (counters[i].addr)
 			wrmsrl(counters[i].addr, counters[i].saved);
 	}
-- 
1.6.3.1


