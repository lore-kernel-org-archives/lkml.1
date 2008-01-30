Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbYA3PBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbYA3PBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYA3PBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:01:04 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:36801 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYA3PBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:01:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALofoEdMQWYq/2dsb2JhbACBWJAhnheBdg
Date: Wed, 30 Jan 2008 09:55:49 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Fix x86_64 duplicated TIF
Message-ID: <20080130145549.GA13588@Krystal>
References: <20080130145059.GA13000@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080130145059.GA13000@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:54:35 up 87 days, 20:00,  6 users,  load average: 1.21, 1.13,
	0.90
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder if this is expected ? (in current 2.6.24-git)

commit 7e9916040b3020d0f36d68bb7512e3b80b623097
and commit eee3af4a2c83a97fff107ddc445d9df6fded9ce4

Both use the same TIF number (25) in thread_info_64.h.

This patch changes the TIF ids.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-x86/thread_info_64.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/thread_info_64.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/thread_info_64.h	2008-01-30 09:52:56.000000000 -0500
+++ linux-2.6-lttng/include/asm-x86/thread_info_64.h	2008-01-30 09:53:14.000000000 -0500
@@ -123,8 +123,8 @@ static inline struct thread_info *stack_
 #define TIF_FREEZE		23	/* is freezing for suspend */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
-#define TIF_DS_AREA_MSR	25      /* uses thread_struct.ds_area_msr */
-#define TIF_BTS_TRACE_TS	26      /* record scheduling event timestamps */
+#define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
+#define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
