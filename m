Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbZLKXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbZLKXfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934374AbZLKX3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:19 -0500
Received: from kroah.org ([198.145.64.141]:50437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933930AbZLKX3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/58] serial: cascade needless conditionals
Date: Fri, 11 Dec 2009 15:28:03 -0800
Message-Id: <1260574122-10676-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Goddard Rosa <andre.goddard@gmail.com>

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 885eabe..047530b 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -342,11 +342,11 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 
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
1.6.5.5

