Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZG1RSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZG1RSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZG1RSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:54 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36858 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZG1RS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:28 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DO-03-BLX-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/26] x86/oprofile: Fix usage of NUM_CONTROLS/NUM_COUNTERS macros
Date: Tue, 28 Jul 2009 19:07:04 +0200
Message-ID: <1248800846-25422-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:47.0884 (UTC) FILETIME=[542052C0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the corresponding macros when iterating over counter and control
registers. Since NUM_CONTROLS and NUM_COUNTERS are equal for AMD cpus
the fix is more a cosmetical change.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index fdbed3a..dcfd450 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -99,7 +99,7 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
-		int hw_counter = i % NUM_CONTROLS;
+		int hw_counter = i % NUM_COUNTERS;
 		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
 			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
 		else
@@ -366,7 +366,7 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
 	}
-	for (i = 0; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < NUM_CONTROLS; ++i) {
 		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
-- 
1.6.3.3


