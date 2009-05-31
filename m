Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZEaURA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZEaURA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 16:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZEaUQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 16:16:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:50258 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZEaUQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 16:16:50 -0400
Date: Sun, 31 May 2009 20:16:04 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Fix unknown command help text
Message-ID: <tip-27b9613b7be39412775d0ab80f57229aa73bb07d@git.kernel.org>
Git-Commit-ID: 27b9613b7be39412775d0ab80f57229aa73bb07d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 31 May 2009 20:16:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27b9613b7be39412775d0ab80f57229aa73bb07d
Gitweb:     http://git.kernel.org/tip/27b9613b7be39412775d0ab80f57229aa73bb07d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 31 May 2009 22:09:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 31 May 2009 22:09:49 +0200

perf_counter tools: Fix unknown command help text

Arjan reported this error when entering an unknown command to perf:

  $ perf start
  fatal: Uh oh. Your system reports no Git commands at all.

The Git code expects there to be perf-* commands - but since Perf
is a 'pure' utility with no dash commands anymore, this old assumption
of Git does not hold anymore. Remove that error check.

Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/util/help.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/Documentation/perf_counter/util/help.c b/Documentation/perf_counter/util/help.c
index edde541..397487f 100644
--- a/Documentation/perf_counter/util/help.c
+++ b/Documentation/perf_counter/util/help.c
@@ -323,9 +323,6 @@ const char *help_unknown_cmd(const char *cmd)
 	qsort(main_cmds.names, main_cmds.cnt,
 	      sizeof(*main_cmds.names), levenshtein_compare);
 
-	if (!main_cmds.cnt)
-		die ("Uh oh. Your system reports no Git commands at all.");
-
 	best_similarity = main_cmds.names[0]->len;
 	n = 1;
 	while (n < main_cmds.cnt && best_similarity == main_cmds.names[n]->len)
