Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbZKVLZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbZKVLZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZKVLZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:25:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:51240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbZKVLZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:25:32 -0500
Date: Sun, 22 Nov 2009 11:24:59 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <1258864015-10579-1-git-send-email-fweisbec@gmail.com>
References: <1258864015-10579-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix modular build
Message-ID: <tip-645e8cc0c9f01f07f384fd522b782e5e6ae9de18@git.kernel.org>
Git-Commit-ID: 645e8cc0c9f01f07f384fd522b782e5e6ae9de18
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  645e8cc0c9f01f07f384fd522b782e5e6ae9de18
Gitweb:     http://git.kernel.org/tip/645e8cc0c9f01f07f384fd522b782e5e6ae9de18
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 22 Nov 2009 12:20:19 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Nov 2009 12:21:33 +0100

perf_events: Fix modular build

Fix:

  ERROR: "perf_swevent_put_recursion_context" [fs/ext4/ext4.ko] undefined!
  ERROR: "perf_swevent_get_recursion_context" [fs/ext4/ext4.ko] undefined!

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
LKML-Reference: <1258864015-10579-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b26cb03..abe1ef4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3903,11 +3903,13 @@ int perf_swevent_get_recursion_context(int **recursion)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(perf_swevent_get_recursion_context);
 
 void perf_swevent_put_recursion_context(int *recursion)
 {
 	(*recursion)--;
 }
+EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
 
 static void __do_perf_sw_event(enum perf_type_id type, u32 event_id,
 			       u64 nr, int nmi,
