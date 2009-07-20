Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZGTHWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZGTHWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZGTHWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:22:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55362 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbZGTHWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:22:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] linux/futex.h: place kernel types behind __KERNEL__
Date: Mon, 20 Jul 2009 03:22:45 -0400
Message-Id: <1248074565-11454-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The forward decls for some kernel types are only needed by the code behind
__KERNEL__, so don't bleed these types to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/futex.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 34956c8..8ec1799 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -4,11 +4,6 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
-struct inode;
-struct mm_struct;
-struct task_struct;
-union ktime;
-
 /* Second argument to futex syscall */
 
 
@@ -129,6 +124,11 @@ struct robust_list_head {
 #define FUTEX_BITSET_MATCH_ANY	0xffffffff
 
 #ifdef __KERNEL__
+struct inode;
+struct mm_struct;
+struct task_struct;
+union ktime;
+
 long do_futex(u32 __user *uaddr, int op, u32 val, union ktime *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
-- 
1.6.3.3

