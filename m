Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbYHDCgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbYHDCgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761075AbYHDCeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:34:15 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44561 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760572AbYHDCeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:34:14 -0400
Message-ID: <57571.166.70.238.45.1217816032.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:13:52 -0600 (MDT)
Subject: [PATCH 2.6.26 19/25] mdb: Merkey's Kernel Debugger
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

--- linux-2.6.26/drivers/char/keyboard.c	2008-07-13 15:51:29.000000000 -0600
+++ linux-2.6.26-mdb/drivers/char/keyboard.c	2008-08-03 12:49:01.000000000
-0600
@@ -1178,6 +1178,16 @@
 			if (keycode < BTN_MISC && printk_ratelimit())
 				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode
%d\n", keycode);

+#ifdef CONFIG_MDB
+	if (down && !rep && keycode == KEY_PAUSE)
+        {
+           extern int mdb(int reason, int error, struct pt_regs *regs); +
+	   mdb(19, 0, get_irq_regs());
+	   return;
+	}
+#endif
+
 #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
 	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
 		if (!sysrq_down) {


By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey




