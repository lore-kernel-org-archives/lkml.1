Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYJOVDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYJOVDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYJOVDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:03:00 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:34243 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbYJOVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:02:57 -0400
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K8ST4D-01-4GG-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/8] x86/oprofile: removing unused function parameter in add_ibs_begin()
Date: Wed, 15 Oct 2008 22:09:08 +0200
Message-ID: <1224101350-12877-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <20081015110444.GA28703@elte.hu>
References: <20081015110444.GA28703@elte.hu>
X-OriginalArrivalTime: 15 Oct 2008 21:02:38.0909 (UTC) FILETIME=[5B42DED0:01C92F09]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 5645773..33bfa60 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -340,7 +340,7 @@ static void add_trace_begin(void)
  * Add IBS fetch and op entries to event buffer
  */
 static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
-	int in_kernel, struct mm_struct *mm)
+			  struct mm_struct *mm)
 {
 	unsigned long rip;
 	int i, count;
@@ -592,12 +592,10 @@ void sync_buffer(int cpu)
 #ifdef CONFIG_OPROFILE_IBS
 			} else if (s->event == IBS_FETCH_BEGIN) {
 				state = sb_bt_start;
-				add_ibs_begin(cpu_buf,
-					IBS_FETCH_CODE, in_kernel, mm);
+				add_ibs_begin(cpu_buf, IBS_FETCH_CODE, mm);
 			} else if (s->event == IBS_OP_BEGIN) {
 				state = sb_bt_start;
-				add_ibs_begin(cpu_buf,
-					IBS_OP_CODE, in_kernel, mm);
+				add_ibs_begin(cpu_buf, IBS_OP_CODE, mm);
 #endif
 			} else {
 				struct mm_struct *oldmm = mm;
-- 
1.6.0.1


