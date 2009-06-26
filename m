Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZFZH2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZFZH2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZFZH2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:28:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:55636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZFZH2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:28:33 -0400
Date: Fri, 26 Jun 2009 07:27:53 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A443D59.4080307@cn.fujitsu.com>
References: <4A443D59.4080307@cn.fujitsu.com>
Subject: [tip:tracing/urgent] ftrace: Fix the output of profile
Message-ID: <tip-0296e4254f3318e0dcad9706fa1daf8e5addc1e9@git.kernel.org>
Git-Commit-ID: 0296e4254f3318e0dcad9706fa1daf8e5addc1e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 26 Jun 2009 07:27:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0296e4254f3318e0dcad9706fa1daf8e5addc1e9
Gitweb:     http://git.kernel.org/tip/0296e4254f3318e0dcad9706fa1daf8e5addc1e9
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 26 Jun 2009 11:15:37 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Jun 2009 09:25:42 +0200

ftrace: Fix the output of profile

The first entry of the ftrace profile was always skipped when
reading trace_stat/functionX.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A443D59.4080307@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 71a52c1..f3716bf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -291,7 +291,9 @@ function_stat_next(void *v, int idx)
 	pg = (struct ftrace_profile_page *)((unsigned long)rec & PAGE_MASK);
 
  again:
-	rec++;
+	if (idx != 0)
+		rec++;
+
 	if ((void *)rec >= (void *)&pg->records[pg->index]) {
 		pg = pg->next;
 		if (!pg)
