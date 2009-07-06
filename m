Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZGFIPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZGFIPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZGFIPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:15:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58542 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZGFIPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:15:00 -0400
Message-ID: <4A51B288.70505@cn.fujitsu.com>
Date: Mon, 06 Jul 2009 16:15:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kmemtrace: rename some functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we have:
- kmemtrace_print_alloc/free() for kmemtrace default output
- kmemtrace_print_alloc/free_user() for binary output used
  by kmemtrace-user.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

forgot to CC LKML...again..

---
 kernel/trace/kmemtrace.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 74903b6..256827b 100644
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
@@ -482,14 +482,14 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 
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
-- 
1.5.4.rc3

