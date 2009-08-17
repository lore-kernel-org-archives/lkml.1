Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZHQOpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZHQOpC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZHQOpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:45:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:56393 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbZHQOo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:44:28 -0400
Date: Mon, 17 Aug 2009 14:42:36 GMT
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, acme@redhat.com, mingo@redhat.com,
       williams@redhat.com, efault@gmx.de, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, jonathan@jonmasters.org,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       anton@samba.org, jiayingz@google.com, paulus@samba.org, fche@redhat.com,
       hpa@zytor.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       xiaoguangrong@cn.fujitsu.com, hch@infradead.org, roland@redhat.com,
       mingo@elte.hu, lclaudio@uudg.org
Reply-To: mingo@redhat.com, acme@redhat.com, mathieu.desnoyers@polymtl.ca,
       williams@redhat.com, peterz@infradead.org, efault@gmx.de,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       jonathan@jonmasters.org, tglx@linutronix.de, jbaron@redhat.com,
       laijs@cn.fujitsu.com, mhiramat@redhat.com, hpa@zytor.com,
       fche@redhat.com, paulus@samba.org, jiayingz@google.com,
       linux-kernel@vger.kernel.org, anton@samba.org, tzanussi@gmail.com,
       lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com, hch@infradead.org,
       roland@redhat.com, lclaudio@uudg.org, mingo@elte.hu
In-Reply-To: <1250518688-7207-1-git-send-email-fweisbec@gmail.com>
References: <1250518688-7207-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/tracing] perf tools: Add trace event debugfs IO handler
Message-ID: <tip-520509436417901f30106e021e037c75dfe5386c@git.kernel.org>
Git-Commit-ID: 520509436417901f30106e021e037c75dfe5386c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 14:42:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  520509436417901f30106e021e037c75dfe5386c
Gitweb:     http://git.kernel.org/tip/520509436417901f30106e021e037c75dfe5386c
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Mon, 17 Aug 2009 16:18:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 16:32:38 +0200

perf tools: Add trace event debugfs IO handler

Add util/trace-event-info.c which handles ftrace file IO from
debugfs and provides general helpers to fetch/save ftrace
events informations.

This file is a rename of the trace-cmd.c file from the
trace-cmd tools, written by Steven Rostedt and Josh Triplett,
originated from the git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

This is a perf tools integration.

For now, ftrace events information is saved in a separate file
than the standard perf.data

[fweisbec@gmail.com: various changes for perf tools integration]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Jon Masters <jonathan@jonmasters.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Anton Blanchard <anton@samba.org>
LKML-Reference: <1250518688-7207-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/trace-event-info.c |  491 ++++++++++++++++++++++++++++++++++++
 tools/perf/util/trace-event.h      |  238 +++++++++++++++++
 2 files changed, 729 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
