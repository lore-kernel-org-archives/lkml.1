Return-Path: <linux-kernel-owner+w=401wt.eu-S933468AbZJLW0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468AbZJLW0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbZJLW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:26:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:63038 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758633AbZJLW0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Py02IlLo+siYKLM491SjZCYTojPx9oOKw1bsHfh5qXF2eXzn6rNm1riNuAip0wFm0F
         SRd+J/iiq1DxS42JTWAqGhueQQtn31gznblfLuPgK/uqcD/6SxcZY1m8M76DcNIZkm5b
         UC5XImH6wU+o3h2yJXD2KgI0h+14hzHWhdYkQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/7] tracing/kprobes: Robustify fixed field names against variable field names conflicts
Date: Tue, 13 Oct 2009 00:25:07 +0200
Message-Id: <1255386309-4992-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255386309-4992-1-git-send-email-fweisbec@gmail.com>
References: <1255386309-4992-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
-- 
1.6.2.3

