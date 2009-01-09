Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZAIKre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZAIKre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZAIKrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:47:25 -0500
Received: from ozlabs.org ([203.10.76.45]:44301 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbZAIKrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:47:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.11036.50521.678702@cargo.ozlabs.ibm.com>
Date: Fri, 9 Jan 2009 21:46:52 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/9] perf_counter: Add dummy perf_counter_print_debug function
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: minimize requirements on architectures

Currently, an architecture just enabling CONFIG_PERF_COUNTERS but not
providing any extra functions will fail to build with
perf_counter_print_debug being undefined, since we don't provide an
empty dummy definition like we do with the hw_perf_* functions.

This provides an empty dummy perf_counter_print_debug() to make it
easier for architectures to turn on CONFIG_PERF_COUNTERS.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 9ad11e4..4c0dccb 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -54,6 +54,8 @@ int __weak hw_perf_group_sched_in(struct perf_counter *group_leader,
 	return 0;
 }
 
+void __weak perf_counter_print_debug(void)	{ }
+
 static void
 list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 {
