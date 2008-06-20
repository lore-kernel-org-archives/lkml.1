Return-Path: <linux-kernel-owner+w=401wt.eu-S1762785AbYFTUYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762785AbYFTUYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbYFTUTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35179 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757379AbYFTUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:18:53 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 25/70] whiteheat: fix bugs found in the tidy and audit
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:01:29 +0100
Message-ID: <20080620200126.1479.93090.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Termios tidy up, plus fix break and DTR.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/whiteheat.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)


diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 5a3ed57..0954191 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -652,11 +652,8 @@ static int whiteheat_open(struct tty_struct *tty,
 		goto exit;
 	}
 
-	if (tty) {
-		old_term.c_cflag = ~tty->termios->c_cflag;
-		old_term.c_iflag = ~tty->termios->c_iflag;
-		whiteheat_set_termios(tty, port, &old_term);
-	}
+	if (tty)
+		firm_setup_port(tty);
 
 	/* Work around HCD bugs */
 	usb_clear_halt(port->serial->dev, port->read_urb->pipe);
@@ -907,7 +904,6 @@ static int whiteheat_ioctl(struct tty_struct *tty, struct file *file,
 static void whiteheat_set_termios(struct tty_struct *tty,
 	struct usb_serial_port *port, struct ktermios *old_termios)
 {
-	/* FIXME */
 	firm_setup_port(tty);
 }
 
@@ -1303,7 +1299,7 @@ static int firm_set_dtr(struct usb_serial_port *port, __u8 onoff)
 
 	dtr_command.port = port->number - port->serial->minor + 1;
 	dtr_command.state = onoff;
-	return firm_send_command(port, WHITEHEAT_SET_RTS,
+	return firm_send_command(port, WHITEHEAT_SET_DTR,
 			(__u8 *)&dtr_command, sizeof(dtr_command));
 }
 
@@ -1314,7 +1310,7 @@ static int firm_set_break(struct usb_serial_port *port, __u8 onoff)
 
 	break_command.port = port->number - port->serial->minor + 1;
 	break_command.state = onoff;
-	return firm_send_command(port, WHITEHEAT_SET_RTS,
+	return firm_send_command(port, WHITEHEAT_SET_BREAK,
 			(__u8 *)&break_command, sizeof(break_command));
 }
 

