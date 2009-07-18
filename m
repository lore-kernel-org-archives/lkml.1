Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZGRJux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZGRJux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbZGRJuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:50:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:42227 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbZGRJut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:50:49 -0400
Date: Sat, 18 Jul 2009 09:50:15 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090716104817.517264409@samba.org>
References: <20090716104817.517264409@samba.org>
Subject: [tip:perfcounters/urgent] perf_counter: Synthesize VDSO mmap event
Message-ID: <tip-11b5f81e1b0ea0bc84fe32f0a27054e052b2bf84@git.kernel.org>
Git-Commit-ID: 11b5f81e1b0ea0bc84fe32f0a27054e052b2bf84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 09:50:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11b5f81e1b0ea0bc84fe32f0a27054e052b2bf84
Gitweb:     http://git.kernel.org/tip/11b5f81e1b0ea0bc84fe32f0a27054e052b2bf84
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 11:21:30 +0200

perf_counter: Synthesize VDSO mmap event

perf record synthesizes mmap events for the running process.
Right now it just catches file mappings, but we can check for
the vdso symbol and add that too.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090716104817.517264409@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4ef78a5..072aaf0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -313,6 +313,10 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 		if (*pbf == 'x') { /* vm_exec */
 			char *execname = strchr(bf, '/');
 
+			/* Catch VDSO */
+			if (execname == NULL)
+				execname = strstr(bf, "[vdso]");
+
 			if (execname == NULL)
 				continue;
 
