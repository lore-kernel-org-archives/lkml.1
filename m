Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbZC0Fjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbZC0Fjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZC0Fjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:39:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60482 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbZC0Fja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:39:30 -0400
Message-ID: <49CC66AF.7030001@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 13:39:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/7] trace: make 'mem' argument of trace_seq_putmem() const
References: <49CC6691.7050103@cn.fujitsu.com>
In-Reply-To: <49CC6691.7050103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I passed a const value to trace_seq_putmem(), and I got compile warning.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_output.c |    6 +++---
 kernel/trace/trace_output.h |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 6595074..d72b9a6 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -137,7 +137,7 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 	return 1;
 }
 
-int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
+int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
 {
 	if (len > ((PAGE_SIZE - 1) - s->len))
 		return 0;
@@ -148,10 +148,10 @@ int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
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
index 46fb961..e0bde39 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -31,8 +31,9 @@ extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
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
-- 
1.5.4.rc3