new file mode 100644
index 0000000..78adff1
--- /dev/null
+++ b/tools/perf/util/trace-event-info.c
@@ -0,0 +1,491 @@
+/*
+ * Copyright (C) 2008,2009, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#define _GNU_SOURCE
+#include <dirent.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <pthread.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <errno.h>
+
+#include "trace-event.h"
+
+
+#define VERSION "0.5"
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+#define MAX_PATH 256
+
+#define TRACE_CTRL	"tracing_on"
+#define TRACE		"trace"
+#define AVAILABLE	"available_tracers"
+#define CURRENT		"current_tracer"
+#define ITER_CTRL	"trace_options"
+#define MAX_LATENCY	"tracing_max_latency"
+
+unsigned int page_size;
+
+static const char *output_file = "trace.info";
+static int output_fd;
+
+struct event_list {
+	struct event_list *next;
+	const char *event;
+};
+
+struct events {
+	struct events *sibling;
+	struct events *children;
+	struct events *next;
+	char *name;
+};
+
+
+
+static void die(const char *fmt, ...)
+{
+	va_list ap;
+	int ret = errno;
+
+	if (errno)
+		perror("trace-cmd");
+	else
+		ret = -1;
+
+	va_start(ap, fmt);
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+
+	fprintf(stderr, "\n");
+	exit(ret);
+}
+
+void *malloc_or_die(unsigned int size)
+{
+	void *data;
+
+	data = malloc(size);
+	if (!data)
+		die("malloc");
+	return data;
+}
+
+static const char *find_debugfs(void)
+{
+	static char debugfs[MAX_PATH+1];
+	static int debugfs_found;
+	char type[100];
+	FILE *fp;
+
+	if (debugfs_found)
+		return debugfs;
+
+	if ((fp = fopen("/proc/mounts","r")) == NULL)
+		die("Can't open /proc/mounts for read");
+
+	while (fscanf(fp, "%*s %"
+		      STR(MAX_PATH)
+		      "s %99s %*s %*d %*d\n",
+		      debugfs, type) == 2) {
+		if (strcmp(type, "debugfs") == 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") != 0)
+		die("debugfs not mounted, please mount");
+
+	debugfs_found = 1;
+
+	return debugfs;
+}
+
+/*
+ * Finds the path to the debugfs/tracing
+ * Allocates the string and stores it.
+ */
+static const char *find_tracing_dir(void)
+{
+	static char *tracing;
+	static int tracing_found;
+	const char *debugfs;
+
+	if (tracing_found)
+		return tracing;
+
+	debugfs = find_debugfs();
+
+	tracing = malloc_or_die(strlen(debugfs) + 9);
+
+	sprintf(tracing, "%s/tracing", debugfs);
+
+	tracing_found = 1;
+	return tracing;
+}
+
+static char *get_tracing_file(const char *name)
+{
+	const char *tracing;
+	char *file;
+
+	tracing = find_tracing_dir();
+	if (!tracing)
+		return NULL;
+
+	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
+
+	sprintf(file, "%s/%s", tracing, name);
+	return file;
+}
+
+static void put_tracing_file(char *file)
+{
+	free(file);
+}
+
+static ssize_t write_or_die(const void *buf, size_t len)
+{
+	int ret;
+
+	ret = write(output_fd, buf, len);
+	if (ret < 0)
+		die("writing to '%s'", output_file);
+
+	return ret;
+}
+
+int bigendian(void)
+{
+	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
+	unsigned int *ptr;
+
+	ptr = (unsigned int *)str;
+	return *ptr == 0x01020304;
+}
+
+static unsigned long long copy_file_fd(int fd)
+{
+	unsigned long long size = 0;
+	char buf[BUFSIZ];
+	int r;
+
+	do {
+		r = read(fd, buf, BUFSIZ);
+		if (r > 0) {
+			size += r;
+			write_or_die(buf, r);
+		}
+	} while (r > 0);
+
+	return size;
+}
+
+static unsigned long long copy_file(const char *file)
+{
+	unsigned long long size = 0;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		die("Can't read '%s'", file);
+	size = copy_file_fd(fd);
+	close(fd);
+
+	return size;
+}
+
+static unsigned long get_size_fd(int fd)
+{
+	unsigned long long size = 0;
+	char buf[BUFSIZ];
+	int r;
+
+	do {
+		r = read(fd, buf, BUFSIZ);
+		if (r > 0)
+			size += r;
+	} while (r > 0);
+
+	lseek(fd, 0, SEEK_SET);
+
+	return size;
+}
+
+static unsigned long get_size(const char *file)
+{
+	unsigned long long size = 0;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		die("Can't read '%s'", file);
+	size = get_size_fd(fd);
+	close(fd);
+
+	return size;
+}
+
+static void read_header_files(void)
+{
+	unsigned long long size, check_size;
+	char *path;
+	int fd;
+
+	path = get_tracing_file("events/header_page");
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		die("can't read '%s'", path);
+
+	/* unfortunately, you can not stat debugfs files for size */
+	size = get_size_fd(fd);
+
+	write_or_die("header_page", 12);
+	write_or_die(&size, 8);
+	check_size = copy_file_fd(fd);
+	if (size != check_size)
+		die("wrong size for '%s' size=%lld read=%lld",
+		    path, size, check_size);
+	put_tracing_file(path);
+
+	path = get_tracing_file("events/header_event");
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		die("can't read '%s'", path);
+
+	size = get_size_fd(fd);
+
+	write_or_die("header_event", 13);
+	write_or_die(&size, 8);
+	check_size = copy_file_fd(fd);
+	if (size != check_size)
+		die("wrong size for '%s'", path);
+	put_tracing_file(path);
+}
+
+static void copy_event_system(const char *sys)
+{
+	unsigned long long size, check_size;
+	struct dirent *dent;
+	struct stat st;
+	char *format;
+	DIR *dir;
+	int count = 0;
+	int ret;
+
+	dir = opendir(sys);
+	if (!dir)
+		die("can't read directory '%s'", sys);
+
+	while ((dent = readdir(dir))) {
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0)
+			continue;
+		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		sprintf(format, "%s/%s/format", sys, dent->d_name);
+		ret = stat(format, &st);
+		free(format);
+		if (ret < 0)
+			continue;
+		count++;
+	}
+
+	write_or_die(&count, 4);
+
+	rewinddir(dir);
+	while ((dent = readdir(dir))) {
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0)
+			continue;
+		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		sprintf(format, "%s/%s/format", sys, dent->d_name);
+		ret = stat(format, &st);
+
+		if (ret >= 0) {
+			/* unfortunately, you can not stat debugfs files for size */
+			size = get_size(format);
+			write_or_die(&size, 8);
+			check_size = copy_file(format);
+			if (size != check_size)
+				die("error in size of file '%s'", format);
+		}
+
+		free(format);
+	}
+}
+
+static void read_ftrace_files(void)
+{
+	char *path;
+
+	path = get_tracing_file("events/ftrace");
+
+	copy_event_system(path);
+
+	put_tracing_file(path);
+}
+
+static void read_event_files(void)
+{
+	struct dirent *dent;
+	struct stat st;
+	char *path;
+	char *sys;
+	DIR *dir;
+	int count = 0;
+	int ret;
+
+	path = get_tracing_file("events");
+
+	dir = opendir(path);
+	if (!dir)
+		die("can't read directory '%s'", path);
+
+	while ((dent = readdir(dir))) {
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    strcmp(dent->d_name, "ftrace") == 0)
+			continue;
+		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
+		sprintf(sys, "%s/%s", path, dent->d_name);
+		ret = stat(sys, &st);
+		free(sys);
+		if (ret < 0)
+			continue;
+		if (S_ISDIR(st.st_mode))
+			count++;
+	}
+
+	write_or_die(&count, 4);
+
+	rewinddir(dir);
+	while ((dent = readdir(dir))) {
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    strcmp(dent->d_name, "ftrace") == 0)
+			continue;
+		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
+		sprintf(sys, "%s/%s", path, dent->d_name);
+		ret = stat(sys, &st);
+		if (ret >= 0) {
+			if (S_ISDIR(st.st_mode)) {
+				write_or_die(dent->d_name, strlen(dent->d_name) + 1);
+				copy_event_system(sys);
+			}
+		}
+		free(sys);
+	}
+
+	put_tracing_file(path);
+}
+
+static void read_proc_kallsyms(void)
+{
+	unsigned int size, check_size;
+	const char *path = "/proc/kallsyms";
+	struct stat st;
+	int ret;
+
+	ret = stat(path, &st);
+	if (ret < 0) {
+		/* not found */
+		size = 0;
+		write_or_die(&size, 4);
+		return;
+	}
+	size = get_size(path);
+	write_or_die(&size, 4);
+	check_size = copy_file(path);
+	if (size != check_size)
+		die("error in size of file '%s'", path);
+
+}
+
+static void read_ftrace_printk(void)
+{
+	unsigned int size, check_size;
+	const char *path;
+	struct stat st;
+	int ret;
+
+	path = get_tracing_file("printk_formats");
+	ret = stat(path, &st);
+	if (ret < 0) {
+		/* not found */
+		size = 0;
+		write_or_die(&size, 4);
+		return;
+	}
+	size = get_size(path);
+	write_or_die(&size, 4);
+	check_size = copy_file(path);
+	if (size != check_size)
+		die("error in size of file '%s'", path);
+
+}
+
+void read_tracing_data(void)
+{
+	char buf[BUFSIZ];
+
+	output_fd = open(output_file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (output_fd < 0)
+		die("creating file '%s'", output_file);
+
+	buf[0] = 23;
+	buf[1] = 8;
+	buf[2] = 68;
+	memcpy(buf + 3, "tracing", 7);
+
+	write_or_die(buf, 10);
+
+	write_or_die(VERSION, strlen(VERSION) + 1);
+
+	/* save endian */
+	if (bigendian())
+		buf[0] = 1;
+	else
+		buf[0] = 0;
+
+	write_or_die(buf, 1);
+
+	/* save size of long */
+	buf[0] = sizeof(long);
+	write_or_die(buf, 1);
+
+	/* save page_size */
+	page_size = getpagesize();
+	write_or_die(&page_size, 4);
+
+	read_header_files();
+	read_ftrace_files();
+	read_event_files();
+	read_proc_kallsyms();
+	read_ftrace_printk();
+}
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
new file mode 100644
index 0000000..3ddb894
--- /dev/null
+++ b/tools/perf/util/trace-event.h
@@ -0,0 +1,238 @@
+#ifndef _PARSE_EVENTS_H
+#define _PARSE_EVENTS_H
+
+
+#define __unused __attribute__((unused))
+
+
+#ifndef PAGE_MASK
+#define PAGE_MASK (page_size - 1)
+#endif
+
+enum {
+	RINGBUF_TYPE_PADDING		= 29,
+	RINGBUF_TYPE_TIME_EXTEND	= 30,
+	RINGBUF_TYPE_TIME_STAMP		= 31,
+};
+
+#ifndef TS_SHIFT
+#define TS_SHIFT		27
+#endif
+
+#define NSECS_PER_SEC		1000000000ULL
+#define NSECS_PER_USEC		1000ULL
+
+enum format_flags {
+	FIELD_IS_ARRAY		= 1,
+	FIELD_IS_POINTER	= 2,
+};
+
+struct format_field {
+	struct format_field	*next;
+	char			*type;
+	char			*name;
+	int			offset;
+	int			size;
+	unsigned long		flags;
+};
+
+struct format {
+	int			nr_common;
+	int			nr_fields;
+	struct format_field	*common_fields;
+	struct format_field	*fields;
+};
+
+struct print_arg_atom {
+	char			*atom;
+};
+
+struct print_arg_string {
+	char			*string;
+};
+
+struct print_arg_field {
+	char			*name;
+	struct format_field	*field;
+};
+
+struct print_flag_sym {
+	struct print_flag_sym	*next;
+	char			*value;
+	char			*str;
+};
+
+struct print_arg_typecast {
+	char 			*type;
+	struct print_arg	*item;
+};
+
+struct print_arg_flags {
+	struct print_arg	*field;
+	char			*delim;
+	struct print_flag_sym	*flags;
+};
+
+struct print_arg_symbol {
+	struct print_arg	*field;
+	struct print_flag_sym	*symbols;
+};
+
+struct print_arg;
+
+struct print_arg_op {
+	char			*op;
+	int			prio;
+	struct print_arg	*left;
+	struct print_arg	*right;
+};
+
+struct print_arg_func {
+	char			*name;
+	struct print_arg	*args;
+};
+
+enum print_arg_type {
+	PRINT_NULL,
+	PRINT_ATOM,
+	PRINT_FIELD,
+	PRINT_FLAGS,
+	PRINT_SYMBOL,
+	PRINT_TYPE,
+	PRINT_STRING,
+	PRINT_OP,
+};
+
+struct print_arg {
+	struct print_arg		*next;
+	enum print_arg_type		type;
+	union {
+		struct print_arg_atom		atom;
+		struct print_arg_field		field;
+		struct print_arg_typecast	typecast;
+		struct print_arg_flags		flags;
+		struct print_arg_symbol		symbol;
+		struct print_arg_func		func;
+		struct print_arg_string		string;
+		struct print_arg_op		op;
+	};
+};
+
+struct print_fmt {
+	char			*format;
+	struct print_arg	*args;
+};
+
+struct event {
+	struct event		*next;
+	char			*name;
+	int			id;
+	int			flags;
+	struct format		format;
+	struct print_fmt	print_fmt;
+};
+
+enum {
+	EVENT_FL_ISFTRACE	= 1,
+	EVENT_FL_ISPRINT	= 2,
+	EVENT_FL_ISBPRINT	= 4,
+	EVENT_FL_ISFUNC		= 8,
+	EVENT_FL_ISFUNCENT	= 16,
+	EVENT_FL_ISFUNCRET	= 32,
+};
+
+struct record {
+	unsigned long long ts;
+	int size;
+	void *data;
+};
+
+struct record *trace_peek_data(int cpu);
+struct record *trace_read_data(int cpu);
+
+void parse_set_info(int nr_cpus, int long_sz);
+
+void trace_report(void);
+
+void *malloc_or_die(unsigned int size);
+
+void parse_cmdlines(char *file, int size);
+void parse_proc_kallsyms(char *file, unsigned int size);
+void parse_ftrace_printk(char *file, unsigned int size);
+
+void print_funcs(void);
+void print_printk(void);
+
+int parse_ftrace_file(char *buf, unsigned long size);
+int parse_event_file(char *buf, unsigned long size, char *system);
+void print_event(int cpu, void *data, int size, unsigned long long nsecs,
+		  char *comm);
+
+extern int file_bigendian;
+extern int host_bigendian;
+
+int bigendian(void);
+
+static inline unsigned short __data2host2(unsigned short data)
+{
+	unsigned short swap;
+
+	if (host_bigendian == file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 8) |
+		((data & (0xffULL << 8)) >> 8);
+
+	return swap;
+}
+
+static inline unsigned int __data2host4(unsigned int data)
+{
+	unsigned int swap;
+
+	if (host_bigendian == file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 24) |
+		((data & (0xffULL << 8)) << 8) |
+		((data & (0xffULL << 16)) >> 8) |
+		((data & (0xffULL << 24)) >> 24);
+
+	return swap;
+}
+
+static inline unsigned long long __data2host8(unsigned long long data)
+{
+	unsigned long long swap;
+
+	if (host_bigendian == file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 56) |
+		((data & (0xffULL << 8)) << 40) |
+		((data & (0xffULL << 16)) << 24) |
+		((data & (0xffULL << 24)) << 8) |
+		((data & (0xffULL << 32)) >> 8) |
+		((data & (0xffULL << 40)) >> 24) |
+		((data & (0xffULL << 48)) >> 40) |
+		((data & (0xffULL << 56)) >> 56);
+
+	return swap;
+}
+
+#define data2host2(ptr)		__data2host2(*(unsigned short *)ptr)
+#define data2host4(ptr)		__data2host4(*(unsigned int *)ptr)
+#define data2host8(ptr)		__data2host8(*(unsigned long long *)ptr)
+
+extern int header_page_ts_offset;
+extern int header_page_ts_size;
+extern int header_page_size_offset;
+extern int header_page_size_size;
+extern int header_page_data_offset;
+extern int header_page_data_size;
+
+int parse_header_page(char *buf, unsigned long size);
+
+void read_tracing_data(void);
+
+#endif /* _PARSE_EVENTS_H */
