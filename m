Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZEOOpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZEOOpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762011AbZEOOoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:44:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:54768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762254AbZEOOoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:44:20 -0400
Date: Fri, 15 May 2009 14:43:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090515132018.707922166@chello.nl>
References: <20090515132018.707922166@chello.nl>
Subject: [tip:perfcounters/core] perf top: update to use the new freq interface
Message-ID: <tip-f5456a6b056b709282e87a68b4c1b81ac2e866fa@git.kernel.org>
Git-Commit-ID: f5456a6b056b709282e87a68b4c1b81ac2e866fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 14:43:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5456a6b056b709282e87a68b4c1b81ac2e866fa
Gitweb:     http://git.kernel.org/tip/f5456a6b056b709282e87a68b4c1b81ac2e866fa
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 15 May 2009 15:19:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 15:26:57 +0200

perf top: update to use the new freq interface

Provide perf top -F as alternative to -c.

[ Impact: new 'perf top' feature ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20090515132018.707922166@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index b1549dd..814b2e4 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -98,6 +98,7 @@ static unsigned int		page_size;
 static unsigned int		mmap_pages			=  16;
 static int			use_mmap			= 0;
 static int			use_munmap			= 0;
+static int			freq				= 0;
 
 static char			*vmlinux;
 
@@ -846,9 +847,10 @@ static void process_options(int argc, char **argv)
 			{"stat",	no_argument,		NULL, 'S'},
 			{"vmlinux",	required_argument,	NULL, 'x'},
 			{"zero",	no_argument,		NULL, 'z'},
+			{"freq",	required_argument,	NULL, 'F'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hln:m:p:r:s:Sx:zMU",
+		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hln:m:p:r:s:Sx:zMUF:",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -889,6 +891,7 @@ static void process_options(int argc, char **argv)
 		case 'm': mmap_pages			=   atoi(optarg); break;
 		case 'M': use_mmap			=              1; break;
 		case 'U': use_munmap			=              1; break;
+		case 'F': freq = 1; default_interval	=   atoi(optarg); break;
 		default: error = 1; break;
 		}
 	}
@@ -1075,6 +1078,7 @@ int cmd_top(int argc, char **argv, const char *prefix)
 			hw_event.nmi		= nmi;
 			hw_event.mmap		= use_mmap;
 			hw_event.munmap		= use_munmap;
+			hw_event.freq		= freq;
 
 			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
 			if (fd[i][counter] < 0) {
