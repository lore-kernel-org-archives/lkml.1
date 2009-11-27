Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZK0XJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZK0XJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZK0XJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:09:26 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60470 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZK0XGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com
Subject: [PATCH v3 12/27] resource: move kernel functions inside __KERNEL__
Date: Sat, 28 Nov 2009 00:05:52 +0100
Message-Id: <1259363167-9347-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are internal functions. Move them inside __KERNEL__ ifdef.

This needs also unifdef of resource.h before installing. Change
that too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/Kbuild     |    2 +-
 include/linux/resource.h |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 1feed71..a73a9c2 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -140,7 +140,6 @@ header-y += qnxtypes.h
 header-y += qnx4_fs.h
 header-y += radeonfb.h
 header-y += raw.h
-header-y += resource.h
 header-y += romfs_fs.h
 header-y += rose.h
 header-y += serial_reg.h
@@ -323,6 +322,7 @@ unifdef-y += irqnr.h
 unifdef-y += reboot.h
 unifdef-y += reiserfs_fs.h
 unifdef-y += reiserfs_xattr.h
+unifdef-y += resource.h
 unifdef-y += route.h
 unifdef-y += rtc.h
 unifdef-y += rtnetlink.h
diff --git a/include/linux/resource.h b/include/linux/resource.h
index 08beb1a..cf8dc96 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -3,8 +3,6 @@
 
 #include <linux/time.h>
 
-struct task_struct;
-
 /*
  * Resource control/accounting header file for linux
  */
@@ -70,8 +68,14 @@ struct rlimit {
  */
 #include <asm/resource.h>
 
+#ifdef __KERNEL__
+
+struct task_struct;
+
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
 int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim);
 
+#endif /* __KERNEL__ */
+
 #endif
-- 
1.6.5.3

