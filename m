Return-Path: <linux-kernel-owner+w=401wt.eu-S934851AbZJJU5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851AbZJJU5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934818AbZJJU5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:57:30 -0400
Received: from smtprelay11.ispgateway.de ([80.67.29.28]:42334 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934806AbZJJU53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:57:29 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2009 16:57:29 EDT
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bernhard@bwalle.de>
Subject: [PATCH 4/5] Make kmsg_redirect static
Date: Sat, 10 Oct 2009 22:51:09 +0200
Message-Id: <1255207870-24496-5-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have vt_get_kmsg_redirect()/vt_set_kmsg_redirect(), so we can make the
variable local to the compilcation unit.


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 drivers/char/vt.c   |    2 +-
 include/linux/tty.h |    4 ----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 01c4a1c..ad1e7af 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -188,7 +188,7 @@ int fg_console;
 int last_console;
 int want_console = -1;
 #ifdef CONFIG_VT_CONSOLE
-int kmsg_redirect;
+static int kmsg_redirect;
 #endif
 
 /*
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 91bb1df..fddafcb 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -340,10 +340,6 @@ extern void tty_write_flush(struct tty_struct *);
 
 extern struct ktermios tty_std_termios;
 
-#ifdef CONFIG_VT_CONSOLE
-extern int kmsg_redirect;
-#endif
-
 extern void console_init(void);
 extern int vcs_init(void);
 
-- 
1.6.3.3

