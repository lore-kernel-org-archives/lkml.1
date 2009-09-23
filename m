Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZIWApf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZIWApf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZIWApe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:45:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57859 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbZIWApd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:45:33 -0400
Date: Wed, 23 Sep 2009 10:45:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the ocfs2 tree with Linus' tree
Message-Id: <20090923104537.2885f67a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

Today's linux-next merge of the ocfs2 tree got conflicts in
arch/x86/ia32/ia32entry.S, arch/x86/include/asm/unistd_32.h,
arch/x86/include/asm/unistd_64.h and arch/x86/kernel/syscall_table_32.S
between various commits from Linus' tree and commit
25767b48501de19421ae86c406b2dd42df37baf3 ("fs: Add the reflink()
operation and reflinkat(2) system call") from the ocfs2 tree.

I fixed it up (see below) and can carry the fix for a short while.  Given
the ongoing discussions about this patch with Linus, however, it may be
worth dropping for now?
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/ia32/ia32entry.S
index 74619c4,5fede3e..0000000
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@@ -831,5 -831,6 +831,6 @@@ ia32_sys_call_table
  	.quad compat_sys_preadv
  	.quad compat_sys_pwritev
  	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 -	.quad sys_perf_counter_open
 +	.quad sys_perf_event_open
+ 	.quad sys_reflinkat
  ia32_syscall_end:
diff --cc arch/x86/include/asm/unistd_32.h
index 6fb3c20,a7924e9..0000000
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@@ -341,12 -341,11 +341,13 @@@
  #define __NR_preadv		333
  #define __NR_pwritev		334
  #define __NR_rt_tgsigqueueinfo	335
 -#define __NR_perf_counter_open	336
 +#define __NR_perf_event_open	336
+ #define __NR_reflinkat		337
  
  #ifdef __KERNEL__
  
- #define NR_syscalls 337
++#define NR_syscalls 338
 +
  #define __ARCH_WANT_IPC_PARSE_VERSION
  #define __ARCH_WANT_OLD_READDIR
  #define __ARCH_WANT_OLD_STAT
diff --cc arch/x86/include/asm/unistd_64.h
index 8d3ad0a,b8df7a2..0000000
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@@ -659,8 -659,10 +659,10 @@@ __SYSCALL(__NR_preadv, sys_preadv
  __SYSCALL(__NR_pwritev, sys_pwritev)
  #define __NR_rt_tgsigqueueinfo			297
  __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 -#define __NR_perf_counter_open			298
 -__SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
 +#define __NR_perf_event_open			298
 +__SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+ #define __NR_reflinkat				299
+ __SYSCALL(__NR_reflinkat, sys_reflinkat)
  
  #ifndef __NO_STUBS
  #define __ARCH_WANT_OLD_READDIR
diff --cc arch/x86/kernel/syscall_table_32.S
index 0157cd2,d3b6ebe..0000000
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@@ -335,4 -335,5 +335,5 @@@ ENTRY(sys_call_table
  	.long sys_preadv
  	.long sys_pwritev
  	.long sys_rt_tgsigqueueinfo	/* 335 */
 -	.long sys_perf_counter_open
 +	.long sys_perf_event_open
+ 	.long sys_reflinkat
