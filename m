Return-Path: <linux-kernel-owner+w=401wt.eu-S934657AbZJNPrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657AbZJNPrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934576AbZJNPrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:47:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:33989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934151AbZJNPrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:47:17 -0400
Date: Wed, 14 Oct 2009 15:46:20 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dhowells@redhat.com, fweisbec@gmail.com, jkacur@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, fweisbec@gmail.com, dhowells@redhat.com,
       tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/arch] frv: Remove the BKL from sys_execve
Message-ID: <tip-b69975a35a7332624b6977a5676a6fc320070360@git.kernel.org>
Git-Commit-ID: b69975a35a7332624b6977a5676a6fc320070360
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:46:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b69975a35a7332624b6977a5676a6fc320070360
Gitweb:     http://git.kernel.org/tip/b69975a35a7332624b6977a5676a6fc320070360
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Mon, 12 Oct 2009 22:53:25 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:18:14 +0200

frv: Remove the BKL from sys_execve

sys_execve for frv seems to be a copy-and-paste of sys_execve that no
longer requires the bkl. Just remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
LKML-Reference: <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/kernel/process.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 9042559..21d0fd1 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -255,15 +255,12 @@ asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __
 	int error;
 	char * filename;
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, __frame);
 	putname(filename);
- out:
-	unlock_kernel();
 	return error;
 }
 
