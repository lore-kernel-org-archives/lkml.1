Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYGVTad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYGVTad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYGVTYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:53 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:28974 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbYGVTYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:24:52 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9WW-02-3OP-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 16/24] OProfile: Fix setup_ibs_files() function interface
Date: Tue, 22 Jul 2008 21:09:00 +0200
Message-ID: <1216753748-11261-17-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:40.0245 (UTC) FILETIME=[726DE850:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index ce73236..2650b12 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -446,13 +446,13 @@ static void clear_ibs_nmi(void)
 		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
 }
 
-static void setup_ibs_files(struct super_block *sb, struct dentry *root)
+static int setup_ibs_files(struct super_block * sb, struct dentry * root)
 {
 	char buf[12];
 	struct dentry *dir;
 
 	if (!ibs_allowed)
-		return;
+		return 0;
 
 	/* setup some reasonable defaults */
 	ibs_config.max_cnt_fetch = 250000;
@@ -476,6 +476,8 @@ static void setup_ibs_files(struct super_block *sb, struct dentry *root)
 		&ibs_config.max_cnt_op);
 	oprofilefs_create_ulong(sb, dir, "dispatched_ops",
 		&ibs_config.dispatched_ops);
+
+	return 0;
 }
 
 static int op_amd_init(struct oprofile_operations *ops)
-- 
1.5.5.4


