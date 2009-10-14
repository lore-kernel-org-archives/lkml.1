Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbZJNPsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbZJNPsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934611AbZJNPsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:48:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:34045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbZJNPsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:48:10 -0400
Date: Wed, 14 Oct 2009 15:46:36 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, jkacur@redhat.com, tglx@linutronix.de,
       ysato@users.sourceforge.jp
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       ysato@users.sourceforge.jp
In-Reply-To: <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/arch] h83000: Remove BKL from sys_execve
Message-ID: <tip-e3c1a6b35c84795f7cb31cb7f4748166904cc0bc@git.kernel.org>
Git-Commit-ID: e3c1a6b35c84795f7cb31cb7f4748166904cc0bc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:46:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3c1a6b35c84795f7cb31cb7f4748166904cc0bc
Gitweb:     http://git.kernel.org/tip/e3c1a6b35c84795f7cb31cb7f4748166904cc0bc
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Mon, 12 Oct 2009 23:04:11 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:18:14 +0200

h83000: Remove BKL from sys_execve

This looks like a copy-and-paste job for code that no-longer needs the
BKL Just remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
LKML-Reference: <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/h8300/kernel/process.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index e2f33d0..bd883fa 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -218,15 +218,12 @@ asmlinkage int sys_execve(char *name, char **argv, char **envp,int dummy,...)
 	char * filename;
 	struct pt_regs *regs = (struct pt_regs *) ((unsigned char *)&dummy-4);
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
-out:
-	unlock_kernel();
 	return error;
 }
 
