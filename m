Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbZAGWbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbZAGWbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762169AbZAGWXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:47 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40189 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762598AbZAGWXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:45 -0500
X-BigFish: VPS3(zzzzzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KD4GUB-02-XTJ-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/18] oprofile: simplify oprofile_begin_trace()
Date: Wed, 7 Jan 2009 23:17:26 +0100
Message-ID: <1231366655-17837-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0381 (UTC) FILETIME=[7F2F8650:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused return parameter in
oprofile_begin_trace(). Also, oprofile_begin_trace() and
oprofile_end_trace() are inline now.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 9e66c38..435bd6e 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -265,14 +265,13 @@ fail:
 	return 0;
 }
 
-static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
+static inline void oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
 	add_code(cpu_buf, CPU_TRACE_BEGIN);
 	cpu_buf->tracing = 1;
-	return 1;
 }
 
-static void oprofile_end_trace(struct oprofile_cpu_buffer *cpu_buf)
+static inline void oprofile_end_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
 	cpu_buf->tracing = 0;
 }
@@ -288,8 +287,7 @@ __oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 		return;
 	}
 
-	if (!oprofile_begin_trace(cpu_buf))
-		return;
+	oprofile_begin_trace(cpu_buf);
 
 	/*
 	 * if log_sample() fail we can't backtrace since we lost the
@@ -297,6 +295,7 @@ __oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 	 */
 	if (log_sample(cpu_buf, pc, is_kernel, event))
 		oprofile_ops.backtrace(regs, oprofile_backtrace_depth);
+
 	oprofile_end_trace(cpu_buf);
 }
 
-- 
1.6.0.1


