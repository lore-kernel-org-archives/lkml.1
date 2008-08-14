Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYHNGrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYHNGrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYHNGim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:42 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38159 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYHNGh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:37:58 -0400
Date: Thu, 14 Aug 2008 00:14:38 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6Ecb8006259@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 21/29] mdb: disable console warnings if the debugger is present.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disable the console warning checks if the debugger is active
because the debugger is dependent in the console output
functions in order to provide console display.   


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/include/linux/console.h	2008-08-13 14:22:32.000000000 -0600
+++ b/include/linux/console.h	2008-08-13 11:56:03.000000000 -0600
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
