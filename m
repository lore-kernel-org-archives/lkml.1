Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZJYNSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZJYNSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 09:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbZJYNSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 09:18:42 -0400
Received: from mail-vw0-f184.google.com ([209.85.212.184]:46218 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZJYNSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 09:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=r2xQ4FuWCsGp32f2r4bSdgqKh3cx8wHWnWxytfpgJCMxriYL1mHR6UPZuCUeaYgVsr
         zgkeWDm4eXvPTJxGHy1jqwCWi3DbPy+rSrgnFhSPhz0E7AKrHYzl+Y2Jh0sb9u1ozq7i
         YBvkk2ce+gA/u6K3+VIrOlLSdm3rbfaD2FIwA=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 25 Oct 2009 11:18:26 -0200
Message-ID: <b8bf37780910250618h3edce547y41a8dd03e4fb4e71@mail.gmail.com>
Subject: [PATCH 2/2] serial: cascade needless conditionals
To: gregkh@suse.de, alan@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0f6b1bcb358532007f6098da9bf70794e6a99828 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sat, 24 Oct 2009 11:07:22 -0200
Subject: [PATCH 2/2] serial: cascade needless conditionals
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 885eabe..047530b 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -342,11 +342,11 @@ uart_get_baud_rate(struct uart_port *port,
struct ktermios *termios,

 	if (flags == UPF_SPD_HI)
 		altbaud = 57600;
-	if (flags == UPF_SPD_VHI)
+	else if (flags == UPF_SPD_VHI)
 		altbaud = 115200;
-	if (flags == UPF_SPD_SHI)
+	else if (flags == UPF_SPD_SHI)
 		altbaud = 230400;
-	if (flags == UPF_SPD_WARP)
+	else if (flags == UPF_SPD_WARP)
 		altbaud = 460800;

 	for (try = 0; try < 2; try++) {
@@ -1217,9 +1217,8 @@ static void uart_set_termios(struct tty_struct *tty,
 	/* Handle transition to B0 status */
 	if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD))
 		uart_clear_mctrl(state->uart_port, TIOCM_RTS | TIOCM_DTR);
-
 	/* Handle transition away from B0 status */
-	if (!(old_termios->c_cflag & CBAUD) && (cflag & CBAUD)) {
+	else if (!(old_termios->c_cflag & CBAUD) && (cflag & CBAUD)) {
 		unsigned int mask = TIOCM_DTR;
 		if (!(cflag & CRTSCTS) ||
 		    !test_bit(TTY_THROTTLED, &tty->flags))
@@ -1234,9 +1233,8 @@ static void uart_set_termios(struct tty_struct *tty,
 		__uart_start(tty);
 		spin_unlock_irqrestore(&state->uart_port->lock, flags);
 	}
-
 	/* Handle turning on CRTSCTS */
-	if (!(old_termios->c_cflag & CRTSCTS) && (cflag & CRTSCTS)) {
+	else if (!(old_termios->c_cflag & CRTSCTS) && (cflag & CRTSCTS)) {
 		spin_lock_irqsave(&state->uart_port->lock, flags);
 		if (!(state->uart_port->ops->get_mctrl(state->uart_port) & TIOCM_CTS)) {
 			tty->hw_stopped = 1;
-- 
1.6.5.1.75.g02d56
