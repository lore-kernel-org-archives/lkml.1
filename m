Return-Path: <linux-kernel-owner+w=401wt.eu-S932256AbZAGW3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbZAGW3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762422AbZAGWX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:26 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21813 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762405AbZAGWXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:25 -0500
X-BigFish: VPS1(zzzzzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KD4GUK-02-XU0-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 18/18] oprofile: rename variables in add_ibs_begin()
Date: Wed, 7 Jan 2009 23:17:35 +0100
Message-ID: <1231366655-17837-19-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0663 (UTC) FILETIME=[7F5A8DF0:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This unifies usage of variable names within oprofile.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index bf8fcc7..21fd249 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -325,36 +325,36 @@ static void add_trace_begin(void)
  */
 static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
 {
-	unsigned long rip;
+	unsigned long pc;
 	int i, count;
-	unsigned long ibs_cookie = 0;
+	unsigned long cookie = 0;
 	off_t offset;
 	struct op_sample *sample;
 
 	sample = op_cpu_buffer_read_entry(cpu);
 	if (!sample)
 		return;
-	rip = sample->eip;
+	pc = sample->eip;
 
 #ifdef __LP64__
-	rip += sample->event << 32;
+	pc += sample->event << 32;
 #endif
 
 	if (mm) {
-		ibs_cookie = lookup_dcookie(mm, rip, &offset);
+		cookie = lookup_dcookie(mm, pc, &offset);
 
-		if (ibs_cookie == NO_COOKIE)
-			offset = rip;
-		if (ibs_cookie == INVALID_COOKIE) {
+		if (cookie == NO_COOKIE)
+			offset = pc;
+		if (cookie == INVALID_COOKIE) {
 			atomic_inc(&oprofile_stats.sample_lost_no_mapping);
-			offset = rip;
+			offset = pc;
 		}
-		if (ibs_cookie != last_cookie) {
-			add_cookie_switch(ibs_cookie);
-			last_cookie = ibs_cookie;
+		if (cookie != last_cookie) {
+			add_cookie_switch(cookie);
+			last_cookie = cookie;
 		}
 	} else
-		offset = rip;
+		offset = pc;
 
 	add_event_entry(ESCAPE_CODE);
 	add_event_entry(code);
-- 
1.6.0.1


