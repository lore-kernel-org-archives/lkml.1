Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab0BUOaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:30:17 -0500
Received: from mail-gx0-f225.google.com ([209.85.217.225]:39513 "EHLO
	mail-gx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0BUOaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:30:15 -0500
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 09:30:15 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=svihYA2cRocChHARzWEKoXk6KFGurOgv17OZxeFsPnqpqDA3EQoNcy2PP8+gkjSiXI
         clnZuYgMz0fWpVO7vMi9vDxV2w7DU9587fKYE2W43VHAdgfVrg5KXlzNhDvv4oZTyJGA
         yiDUlL3ZBpG21wmJD/Lp/YLHFpnP3yjcRaIRA=
Date: Sun, 21 Feb 2010 22:25:01 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 13/17] sysctl extern cleanup - acct
Message-ID: <20100221142501.GA3026@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move acct_parm extern declaration to linux/acct.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/acct.h |    1 +
 kernel/sysctl.c      |    7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/include/linux/acct.h	2010-02-21 11:15:43.763425087 +0800
+++ linux-2.6.32/include/linux/acct.h	2010-02-21 11:21:31.812557029 +0800
@@ -121,6 +121,7 @@ struct vfsmount;
 struct super_block;
 struct pacct_struct;
 struct pid_namespace;
+extern int acct_parm[]; /* for sysctl */
 extern void acct_auto_close_mnt(struct vfsmount *m);
 extern void acct_auto_close(struct super_block *sb);
 extern void acct_collect(long exitcode, int group_dead);
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 11:21:02.202561933 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 11:22:08.955888265 +0800
@@ -63,6 +63,9 @@
 #ifdef CONFIG_BLOCK
 #include <linux/blk-iopoll.h>
 #endif
+#ifdef CONFIG_BSD_PROCESS_ACCT
+#include <linux/acct.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -128,10 +131,6 @@ extern int sysctl_userprocess_debug;
 extern int spin_retry;
 #endif
 
-#ifdef CONFIG_BSD_PROCESS_ACCT
-extern int acct_parm[];
-#endif
-
 #ifdef CONFIG_IA64
 extern int no_unaligned_warning;
 extern int unaligned_dump_stack;
