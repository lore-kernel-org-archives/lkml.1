Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZC3BVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZC3BVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbZC3BVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:21:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:33041 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbZC3BVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:21:07 -0400
Date: Mon, 30 Mar 2009 01:20:00 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49CC380C.4010700@cn.fujitsu.com>
References: <49CC380C.4010700@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] trace: make argument 'mem' of trace_seq_putmem() const
Message-ID: <tip-a8168d4a50145652812866390939ae6774627a8e@git.kernel.org>
Git-Commit-ID: a8168d4a50145652812866390939ae6774627a8e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 30 Mar 2009 01:20:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8168d4a50145652812866390939ae6774627a8e
Gitweb:     http://git.kernel.org/tip/a8168d4a50145652812866390939ae6774627a8e
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 27 Mar 2009 10:21:00 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Mar 2009 03:16:16 +0200

trace: make argument 'mem' of trace_seq_putmem() const

Impact: fix build warning

I passed a const value to trace_seq_putmem(), and I got compile warning.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49CC380C.4010700@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_output.c |    6 +++---
 kernel/trace/trace_output.h |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 9c1ddd6..aeac358 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -147,7 +147,7 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 	return 1;
 }
 
-int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
+int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
 {
 	if (len > ((PAGE_SIZE - 1) - s->len))
 		return 0;
@@ -158,10 +158,10 @@ int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
 	return len;
 }
 
-int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
+int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
 {
 	unsigned char hex[HEX_CHARS];
-	unsigned char *data = mem;
+	const unsigned char *data = mem;
 	int i, j;
 
 #ifdef __BIG_ENDIAN
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index d8cb8c9..9163021 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -33,8 +33,9 @@ extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern int trace_seq_puts(struct trace_seq *s, const char *str);
 extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
-extern int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len);
-extern int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len);
+extern int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len);
+extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+				size_t len);
 extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
 extern int trace_seq_path(struct trace_seq *s, struct path *path);
 extern int seq_print_userip_objs(const struct userstack_entry *entry,
