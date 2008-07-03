Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYGCQrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYGCQrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYGCQqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:46:55 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47825 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbYGCQqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:46:54 -0400
Message-Id: <20080703161103.400501399@polymtl.ca>
References: <20080703160526.637679319@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jul 2008 12:05:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC patch 3/3] LTTng instrumentation FS tracepoint probes
Content-Disposition: inline; filename=lttng-instrumentation-fs-tracepoints-probes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  3 Jul 2008 16:11:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a module which declares FS tracepoint probes, using markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
---
 fs/Makefile   |    1 
 fs/fs-trace.c |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 173 insertions(+)

Index: linux-2.6-lttng/fs/fs-trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/fs/fs-trace.c	2008-07-03 11:53:11.000000000 -0400
@@ -0,0 +1,172 @@
+/*
+ * fs/fs-trace.c
+ *
+ * FS tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include <linux/buffer_head.h>
+#include "fs-trace.h"
+
+static void probe_fs_buffer_wait_start(void *private_data,
+		struct buffer_head *bh)
+{
+	trace_mark(fs_buffer_wait_start, "bh %p", bh);
+}
+
+static void probe_fs_buffer_wait_end(void *private_data,
+		struct buffer_head *bh)
+{
+	trace_mark(fs_buffer_wait_end, "bh %p", bh);
+}
+
+static void probe_fs_exec(void *private_data, char *filename)
+{
+	trace_mark(fs_exec, "filename %s", filename);
+}
+
+static void probe_fs_ioctl(void *private_data,
+		unsigned int fd, unsigned int cmd, unsigned long arg)
+{
+	trace_mark(fs_ioctl, "fd %u cmd %u arg %lu", fd, cmd, arg);
+}
+
+static void probe_fs_open(void *private_data, unsigned int fd, char *filename)
+{
+	trace_mark(fs_open, "fd %d filename %s", fd, filename);
+}
+
+static void probe_fs_close(void *private_data, unsigned int fd)
+{
+	trace_mark(fs_close, "fd %u", fd);
+}
+
+static void probe_fs_lseek(void *private_data,
+		unsigned int fd, unsigned long offset, unsigned int origin)
+{
+	trace_mark(fs_lseek, "fd %u offset %ld origin %u", fd, offset, origin);
+}
+
+static void probe_fs_llseek(void *private_data,
+		unsigned int fd, loff_t offset, unsigned int origin)
+{
+	trace_mark(fs_llseek, "fd %u offset %llu origin %u", fd,
+			(unsigned long long)offset, origin);
+}
+
+static void probe_fs_read(void *private_data, unsigned int fd, size_t count)
+{
+	trace_mark(fs_read, "fd %u count %zu", fd, count);
+}
+
+static void probe_fs_write(void *private_datat, unsigned int fd, size_t count)
+{
+	trace_mark(fs_write, "fd %u count %zu", fd, count);
+}
+
+static void probe_fs_pread64(void *private_data,
+		unsigned int fd, size_t count, loff_t pos)
+{
+	trace_mark(fs_pread64, "fd %u count %zu pos %llu",
+			fd, count, (unsigned long long)pos);
+}
+
+static void probe_fs_pwrite64(void *private_data,
+		unsigned int fd, size_t count, loff_t pos)
+{
+	trace_mark(fs_pwrite64, "fd %u count %zu pos %llu",
+			fd, count, (unsigned long long)pos);
+}
+
+static void probe_fs_readv(void *private_data,
+		unsigned long fd, unsigned long vlen)
+{
+	trace_mark(fs_readv, "fd %lu vlen %lu", fd, vlen);
+}
+
+static void probe_fs_writev(void *private_data,
+		unsigned long fd, unsigned long vlen)
+{
+	trace_mark(fs_writev, "fd %lu vlen %lu", fd, vlen);
+}
+
+static void probe_fs_select(void *private_data, int fd, s64 timeout)
+{
+	trace_mark(fs_select, "fd %d timeout #8d%lld", fd, (long long)timeout);
+}
+
+static void probe_fs_poll(void *private_data, int fd)
+{
+	trace_mark(fs_pollfd, "fd %d", fd);
+}
+
+
+int __init fs_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_fs_buffer_wait_start(probe_fs_buffer_wait_start,
+		NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_buffer_wait_end(probe_fs_buffer_wait_end,
+		NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_exec(probe_fs_exec, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_ioctl(probe_fs_ioctl, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_open(probe_fs_open, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_close(probe_fs_close, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_lseek(probe_fs_lseek, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_llseek(probe_fs_llseek, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_read(probe_fs_read, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_write(probe_fs_write, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_pread64(probe_fs_pread64, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_pwrite64(probe_fs_pwrite64, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_readv(probe_fs_readv, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_writev(probe_fs_writev, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_select(probe_fs_select, NULL);
+	WARN_ON(ret);
+	ret = register_trace_fs_poll(probe_fs_poll, NULL);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(fs_trace_init);
+
+void __exit fs_trace_exit(void)
+{
+	unregister_trace_fs_poll(probe_fs_poll, NULL);
+	unregister_trace_fs_select(probe_fs_select, NULL);
+	unregister_trace_fs_writev(probe_fs_writev, NULL);
+	unregister_trace_fs_readv(probe_fs_readv, NULL);
+	unregister_trace_fs_pwrite64(probe_fs_pwrite64, NULL);
+	unregister_trace_fs_pread64(probe_fs_pread64, NULL);
+	unregister_trace_fs_write(probe_fs_write, NULL);
+	unregister_trace_fs_read(probe_fs_read, NULL);
+	unregister_trace_fs_llseek(probe_fs_llseek, NULL);
+	unregister_trace_fs_lseek(probe_fs_lseek, NULL);
+	unregister_trace_fs_close(probe_fs_close, NULL);
+	unregister_trace_fs_open(probe_fs_open, NULL);
+	unregister_trace_fs_ioctl(probe_fs_ioctl, NULL);
+	unregister_trace_fs_exec(probe_fs_exec, NULL);
+	unregister_trace_fs_buffer_wait_end(probe_fs_buffer_wait_end, NULL);
+	unregister_trace_fs_buffer_wait_start(probe_fs_buffer_wait_start, NULL);
+}
+
+module_exit(fs_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("FS Tracepoint Probes");
Index: linux-2.6-lttng/fs/Makefile
===================================================================
--- linux-2.6-lttng.orig/fs/Makefile	2008-07-03 11:47:14.000000000 -0400
+++ linux-2.6-lttng/fs/Makefile	2008-07-03 11:49:54.000000000 -0400
@@ -63,6 +63,7 @@ obj-$(CONFIG_CONFIGFS_FS)	+= configfs/
 obj-y				+= devpts/
 
 obj-$(CONFIG_PROFILING)		+= dcookies.o
+obj-$(CONFIG_TRACEPROBES)	+= fs-trace.o
 obj-$(CONFIG_DLM)		+= dlm/
  
 # Do not add any filesystems before this line

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
