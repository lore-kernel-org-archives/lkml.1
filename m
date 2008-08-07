Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbYHGWmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbYHGWmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986AbYHGWkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:40:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48925 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbYHGWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:40:43 -0400
Subject: [RFC][PATCH 4/4] introduce sys_checkpoint and sys_restore
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 07 Aug 2008 15:40:38 -0700
References: <20080807224033.FFB3A2C1@kernel>
In-Reply-To: <20080807224033.FFB3A2C1@kernel>
Message-Id: <20080807224038.0B03CEEF@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Oren Laadan <orenl@cs.columbia.edu>

Create trivial sys_checkpoint and sys_restore system calls. They will
enable to checkpoint and restart an entire container, to and from a
checkpoint image file.

First create a template for both syscalls: they take a file descriptor
(for the image file) and flags as arguments. For sys_checkpoint the
first argument identifies the target container; for sys_restart it will
identify the checkpoint image.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>

---

 linux-2.6.git-dave/arch/x86/kernel/syscall_table_32.S |    2 ++
 linux-2.6.git-dave/include/asm-x86/unistd_32.h        |    2 ++
 2 files changed, 4 insertions(+)

diff -puN arch/x86/kernel/syscall_table_32.S~introduce_sys_checkpoint_and_sys_restore arch/x86/kernel/syscall_table_32.S
--- linux-2.6.git/arch/x86/kernel/syscall_table_32.S~introduce_sys_checkpoint_and_sys_restore	2008-08-07 15:38:04.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kernel/syscall_table_32.S	2008-08-07 15:38:04.000000000 -0700
@@ -326,3 +326,5 @@ ENTRY(sys_call_table)
 	.long sys_fallocate
 	.long sys_timerfd_settime	/* 325 */
 	.long sys_timerfd_gettime
+	.long sys_checkpoint
+	.long sys_restart
diff -puN include/asm-x86/unistd_32.h~introduce_sys_checkpoint_and_sys_restore include/asm-x86/unistd_32.h
--- linux-2.6.git/include/asm-x86/unistd_32.h~introduce_sys_checkpoint_and_sys_restore	2008-08-07 15:38:04.000000000 -0700
+++ linux-2.6.git-dave/include/asm-x86/unistd_32.h	2008-08-07 15:38:04.000000000 -0700
@@ -332,6 +332,8 @@
 #define __NR_fallocate		324
 #define __NR_timerfd_settime	325
 #define __NR_timerfd_gettime	326
+#define __NR_checkpoint		327
+#define __NR_restart		328
 
 #ifdef __KERNEL__
 
diff -puN Makefile~introduce_sys_checkpoint_and_sys_restore Makefile
_
