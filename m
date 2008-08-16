Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYHPEMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYHPEMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 00:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYHPEGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 00:06:13 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33310 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYHPEFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 00:05:43 -0400
Date: Fri, 15 Aug 2008 21:41:47 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808160341.m7G3flG1022571@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 21/28] mdb: disable console warnings if the debugger is present.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disable the console warning checks if the debugger is active
because the debugger is dependent in the console output
functions in order to provide console display.   


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/include/linux/console.h	2008-08-15 21:26:27.000000000 -0600
+++ b/include/linux/console.h	2008-08-15 15:41:57.000000000 -0600
@@ -141,11 +141,16 @@
 void vcs_remove_sysfs(struct tty_struct *tty);
 
 /* Some debug stub to catch some of the obvious races in the VT code */
+
+#if defined(CONFIG_MDB) || defined(CONFIG_MDB_MODULE)
+#define WARN_CONSOLE_UNLOCKED()
+#else
 #if 1
 #define WARN_CONSOLE_UNLOCKED()	WARN_ON(!is_console_locked() && !oops_in_progress)
 #else
 #define WARN_CONSOLE_UNLOCKED()
 #endif
+#endif /* CONFIG_MDB */
 
 /* VESA Blanking Levels */
 #define VESA_NO_BLANKING        0
