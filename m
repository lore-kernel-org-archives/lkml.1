Return-Path: <linux-kernel-owner+w=401wt.eu-S1761693AbYHDChC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693AbYHDChC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbYHDCeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:34:24 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44568 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761117AbYHDCeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:34:23 -0400
Message-ID: <57577.166.70.238.45.1217816041.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:14:01 -0600 (MDT)
Subject: [PATCH 2.6.26 20/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

--- linux-2.6.26/include/linux/console.h	2008-07-13 15:51:29.000000000 -0600
+++ linux-2.6.26-mdb/include/linux/console.h	2008-08-03 12:49:01.000000000
-0600
@@ -139,11 +139,20 @@
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


By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey




