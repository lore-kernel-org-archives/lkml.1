Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbYGPNvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbYGPNvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758602AbYGPNuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:50:40 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58688 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519AbYGPNui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:50:38 -0400
Date: Wed, 16 Jul 2008 17:53:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] coredump: binfmt_elf_fdpic: don't use sub-thread's ->mm
Message-ID: <20080716135358.GA1216@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change binfmt_elf_fdpic.c:fill_prstatus() to use current->mm instead of p->mm.
They are equal, but with the next patch p->mm == NULL.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 binfmt_elf_fdpic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- 26-rc2/fs/binfmt_elf_fdpic.c~6_DONT_USE_MM	2008-07-13 21:18:31.000000000 +0400
+++ 26-rc2/fs/binfmt_elf_fdpic.c	2008-07-15 21:48:48.000000000 +0400
@@ -1374,8 +1374,8 @@ static void fill_prstatus(struct elf_prs
 	cputime_to_timeval(p->signal->cutime, &prstatus->pr_cutime);
 	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
 
-	prstatus->pr_exec_fdpic_loadmap = p->mm->context.exec_fdpic_loadmap;
-	prstatus->pr_interp_fdpic_loadmap = p->mm->context.interp_fdpic_loadmap;
+	prstatus->pr_exec_fdpic_loadmap = current->mm->context.exec_fdpic_loadmap;
+	prstatus->pr_interp_fdpic_loadmap = current->mm->context.interp_fdpic_loadmap;
 }
 
 static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,

