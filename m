Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZISVn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZISVn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbZISVny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:54 -0400
Received: from kroah.org ([198.145.64.141]:40538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbZISVnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 62/79] tty: vt: use printk_once
Date: Sat, 19 Sep 2009 14:37:07 -0700
Message-Id: <1253396244-7885-62-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_ioctl.c |    4 +---
 drivers/char/vt.c        |    6 +-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index ad6ba4e..8e67d5c 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -393,9 +393,7 @@ void tty_termios_encode_baud_rate(struct ktermios *termios,
 		termios->c_cflag |= (BOTHER << IBSHIFT);
 #else
 	if (ifound == -1 || ofound == -1) {
-		static int warned;
-		if (!warned++)
-			printk(KERN_WARNING "tty: Unable to return correct "
+		printk_once(KERN_WARNING "tty: Unable to return correct "
 			  "speed data as your architecture needs updating.\n");
 	}
 #endif
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 5dfbfa7..0c80c68 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2129,11 +2129,7 @@ static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int co
 	currcons = vc->vc_num;
 	if (!vc_cons_allocated(currcons)) {
 	    /* could this happen? */
-	    static int error = 0;
-	    if (!error) {
-		error = 1;
-		printk("con_write: tty %d not allocated\n", currcons+1);
-	    }
+		printk_once("con_write: tty %d not allocated\n", currcons+1);
 	    release_console_sem();
 	    return 0;
 	}
-- 
1.6.4.2

