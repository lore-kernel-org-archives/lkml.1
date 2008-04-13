Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbYDMReb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbYDMReb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbYDMReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:34:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40757 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751544AbYDMReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:34:22 -0400
Date: Sun, 13 Apr 2008 18:30:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isicom: bring into coding style
Message-ID: <20080413183022.6680cff5@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/isicom.c linux-2.6.25-rc8-mm2/drivers/char/isicom.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/isicom.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/isicom.c	2008-04-13 17:48:44.000000000 +0100
@@ -126,8 +126,8 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/system.h>
 
 #include <linux/pci.h>
@@ -189,7 +189,7 @@
 	unsigned short		status;
 	unsigned short		port_status; /* each bit for each port */
 	unsigned short		shift_count;
-	struct isi_port		* ports;
+	struct isi_port		*ports;
 	signed char		count;
 	spinlock_t		card_lock; /* Card wide lock 11/5/00 -sameer */
 	unsigned long		flags;
@@ -205,11 +205,11 @@
 	u16			channel;
 	u16			status;
 	u16			closing_wait;
-	struct isi_board	* card;
-	struct tty_struct 	* tty;
+	struct isi_board	*card;
+	struct tty_struct 	*tty;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	open_wait;
-	unsigned char		* xmit_buf;
+	unsigned char		*xmit_buf;
 	int			xmit_head;
 	int			xmit_tail;
 	int			xmit_cnt;
@@ -405,7 +405,7 @@
 
 	/*	find next active board	*/
 	card = (prev_card + 1) & 0x0003;
