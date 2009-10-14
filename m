Return-Path: <linux-kernel-owner+w=401wt.eu-S934619AbZJNPsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbZJNPsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934327AbZJNPsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:48:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:34042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbZJNPsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:48:07 -0400
Date: Wed, 14 Oct 2009 15:47:08 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, gerg@uclinux.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, gerg@uclinux.org, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.0910130014520.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910130014520.3658@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/arch] m68knommu: Remove the BKL from sys_execve
Message-ID: <tip-eb7371d4fdcc40a390e8bdf90c99b5541213ca45@git.kernel.org>
Git-Commit-ID: eb7371d4fdcc40a390e8bdf90c99b5541213ca45
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:47:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb7371d4fdcc40a390e8bdf90c99b5541213ca45
Gitweb:     http://git.kernel.org/tip/eb7371d4fdcc40a390e8bdf90c99b5541213ca45
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Mon, 12 Oct 2009 23:37:28 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:18:14 +0200

m68knommu: Remove the BKL from sys_execve

This looks like a copy-and-paste of functionality that no-longer needs
the bkl.  Just remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
Reviewed: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
LKML-Reference: <alpine.LFD.2.00.0910130014520.3658@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/kernel/process.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 8f8f4ab..5c9ecd4 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -352,15 +352,12 @@ asmlinkage int sys_execve(char *name, char **argv, char **envp)
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
 
