Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZJGWoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZJGWoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbZJGWoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:44:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:48222 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbZJGWoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:44:09 -0400
Date: Wed, 7 Oct 2009 22:43:13 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpuid: Remove the bkl from cpuid_open()
Message-ID: <tip-170a0bc3808909d8ea0f3f9c725c6565efe7f9c4@git.kernel.org>
Git-Commit-ID: 170a0bc3808909d8ea0f3f9c725c6565efe7f9c4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 22:43:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  170a0bc3808909d8ea0f3f9c725c6565efe7f9c4
Gitweb:     http://git.kernel.org/tip/170a0bc3808909d8ea0f3f9c725c6565efe7f9c4
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Wed, 7 Oct 2009 20:19:32 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 7 Oct 2009 15:41:21 -0700

x86, cpuid: Remove the bkl from cpuid_open()

Most of the variables are local to the function. It IS possible that
for struct cpuinfo_x86 *c c could point to the same area. However,
this is used read only.

Signed-off-by: John Kacur <jkacur@redhat.com>
LKML-Reference: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpuid.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index b07af88..ef69284 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -118,8 +118,6 @@ static int cpuid_open(struct inode *inode, struct file *file)
 	struct cpuinfo_x86 *c;
 	int ret = 0;
 
-	lock_kernel();
-
 	cpu = iminor(file->f_path.dentry->d_inode);
 	if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
 		ret = -ENXIO;	/* No such CPU */
@@ -129,7 +127,6 @@ static int cpuid_open(struct inode *inode, struct file *file)
 	if (c->cpuid_level < 0)
 		ret = -EIO;	/* CPUID not supported */
 out:
-	unlock_kernel();
 	return ret;
 }
 
