Return-Path: <linux-kernel-owner+w=401wt.eu-S1762140AbYHDHAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140AbYHDHAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760147AbYHDG7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:59:55 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50382 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbYHDG7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:59:54 -0400
Message-ID: <51989.166.70.238.45.1217831969.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:39:29 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 19/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
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

--- a/drivers/char/keyboard.c	2008-08-03 16:09:56.000000000 -0600
+++ b/drivers/char/keyboard.c	2008-08-03 16:15:00.000000000 -0600
@@ -1180,6 +1180,16 @@
 			if (keycode < BTN_MISC && printk_ratelimit())
 				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode
%d\n", keycode);

+#ifdef CONFIG_MDB
+	if (down && !rep && keycode == KEY_PAUSE)
+        {
+           extern int mdb(int reason, int error, struct pt_regs *regs);
+
+	   mdb(19, 0, get_irq_regs());
+	   return;
+	}
+#endif
+
 #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
 	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
 		if (!sysrq_down) {


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



