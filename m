Return-Path: <linux-kernel-owner+w=401wt.eu-S932707AbZAGXAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbZAGXAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762345AbZAGW6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:58:09 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64827 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760550AbZAGW6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:58:05 -0500
X-BigFish: VPS3(zzzzzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KD4IG9-02-ZHA-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 8/9] oprofile: remove #ifdef CONFIG_OPROFILE_IBS in non-ibs code
Date: Wed, 7 Jan 2009 23:45:24 +0100
Message-ID: <1231368325-19246-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0585 (UTC) FILETIME=[5B419490:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ifdefs can be removed since the code is no longer ibs specific and
can be used for other purposes as well. IBS specific code is only in
op_model_amd.c.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |    6 ------
 drivers/oprofile/cpu_buffer.c  |    4 ----
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index d692fdc..ac014cb 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -316,8 +316,6 @@ static void add_trace_begin(void)
 	add_event_entry(TRACE_BEGIN_CODE);
 }
 
-#ifdef CONFIG_OPROFILE_IBS
-
 static void add_data(struct op_entry *entry, struct mm_struct *mm)
 {
 	unsigned long code, pc, val;
@@ -355,8 +353,6 @@ static void add_data(struct op_entry *entry, struct mm_struct *mm)
 		add_event_entry(val);
 }
 
-#endif
-
 static inline void add_sample_entry(unsigned long offset, unsigned long event)
 {
 	add_event_entry(offset);
@@ -544,10 +540,8 @@ void sync_buffer(int cpu)
 					cookie = get_exec_dcookie(mm);
 				add_user_ctx_switch(new, cookie);
 			}
-#ifdef CONFIG_OPROFILE_IBS
 			if (op_cpu_buffer_get_size(&entry))
 				add_data(&entry, mm);
-#endif
 			continue;
 		}
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index ddba9d0..b846af6 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -361,8 +361,6 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 	__oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }
 
-#ifdef CONFIG_OPROFILE_IBS
-
 /*
  * Add samples with data to the ring buffer.
  *
@@ -397,8 +395,6 @@ fail:
 	cpu_buf->sample_lost_overflow++;
 }
 
-#endif
-
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
-- 
1.6.0.1


