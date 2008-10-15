Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYJOVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYJOVDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYJOVCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:02:55 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:34104 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYJOVCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:02:54 -0400
X-BigFish: VPS14(zz82c2szzzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K8ST49-01-4G8-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/8] OProfile: Rework string handling in setup_ibs_files()
Date: Wed, 15 Oct 2008 22:09:04 +0200
Message-ID: <1224101350-12877-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <20081015110444.GA28703@elte.hu>
References: <20081015110444.GA28703@elte.hu>
X-OriginalArrivalTime: 15 Oct 2008 21:02:38.0784 (UTC) FILETIME=[5B2FCC00:01C92F09]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 54632e0..0657c56 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -473,7 +473,6 @@ static int (*create_arch_files)(struct super_block * sb, struct dentry * root);
 
 static int setup_ibs_files(struct super_block * sb, struct dentry * root)
 {
-	char buf[12];
 	struct dentry *dir;
 	int ret = 0;
 
@@ -495,22 +494,22 @@ static int setup_ibs_files(struct super_block * sb, struct dentry * root)
 	ibs_config.max_cnt_op = 250000;
 	ibs_config.op_enabled = 0;
 	ibs_config.dispatched_ops = 1;
-	snprintf(buf,  sizeof(buf), "ibs_fetch");
-	dir = oprofilefs_mkdir(sb, root, buf);
-	oprofilefs_create_ulong(sb, dir, "rand_enable",
-				&ibs_config.rand_en);
+
+	dir = oprofilefs_mkdir(sb, root, "ibs_fetch");
 	oprofilefs_create_ulong(sb, dir, "enable",
-		&ibs_config.fetch_enabled);
+				&ibs_config.fetch_enabled);
 	oprofilefs_create_ulong(sb, dir, "max_count",
-		&ibs_config.max_cnt_fetch);
-	snprintf(buf,  sizeof(buf), "ibs_uops");
-	dir = oprofilefs_mkdir(sb, root, buf);
+				&ibs_config.max_cnt_fetch);
+	oprofilefs_create_ulong(sb, dir, "rand_enable",
+				&ibs_config.rand_en);
+
+	dir = oprofilefs_mkdir(sb, root, "ibs_uops");
 	oprofilefs_create_ulong(sb, dir, "enable",
-		&ibs_config.op_enabled);
+				&ibs_config.op_enabled);
 	oprofilefs_create_ulong(sb, dir, "max_count",
-		&ibs_config.max_cnt_op);
+				&ibs_config.max_cnt_op);
 	oprofilefs_create_ulong(sb, dir, "dispatched_ops",
-		&ibs_config.dispatched_ops);
+				&ibs_config.dispatched_ops);
 
 	return 0;
 }
-- 
1.6.0.1


