Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbXE1N1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbXE1N1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbXE1N1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:27:48 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:42049 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753657AbXE1N1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:27:47 -0400
Message-id: <59421588199401771@wsc.cz>
In-reply-to: <12191294601255228079@wsc.cz>
Subject: [PATCH 3/8] Char: tty_ioctl, little whitespace cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 28 May 2007 15:27:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tty_ioctl, little whitespace cleanup

the point is to make
while (++i < n_baud_table);
clear and assign it to the do { } loop

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit 68362b19a0b8b05ce81b8d17743f2d0fceedb81b
tree 7472987557d2eb33ee196a16c4de26f497193e75
parent f030662cbc20e758047c5ec07396862761ea8643
author Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 21:10:32 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 21:10:32 +0200

 drivers/char/tty_ioctl.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 2b6a384..3423e9e 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -261,13 +261,12 @@ void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed
 				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
 			ifound = i;
 		}
-	}
-	while(++i < n_baud_table);
+	} while (++i < n_baud_table);
 	if (ofound == -1)
 		termios->c_cflag |= BOTHER;
 	/* Set exact input bits only if the input and output differ or the
 	   user already did */
-	if (ifound == -1 && (ibaud != obaud  || ibinput))
+	if (ifound == -1 && (ibaud != obaud || ibinput))
 		termios->c_cflag |= (BOTHER << IBSHIFT);
 }
 
@@ -560,7 +559,7 @@ static int set_sgttyb(struct tty_struct * tty, struct sgttyb __user * sgttyb)
 		return -EFAULT;
 
 	mutex_lock(&tty->termios_mutex);
-	termios =  *tty->termios;
+	termios = *tty->termios;
 	termios.c_cc[VERASE] = tmp.sg_erase;
 	termios.c_cc[VKILL] = tmp.sg_kill;
 	set_sgflags(&termios, tmp.sg_flags);
