Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbXHFSza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbXHFSza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbXHFSzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:55:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:44305 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114AbXHFSzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=rotZtwhB/Wxyg0lPUGpdxVsAvjMF3HeY+6gUTDi4J/XivhpXc/UBSjgvUMZAw2PSNQJJy6QAk6mBGdrv8YBeuAuVKJ/UQsF+qW1Bw50N6m5D0CcNoqJuU75WoAkNL6LNl296N88h+8ZD3vebB0O7HDcwkprb7oR57pymbsOcajY=
Date: Mon, 6 Aug 2007 22:55:14 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ifdef struct task_struct::security
Message-ID: <20070806185514.GA5842@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For those who don't care about CONFIG_SECURITY.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/sched.h |    3 ++-
 kernel/fork.c         |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1086,8 +1086,9 @@ struct task_struct {
 	int (*notifier)(void *priv);
 	void *notifier_data;
 	sigset_t *notifier_mask;
-	
+#ifdef CONFIG_SECURITY
 	void *security;
+#endif
 	struct audit_context *audit_context;
 	seccomp_t seccomp;
 
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1066,7 +1066,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
+#ifdef CONFIG_SECURITY
 	p->security = NULL;
+#endif
 	p->io_context = NULL;
 	p->io_wait = NULL;
 	p->audit_context = NULL;

