Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZKBQRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZKBQRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZKBQRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:17:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:53636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647AbZKBQRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:17:30 -0500
Date: Mon, 2 Nov 2009 16:16:09 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AEE2D01.4010305@cn.fujitsu.com>
References: <4AEE2D01.4010305@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Fix to use __always_unused attribute
Message-ID: <tip-5e9b397292ca0b9409dced33e3a22ec993377064@git.kernel.org>
Git-Commit-ID: 5e9b397292ca0b9409dced33e3a22ec993377064
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e9b397292ca0b9409dced33e3a22ec993377064
Gitweb:     http://git.kernel.org/tip/5e9b397292ca0b9409dced33e3a22ec993377064
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 2 Nov 2009 08:51:13 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 15:47:54 +0100

tracing: Fix to use __always_unused attribute

____ftrace_check_##name() is used for compile-time check on
F_printk() only, so it should be marked as __unused instead
of __used.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4AEE2D01.4010305@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_export.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 9753fcc..c74848d 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -48,11 +48,11 @@
 struct ____ftrace_##name {					\
 	tstruct							\
 };								\
-static void __used ____ftrace_check_##name(void)		\
+static void __always_unused ____ftrace_check_##name(void)	\
 {								\
 	struct ____ftrace_##name *__entry = NULL;		\
 								\
-	/* force cmpile-time check on F_printk() */		\
+	/* force compile-time check on F_printk() */		\
 	printk(print);						\
 }
 
