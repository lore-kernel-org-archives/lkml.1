Return-Path: <linux-kernel-owner+w=401wt.eu-S934854AbZJJUzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbZJJUzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934818AbZJJUzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:55:25 -0400
Received: from smtprelay11.ispgateway.de ([80.67.31.34]:38300 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934815AbZJJUzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:55:24 -0400
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bernhard@bwalle.de>
Subject: [PATCH 1/5] Only define/declare kmsg_redirect when CONFIG_VT_CONSOLE is set
Date: Sat, 10 Oct 2009 22:51:06 +0200
Message-Id: <1255207870-24496-2-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the variable is only used when CONFIG_VT_CONSOLE is set, we can save some
bytes of memory when CONFIG_VT_CONSOLE is not set.


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 drivers/char/vt.c   |    2 ++
 include/linux/tty.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 0c80c68..c3b1a86 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -187,7 +187,9 @@ static DECLARE_WORK(console_work, console_callback);
 int fg_console;
 int last_console;
 int want_console = -1;
+#ifdef CONFIG_VT_CONSOLE
 int kmsg_redirect;
+#endif
 
 /*
  * For each existing display, we have a pointer to console currently visible
diff --git a/include/linux/tty.h b/include/linux/tty.h
index f0f43d0..91bb1df 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -340,7 +340,9 @@ extern void tty_write_flush(struct tty_struct *);
 
 extern struct ktermios tty_std_termios;
 
+#ifdef CONFIG_VT_CONSOLE
 extern int kmsg_redirect;
+#endif
 
 extern void console_init(void);
 extern int vcs_init(void);
-- 
1.6.3.3

