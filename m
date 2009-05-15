Return-Path: <linux-kernel-owner+w=401wt.eu-S1763276AbZEONVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763276AbZEONVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762804AbZEONVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:21:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761588AbZEONVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:21:13 -0400
Message-Id: <20090515132018.707922166@chello.nl>
References: <20090515131925.616419905@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 15:19:29 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] perf_counter: update perf-top to use the new freq interface
Content-Disposition: inline; filename=perf_counter-tool-freq.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide perf top -F as alternative to -c.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>
---
 Documentation/perf_counter/builtin-top.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/Documentation/perf_counter/builtin-top.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-top.c
+++ linux-2.6/Documentation/perf_counter/builtin-top.c
@@ -98,6 +98,7 @@ static unsigned int		page_size;
 static unsigned int		mmap_pages			=  16;
 static int			use_mmap			= 0;
 static int			use_munmap			= 0;
+static int			freq				= 0;
 
 static char			*vmlinux;
 
@@ -846,9 +847,10 @@ static void process_options(int argc, ch
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
@@ -889,6 +891,7 @@ static void process_options(int argc, ch
 		case 'm': mmap_pages			=   atoi(optarg); break;
 		case 'M': use_mmap			=              1; break;
 		case 'U': use_munmap			=              1; break;
+		case 'F': freq = 1; default_interval	=   atoi(optarg); break;
 		default: error = 1; break;
 		}
 	}
@@ -1075,6 +1078,7 @@ int cmd_top(int argc, char **argv, const
 			hw_event.nmi		= nmi;
 			hw_event.mmap		= use_mmap;
 			hw_event.munmap		= use_munmap;
+			hw_event.freq		= freq;
 
 			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
 			if (fd[i][counter] < 0) {

-- 

