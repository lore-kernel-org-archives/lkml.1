Return-Path: <linux-kernel-owner+w=401wt.eu-S1763365AbYHEHLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763365AbYHEHLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbYHEGr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:57 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:46583 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYHEGrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:24 -0400
Date: Tue, 5 Aug 2008 00:26:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756Qam7003780@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 20/26] mdb: remove inmdb atomic checks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

remove inmdb atomic checks -- console state checking is moot since the 
debugger relies on this code in this version.  

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/include/linux/console.h	2008-08-04 15:53:42.000000000 -0600
+++ b/include/linux/console.h	2008-08-04 15:49:51.000000000 -0600
@@ -141,11 +141,16 @@
 void vcs_remove_sysfs(struct tty_struct *tty);
 
 /* Some debug stub to catch some of the obvious races in the VT code */
+
+#ifdef CONFIG_MDB
+#define WARN_CONSOLE_UNLOCKED()
+#else
 #if 1
 #define WARN_CONSOLE_UNLOCKED()	WARN_ON(!is_console_locked() && !oops_in_progress)
 #else
 #define WARN_CONSOLE_UNLOCKED()
 #endif
+#endif // CONFIG_MDB
 
 /* VESA Blanking Levels */
 #define VESA_NO_BLANKING        0
