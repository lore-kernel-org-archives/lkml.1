Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZICO2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZICO2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZICO2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:28:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:55056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZICO2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:28:14 -0400
Date: Thu, 3 Sep 2009 14:27:37 GMT
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
Subject: [tip:perfcounters/core] perf trace: Fix parsing of perf.data
Message-ID: <tip-8886f42d6d8dabeb488c706c339634a0e3e08df4@git.kernel.org>
Git-Commit-ID: 8886f42d6d8dabeb488c706c339634a0e3e08df4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 14:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8886f42d6d8dabeb488c706c339634a0e3e08df4
Gitweb:     http://git.kernel.org/tip/8886f42d6d8dabeb488c706c339634a0e3e08df4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 3 Sep 2009 16:19:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Sep 2009 16:19:57 +0200

perf trace: Fix parsing of perf.data

We started parsing perf.data at head 0. This caused -D to
segfault and it could possibly also case incorrect trace
entries to be displayed.

Parse it at data_offset instead.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d59bf8a..914ab36 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -196,6 +196,7 @@ static int __cmd_trace(void)
 		exit(0);
 	}
 	header = perf_header__read(input);
+	head = header->data_offset;
 	sample_type = perf_header__sample_type(header);
 
 	if (!(sample_type & PERF_SAMPLE_RAW))
