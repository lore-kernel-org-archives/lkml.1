Return-Path: <linux-kernel-owner+w=401wt.eu-S965859AbXCLNuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965859AbXCLNuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965855AbXCLNuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:50:09 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:4879 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965854AbXCLNuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:50:07 -0400
Date: Mon, 12 Mar 2007 14:50:13 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Wire up compat_sys_epoll_pwait.
Message-ID: <20070312135013.GA11426@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Wire up compat_sys_epoll_pwait.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/compat_wrapper.S |   11 +++++++++++
 arch/s390/kernel/syscalls.S       |    2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/arch/s390/kernel/compat_wrapper.S linux-2.6-patched/arch/s390/kernel/compat_wrapper.S
--- linux-2.6/arch/s390/kernel/compat_wrapper.S	2007-03-12 13:52:25.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/compat_wrapper.S	2007-03-12 13:53:00.000000000 +0100
@@ -1665,3 +1665,14 @@ sys_getcpu_wrapper:
 	llgtr	%r3,%r3			# unsigned *
 	llgtr	%r4,%r4			# struct getcpu_cache *
 	jg	sys_getcpu
+
+	.globl	compat_sys_epoll_pwait_wrapper
+compat_sys_epoll_pwait_wrapper:
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# struct compat_epoll_event *
+	lgfr	%r4,%r4			# int
+	lgfr	%r5,%r5			# int
+	llgtr	%r6,%r6			# compat_sigset_t *
+	llgf	%r0,164(%r15)		# compat_size_t
+	stg	%r0,160(%r15)
+	jg	compat_sys_epoll_pwait
diff -urpN linux-2.6/arch/s390/kernel/syscalls.S linux-2.6-patched/arch/s390/kernel/syscalls.S
--- linux-2.6/arch/s390/kernel/syscalls.S	2007-03-12 13:52:25.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/syscalls.S	2007-03-12 13:53:00.000000000 +0100
@@ -320,4 +320,4 @@ SYSCALL(sys_tee,sys_tee,sys_tee_wrapper)
 SYSCALL(sys_vmsplice,sys_vmsplice,compat_sys_vmsplice_wrapper)
 NI_SYSCALL							/* 310 sys_move_pages */
 SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
-SYSCALL(sys_epoll_pwait,sys_epoll_pwait,sys_ni_syscall)
+SYSCALL(sys_epoll_pwait,sys_epoll_pwait,compat_sys_epoll_pwait_wrapper)
