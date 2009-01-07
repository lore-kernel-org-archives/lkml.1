Return-Path: <linux-kernel-owner+w=401wt.eu-S1762432AbZAGWX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762432AbZAGWX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbZAGWXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:13 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:20753 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761453AbZAGWXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:12 -0500
X-BigFish: VPS1(zzzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KD4GU3-02-XT7-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/18] oprofile: reordering some code in cpu_buffer.c
Date: Wed, 7 Jan 2009 23:17:22 +0100
Message-ID: <1231366655-17837-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0256 (UTC) FILETIME=[7F1C7380:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reordering code to keep alloc/free functions together.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index cd67d4d..b353b19 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -54,16 +54,6 @@ static void wq_sync_buffer(struct work_struct *work);
 #define DEFAULT_TIMER_EXPIRE (HZ / 10)
 static int work_enabled;
 
-void free_cpu_buffers(void)
-{
-	if (op_ring_buffer_read)
-		ring_buffer_free(op_ring_buffer_read);
-	op_ring_buffer_read = NULL;
-	if (op_ring_buffer_write)
-		ring_buffer_free(op_ring_buffer_write);
-	op_ring_buffer_write = NULL;
-}
-
 unsigned long oprofile_get_cpu_buffer_size(void)
 {
 	return oprofile_cpu_buffer_size;
@@ -77,6 +67,16 @@ void oprofile_cpu_buffer_inc_smpl_lost(void)
 	cpu_buf->sample_lost_overflow++;
 }
 
+void free_cpu_buffers(void)
+{
+	if (op_ring_buffer_read)
+		ring_buffer_free(op_ring_buffer_read);
+	op_ring_buffer_read = NULL;
+	if (op_ring_buffer_write)
+		ring_buffer_free(op_ring_buffer_write);
+	op_ring_buffer_write = NULL;
+}
+
 int alloc_cpu_buffers(void)
 {
 	int i;
-- 
1.6.0.1


