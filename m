Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYBVOxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYBVOxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYBVOrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:47:46 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42332 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYBVOrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:47:42 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 17/19] Char: moxa, remove useless tty functions
Date: Fri, 22 Feb 2008 15:46:44 +0100
Message-Id: <1203691606-9310-17-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- moxa_flush_chars -- no code; ldics handle this well
- moxa_put_char -- only wrapper to moxa_write (same code), tty does this
  the same way if tty->driver->put_char is NULL

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 2303b0e..b0f9995 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -193,8 +193,6 @@ static int moxa_write(struct tty_struct *, const unsigned char *, int);
 static int moxa_write_room(struct tty_struct *);
 static void moxa_flush_buffer(struct tty_struct *);
 static int moxa_chars_in_buffer(struct tty_struct *);
-static void moxa_flush_chars(struct tty_struct *);
-static void moxa_put_char(struct tty_struct *, unsigned char);
 static void moxa_throttle(struct tty_struct *);
 static void moxa_unthrottle(struct tty_struct *);
 static void moxa_set_termios(struct tty_struct *, struct ktermios *);
@@ -391,8 +389,6 @@ static const struct tty_operations moxa_ops = {
 	.write_room = moxa_write_room,
 	.flush_buffer = moxa_flush_buffer,
 	.chars_in_buffer = moxa_chars_in_buffer,
-	.flush_chars = moxa_flush_chars,
-	.put_char = moxa_put_char,
 	.ioctl = moxa_ioctl,
 	.throttle = moxa_throttle,
 	.unthrottle = moxa_unthrottle,
@@ -1283,27 +1279,6 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 	return chars;
 }
 
-static void moxa_flush_chars(struct tty_struct *tty)
-{
-	/*
-	 * Don't think I need this, because this is called to empty the TX
-	 * buffer for the 16450, 16550, etc.
-	 */
-}
-
-static void moxa_put_char(struct tty_struct *tty, unsigned char c)
-{
-	struct moxa_port *ch = tty->driver_data;
-
-	if (ch == NULL)
-		return;
-	spin_lock_bh(&moxa_lock);
-	MoxaPortWriteData(ch, &c, 1);
-	spin_unlock_bh(&moxa_lock);
-
-	ch->statusflags |= LOWWAIT;
-}
-
 static int moxa_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct moxa_port *ch;
-- 
1.5.4.1

