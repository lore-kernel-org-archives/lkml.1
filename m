Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZGEJxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZGEJxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZGEJwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:52:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:55419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566AbZGEJwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:52:47 -0400
Date: Sun, 5 Jul 2009 09:52:16 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, jens.axboe@oracle.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246772361-9960-3-git-send-email-fweisbec@gmail.com>
References: <1246772361-9960-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf report: Change default callchain parameters
Message-ID: <tip-94a8eb028a57854157a936c7e66b09e2559f115a@git.kernel.org>
Git-Commit-ID: 94a8eb028a57854157a936c7e66b09e2559f115a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Jul 2009 09:52:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94a8eb028a57854157a936c7e66b09e2559f115a
Gitweb:     http://git.kernel.org/tip/94a8eb028a57854157a936c7e66b09e2559f115a
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 5 Jul 2009 07:39:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Jul 2009 10:30:22 +0200

perf report: Change default callchain parameters

The default callchain parameters are set to use the flat mode and never
filter any overhead threshold of backtrace.

But flat mode is boring compared to graph mode.
Also the number of callchains may be very high if none is
filtered.

Let's change this to set the graph view and a minimum overhead of 0.5%
as default parameters.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246772361-9960-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3db99fd..8bd5865 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -59,10 +59,10 @@ static regex_t		parent_regex;
 
 static int		exclude_other = 1;
 
-static char		callchain_default_opt[] = "flat,0";
+static char		callchain_default_opt[] = "graph,0.5";
 static int		callchain;
 static enum chain_mode	callchain_mode;
-static double		callchain_min_percent = 0.0;
+static double		callchain_min_percent = 0.5;
 
 static u64		sample_type;
 
