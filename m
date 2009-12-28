Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZL1KGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZL1KGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZL1KGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:06:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:45901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZL1KGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:06:15 -0500
Date: Mon, 28 Dec 2009 10:04:37 GMT
From: tip-bot for Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       amwang@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       amwang@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091214082700.4224.57640.sendpatchset@localhost.localdomain>
References: <20091214082700.4224.57640.sendpatchset@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Use format string of printf to align strings
Message-ID: <tip-3912f2abc942a002ef611fc973add5e5eadb3432@git.kernel.org>
Git-Commit-ID: 3912f2abc942a002ef611fc973add5e5eadb3432
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3912f2abc942a002ef611fc973add5e5eadb3432
Gitweb:     http://git.kernel.org/tip/3912f2abc942a002ef611fc973add5e5eadb3432
Author:     Amerigo Wang <amwang@redhat.com>
AuthorDate: Mon, 14 Dec 2009 03:23:56 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 09:03:16 +0100

perf: Use format string of printf to align strings

Instead of filling whitespaces to do alignment, use
printf's format string.

This simplifies the code a bit.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091214082700.4224.57640.sendpatchset@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-help.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 9f810b1..e427d69 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -286,8 +286,7 @@ void list_common_cmds_help(void)
 
 	puts(" The most commonly used perf commands are:");
 	for (i = 0; i < ARRAY_SIZE(common_cmds); i++) {
-		printf("   %s   ", common_cmds[i].name);
-		mput_char(' ', longest - strlen(common_cmds[i].name));
+		printf("   %-*s   ", longest, common_cmds[i].name);
 		puts(common_cmds[i].help);
 	}
 }
