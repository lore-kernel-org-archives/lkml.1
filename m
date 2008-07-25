Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYGYHq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYGYHq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYGYHqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:46:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57433 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYGYHqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:46:19 -0400
Message-ID: <48898461.4070603@cn.fujitsu.com>
Date: Fri, 25 Jul 2008 15:44:33 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] flag parameters: fix compile error of sys_epoll_create1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      vmlinux
arch/x86/kernel/built-in.o: In function `sys_call_table':
(.rodata+0x8a4): undefined reference to `sys_epoll_create1'
make: *** [vmlinux] Error 1

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-arch@vger.kernel.org>
---
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index bd66ac5..55eca15 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -57,6 +57,7 @@ cond_syscall(compat_sys_set_robust_list);
 cond_syscall(sys_get_robust_list);
 cond_syscall(compat_sys_get_robust_list);
 cond_syscall(sys_epoll_create);
+cond_syscall(sys_epoll_create1);
 cond_syscall(sys_epoll_ctl);
 cond_syscall(sys_epoll_wait);
 cond_syscall(sys_epoll_pwait);


