Return-Path: <linux-kernel-owner+w=401wt.eu-S933877AbXHNViI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbXHNViI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXHNVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:37 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38460 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756060AbXHNVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:34 -0400
Date: Tue, 14 Aug 2007 23:23:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/sys_ni.c: add dummy sys_ni_syscall() prototype
Message-ID: <20070814212326.GP18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sys_ni.c can't #include <linux/syscalls.h> due to cond_syscall(), 
but let's tell gcc to not warn with -Wmissing-prototypes.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
bb96ccd3b695dfa92056e6fc5e42a89ea99f3a8c 
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index b0ec498..0c90f60 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -4,6 +4,10 @@
 
 #include <asm/unistd.h>
 
+/*  we can't #include <linux/syscalls.h> here,
+    but tell gcc to not warn with -Wmissing-prototypes  */
+asmlinkage long sys_ni_syscall(void);
+
 /*
  * Non-implemented system calls get redirected here.
  */

