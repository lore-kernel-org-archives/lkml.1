Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZJFNoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZJFNoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbZJFNoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:44:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:43091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbZJFNoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:44:09 -0400
Date: Tue, 6 Oct 2009 13:42:42 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Default to 1 KHz auto-sampling freq events
Message-ID: <tip-42e59d7d19dc4b49feab2a860fd9a8ca3248c833@git.kernel.org>
Git-Commit-ID: 42e59d7d19dc4b49feab2a860fd9a8ca3248c833
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 13:42:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42e59d7d19dc4b49feab2a860fd9a8ca3248c833
Gitweb:     http://git.kernel.org/tip/42e59d7d19dc4b49feab2a860fd9a8ca3248c833
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 6 Oct 2009 15:14:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Oct 2009 15:41:09 +0200

perf tools: Default to 1 KHz auto-sampling freq events

Use auto-freq events by default in perf record and
perf top.

This allows more consistent hardware event sampling,
regardless of the intensity of the underlying event.

It also keeps us from over-sampling on larger/busier
systems.

(also make surrounding initializations more consistent)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   52 +++++++++++++++++++++---------------------
 tools/perf/builtin-top.c    |   38 +++++++++++++++---------------
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3eeef33..494f8c7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -29,43 +29,43 @@ static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static long			default_interval		= 100000;
 
-static int			nr_cpus				= 0;
+static int			nr_cpus				=      0;
 static unsigned int		page_size;
-static unsigned int		mmap_pages			= 128;
-static int			freq				= 0;
+static unsigned int		mmap_pages			=    128;
+static int			freq				=   1000;
 static int			output;
 static const char		*output_name			= "perf.data";
-static int			group				= 0;
-static unsigned int		realtime_prio			= 0;
-static int			raw_samples			= 0;
-static int			system_wide			= 0;
-static int			profile_cpu			= -1;
-static pid_t			target_pid			= -1;
-static pid_t			child_pid			= -1;
-static int			inherit				= 1;
-static int			force				= 0;
-static int			append_file			= 0;
-static int			call_graph			= 0;
-static int			inherit_stat			= 0;
-static int			no_samples			= 0;
-static int			sample_address			= 0;
-static int			multiplex			= 0;
-static int			multiplex_fd			= -1;
-
-static long			samples;
+static int			group				=      0;
+static unsigned int		realtime_prio			=      0;
+static int			raw_samples			=      0;
+static int			system_wide			=      0;
+static int			profile_cpu			=     -1;
+static pid_t			target_pid			=     -1;
+static pid_t			child_pid			=     -1;
+static int			inherit				=      1;
+static int			force				=      0;
+static int			append_file			=      0;
+static int			call_graph			=      0;
+static int			inherit_stat			=      0;
+static int			no_samples			=      0;
+static int			sample_address			=      0;
+static int			multiplex			=      0;
+static int			multiplex_fd			=     -1;
+
+static long			samples				=      0;
 static struct timeval		last_read;
 static struct timeval		this_read;
 
-static u64			bytes_written;
+static u64			bytes_written			=      0;
 
 static struct pollfd		event_array[MAX_NR_CPUS * MAX_COUNTERS];
 
-static int			nr_poll;
-static int			nr_cpu;
+static int			nr_poll				=      0;
+static int			nr_cpu				=      0;
 
-static int			file_new = 1;
+static int			file_new			=      1;
 
-struct perf_header		*header;
+struct perf_header		*header				=   NULL;
 
 struct mmap_data {
 	int			counter;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c574c5b..d978dc9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -55,26 +55,26 @@
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static int			system_wide			=  0;
+static int			system_wide			=      0;
 
 static int			default_interval		= 100000;
 
-static int			count_filter			=  5;
-static int			print_entries			= 15;
+static int			count_filter			=      5;
+static int			print_entries			=     15;
 
-static int			target_pid			= -1;
-static int			inherit				=  0;
-static int			profile_cpu			= -1;
-static int			nr_cpus				=  0;
-static unsigned int		realtime_prio			=  0;
-static int			group				=  0;
+static int			target_pid			=     -1;
+static int			inherit				=      0;
+static int			profile_cpu			=     -1;
+static int			nr_cpus				=      0;
+static unsigned int		realtime_prio			=      0;
+static int			group				=      0;
 static unsigned int		page_size;
-static unsigned int		mmap_pages			= 16;
-static int			freq				=  0;
+static unsigned int		mmap_pages			=     16;
+static int			freq				=   1000; /* 1 KHz */
 
-static int			delay_secs			=  2;
-static int			zero;
-static int			dump_symtab;
+static int			delay_secs			=      2;
+static int			zero                            =      0;
+static int			dump_symtab                     =      0;
 
 /*
  * Source
@@ -87,11 +87,11 @@ struct source_line {
 	struct source_line	*next;
 };
 
-static char			*sym_filter			=  NULL;
-struct sym_entry		*sym_filter_entry		=  NULL;
-static int			sym_pcnt_filter			=  5;
-static int			sym_counter			=  0;
-static int			display_weighted		= -1;
+static char			*sym_filter			=   NULL;
+struct sym_entry		*sym_filter_entry		=   NULL;
+static int			sym_pcnt_filter			=      5;
+static int			sym_counter			=      0;
+static int			display_weighted		=     -1;
 
 /*
  * Symbols
