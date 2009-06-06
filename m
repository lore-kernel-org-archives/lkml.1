Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbZFFTW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbZFFTW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 15:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZFFTWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 15:22:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:43052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZFFTWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 15:22:18 -0400
Date: Sat, 6 Jun 2009 19:21:32 GMT
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
Subject: [tip:perfcounters/core] perf annotate: Automatically pick up vmlinux in the local directory
Message-ID: <tip-39273ee9756917129de3190d469b0b120f87e763@git.kernel.org>
Git-Commit-ID: 39273ee9756917129de3190d469b0b120f87e763
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 19:21:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39273ee9756917129de3190d469b0b120f87e763
Gitweb:     http://git.kernel.org/tip/39273ee9756917129de3190d469b0b120f87e763
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 6 Jun 2009 21:17:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 21:17:03 +0200

perf annotate: Automatically pick up vmlinux in the local directory

Right now kernel debug info does not get resolved by default, because
we dont know where to look for the vmlinux.

The -k option can be used for that - but if no option is given, pick
up vmlinux files in the current directory - in case a kernel hacker
runs profiling from the source directory that the kernel was built in.

The real solution would be to embedd the location (and perhaps the
date/timestamp) of the vmlinux file in /proc/kallsyms, so that
tools can pick it up automatically.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4a3c279..80c5aa0 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -26,7 +26,7 @@
 #define SHOW_HV		4
 
 static char		const *input_name = "perf.data";
-static char		*vmlinux = NULL;
+static char		*vmlinux = "vmlinux";
 
 static char		default_sort_order[] = "comm,symbol";
 static char		*sort_order = default_sort_order;
