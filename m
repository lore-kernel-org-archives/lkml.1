Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZFDMFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZFDMFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbZFDMFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:05:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:33670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757648AbZFDMFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:05:00 -0400
Date: Thu, 4 Jun 2009 12:04:39 GMT
From: tip-bot for Steven Whitehouse <swhiteho@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, swhiteho@redhat.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, swhiteho@redhat.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1243868015.29604.542.camel@localhost.localdomain>
References: <1243868015.29604.542.camel@localhost.localdomain>
Subject: [tip:tracing/core] tracing: add exports to use __print_symbolic and __print_flags from a module
Message-ID: <tip-ec081ddc3d90aab35bc0de19a358b964978837cf@git.kernel.org>
Git-Commit-ID: ec081ddc3d90aab35bc0de19a358b964978837cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 12:04:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec081ddc3d90aab35bc0de19a358b964978837cf
Gitweb:     http://git.kernel.org/tip/ec081ddc3d90aab35bc0de19a358b964978837cf
Author:     Steven Whitehouse <swhiteho@redhat.com>
AuthorDate: Mon, 1 Jun 2009 15:53:35 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 1 Jun 2009 23:25:29 -0400

tracing: add exports to use __print_symbolic and __print_flags from a module

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
