Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbZFBEqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbZFBEqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758477AbZFBEnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:43:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZFBEnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:43:39 -0400
Message-Id: <20090602044340.707875136@goodmis.org>
References: <20090602044315.439593107@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 00:43:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/10] tracing: add exports to use __print_symbolic and __print_flags from a module
Content-Disposition: inline; filename=0007-tracing-add-exports-to-use-__print_symbolic-and-__pr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

A patch to allow the use of __print_symbolic and __print_flags
from a module. This allows the current GFS2 tracing patch to
build.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
LKML-Reference: <1243868015.29604.542.camel@localhost.localdomain>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c12d95d..0fe3b22 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -17,6 +17,7 @@
 static DECLARE_RWSEM(trace_event_mutex);
 
 DEFINE_PER_CPU(struct trace_seq, ftrace_event_seq);
+EXPORT_PER_CPU_SYMBOL(ftrace_event_seq);
 
 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
@@ -250,6 +251,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 
 	return p->buffer;
 }
+EXPORT_SYMBOL(ftrace_print_flags_seq);
 
 const char *
 ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
@@ -275,6 +277,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 
 	return p->buffer;
 }
+EXPORT_SYMBOL(ftrace_print_symbols_seq);
 
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
-- 
1.6.3.1

-- 
