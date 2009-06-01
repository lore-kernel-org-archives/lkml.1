Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbZFAOx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbZFAOx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZFAOxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:53:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49245 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZFAOxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:53:47 -0400
Subject: trace: Add exports to use __print_symbolic and __print_flags from
 a module
From: Steven Whitehouse <swhiteho@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 01 Jun 2009 15:53:35 +0100
Message-Id: <1243868015.29604.542.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A patch to allow the use of __print_symbolic and __print_flags
from a module. This allows the current GFS2 tracing patch to
build. This is against the latest -tip tree.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

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


