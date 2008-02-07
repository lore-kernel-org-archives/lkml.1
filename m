Return-Path: <linux-kernel-owner+w=401wt.eu-S934936AbYBGXZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936AbYBGXZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760834AbYBGXYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:24:50 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55763 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934446AbYBGXYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:24:49 -0500
Date: Fri, 8 Feb 2008 01:25:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Davide Libenzi <davidel@xmailserver.org>, chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix xtensa timerfd breakage
Message-ID: <20080207232502.GH7198@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC      arch/xtensa/kernel/syscall.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/xtensa/kernel/syscall.c:39:
include2/asm/unistd.h:681: error: 'sys_timerfd' undeclared here (not in a function)
make[2]: *** [arch/xtensa/kernel/syscall.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a42376eff20647fda6dc1bde20e793f9b4001c39 diff --git a/include/asm-xtensa/unistd.h b/include/asm-xtensa/unistd.h
index 92968aa..98d9cd1 100644
--- a/include/asm-xtensa/unistd.h
+++ b/include/asm-xtensa/unistd.h
@@ -677,8 +677,8 @@ __SYSCALL(303, sys_ni_syscall, 0)
 
 #define __NR_signalfd				304
 __SYSCALL(304, sys_signalfd, 3)
-#define __NR_timerfd				305
-__SYSCALL(305, sys_timerfd, 4)
+/*  305 was __NR_timerfd  */
+__SYSCALL(305, sys_ni_syscall, 0)
 #define __NR_eventfd				306
 __SYSCALL(306, sys_eventfd, 1)
 
