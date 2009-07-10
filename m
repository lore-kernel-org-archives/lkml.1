Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZGJKoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZGJKoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZGJKni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:43:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:53577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbZGJKnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:43:35 -0400
Date: Fri, 10 Jul 2009 10:42:33 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A51B288.70505@cn.fujitsu.com>
References: <4A51B288.70505@cn.fujitsu.com>
Subject: [tip:tracing/core] kmemtrace: Rename some functions
Message-ID: <tip-80098c200e2ee3b4c86a9d1e156dbcd05380e08f@git.kernel.org>
Git-Commit-ID: 80098c200e2ee3b4c86a9d1e156dbcd05380e08f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:42:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80098c200e2ee3b4c86a9d1e156dbcd05380e08f
Gitweb:     http://git.kernel.org/tip/80098c200e2ee3b4c86a9d1e156dbcd05380e08f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 6 Jul 2009 16:15:04 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 12:09:04 +0200

kmemtrace: Rename some functions

So we have:

 - kmemtrace_print_alloc/free() for kmemtrace default output

 - kmemtrace_print_alloc/free_user() for binary output used
   by kmemtrace-user.

Suggested-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A51B288.70505@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/kmemtrace.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 2f6fa47..dda53cc 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -239,7 +239,7 @@ struct kmemtrace_user_event_alloc {
 };
 
 static enum print_line_t
-kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
+kmemtrace_print_alloc(struct trace_iterator *iter, int flags)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_alloc_entry *entry;
@@ -259,7 +259,7 @@ kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
 }
 
 static enum print_line_t
-kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
+kmemtrace_print_free(struct trace_iterator *iter, int flags)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_free_entry *entry;
@@ -277,7 +277,7 @@ kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
 }
 
 static enum print_line_t
-kmemtrace_print_alloc_user_bin(struct trace_iterator *iter, int flags)
+kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_alloc_entry *entry;
@@ -311,7 +311,7 @@ kmemtrace_print_alloc_user_bin(struct trace_iterator *iter, int flags)
 }
 
 static enum print_line_t
-kmemtrace_print_free_user_bin(struct trace_iterator *iter, int flags)
+kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_free_entry *entry;
@@ -467,14 +467,14 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 
 static struct trace_event kmem_trace_alloc = {
 	.type			= TRACE_KMEM_ALLOC,
-	.trace			= kmemtrace_print_alloc_user,
-	.binary			= kmemtrace_print_alloc_user_bin,
+	.trace			= kmemtrace_print_alloc,
+	.binary			= kmemtrace_print_alloc_user,
 };
 
 static struct trace_event kmem_trace_free = {
 	.type			= TRACE_KMEM_FREE,
-	.trace			= kmemtrace_print_free_user,
-	.binary			= kmemtrace_print_free_user_bin,
+	.trace			= kmemtrace_print_free,
+	.binary			= kmemtrace_print_free_user,
 };
 
 static struct tracer kmem_tracer __read_mostly = {
