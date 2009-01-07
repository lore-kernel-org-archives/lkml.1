Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbZAGW35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbZAGW35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762449AbZAGWX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:28 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21989 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762437AbZAGWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:27 -0500
X-BigFish: VPS1(zzzzzzz32i63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KD4GUK-01-K4A-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 17/18] oprofile: rename add_sample() in cpu_buffer.c
Date: Wed, 7 Jan 2009 23:17:34 +0100
Message-ID: <1231366655-17837-18-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0631 (UTC) FILETIME=[7F55ABF0:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the fucntion to op_add_sample() since there is a collision with
another one with the same name in buffer_sync.c.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 92bf8c0..ac79f66 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -188,8 +188,8 @@ unsigned long op_cpu_buffer_entries(int cpu)
 }
 
 static inline int
-add_sample(struct oprofile_cpu_buffer *cpu_buf,
-	   unsigned long pc, unsigned long event)
+op_add_sample(struct oprofile_cpu_buffer *cpu_buf,
+	      unsigned long pc, unsigned long event)
 {
 	struct op_entry entry;
 	int ret;
@@ -207,7 +207,7 @@ add_sample(struct oprofile_cpu_buffer *cpu_buf,
 static inline int
 add_code(struct oprofile_cpu_buffer *buffer, unsigned long value)
 {
-	return add_sample(buffer, ESCAPE_CODE, value);
+	return op_add_sample(buffer, ESCAPE_CODE, value);
 }
 
 /* This must be safe from any context. It's safe writing here
@@ -249,7 +249,7 @@ static int log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
 			goto fail;
 	}
 
-	if (add_sample(cpu_buf, pc, event))
+	if (op_add_sample(cpu_buf, pc, event))
 		goto fail;
 
 	return 1;
@@ -337,14 +337,14 @@ void oprofile_add_ibs_sample(struct pt_regs * const regs,
 	}
 
 	fail = fail || add_code(cpu_buf, ibs_code);
-	fail = fail || add_sample(cpu_buf, ibs_sample[0], ibs_sample[1]);
-	fail = fail || add_sample(cpu_buf, ibs_sample[2], ibs_sample[3]);
-	fail = fail || add_sample(cpu_buf, ibs_sample[4], ibs_sample[5]);
+	fail = fail || op_add_sample(cpu_buf, ibs_sample[0], ibs_sample[1]);
+	fail = fail || op_add_sample(cpu_buf, ibs_sample[2], ibs_sample[3]);
+	fail = fail || op_add_sample(cpu_buf, ibs_sample[4], ibs_sample[5]);
 
 	if (ibs_code == IBS_OP_BEGIN) {
-		fail = fail || add_sample(cpu_buf, ibs_sample[6], ibs_sample[7]);
-		fail = fail || add_sample(cpu_buf, ibs_sample[8], ibs_sample[9]);
-		fail = fail || add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
+		fail = fail || op_add_sample(cpu_buf, ibs_sample[6], ibs_sample[7]);
+		fail = fail || op_add_sample(cpu_buf, ibs_sample[8], ibs_sample[9]);
+		fail = fail || op_add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
 	}
 
 	if (!fail)
@@ -376,7 +376,7 @@ void oprofile_add_trace(unsigned long pc)
 	if (pc == ESCAPE_CODE)
 		goto fail;
 
-	if (add_sample(cpu_buf, pc, 0))
+	if (op_add_sample(cpu_buf, pc, 0))
 		goto fail;
 
 	return;
-- 
1.6.0.1


