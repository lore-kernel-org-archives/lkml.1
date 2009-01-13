Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbZAMGVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbZAMGVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759705AbZAMGV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:21:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:42319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZAMGVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:21:25 -0500
Subject: [PATCH] capability.h: extern's make no sense in userspace
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, sam@ravnborg.org, harvey.harrison@gmail.com,
       gorcunov@gmail.com, morgan@kernel.org, astor@guardian.no,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 11:49:05 +0530
Message-Id: <1231827545.3212.12.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix 2 make headers_check warnings:

 usr/include/linux/capability.h:72: leaks CONFIG_SECURITY to userspace where it is not valid
 usr/include/linux/capability.h:73: extern's make no sense in userspace

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/capability.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 02bdb76..1b98725 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -69,10 +69,6 @@ typedef struct __user_cap_data_struct {
 #define VFS_CAP_U32             VFS_CAP_U32_2
 #define VFS_CAP_REVISION	VFS_CAP_REVISION_2
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
-extern int file_caps_enabled;
-#endif
-
 struct vfs_cap_data {
 	__le32 magic_etc;            /* Little endian */
 	struct {
@@ -96,6 +92,10 @@ struct vfs_cap_data {
 #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
 #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+extern int file_caps_enabled;
+#endif
+
 typedef struct kernel_cap_struct {
 	__u32 cap[_KERNEL_CAPABILITY_U32S];
 } kernel_cap_t;
-- 
1.5.6.6



