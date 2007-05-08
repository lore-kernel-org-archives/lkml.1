Return-Path: <linux-kernel-owner+w=401wt.eu-S1032111AbXEHUHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032111AbXEHUHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967084AbXEHUHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:07:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45436 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032051AbXEHUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:07:44 -0400
Date: Tue, 8 May 2007 21:07:42 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: [PATCH] kmsg_redirect move
Message-ID: <Pine.LNX.4.64.0705082102440.3459@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of migrating the working of the linuxconsole project to 
the mainline kernel. 

This first patch moves kmsg_redirect to vt_kern.h thus making tty.h 
independent of anything from the VT layer. Tested on my local system.
Comments welcomed.

Signed-Off: James Simmons <jsimmons@infradead.org>

diff --git a/include/linux/tty.h b/include/linux/tty.h
index dee72b9..8661b16 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -280,8 +280,6 @@ extern void tty_write_flush(struct tty_struct *);
 
 extern struct ktermios tty_std_termios;
 
-extern int kmsg_redirect;
-
 extern void console_init(void);
 extern int vcs_init(void);
 
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index e0db669..5a08774 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -26,7 +26,7 @@
 
 extern void kd_mksound(unsigned int hz, unsigned int ticks);
 extern int kbd_rate(struct kbd_repeat *rep);
-extern int fg_console, last_console, want_console;
+extern int fg_console, last_console, want_console, kmsg_redirect;
 
 /* console.c */
 
