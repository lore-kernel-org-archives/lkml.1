Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZFDPbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZFDPbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbZFDPbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:31:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:59020 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZFDPbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:31:16 -0400
Date: Thu, 4 Jun 2009 15:30:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Bail out if there are unrecognized options/arguments
Message-ID: <tip-edc52deac624e4641211a325c23da2a73b01a85d@git.kernel.org>
Git-Commit-ID: edc52deac624e4641211a325c23da2a73b01a85d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 15:30:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edc52deac624e4641211a325c23da2a73b01a85d
Gitweb:     http://git.kernel.org/tip/edc52deac624e4641211a325c23da2a73b01a85d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 4 Jun 2009 16:24:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 16:24:37 +0200

perf report: Bail out if there are unrecognized options/arguments

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 7beedc6..389ae25 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -1094,10 +1094,16 @@ int cmd_report(int argc, const char **argv, const char *prefix)
 
 	page_size = getpagesize();
 
-	parse_options(argc, argv, options, report_usage, 0);
+	argc = parse_options(argc, argv, options, report_usage, 0);
 
 	setup_sorting();
 
+	/*
+	 * Any (unrecognized) arguments left?
+	 */
+	if (argc)
+		usage_with_options(report_usage, options);
+
 	setup_pager();
 
 	return __cmd_report();
