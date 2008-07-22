Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYGVT0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYGVT0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYGVTYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:00 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:25335 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYGVTX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:57 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VC-02-3LU-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 15/24] OProfile: on_each_cpu(): kill unused retry parameter
Date: Tue, 22 Jul 2008 21:08:59 +0200
Message-ID: <1216753748-11261-16-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:40.0183 (UTC) FILETIME=[72647270:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 284c456..ce73236 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -382,7 +382,7 @@ static int pfm_amd64_setup_eilvt(void)
 	u32 value = 0;
 
 	/* per CPU setup */
-	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 0, 1);
+	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1);
 
 	nodes = 0;
 	cpu_cfg = NULL;
@@ -443,7 +443,7 @@ static void setup_ibs(void)
 static void clear_ibs_nmi(void)
 {
 	if (ibs_allowed)
-		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1, 1);
+		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
 }
 
 static void setup_ibs_files(struct super_block *sb, struct dentry *root)
-- 
1.5.5.4


