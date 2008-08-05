Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbYHEHIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbYHEHIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYHEGrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:53 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44146 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbYHEGrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:24 -0400
Date: Tue, 5 Aug 2008 00:26:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QasY003779@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 19/26] mdb: fix include and extern statements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

fix externs and include statements.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/drivers/char/keyboard.c	2008-08-04 15:53:25.000000000 -0600
+++ b/drivers/char/keyboard.c	2008-08-04 16:03:56.000000000 -0600
@@ -44,6 +44,10 @@
 #include <linux/notifier.h>
 #include <linux/jiffies.h>
 
+#ifdef CONFIG_MDB
+#include <linux/mdb.h>
+#endif
+
 extern void ctrl_alt_del(void);
 
 #define to_handle_h(n) container_of(n, struct input_handle, h_node)
@@ -1180,6 +1184,14 @@
 			if (keycode < BTN_MISC && printk_ratelimit())
 				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);
 
+#ifdef CONFIG_MDB
+	if (down && !rep && keycode == KEY_PAUSE) 
+        {
+	   mdb(KEYBOARD_ENTRY, 0, get_irq_regs());
+	   return;
+	}
+#endif	
+
 #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
 	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
 		if (!sysrq_down) {
