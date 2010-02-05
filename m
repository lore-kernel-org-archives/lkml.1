Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab0BEHGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:06:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab0BEHGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:06:05 -0500
Date: Fri, 5 Feb 2010 02:05:56 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
       Arnd Bergmann <arnd@arndb.de>, Amerigo Wang <amwang@redhat.com>
Message-Id: <20100205070921.4179.39579.sendpatchset@localhost.localdomain>
Subject: [Patch] compat ioctl: fix some build warnings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got these warnings:

fs/compat_ioctl.c: In function ‘compat_sys_ioctl':
fs/compat_ioctl.c:534: warning: ‘karg' may be used uninitialized in this function
fs/compat_ioctl.c:533: warning: ‘kcmd' may be used uninitialized in this function
fs/compat_ioctl.c:656: warning: ‘ret' may be used uninitialized in this function

These warnings are harmless, so just shut gcc up.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>

---
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index c5c45de..2468f80 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -543,6 +543,8 @@ static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, void __user *argp)
 		kcmd = MTIOCGET;
 		karg = &get;
 		break;
+	default:
+		return -EINVAL;
 	}
 	set_fs (KERNEL_DS);
 	err = sys_ioctl (fd, kcmd, (unsigned long)karg);
@@ -653,7 +655,7 @@ static int set_raw32_request(struct raw_config_request *req, struct raw32_config
 static int raw_ioctl(unsigned fd, unsigned cmd,
 		struct raw32_config_request __user *user_req)
 {
-        int ret;
+        int ret = -EINVAL;
 
         switch (cmd) {
         case RAW_SETBIND:
