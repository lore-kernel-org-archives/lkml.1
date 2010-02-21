Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0BUOaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:30:23 -0500
Received: from mail-gx0-f225.google.com ([209.85.217.225]:39513 "EHLO
	mail-gx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab0BUOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:30:20 -0500
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 09:30:15 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=K2rfdWPWs7vRGZV/SpleKXd++vsGL/xbs7RJz3mGOe7jXqeTZxi/o5S45JIqPQFa4r
         J7DVJ2VFYgIjra5fQpn+KTfxpsQxdOvoM1mlstv50ow10S3BD+m0aLJ4a5IsLc0/fNDm
         qzCVyFBHqUJ2x1GyhDu15LgGrs+lmBVu6fIJs=
Date: Sun, 21 Feb 2010 22:22:40 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 01/17] sysctl extern cleanup - C_A_D
Message-ID: <20100221142240.GA3001@darkstar>
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
 include/linux/reboot.h |    1 +
 kernel/sysctl.c        |    1 -
 2 files changed, 1 insertions(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/reboot.h	2010-02-21 09:38:10.237344322 +0800
+++ linux-2.6.32/include/linux/reboot.h	2010-02-21 09:40:04.999834287 +0800
@@ -64,6 +64,7 @@ extern void kernel_restart(char *cmd);
 extern void kernel_halt(void);
 extern void kernel_power_off(void);
 
+extern int C_A_D; /* for sysctl */
 void ctrl_alt_del(void);
 
 #define POWEROFF_CMD_PATH_LEN	256
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 09:38:10.224011478 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 09:42:13.647319319 +0800
@@ -68,7 +68,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int C_A_D;
 extern int print_fatal_signals;
 extern int max_threads;
 extern int core_uses_pid;
