Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZHITyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZHITyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZHITyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:54:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39181 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZHITyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jxzWPXU4r4z24rqRO/XWqRkiybB4K4XPsBnWEntxf9DVHfC2voCkThyAEVG3IJ3KxP
         EjvLFcwfbjP45zPVYR8ZwMVzRM+ad2+NUwALx83viJ3lnqBPtBLiohg39hvZHOb0s37I
         FLQy7A5ILPJu359fD+8PVrs7p717miiOisXhg=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/14] tty/vt: use printk_once
Date: Sun,  9 Aug 2009 21:54:03 +0200
Message-Id: <1249847649-11631-9-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
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
index 404f4c1..5d77fb3 100644
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
1.6.3.3

