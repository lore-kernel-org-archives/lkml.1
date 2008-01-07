Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbYAGWXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbYAGWXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYAGWWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:22:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYAGWWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:22:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] core dump: real_parent ppid
X-Zippy-Says: FIRST, I'm covering you with OLIVE OIL and PRUNE WHIP!!
Message-Id: <20080107222244.F102726F9A5@magilla.localdomain>
Date: Mon,  7 Jan 2008 14:22:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The pr_ppid field reported in core dumps should match what
getppid() would have returned to that process, regardless of
whether a debugger is attached.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/binfmt_elf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index ba8de7c..f0b3171 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1384,7 +1384,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
 	prstatus->pr_pid = task_pid_vnr(p);
-	prstatus->pr_ppid = task_pid_vnr(p->parent);
+	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
@@ -1430,7 +1430,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_psargs[len] = 0;
 
 	psinfo->pr_pid = task_pid_vnr(p);
-	psinfo->pr_ppid = task_pid_vnr(p->parent);
+	psinfo->pr_ppid = task_pid_vnr(p->real_parent);
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 
