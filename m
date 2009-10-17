Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZJQKFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZJQKFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZJQKE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:04:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:32987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbZJQKE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:04:58 -0400
Date: Sat, 17 Oct 2009 10:04:13 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, fche@redhat.com, paulus@samba.org,
       acme@redhat.com, hpa@zytor.com, mingo@redhat.com, jkenisto@us.ibm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, hch@infradead.org,
       ananth@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       fche@redhat.com, linux-kernel@vger.kernel.org, jkenisto@us.ibm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, hch@infradead.org,
       ananth@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091007222814.1684.407.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091007222814.1684.407.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Robustify fixed field names against variable field names conflicts
Message-ID: <tip-e93f4d8539d5e9dd59f4af9d8ef4e9b62cfa1f81@git.kernel.org>
Git-Commit-ID: e93f4d8539d5e9dd59f4af9d8ef4e9b62cfa1f81
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:04:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e93f4d8539d5e9dd59f4af9d8ef4e9b62cfa1f81
Gitweb:     http://git.kernel.org/tip/e93f4d8539d5e9dd59f4af9d8ef4e9b62cfa1f81
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 7 Oct 2009 18:28:14 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 12 Oct 2009 23:31:51 +0200

tracing/kprobes: Robustify fixed field names against variable field names conflicts

Rename probe-common fixed field names to harder conflictable names,
because current 'ip', 'func', and other probe field names are easily in
conflict with user-specified variable names.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
LKML-Reference: <20091007222814.1684.407.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_kprobe.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index bb6cb2b..739f70e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -39,10 +39,10 @@
 #define KPROBE_EVENT_SYSTEM "kprobes"
 
 /* Reserved field names */
-#define FIELD_STRING_IP "ip"
-#define FIELD_STRING_NARGS "nargs"
-#define FIELD_STRING_RETIP "ret_ip"
-#define FIELD_STRING_FUNC "func"
+#define FIELD_STRING_IP "__probe_ip"
+#define FIELD_STRING_NARGS "__probe_nargs"
+#define FIELD_STRING_RETIP "__probe_ret_ip"
+#define FIELD_STRING_FUNC "__probe_func"
 
 const char *reserved_field_names[] = {
 	"common_type",
