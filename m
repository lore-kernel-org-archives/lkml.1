Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZCLL6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZCLL6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZCLL6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:58:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:59726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbZCLL6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:58:11 -0400
Date: Thu, 12 Mar 2009 11:57:28 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B8F355.76E4.0078.0@novell.com>
References: <49B8F355.76E4.0078.0@novell.com>
Subject: [tip:x86/asm] x86: remove leftover unwind annotations
Message-ID: <tip-9fa7266c2f0cdfcb09eacba2d3624bec7df78641@git.kernel.org>
Git-Commit-ID: 9fa7266c2f0cdfcb09eacba2d3624bec7df78641
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 11:57:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fa7266c2f0cdfcb09eacba2d3624bec7df78641
Gitweb:     http://git.kernel.org/tip/9fa7266c2f0cdfcb09eacba2d3624bec7df78641
Author:     "Jan Beulich" <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 10:34:45 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 11:50:39 +0100

x86: remove leftover unwind annotations

Impact: cleanup

These got left in needlessly when ret_from_fork got simplified.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B8F355.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/entry_64.S |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7ba4621..54866bb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -416,7 +416,6 @@ ENTRY(ret_from_fork)
 
 	GET_THREAD_INFO(%rcx)
 
-	CFI_REMEMBER_STATE
 	RESTORE_REST
 
 	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
@@ -428,7 +427,6 @@ ENTRY(ret_from_fork)
 	RESTORE_TOP_OF_STACK %rdi, -ARGOFFSET
 	jmp ret_from_sys_call			# go to the SYSRET fastpath
 
-	CFI_RESTORE_STATE
 	CFI_ENDPROC
 END(ret_from_fork)
 
