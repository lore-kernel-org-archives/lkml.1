Return-Path: <linux-kernel-owner+w=401wt.eu-S934647AbZJNPs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbZJNPs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934611AbZJNPs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:48:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:34057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934591AbZJNPsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:48:23 -0400
Date: Wed, 14 Oct 2009 15:47:24 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, yasutake.koichi@jp.panasonic.com, fweisbec@gmail.com,
       dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, fweisbec@gmail.com, jkacur@redhat.com,
       tglx@linutronix.de, yasutake.koichi@jp.panasonic.com
In-Reply-To: <alpine.LFD.2.00.0910130016540.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910130016540.3658@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/arch] mn10300: Remove the BKL from sys_execve
Message-ID: <tip-8c0daee204f794d095ae301f408c5f9f40e4547d@git.kernel.org>
Git-Commit-ID: 8c0daee204f794d095ae301f408c5f9f40e4547d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:47:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c0daee204f794d095ae301f408c5f9f40e4547d
Gitweb:     http://git.kernel.org/tip/8c0daee204f794d095ae301f408c5f9f40e4547d
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Mon, 12 Oct 2009 23:41:55 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:18:15 +0200

mn10300: Remove the BKL from sys_execve

This looks like a cut-and-paste from functionality that no-longer
needs the bkl Just remove it. Also, rewrite slightly so that it looks
closer to sys_execve on other architectures.

Signed-off-by: John Kacur <jkacur@redhat.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
LKML-Reference: <alpine.LFD.2.00.0910130016540.3658@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/kernel/process.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 892cce8..ec8a21d 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -275,16 +275,12 @@ asmlinkage long sys_execve(char __user *name,
 	char *filename;
 	int error;
 
-	lock_kernel();
-
 	filename = getname(name);
 	error = PTR_ERR(filename);
-	if (!IS_ERR(filename)) {
-		error = do_execve(filename, argv, envp, __frame);
-		putname(filename);
-	}
-
-	unlock_kernel();
+	if (IS_ERR(filename))
+		return error;
+	error = do_execve(filename, argv, envp, __frame);
+	putname(filename);
 	return error;
 }
 
