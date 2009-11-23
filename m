Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZKWLxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZKWLxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZKWLxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:53:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:56040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231AbZKWLxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:53:35 -0500
Date: Mon, 23 Nov 2009 11:52:58 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Do not generate function trace entries in perf code
Message-ID: <tip-6e3d8330ae2c4b2c11a9577a0130d2ecda1c610d@git.kernel.org>
Git-Commit-ID: 6e3d8330ae2c4b2c11a9577a0130d2ecda1c610d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e3d8330ae2c4b2c11a9577a0130d2ecda1c610d
Gitweb:     http://git.kernel.org/tip/6e3d8330ae2c4b2c11a9577a0130d2ecda1c610d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 23 Nov 2009 10:19:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 10:19:20 +0100

perf events: Do not generate function trace entries in perf code

Decreases perf overhead when function tracing is enabled,
by about 50%.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/Makefile |    1 +
 kernel/Makefile              |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 68537e9..1d2cb38 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -5,6 +5,7 @@
 # Don't trace early stages of a secondary CPU boot
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_common.o = -pg
+CFLAGS_REMOVE_perf_event.o = -pg
 endif
 
 # Make sure load_percpu_segment has no stackprotector
diff --git a/kernel/Makefile b/kernel/Makefile
index 17b575e..6b7ce81 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -21,6 +21,7 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
+CFLAGS_REMOVE_perf_event.o = -pg
 endif
 
 obj-$(CONFIG_FREEZER) += freezer.o
