Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0BTOFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:05:31 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:57952 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0BTOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:05:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ww9S0/Ec5kGu68/JFIOddZHdtDocZ2iNEEVQlIuItqGL75zDSroKJhPASl74yJ88S2
         aJNf+MKbfAFKXOyoAYwZbCKQkS/m2+8BthaX8zLVF2UBhh/kZi7775ayL+/IS/9e4rjl
         ColrrFj523fyFObIJ80gyRTonUPbPQ9SKGO3U=
Date: Sat, 20 Feb 2010 22:05:19 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] sysctl extern cleanup - C_A_D
Message-ID: <20100220140459.GA3005@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move C_A_D extern variable declaration to linux/reboot.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/reboot.h |    3 +++
 kernel/sysctl.c        |    1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/reboot.h	2010-02-20 14:02:29.541591107 +0800
+++ linux-2.6.32/include/linux/reboot.h	2010-02-20 14:04:53.261578954 +0800
@@ -64,6 +64,9 @@ extern void kernel_restart(char *cmd);
 extern void kernel_halt(void);
 extern void kernel_power_off(void);
 
+#ifdef CONFIG_SYSCTL
+extern int C_A_D;
+#endif
 void ctrl_alt_del(void);
 
 #define POWEROFF_CMD_PATH_LEN	256
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:02:29.528258054 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:03:41.452418032 +0800
@@ -68,7 +68,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int C_A_D;
 extern int print_fatal_signals;
 extern int max_threads;
 extern int core_uses_pid;
