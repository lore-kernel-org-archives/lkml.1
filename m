Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbYBVOxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbYBVOxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYBVOrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:47:47 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42338 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbYBVOro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:47:44 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 16/19] Char: moxa, little cleanup
Date: Fri, 22 Feb 2008 15:46:43 +0100
Message-Id: <1203691606-9310-16-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup of
- whitespace
- macros
- useless casts
- return (sth); -> return sth;
- types
- superfluous parenthesis and braces
- init tmp directly in moxa_get_serial_info
- commented defunct code
- commented prototypes
- MOXA/moxa printk case

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |  172 ++++++++++++++++++--------------------------------
 1 files changed, 62 insertions(+), 110 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 2c02123..2303b0e 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -54,7 +54,6 @@
 #define MOXA_FW_HDRLEN		32
 
 #define MOXAMAJOR		172
-#define MOXACUMAJOR		173
 
 #define MAX_BOARDS		4	/* Don't change this value */
 #define MAX_PORTS_PER_BOARD	32	/* Don't change this value */
@@ -246,7 +245,7 @@ static void moxa_wait_finish(void __iomem *ofsAddr)
 		printk(KERN_WARNING "moxa function expired\n");
 }
 
-static void moxafunc(void __iomem *ofsAddr, int cmd, ushort arg)
+static void moxafunc(void __iomem *ofsAddr, u16 cmd, u16 arg)
 {
 	writew(arg, ofsAddr + FuncArg);
 	writew(cmd, ofsAddr + FuncCode);
@@ -478,7 +477,7 @@ static int moxa_load_bios(struct moxa_board_conf *brd, const u8 *buf,
 			goto err;
 		tmp = readw(baseAddr + C320_status);
 		if (tmp != STS_init) {
-			printk(KERN_ERR "moxa: bios upload failed -- CPU/Basic "
+			printk(KERN_ERR "MOXA: bios upload failed -- CPU/Basic "
 					"module not found\n");
 			return -EIO;
 		}
@@ -487,7 +486,7 @@ static int moxa_load_bios(struct moxa_board_conf *brd, const u8 *buf,
 
 	return 0;
 err:
-	printk(KERN_ERR "moxa: bios upload failed -- board not found\n");
+	printk(KERN_ERR "MOXA: bios upload failed -- board not found\n");
 	return -EIO;
 }
 
@@ -497,7 +496,7 @@ static int moxa_load_320b(struct moxa_board_conf *brd, const u8 *ptr,
 	void __iomem *baseAddr = brd->basemem;
 
 	if (len < 7168) {
-		printk(KERN_ERR "moxa: invalid 320 bios -- too short\n");
+		printk(KERN_ERR "MOXA: invalid 320 bios -- too short\n");
 		return -EINVAL;
 	}
 
@@ -642,7 +641,7 @@ static int moxa_load_code(struct moxa_board_conf *brd, const void *ptr,
 	int retval, i;
 
 	if (len % 2) {
-		printk(KERN_ERR "moxa: bios length is not even\n");
+		printk(KERN_ERR "MOXA: bios length is not even\n");
 		return -EINVAL;
 	}
 
@@ -764,7 +763,7 @@ static int moxa_load_fw(struct moxa_board_conf *brd, const struct firmware *fw)
 		lens[a] = le16_to_cpu(hdr->len[a]);
 		if (lens[a] && len + lens[a] <= fw->size &&
 				moxa_check_fw(&fw->data[len]))
-			printk(KERN_WARNING "moxa firmware: unexpected input "
+			printk(KERN_WARNING "MOXA firmware: unexpected input "
 				"at offset %u, but going on\n", (u32)len);
 		if (!lens[a] && a < lencnt) {
 			sprintf(rsn, "too few entries in fw file");
@@ -965,7 +964,7 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, board);
 
-	return (0);
+	return 0;
 err_base:
 	iounmap(board->basemem);
 	board->basemem = NULL;
@@ -1016,10 +1015,8 @@ static int __init moxa_init(void)
 	moxaDriver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(moxaDriver, &moxa_ops);
 
-	pr_debug("Moxa tty devices major number = %d\n", ttymajor);
-
 	if (tty_register_driver(moxaDriver)) {
-		printk(KERN_ERR "Couldn't install MOXA Smartio family driver !\n");
+		printk(KERN_ERR "can't register MOXA Smartio tty driver!\n");
 		put_tty_driver(moxaDriver);
 		return -1;
 	}
@@ -1042,7 +1039,7 @@ static int __init moxa_init(void)
 			brd->busType = MOXA_BUS_TYPE_ISA;
 			brd->basemem = ioremap(baseaddr[i], 0x4000);
 			if (!brd->basemem) {
-				printk(KERN_ERR "moxa: can't remap %lx\n",
+				printk(KERN_ERR "MOXA: can't remap %lx\n",
 						baseaddr[i]);
 				continue;
 			}
@@ -1062,7 +1059,7 @@ static int __init moxa_init(void)
 #ifdef CONFIG_PCI
 	retval = pci_register_driver(&moxa_pci_driver);
 	if (retval) {
-		printk(KERN_ERR "Can't register moxa pci driver!\n");
+		printk(KERN_ERR "Can't register MOXA pci driver!\n");
 		if (isabrds)
 			retval = 0;
 	}
@@ -1073,7 +1070,7 @@ static int __init moxa_init(void)
 
 static void __exit moxa_exit(void)
 {
-	int i;
+	unsigned int i;
 
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&moxa_pci_driver);
@@ -1235,12 +1232,8 @@ static int moxa_write(struct tty_struct *tty,
 	len = MoxaPortWriteData(ch, buf, count);
 	spin_unlock_bh(&moxa_lock);
 
-	/*********************************************
-	if ( !(ch->statusflags & LOWWAIT) &&
-	     ((len != count) || (MoxaPortTxFree(port) <= 100)) )
-	************************************************/
 	ch->statusflags |= LOWWAIT;
-	return (len);
+	return len;
 }
 
 static int moxa_write_room(struct tty_struct *tty)
@@ -1248,10 +1241,10 @@ static int moxa_write_room(struct tty_struct *tty)
 	struct moxa_port *ch;
 
 	if (tty->stopped)
-		return (0);
+		return 0;
 	ch = tty->driver_data;
 	if (ch == NULL)
-		return (0);
+		return 0;
 	return MoxaPortTxFree(ch);
 }
 
@@ -1277,7 +1270,7 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 	 * routine.  And since the open() failed, we return 0 here.  TDJ
 	 */
 	if (ch == NULL)
-		return (0);
+		return 0;
 	chars = MoxaPortTxQueue(ch);
 	if (chars) {
 		/*
@@ -1287,7 +1280,7 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 		if (!(ch->statusflags & EMPTYWAIT))
 			moxa_setup_empty_event(tty);
 	}
-	return (chars);
+	return chars;
 }
 
 static void moxa_flush_chars(struct tty_struct *tty)
@@ -1307,9 +1300,7 @@ static void moxa_put_char(struct tty_struct *tty, unsigned char c)
 	spin_lock_bh(&moxa_lock);
 	MoxaPortWriteData(ch, &c, 1);
 	spin_unlock_bh(&moxa_lock);
-	/************************************************
-	if ( !(ch->statusflags & LOWWAIT) && (MoxaPortTxFree(port) <= 100) )
-	*************************************************/
+
 	ch->statusflags |= LOWWAIT;
 }
 
@@ -1372,34 +1363,33 @@ static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 
 static void moxa_throttle(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	ch->statusflags |= THROTTLE;
 }
 
 static void moxa_unthrottle(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	ch->statusflags &= ~THROTTLE;
 }
 
 static void moxa_set_termios(struct tty_struct *tty,
-			     struct ktermios *old_termios)
+		struct ktermios *old_termios)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
 	moxa_set_tty_param(tty, old_termios);
-	if (!(old_termios->c_cflag & CLOCAL) &&
-	    (tty->termios->c_cflag & CLOCAL))
+	if (!(old_termios->c_cflag & CLOCAL) && C_CLOCAL(tty))
 		wake_up_interruptible(&ch->open_wait);
 }
 
 static void moxa_stop(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -1410,7 +1400,7 @@ static void moxa_stop(struct tty_struct *tty)
 
 static void moxa_start(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -1443,7 +1433,7 @@ static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 {
 	dcd = !!dcd;
 
-	if ((dcd != p->DCDState) && p->tty && C_CLOCAL(p->tty)) {
+	if (dcd != p->DCDState && p->tty && C_CLOCAL(p->tty)) {
 		if (!dcd)
 			tty_hangup(p->tty);
 	}
@@ -1551,12 +1541,10 @@ static void moxa_poll(unsigned long ignored)
 
 static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_termios)
 {
-	register struct ktermios *ts;
-	struct moxa_port *ch;
+	register struct ktermios *ts = tty->termios;
+	struct moxa_port *ch = tty->driver_data;
 	int rts, cts, txflow, rxflow, xany, baud;
 
-	ch = (struct moxa_port *) tty->driver_data;
-	ts = tty->termios;
 	rts = cts = txflow = rxflow = xany = 0;
 	if (ts->c_cflag & CRTSCTS)
 		rts = cts = 1;
@@ -1613,7 +1601,7 @@ static void moxa_shut_down(struct moxa_port *ch)
 static void MoxaPortFlushData(struct moxa_port *port, int mode)
 {
 	void __iomem *ofsAddr;
-	if ((mode < 0) || (mode > 2))
+	if (mode < 0 || mode > 2)
 		return;
 	ofsAddr = port->tableAddr;
 	moxafunc(ofsAddr, FC_FlushQueue, mode);
@@ -1623,27 +1611,6 @@ static void MoxaPortFlushData(struct moxa_port *port, int mode)
 	}
 }
 
-/*****************************************************************************
- *	Port level functions:						     *
- *	2.  MoxaPortEnable(int port);					     *
- *	3.  MoxaPortDisable(int port);					     *
- *	4.  MoxaPortGetMaxBaud(int port);				     *
- *	6.  MoxaPortSetBaud(int port, long baud);			     *
- *	8.  MoxaPortSetTermio(int port, unsigned char *termio); 	     *
- *	9.  MoxaPortGetLineOut(int port, int *dtrState, int *rtsState);      *
- *	10. MoxaPortLineCtrl(int port, int dtrState, int rtsState);	     *
- *	11. MoxaPortFlowCtrl(int port, int rts, int cts, int rx, int tx,int xany);    *
- *	12. MoxaPortLineStatus(int port);				     *
- *	15. MoxaPortFlushData(int port, int mode);	                     *
- *	16. MoxaPortWriteData(int port, unsigned char * buffer, int length); *
- *	17. MoxaPortReadData(int port, struct tty_struct *tty); 	     *
- *	20. MoxaPortTxQueue(int port);					     *
- *	21. MoxaPortTxFree(int port);					     *
- *	22. MoxaPortRxQueue(int port);					     *
- *	24. MoxaPortTxDisable(int port);				     *
- *	25. MoxaPortTxEnable(int port); 				     *
- *	27. MoxaPortResetBrkCnt(int port);				     *
- *****************************************************************************/
 /*
  *    Moxa Port Number Description:
  *
@@ -1848,16 +1815,16 @@ static void MoxaPortFlushData(struct moxa_port *port, int mode)
 static void MoxaPortEnable(struct moxa_port *port)
 {
 	void __iomem *ofsAddr;
-	short lowwater = 512;
+	u16 lowwater = 512;
 
 	ofsAddr = port->tableAddr;
 	writew(lowwater, ofsAddr + Low_water);
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-	    port->board->boardType == MOXA_BOARD_C320_PCI) {
+			port->board->boardType == MOXA_BOARD_C320_PCI)
 		moxafunc(ofsAddr, FC_SetBreakIrq, 0);
-	} else {
-		writew(readw(ofsAddr + HostStat) | WakeupBreak, ofsAddr + HostStat);
-	}
+	else
+		writew(readw(ofsAddr + HostStat) | WakeupBreak,
+				ofsAddr + HostStat);
 
 	moxafunc(ofsAddr, FC_SetLineIrq, Magic_code);
 	moxafunc(ofsAddr, FC_FlushQueue, 2);
@@ -1880,9 +1847,9 @@ static long MoxaPortGetMaxBaud(struct moxa_port *port)
 {
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
 			port->board->boardType == MOXA_BOARD_C320_PCI)
-		return (460800L);
+		return 460800L;
 	else
-		return (921600L);
+		return 921600L;
 }
 
 
@@ -1892,8 +1859,8 @@ static long MoxaPortSetBaud(struct moxa_port *port, long baud)
 	long max, clock;
 	unsigned int val;
 
-	if ((baud < 50L) || ((max = MoxaPortGetMaxBaud(port)) == 0))
-		return (0);
+	if (baud < 50L || (max = MoxaPortGetMaxBaud(port)) == 0)
+		return 0;
 	ofsAddr = port->tableAddr;
 	if (baud > max)
 		baud = max;
@@ -1906,7 +1873,7 @@ static long MoxaPortSetBaud(struct moxa_port *port, long baud)
 	val = clock / baud;
 	moxafunc(ofsAddr, FC_SetBaud, val);
 	baud = clock / val;
-	return (baud);
+	return baud;
 }
 
 static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
@@ -1945,12 +1912,12 @@ static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
 	} else
 		mode |= MX_PARNONE;
 
-	moxafunc(ofsAddr, FC_SetDataMode, (ushort) mode);
+	moxafunc(ofsAddr, FC_SetDataMode, (u16)mode);
 
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
 			port->board->boardType == MOXA_BOARD_C320_PCI) {
 		if (baud >= 921600L)
-			return (-1);
+			return -1;
 	}
 	baud = MoxaPortSetBaud(port, baud);
 
@@ -1961,24 +1928,23 @@ static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
 		moxa_wait_finish(ofsAddr);
 
 	}
-	return (baud);
+	return baud;
 }
 
 static int MoxaPortGetLineOut(struct moxa_port *port, int *dtrState,
 		int *rtsState)
 {
-
 	if (dtrState)
 		*dtrState = !!(port->lineCtrl & DTR_ON);
 	if (rtsState)
 		*rtsState = !!(port->lineCtrl & RTS_ON);
 
-	return (0);
+	return 0;
 }
 
 static void MoxaPortLineCtrl(struct moxa_port *port, int dtr, int rts)
 {
-	int mode = 0;
+	u8 mode = 0;
 
 	if (dtr)
 		mode |= DTR_ON;
@@ -2192,60 +2158,46 @@ static void MoxaPortTxEnable(struct moxa_port *port)
 }
 
 static int moxa_get_serial_info(struct moxa_port *info,
-				struct serial_struct __user *retinfo)
+		struct serial_struct __user *retinfo)
 {
-	struct serial_struct tmp;
-
-	memset(&tmp, 0, sizeof(tmp));
-	tmp.type = info->type;
-	tmp.line = info->tty->index;
-	tmp.port = 0;
-	tmp.irq = 0;
-	tmp.flags = info->asyncflags;
-	tmp.baud_base = 921600;
-	tmp.close_delay = info->close_delay;
-	tmp.custom_divisor = 0;
-	tmp.hub6 = 0;
-	if(copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
-		return -EFAULT;
-	return (0);
+	struct serial_struct tmp = {
+		.type = info->type,
+		.line = info->tty->index,
+		.flags = info->asyncflags,
+		.baud_base = 921600,
+		.close_delay = info->close_delay
+	};
+	return copy_to_user(retinfo, &tmp, sizeof(*retinfo)) ? -EFAULT : 0;
 }
 
 
 static int moxa_set_serial_info(struct moxa_port *info,
-				struct serial_struct __user *new_info)
+		struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
 
-	if(copy_from_user(&new_serial, new_info, sizeof(new_serial)))
+	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
 		return -EFAULT;
 
-	if ((new_serial.irq != 0) ||
-	    (new_serial.port != 0) ||
-//           (new_serial.type != info->type) ||
-	    (new_serial.custom_divisor != 0) ||
-	    (new_serial.baud_base != 921600))
-		return (-EPERM);
+	if (new_serial.irq != 0 || new_serial.port != 0 ||
+			new_serial.custom_divisor != 0 ||
+			new_serial.baud_base != 921600)
+		return -EPERM;
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (info->asyncflags & ~ASYNC_USR_MASK)))
-			return (-EPERM);
-	} else {
+			return -EPERM;
+	} else
 		info->close_delay = new_serial.close_delay * HZ / 100;
-	}
 
 	new_serial.flags = (new_serial.flags & ~ASYNC_FLAGS);
 	new_serial.flags |= (info->asyncflags & ASYNC_FLAGS);
 
-	if (new_serial.type == PORT_16550A) {
-		MoxaSetFifo(info, 1);
-	} else {
-		MoxaSetFifo(info, 0);
-	}
+	MoxaSetFifo(info, new_serial.type == PORT_16550A);
 
 	info->type = new_serial.type;
-	return (0);
+	return 0;
 }
 
 
-- 
1.5.4.1

