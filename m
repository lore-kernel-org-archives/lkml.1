Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZD1WgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZD1WgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZD1WgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:36:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37249 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZD1WgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:36:07 -0400
Date: Wed, 29 Apr 2009 00:30:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: s/parent/real_parent/ in binfmt_elf_fdpic.c
Message-ID: <20090428223050.GA12020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->real_parent is the parent. ->parent may be the tracer.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/fs/binfmt_elf_fdpic.c~FDPIC	2009-04-06 00:03:40.000000000 +0200
+++ PTRACE/fs/binfmt_elf_fdpic.c	2009-04-28 21:40:49.000000000 +0200
@@ -1388,7 +1388,7 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
 	prstatus->pr_pid = task_pid_vnr(p);
-	prstatus->pr_ppid = task_pid_vnr(p->parent);
+	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
@@ -1433,7 +1433,7 @@ static int fill_psinfo(struct elf_prpsin
 	psinfo->pr_psargs[len] = 0;
 
 	psinfo->pr_pid = task_pid_vnr(p);
-	psinfo->pr_ppid = task_pid_vnr(p->parent);
+	psinfo->pr_ppid = task_pid_vnr(p->real_parent);
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 

