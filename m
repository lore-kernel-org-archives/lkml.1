Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbYHDHAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbYHDHAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760147AbYHDHAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:00:37 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50386 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbYHDHAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:00:37 -0400
Message-ID: <51992.166.70.238.45.1217832011.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:40:11 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 20/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/include/linux/console.h	2008-08-03 16:10:18.000000000 -0600
+++ b/include/linux/console.h	2008-08-03 16:15:00.000000000 -0600
@@ -141,11 +141,20 @@
 void vcs_remove_sysfs(struct tty_struct *tty);

 /* Some debug stub to catch some of the obvious races in the VT code */
+
+#ifdef CONFIG_MDB
+//
+#define WARN_CONSOLE_UNLOCKED()
+//
+//extern atomic_t inmdb;
+//#define WARN_CONSOLE_UNLOCKED()	WARN_ON(!is_console_locked() &&
!oops_in_progress && !atomic_read(&inmdb))
+#else
 #if 1
 #define WARN_CONSOLE_UNLOCKED()	WARN_ON(!is_console_locked() &&
!oops_in_progress)
 #else
 #define WARN_CONSOLE_UNLOCKED()
 #endif
+#endif // CONFIG_MDB

 /* VESA Blanking Levels */
 #define VESA_NO_BLANKING        0


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



