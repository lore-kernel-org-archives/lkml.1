Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZLNDjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZLNDjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZLNDjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:39:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49841 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZLNDjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:39:19 -0500
Date: Mon, 14 Dec 2009 14:39:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, Neil Horman <nhorman@tuxdriver.com>
Subject: linux-next: manual merge of the limits tree with Linus' tree
Message-Id: <20091214143917.f5b90e15.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the limits tree got a conflict in
include/asm-generic/unistd.h between commits
9ab87644393d789b950ba984fa360f45c4df02e5 ("asm-generic: add sys_accept4
to unistd.h") and 3d7703870633dd454f6554e6d8d7f70441d0fd2d ("asm-generic:
add sys_recvmmsg to unistd.h") from Linus' tree and commit
cf8b57cd6af6ccbb8f6de90e677b1e5aca99c472 ("unistd: add __NR_[get|set]
prlimit syscall numbers") from the limits tree.

I fixed it up (see below) and can carry the fix for a while.  Jiri, you
should fix this by doing a merge of Linus' tree before asking him to pull
yours.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/asm-generic/unistd.h
index 6a0b30f,950587d..0000000
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@@ -622,13 -622,13 +622,17 @@@ __SYSCALL(__NR_move_pages, sys_move_pag
  __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
  #define __NR_perf_event_open 241
  __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 -#define __NR_getprlimit 242
 +#define __NR_accept4 242
 +__SYSCALL(__NR_accept4, sys_accept4)
 +#define __NR_recvmmsg 243
 +__SYSCALL(__NR_recvmmsg, sys_recvmmsg)
++#define __NR_getprlimit 244
+ __SYSCALL(__NR_getprlimit, sys_getprlimit)
 -#define __NR_setprlimit 243
++#define __NR_setprlimit 245
+ __SYSCALL(__NR_setprlimit, sys_setprlimit)
  
  #undef __NR_syscalls
--#define __NR_syscalls 244
++#define __NR_syscalls 246
  
  /*
   * All syscalls below here should go away really,