-	while(count-- > 0) {
+	while (count-- > 0) {
 		if (isi_card[card].status & BOARD_ACTIVE)
 			break;
 		card = (card + 1) & 0x0003;
@@ -428,7 +428,7 @@
 	if (retries >= 100)
 		goto unlock;
 
-	for (;count > 0;count--, port++) {
+	for (; count > 0; count--, port++) {
 		/* port not active or tx disabled to force flow control */
 		if (!(port->flags & ASYNC_INITIALIZED) ||
 				!(port->status & ISI_TXOK))
@@ -471,9 +471,10 @@
 					break;
 				}
 			}
-			if (cnt <= 0) break;
+			if (cnt <= 0)
+				break;
 			word_count = cnt >> 1;
-			outsw(base, port->xmit_buf+port->xmit_tail,word_count);
+			outsw(base, port->xmit_buf+port->xmit_tail, word_count);
 			port->xmit_tail = (port->xmit_tail
 				+ (word_count << 1)) & (SERIAL_XMIT_SIZE - 1);
 			txcount -= (word_count << 1);
@@ -556,7 +557,7 @@
 	tty = port->tty;
 	if (tty == NULL) {
 		word_count = byte_count >> 1;
-		while(byte_count > 1) {
+		while (byte_count > 1) {
 			inw(base);
 			byte_count -= 2;
 		}
@@ -569,7 +570,7 @@
 
 	if (header & 0x8000) {		/* Status Packet */
 		header = inw(base);
-		switch(header & 0xff) {
+		switch (header & 0xff) {
 		case 0:	/* Change in EIA signals */
 			if (port->flags & ASYNC_CHECK_CD) {
 				if (port->status & ISI_DCD) {
@@ -656,7 +657,8 @@
 		if (byte_count > 0) {
 			pr_dbg("Intr(0x%lx:%d): Flip buffer overflow! dropping "
 				"bytes...\n", base, channel + 1);
-			while(byte_count > 0) { /* drain out unread xtra data */
+		/* drain out unread xtra data */
+		while (byte_count > 0) {
 				inw(base);
 				byte_count -= 2;
 			}
@@ -679,8 +681,11 @@
 		shift_count = card->shift_count;
 	unsigned char flow_ctrl;
 
-	if (!(tty = port->tty) || !tty->termios)
+	tty = port->tty;
+
+	if (tty == NULL)
 		return;
+	/* FIXME: Switch to new tty baud API */
 	baud = C_BAUD(tty);
 	if (baud & CBAUDEX) {
 		baud &= ~CBAUDEX;
@@ -706,7 +711,7 @@
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			baud++; /*  57.6 Kbps */
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-			baud +=2; /*  115  Kbps */
+			baud += 2; /*  115  Kbps */
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 			baud += 3; /* 230 kbps*/
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
@@ -716,15 +721,14 @@
 		/* hang up */
 		drop_dtr(port);
 		return;
-	}
-	else
+	} else
 		raise_dtr(port);
 
 	if (WaitTillCardIsFree(base) == 0) {
-		outw(0x8000 | (channel << shift_count) |0x03, base);
+		outw(0x8000 | (channel << shift_count) | 0x03, base);
 		outw(linuxb_to_isib[baud] << 8 | 0x03, base);
 		channel_setup = 0;
-		switch(C_CSIZE(tty)) {
+		switch (C_CSIZE(tty)) {
 		case CS5:
 			channel_setup |= ISICOM_CS5;
 			break;
@@ -767,7 +771,7 @@
 		flow_ctrl |= ISICOM_INITIATE_XONXOFF;
 
 	if (WaitTillCardIsFree(base) == 0) {
-		outw(0x8000 | (channel << shift_count) |0x04, base);
+		outw(0x8000 | (channel << shift_count) | 0x04, base);
 		outw(flow_ctrl << 8 | 0x05, base);
 		outw((STOP_CHAR(tty)) << 8 | (START_CHAR(tty)), base);
 		InterruptTheCard(base);
@@ -805,15 +809,13 @@
 	struct isi_board *card = port->card;
 	unsigned long flags;
 
-	if (port->flags & ASYNC_INITIALIZED) {
+	if (port->flags & ASYNC_INITIALIZED)
 		return 0;
-	}
 	if (!port->xmit_buf) {
-		unsigned long page;
-
-		if (!(page = get_zeroed_page(GFP_KERNEL)))
+		/* Relies on BKL */
+		unsigned long page  = get_zeroed_page(GFP_KERNEL);
+		if (page == NULL)
 			return -ENOMEM;
-
 		if (port->xmit_buf) {
 			free_page(page);
 			return -ERESTARTSYS;
@@ -949,21 +951,18 @@
 	port->count++;
 	tty->driver_data = port;
 	port->tty = tty;
-	if ((error = isicom_setup_port(port))!=0)
-		return error;
-	if ((error = block_til_ready(tty, filp, port))!=0)
-		return error;
-
-	return 0;
+	error = isicom_setup_port(port);
+	if (error == 0)
+		error = block_til_ready(tty, filp, port);
+	return error;
 }
 
 /* close et all */
 
 static inline void isicom_shutdown_board(struct isi_board *bp)
 {
-	if (bp->status & BOARD_ACTIVE) {
+	if (bp->status & BOARD_ACTIVE)
 		bp->status &= ~BOARD_ACTIVE;
-	}
 }
 
 /* card->lock HAS to be held */
@@ -1119,7 +1118,7 @@
 
 	spin_lock_irqsave(&card->card_lock, flags);
 
-	while(1) {
+	while (1) {
 		cnt = min_t(int, count, min(SERIAL_XMIT_SIZE - port->xmit_cnt
 				- 1, SERIAL_XMIT_SIZE - port->xmit_head));
 		if (cnt <= 0)
@@ -1140,28 +1139,29 @@
 }
 
 /* put_char et all */
-static void isicom_put_char(struct tty_struct *tty, unsigned char ch)
+static int isicom_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct isi_port *port = tty->driver_data;
 	struct isi_board *card = port->card;
 	unsigned long flags;
 
 	if (isicom_paranoia_check(port, tty->name, "isicom_put_char"))
-		return;
+		return 0;
 
 	if (!port->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&card->card_lock, flags);
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
 		spin_unlock_irqrestore(&card->card_lock, flags);
-		return;
+		return 0;
 	}
 
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= (SERIAL_XMIT_SIZE - 1);
 	port->xmit_cnt++;
 	spin_unlock_irqrestore(&card->card_lock, flags);
+	return 1;
 }
 
 /* flush_chars et all */
@@ -1286,10 +1286,9 @@
 			unlock_kernel();
 			return -EPERM;
 		}
-		port->flags = ((port->flags & ~ ASYNC_USR_MASK) |
+		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
 				(newinfo.flags & ASYNC_USR_MASK));
-	}
-	else {
+	} else {
 		port->close_delay = newinfo.close_delay;
 		port->closing_wait = newinfo.closing_wait;
 		port->flags = ((port->flags & ~ASYNC_FLAGS) |
@@ -1336,7 +1335,7 @@
 	if (isicom_paranoia_check(port, tty->name, "isicom_ioctl"))
 		return -ENODEV;
 
-	switch(cmd) {
+	switch (cmd) {
 	case TCSBRK:
 		retval = tty_check_change(tty);
 		if (retval)
@@ -1585,7 +1584,7 @@
 	default:
 		dev_err(&pdev->dev, "Unknown signature.\n");
 		goto end;
- 	}
+	}
 
 	retval = request_firmware(&fw, name, &pdev->dev);
 	if (retval)
@@ -1613,7 +1612,8 @@
 		if (WaitTillCardIsFree(base))
 			goto errrelfw;
 
-		if ((status = inw(base + 0x4)) != 0) {
+		status = inw(base + 0x4);
+		if (status != 0) {
 			dev_warn(&pdev->dev, "Card%d rejected load header:\n"
 				KERN_WARNING "Address:0x%x\n"
 				KERN_WARNING "Count:0x%x\n"
@@ -1630,12 +1630,13 @@
 		if (WaitTillCardIsFree(base))
 			goto errrelfw;
 
-		if ((status = inw(base + 0x4)) != 0) {
+		status = inw(base + 0x4);
+		if (status != 0) {
 			dev_err(&pdev->dev, "Card%d got out of sync.Card "
 				"Status:0x%x\n", index + 1, status);
 			goto errrelfw;
 		}
- 	}
+	}
 
 /* XXX: should we test it by reading it back and comparing with original like
  * in load firmware package? */
@@ -1659,7 +1660,8 @@
 		if (WaitTillCardIsFree(base))
 			goto errrelfw;
 
-		if ((status = inw(base + 0x4)) != 0) {
+		status = inw(base + 0x4);
+		if (status != 0) {
 			dev_warn(&pdev->dev, "Card%d rejected verify header:\n"
 				KERN_WARNING "Address:0x%x\n"
 				KERN_WARNING "Count:0x%x\n"
@@ -1692,7 +1694,8 @@
 		if (WaitTillCardIsFree(base))
 			goto errrelfw;
 
-		if ((status = inw(base + 0x4)) != 0) {
+		status = inw(base + 0x4);
+		if (status != 0) {
 			dev_err(&pdev->dev, "Card%d verify got out of sync. "
 				"Card Status:0x%x\n", index + 1, status);
 			goto errrelfw;
@@ -1757,7 +1760,7 @@
 			index + 1);
 		retval = -EBUSY;
 		goto errdec;
- 	}
+	}
 
 	retval = request_irq(board->irq, isicom_interrupt,
 			IRQF_SHARED | IRQF_DISABLED, ISICOM_NAME, board);
@@ -1811,7 +1814,7 @@
 	int retval, idx, channel;
 	struct isi_port *port;
 
-	for(idx = 0; idx < BOARD_COUNT; idx++) {
+	for (idx = 0; idx < BOARD_COUNT; idx++) {
 		port = &isi_ports[idx * 16];
 		isi_card[idx].ports = port;
 		spin_lock_init(&isi_card[idx].card_lock);
@@ -1825,7 +1828,7 @@
 			init_waitqueue_head(&port->open_wait);
 			init_waitqueue_head(&port->close_wait);
 			/*  . . .  */
- 		}
+		}
 		isi_card[idx].base = 0;
 		isi_card[idx].irq = 0;
 	}
