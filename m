Return-Path: <linux-kernel-owner+w=401wt.eu-S934665AbZJNPsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665AbZJNPsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934623AbZJNPr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:47:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:34034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934576AbZJNPr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:47:58 -0400
Date: Wed, 14 Oct 2009 15:46:52 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       geert@linux-m68k.org, fweisbec@gmail.com, jkacur@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, fweisbec@gmail.com, geert@linux-m68k.org,
       tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.0910130011180.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910130011180.3658@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/arch] m68k: Remove the BKL from sys_execve
Message-ID: <tip-2624167cd8b4965d0ef548e84767a30214edd8d4@git.kernel.org>
Git-Commit-ID: 2624167cd8b4965d0ef548e84767a30214edd8d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:46:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2624167cd8b4965d0ef548e84767a30214edd8d4
Gitweb:     http://git.kernel.org/tip/2624167cd8b4965d0ef548e84767a30214edd8d4
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Mon, 12 Oct 2009 23:09:24 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:18:14 +0200

m68k: Remove the BKL from sys_execve

This seems like a copy-and-paste from code that no-longer needs the
BKL Just remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <alpine.LFD.2.00.0910130011180.3658@localhost.localdomain>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/kernel/process.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 41230c5..0529659 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -317,15 +317,12 @@ asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __
 	char * filename;
 	struct pt_regs *regs = (struct pt_regs *) &name;
 
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
 
