Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbYA0TS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbYA0TS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYA0TSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:18:49 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:56959 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbYA0TSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:18:48 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [RFC 4/6] Char: moxa, remove unused port entries
Date: Sun, 27 Jan 2008 20:16:43 +0100
Message-Id: <1201461405-9649-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201167165-27635-5-git-send-email-jirislaby@gmail.com>
References: <1201167165-27635-5-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/moxa.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 904b4b1..ee5cbc8 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -131,10 +131,8 @@ struct moxa_port {
 	struct moxa_board_conf *board;
 	int type;
 	int close_delay;
-	unsigned short closing_wait;
 	int count;
 	int blocked_open;
-	long event; /* long req'd for set_bit --RR */
 	int asyncflags;
 	unsigned long statusflags;
 	struct tty_struct *tty;
@@ -147,7 +145,6 @@ struct moxa_port {
 	char chkPort;
 	char lineCtrl;
 	void __iomem *tableAddr;
-	long curBaud;
 	char DCDState;
 	char lowChkFlag;
 
@@ -515,7 +512,6 @@ static int moxa_load_code(struct moxa_board_conf *brd, const void *ptr,
 		for (i = 0; i < brd->numPorts; i++, port++) {
 			port->board = brd;
 			port->chkPort = 1;
-			port->curBaud = 9600L;
 			port->DCDState = 0;
 			port->tableAddr = baseAddr + Extern_table +
 					Extern_size * i;
@@ -535,7 +531,6 @@ static int moxa_load_code(struct moxa_board_conf *brd, const void *ptr,
 		for (i = 0; i < brd->numPorts; i++, port++) {
 			port->board = brd;
 			port->chkPort = 1;
-			port->curBaud = 9600L;
 			port->DCDState = 0;
 			port->tableAddr = baseAddr + Extern_table +
 					Extern_size * i;
@@ -823,7 +818,6 @@ static int __init moxa_init(void)
 	for (i = 0, ch = moxa_ports; i < MAX_PORTS; i++, ch++) {
 		ch->type = PORT_16550A;
 		ch->close_delay = 5 * HZ / 10;
-		ch->closing_wait = 30 * HZ;
 		ch->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 		init_waitqueue_head(&ch->open_wait);
 		init_completion(&ch->close_wait);
@@ -1006,7 +1000,6 @@ static void moxa_close(struct tty_struct *tty, struct file *filp)
 	tty_ldisc_flush(tty);
 			
 	tty->closing = 0;
-	ch->event = 0;
 	ch->tty = NULL;
 	if (ch->blocked_open) {
 		if (ch->close_delay) {
@@ -1270,7 +1263,6 @@ static void moxa_hangup(struct tty_struct *tty)
 
 	moxa_flush_buffer(tty);
 	moxa_shut_down(ch);
-	ch->event = 0;
 	ch->count = 0;
 	ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
 	ch->tty = NULL;
@@ -2079,7 +2071,6 @@ static long MoxaPortSetBaud(struct moxa_port *port, long baud)
 	val = clock / baud;
 	moxafunc(ofsAddr, FC_SetBaud, val);
 	baud = clock / val;
-	port->curBaud = baud;
 	return (baud);
 }
 
@@ -2457,7 +2448,6 @@ static int moxa_get_serial_info(struct moxa_port *info,
 	tmp.flags = info->asyncflags;
 	tmp.baud_base = 921600;
 	tmp.close_delay = info->close_delay;
-	tmp.closing_wait = info->closing_wait;
 	tmp.custom_divisor = 0;
 	tmp.hub6 = 0;
 	if(copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
@@ -2487,7 +2477,6 @@ static int moxa_set_serial_info(struct moxa_port *info,
 			return (-EPERM);
 	} else {
 		info->close_delay = new_serial.close_delay * HZ / 100;
-		info->closing_wait = new_serial.closing_wait * HZ / 100;
 	}
 
 	new_serial.flags = (new_serial.flags & ~ASYNC_FLAGS);
-- 
1.5.3.7

