Return-Path: <linux-kernel-owner+w=401wt.eu-S933522AbXH0Viy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbXH0Viy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765256AbXH0V3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:29:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58860 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765482AbXH0V3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:03 -0400
Date: Mon, 27 Aug 2007 23:29:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/sys_ni.c: add dummy sys_ni_syscall() prototype
Message-ID: <20070827212902.GD26410@stusta.de>
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

This patch has been sent on:
- 14 Aug 2007

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

