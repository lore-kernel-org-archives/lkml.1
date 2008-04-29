Return-Path: <linux-kernel-owner+w=401wt.eu-S1763640AbYD2NVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763640AbYD2NVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbYD2NVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:21:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42064 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755786AbYD2NVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:21:30 -0400
Date: Tue, 29 Apr 2008 14:14:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] epca: coding style
Message-ID: <20080429141400.3e36226b@core>
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

Clean up the epca driver

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/epca.c linux-2.6.25-mm1/drivers/char/epca.c
--- linux.vanilla-2.6.25-mm1/drivers/char/epca.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/epca.c	2008-04-28 10:05:12.000000000 +0100
@@ -38,8 +38,8 @@
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include "digiPCI.h"
@@ -73,7 +73,8 @@
  */
 static DEFINE_SPINLOCK(epca_lock);
 
-/* MAXBOARDS is typically 12, but ISA and EISA cards are restricted to 7 below. */
+/* MAXBOARDS is typically 12, but ISA and EISA cards are restricted
+   to 7 below. */
 static struct board_info boards[MAXBOARDS];
 
 static struct tty_driver *pc_driver;
@@ -162,7 +163,7 @@
 static void pc_flush_buffer(struct tty_struct *);
 static void pc_flush_chars(struct tty_struct *);
 static int block_til_ready(struct tty_struct *, struct file *,
-                           struct channel *);
+			struct channel *);
 static int pc_open(struct tty_struct *, struct file *);
 static void post_fep_init(unsigned int crd);
 static void epcapoll(unsigned long);
@@ -174,18 +175,18 @@
 static void epcaparam(struct tty_struct *, struct channel *);
 static void receive_data(struct channel *);
 static int pc_ioctl(struct tty_struct *, struct file *,
-                    unsigned int, unsigned long);
+			unsigned int, unsigned long);
 static int info_ioctl(struct tty_struct *, struct file *,
-                    unsigned int, unsigned long);
+			unsigned int, unsigned long);
 static void pc_set_termios(struct tty_struct *, struct ktermios *);
 static void do_softint(struct work_struct *work);
 static void pc_stop(struct tty_struct *);
 static void pc_start(struct tty_struct *);
-static void pc_throttle(struct tty_struct * tty);
+static void pc_throttle(struct tty_struct *tty);
 static void pc_unthrottle(struct tty_struct *tty);
 static void digi_send_break(struct channel *ch, int msec);
 static void setup_empty_event(struct tty_struct *tty, struct channel *ch);
-void epca_setup(char *, int *);
+static void epca_setup(char *, int *);
 
 static int pc_write(struct tty_struct *, const unsigned char *, int);
 static int pc_init(void);
@@ -242,7 +243,7 @@
 /* PCXEM windowing is the same as that used in the PCXR and CX series cards. */
 static void pcxem_memwinon(struct board_info *b, unsigned int win)
 {
-        outb_p(FEPWIN|win, b->port + 1);
+	outb_p(FEPWIN | win, b->port + 1);
 }
 
 static void pcxem_memwinoff(struct board_info *b, unsigned int win)
@@ -252,7 +253,7 @@
 
 static void pcxem_globalwinon(struct channel *ch)
 {
-	outb_p( FEPWIN, (int)ch->board->port + 1);
+	outb_p(FEPWIN, (int)ch->board->port + 1);
 }
 
 static void pcxem_rxwinon(struct channel *ch)
@@ -393,7 +394,7 @@
 	 */
 	if (tty) {
 		struct channel *ch = (struct channel *)tty->driver_data;
-		if ((ch >= &digi_channels[0]) && (ch < &digi_channels[nbdevs])) {
+		if (ch >= &digi_channels[0] && ch < &digi_channels[nbdevs]) {
 			if (ch->magic == EPCA_MAGIC)
 				return ch;
 		}
@@ -413,7 +414,7 @@
 
 static void epca_error(int line, char *msg)
 {
-	printk(KERN_ERR "epca_error (Digi): line = %d %s\n",line,msg);
+	printk(KERN_ERR "epca_error (Digi): line = %d %s\n", line, msg);
 }
 
 static void pc_close(struct tty_struct *tty, struct file *filp)
@@ -424,7 +425,8 @@
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
 		if (tty_hung_up_p(filp)) {
 			spin_unlock_irqrestore(&epca_lock, flags);
@@ -439,7 +441,6 @@
 			spin_unlock_irqrestore(&epca_lock, flags);
 			return;
 		}
-
 		/* Port open only once go ahead with shutdown & reset */
 		BUG_ON(ch->count < 0);
 
@@ -454,9 +455,11 @@
 		spin_unlock_irqrestore(&epca_lock, flags);
 
 		if (ch->asyncflags & ASYNC_INITIALIZED)  {
-			/* Setup an event to indicate when the transmit buffer empties */
+			/* Setup an event to indicate when the
+			   transmit buffer empties */
 			setup_empty_event(tty, ch);
-			tty_wait_until_sent(tty, 3000); /* 30 seconds timeout */
+			/* 30 seconds timeout */
+			tty_wait_until_sent(tty, 3000);
 		}
 		pc_flush_buffer(tty);
 
@@ -475,7 +478,7 @@
 			wake_up_interruptible(&ch->open_wait);
 		}
 		ch->asyncflags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_INITIALIZED |
-		                      ASYNC_CLOSING);
+					ASYNC_CLOSING);
 		wake_up_interruptible(&ch->close_wait);
 	}
 }
@@ -522,12 +525,12 @@
 static void pc_hangup(struct tty_struct *tty)
 {
 	struct channel *ch;
-
 	/*
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		unsigned long flags;
 
 		pc_flush_buffer(tty);
@@ -545,7 +548,7 @@
 }
 
 static int pc_write(struct tty_struct *tty,
-                    const unsigned char *buf, int bytesAvailable)
+			const unsigned char *buf, int bytesAvailable)
 {
 	unsigned int head, tail;
 	int dataLen;
@@ -569,7 +572,8 @@
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) == NULL)
+	ch = verifyChannel(tty);
+	if (ch == NULL)
 		return 0;
 
 	/* Make a pointer to the channel data structure found on the board. */
@@ -644,19 +648,17 @@
 
 static int pc_write_room(struct tty_struct *tty)
 {
-	int remain;
+	int remain = 0;
 	struct channel *ch;
 	unsigned long flags;
 	unsigned int head, tail;
 	struct board_chan __iomem *bc;
-
-	remain = 0;
-
 	/*
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL)  {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
 		globalwinon(ch);
 
@@ -668,8 +670,8 @@
 			tail = readw(&bc->tout);
 		/* Wrap tail if necessary */
 		tail &= (ch->txbufsize - 1);
-
-		if ((remain = tail - head - 1) < 0 )
+		remain = tail - head - 1;
+		if (remain < 0)
 			remain += ch->txbufsize;
 
 		if (remain && (ch->statusflags & LOWWAIT) == 0) {
@@ -691,12 +693,12 @@
 	unsigned long flags;
 	struct channel *ch;
 	struct board_chan __iomem *bc;
-
 	/*
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) == NULL)
+	ch = verifyChannel(tty);
+	if (ch == NULL)
 		return 0;
 
 	spin_lock_irqsave(&epca_lock, flags);
@@ -707,7 +709,8 @@
 	head = readw(&bc->tin);
 	ctail = readw(&ch->mailbox->cout);
 
-	if (tail == head && readw(&ch->mailbox->cin) == ctail && readb(&bc->tbusy) == 0)
+	if (tail == head && readw(&ch->mailbox->cin) == ctail &&
+						readb(&bc->tbusy) == 0)
 		chars = 0;
 	else  { /* Begin if some space on the card has been used */
 		head = readw(&bc->tin) & (ch->txbufsize - 1);
@@ -717,7 +720,8 @@
 		 * pc_write_room here we are finding the amount of bytes in the
 		 * buffer filled. Not the amount of bytes empty.
 		 */
-		if ((remain = tail - head - 1) < 0 )
+		remain = tail - head - 1;
+		if (remain < 0)
 			remain += ch->txbufsize;
 		chars = (int)(ch->txbufsize - remain);
 		/*
@@ -728,7 +732,7 @@
 		 * transmit buffer empties.
 		 */
 		if (!(ch->statusflags & EMPTYWAIT))
-			setup_empty_event(tty,ch);
+			setup_empty_event(tty, ch);
 	} /* End if some space on the card has been used */
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
@@ -746,7 +750,8 @@
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) == NULL)
+	ch = verifyChannel(tty);
+	if (ch == NULL)
 		return;
 
 	spin_lock_irqsave(&epca_lock, flags);
@@ -767,23 +772,25 @@
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		unsigned long flags;
 		spin_lock_irqsave(&epca_lock, flags);
 		/*
 		 * If not already set and the transmitter is busy setup an
 		 * event to indicate when the transmit empties.
 		 */
-		if ((ch->statusflags & TXBUSY) && !(ch->statusflags & EMPTYWAIT))
-			setup_empty_event(tty,ch);
+		if ((ch->statusflags & TXBUSY) &&
+				!(ch->statusflags & EMPTYWAIT))
+			setup_empty_event(tty, ch);
 		spin_unlock_irqrestore(&epca_lock, flags);
 	}
 }
 
 static int block_til_ready(struct tty_struct *tty,
-                           struct file *filp, struct channel *ch)
+				struct file *filp, struct channel *ch)
 {
-	DECLARE_WAITQUEUE(wait,current);
+	DECLARE_WAITQUEUE(wait, current);
 	int retval, do_clocal = 0;
 	unsigned long flags;
 
@@ -831,8 +838,7 @@
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(ch->asyncflags & ASYNC_INITIALIZED))
-		{
+				!(ch->asyncflags & ASYNC_INITIALIZED)) {
 			if (ch->asyncflags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
@@ -872,7 +878,7 @@
 	return 0;
 }
 
-static int pc_open(struct tty_struct *tty, struct file * filp)
+static int pc_open(struct tty_struct *tty, struct file *filp)
 {
 	struct channel *ch;
 	unsigned long flags;
@@ -957,7 +963,7 @@
 	 * The below routine generally sets up parity, baud, flow control
 	 * issues, etc.... It effect both control flags and input flags.
 	 */
-	epcaparam(tty,ch);
+	epcaparam(tty, ch);
 	ch->asyncflags |= ASYNC_INITIALIZED;
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
@@ -995,8 +1001,8 @@
 
 	del_timer_sync(&epca_timer);
 
-	if (tty_unregister_driver(pc_driver) || tty_unregister_driver(pc_info))
-	{
+	if (tty_unregister_driver(pc_driver) ||
+				tty_unregister_driver(pc_info)) {
 		printk(KERN_WARNING "epca: cleanup_module failed to un-register tty driver\n");
 		return;
 	}
@@ -1036,7 +1042,7 @@
 	.hangup = pc_hangup,
 };
 
-static int info_open(struct tty_struct *tty, struct file * filp)
+static int info_open(struct tty_struct *tty, struct file *filp)
 {
 	return 0;
 }
@@ -1091,7 +1097,7 @@
 	 * Set up interrupt, we will worry about memory allocation in
 	 * post_fep_init.
 	 */
-	printk(KERN_INFO "DIGI epca driver version %s loaded.\n",VERSION);
+	printk(KERN_INFO "DIGI epca driver version %s loaded.\n", VERSION);
 
 	/*
 	 * NOTE : This code assumes that the number of ports found in the
@@ -1244,7 +1250,7 @@
 				if ((board_id & 0x30) == 0x30)
 					bd->memory_seg = 0x8000;
 			} else
-				printk(KERN_ERR "epca: Board at 0x%x doesn't appear to be an XI\n",(int)bd->port);
+				printk(KERN_ERR "epca: Board at 0x%x doesn't appear to be an XI\n", (int)bd->port);
 			break;
 		}
 	}
@@ -1318,12 +1324,12 @@
 		 */
 		/* PCI cards are already remapped at this point ISA are not */
 		bd->numports = readw(bd->re_map_membase + XEMPORTS);
-		epcaassert(bd->numports <= 64,"PCI returned a invalid number of ports");
+		epcaassert(bd->numports <= 64, "PCI returned a invalid number of ports");
 		nbdevs += (bd->numports);
 	} else {
 		/* Fix up the mappings for ISA/EISA etc */
 		/* FIXME: 64K - can we be smarter ? */
-		bd->re_map_membase = ioremap(bd->membase, 0x10000);
+		bd->re_map_membase = ioremap_nocache(bd->membase, 0x10000);
 	}
 
 	if (crd != 0)
@@ -1354,7 +1360,8 @@
 	 * XEPORTS (address 0xc22) points at the number of channels the card
 	 * supports. (For 64XE, XI, XEM, and XR use 0xc02)
 	 */
-	if ((bd->type == PCXEVE || bd->type == PCXE) && (readw(memaddr + XEPORTS) < 3))
+	if ((bd->type == PCXEVE || bd->type == PCXE) &&
+					(readw(memaddr + XEPORTS) < 3))
 		shrinkmem = 1;
 	if (bd->type < PCIXEM)
 		if (!request_region((int)bd->port, 4, board_desc[bd->type]))
@@ -1453,10 +1460,12 @@
 
 		case PCXEVE:
 		case PCXE:
-			ch->txptr = memaddr + (((tseg - bd->memory_seg) << 4) & 0x1fff);
+			ch->txptr = memaddr + (((tseg - bd->memory_seg) << 4)
+								& 0x1fff);
 			ch->txwin = FEPWIN | ((tseg - bd->memory_seg) >> 9);
-			ch->rxptr = memaddr + (((rseg - bd->memory_seg) << 4) & 0x1fff);
-			ch->rxwin = FEPWIN | ((rseg - bd->memory_seg) >>9 );
+			ch->rxptr = memaddr + (((rseg - bd->memory_seg) << 4)
+								& 0x1fff);
+			ch->rxwin = FEPWIN | ((rseg - bd->memory_seg) >> 9);
 			break;
 
 		case PCXI:
@@ -1510,8 +1519,9 @@
 	}
 
 	printk(KERN_INFO
-	        "Digi PC/Xx Driver V%s:  %s I/O = 0x%lx Mem = 0x%lx Ports = %d\n",
-	        VERSION, board_desc[bd->type], (long)bd->port, (long)bd->membase, bd->numports);
+	"Digi PC/Xx Driver V%s:  %s I/O = 0x%lx Mem = 0x%lx Ports = %d\n",
+				VERSION, board_desc[bd->type], (long)bd->port,
+					(long)bd->membase, bd->numports);
 	memwinoff(bd, 0);
 }
 
@@ -1519,7 +1529,7 @@
 {
 	unsigned long flags;
 	int crd;
-	volatile unsigned int head, tail;
+	unsigned int head, tail;
 	struct channel *ch;
 	struct board_info *bd;
 
@@ -1585,7 +1595,9 @@
 	chan0 = card_ptr[crd];
 	epcaassert(chan0 <= &digi_channels[nbdevs - 1], "ch out of range");
 	assertgwinon(chan0);
-	while ((tail = readw(&chan0->mailbox->eout)) != (head = readw(&chan0->mailbox->ein))) { /* Begin while something in event queue */
+	while ((tail = readw(&chan0->mailbox->eout)) !=
+			(head = readw(&chan0->mailbox->ein))) {
+		/* Begin while something in event queue */
 		assertgwinon(chan0);
 		eventbuf = bd->re_map_membase + tail + ISTART;
 		/* Get the channel the event occurred on */
@@ -1609,7 +1621,8 @@
 			goto next;
 		}
 
-		if ((bc = ch->brdchan) == NULL)
+		bc = ch->brdchan;
+		if (bc == NULL)
 			goto next;
 
 		if (event & DATA_IND)  { /* Begin DATA_IND */
@@ -1621,10 +1634,11 @@
 			/* A modem signal change has been indicated */
 			ch->imodem = mstat;
 			if (ch->asyncflags & ASYNC_CHECK_CD) {
-				if (mstat & ch->dcd)  /* We are now receiving dcd */
+				/* We are now receiving dcd */
+				if (mstat & ch->dcd)
 					wake_up_interruptible(&ch->open_wait);
-				else
-					pc_sched_event(ch, EPCA_EVENT_HANGUP); /* No dcd; hangup */
+				else	/* No dcd; hangup */
+					pc_sched_event(ch, EPCA_EVENT_HANGUP);
 			}
 		}
 		tty = ch->tty;
@@ -1639,7 +1653,8 @@
 					tty_wakeup(tty);
 				}
 			} else if (event & EMPTYTX_IND) {
-				/* This event is generated by setup_empty_event */
+				/* This event is generated by
+				   setup_empty_event */
 				ch->statusflags &= ~TXBUSY;
 				if (ch->statusflags & EMPTYWAIT) {
 					ch->statusflags &= ~EMPTYWAIT;
@@ -1647,7 +1662,7 @@
 				}
 			}
 		}
-	next:
+next:
 		globalwinon(ch);
 		BUG_ON(!bc);
 		writew(1, &bc->idata);
@@ -1657,7 +1672,7 @@
 }
 
 static void fepcmd(struct channel *ch, int cmd, int word_or_byte,
-                   int byte2, int ncmds, int bytecmd)
+					int byte2, int ncmds, int bytecmd)
 {
 	unchar __iomem *memaddr;
 	unsigned int head, cmdTail, cmdStart, cmdMax;
@@ -1682,8 +1697,10 @@
 	memaddr = ch->board->re_map_membase;
 
 	if (head >= (cmdMax - cmdStart) || (head & 03))  {
-		printk(KERN_ERR "line %d: Out of range, cmd = %x, head = %x\n", __LINE__,  cmd, head);
-		printk(KERN_ERR "line %d: Out of range, cmdMax = %x, cmdStart = %x\n", __LINE__,  cmdMax, cmdStart);
+		printk(KERN_ERR "line %d: Out of range, cmd = %x, head = %x\n",
+						__LINE__,  cmd, head);
+		printk(KERN_ERR "line %d: Out of range, cmdMax = %x, cmdStart = %x\n",
+						__LINE__,  cmdMax, cmdStart);
 		return;
 	}
 	if (bytecmd)  {
@@ -1762,7 +1779,7 @@
 static unsigned termios2digi_i(struct channel *ch, unsigned iflag)
 {
 	unsigned res = iflag & (IGNBRK | BRKINT | IGNPAR | PARMRK |
-	                        INPCK | ISTRIP|IXON|IXANY|IXOFF);
+					INPCK | ISTRIP | IXON | IXANY | IXOFF);
 	if (ch->digiext.digi_flags & DIGI_AIXON)
 		res |= IAIXON;
 	return res;
@@ -1876,8 +1893,10 @@
 		 * Command sets channels iflag structure on the board. Such
 		 * things as input soft flow control, handling of parity
 		 * errors, and break handling are all set here.
+		 *
+		 * break handling, parity handling, input stripping,
+		 * flow control chars
 		 */
-		/* break handling, parity handling, input stripping, flow control chars */
 		fepcmd(ch, SETIFLAGS, (unsigned int) ch->fepiflag, 0, 0, 0);
 	}
 	/*
@@ -1973,7 +1992,7 @@
 		return;
 
 	/* If CREAD bit is off or device not open, set TX tail to head */
-	if (!tty || !ts || !(ts->c_cflag & CREAD))  {
+	if (!tty || !ts || !(ts->c_cflag & CREAD)) {
 		writew(head, &bc->rout);
 		return;
 	}
@@ -1983,18 +2002,21 @@
 
 	if (readb(&bc->orun)) {
 		writeb(0, &bc->orun);
-		printk(KERN_WARNING "epca; overrun! DigiBoard device %s\n",tty->name);
+		printk(KERN_WARNING "epca; overrun! DigiBoard device %s\n",
+								tty->name);
 		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 	}
 	rxwinon(ch);
-	while (bytesAvailable > 0)  { /* Begin while there is data on the card */
+	while (bytesAvailable > 0) {
+		/* Begin while there is data on the card */
 		wrapgap = (head >= tail) ? head - tail : ch->rxbufsize - tail;
 		/*
 		 * Even if head has wrapped around only report the amount of
 		 * data to be equal to the size - tail. Remember memcpy can't
 		 * automaticly wrap around the receive buffer.
 		 */
-		dataToRead = (wrapgap < bytesAvailable) ? wrapgap : bytesAvailable;
+		dataToRead = (wrapgap < bytesAvailable) ? wrapgap
+							: bytesAvailable;
 		/* Make sure we don't overflow the buffer */
 		dataToRead = tty_prepare_flip_string(tty, &rptr, dataToRead);
 		if (dataToRead == 0)
@@ -2145,14 +2167,14 @@
 	 * The below routine generally sets up parity, baud, flow control
 	 * issues, etc.... It effect both control flags and input flags.
 	 */
-	epcaparam(tty,ch);
+	epcaparam(tty, ch);
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
 	return 0;
 }
 
-static int pc_ioctl(struct tty_struct *tty, struct file * file,
-		    unsigned int cmd, unsigned long arg)
+static int pc_ioctl(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	digiflow_t dflow;
 	int retval;
@@ -2167,7 +2189,6 @@
 		bc = ch->brdchan;
 	else
 		return -EINVAL;
-
 	/*
 	 * For POSIX compliance we need to add more ioctls. See tty_ioctl.c in
 	 * /usr/src/linux/drivers/char for a good example. In particular think
@@ -2178,9 +2199,10 @@
 		retval = tty_check_change(tty);
 		if (retval)
 			return retval;
-		/* Setup an event to indicate when the transmit buffer empties */
+		/* Setup an event to indicate when the transmit
+		   buffer empties */
 		spin_lock_irqsave(&epca_lock, flags);
-		setup_empty_event(tty,ch);
+		setup_empty_event(tty, ch);
 		spin_unlock_irqrestore(&epca_lock, flags);
 		tty_wait_until_sent(tty, 0);
 		if (!arg)
@@ -2190,10 +2212,10 @@
 		retval = tty_check_change(tty);
 		if (retval)
 			return retval;
-
-		/* Setup an event to indicate when the transmit buffer empties */
+		/* Setup an event to indicate when the transmit buffer
+		   empties */
 		spin_lock_irqsave(&epca_lock, flags);
-		setup_empty_event(tty,ch);
+		setup_empty_event(tty, ch);
 		spin_unlock_irqrestore(&epca_lock, flags);
 		tty_wait_until_sent(tty, 0);
 		digi_send_break(ch, arg ? arg*(HZ/10) : HZ/4);
@@ -2232,9 +2254,10 @@
 	case DIGI_SETAF:
 		lock_kernel();
 		if (cmd == DIGI_SETAW) {
-			/* Setup an event to indicate when the transmit buffer empties */
+			/* Setup an event to indicate when the transmit
+			   buffer empties */
 			spin_lock_irqsave(&epca_lock, flags);
-			setup_empty_event(tty,ch);
+			setup_empty_event(tty, ch);
 			spin_unlock_irqrestore(&epca_lock, flags);
 			tty_wait_until_sent(tty, 0);
 		} else {
@@ -2264,7 +2287,7 @@
 		 * control issues, etc.... It effect both control flags and
 		 * input flags.
 		 */
-		epcaparam(tty,ch);
+		epcaparam(tty, ch);
 		memoff(ch);
 		spin_unlock_irqrestore(&epca_lock, flags);
 		break;
@@ -2300,18 +2323,21 @@
 		if (copy_from_user(&dflow, argp, sizeof(dflow)))
 			return -EFAULT;
 
-		if (dflow.startc != startc || dflow.stopc != stopc) { /* Begin  if setflow toggled */
+		if (dflow.startc != startc || dflow.stopc != stopc) {
+			/* Begin  if setflow toggled */
 			spin_lock_irqsave(&epca_lock, flags);
 			globalwinon(ch);
 
 			if (cmd == DIGI_SETFLOW) {
 				ch->fepstartc = ch->startc = dflow.startc;
 				ch->fepstopc = ch->stopc = dflow.stopc;
-				fepcmd(ch, SONOFFC, ch->fepstartc, ch->fepstopc, 0, 1);
+				fepcmd(ch, SONOFFC, ch->fepstartc,
+						ch->fepstopc, 0, 1);
 			} else {
 				ch->fepstartca = ch->startca = dflow.startc;
 				ch->fepstopca  = ch->stopca = dflow.stopc;
-				fepcmd(ch, SAUXONOFFC, ch->fepstartca, ch->fepstopca, 0, 1);
+				fepcmd(ch, SAUXONOFFC, ch->fepstartca,
+						ch->fepstopca, 0, 1);
 			}
 
 			if (ch->statusflags & TXSTOPPED)
@@ -2335,7 +2361,9 @@
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL)  { /* Begin if channel valid */
+	ch = verifyChannel(tty);
+
+	if (ch != NULL)  { /* Begin if channel valid */
 		spin_lock_irqsave(&epca_lock, flags);
 		globalwinon(ch);
 		epcaparam(tty, ch);
@@ -2362,7 +2390,7 @@
 
 		if (tty && tty->driver_data) {
 			if (test_and_clear_bit(EPCA_EVENT_HANGUP, &ch->event)) {
-				tty_hangup(tty);	/* FIXME: module removal race here - AKPM */
+				tty_hangup(tty);
 				wake_up_interruptible(&ch->open_wait);
 				ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
 			}
@@ -2382,9 +2410,11 @@
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
-		if ((ch->statusflags & TXSTOPPED) == 0) { /* Begin if transmit stop requested */
+		if ((ch->statusflags & TXSTOPPED) == 0) {
+			/* Begin if transmit stop requested */
 			globalwinon(ch);
 			/* STOP transmitting now !! */
 			fepcmd(ch, PAUSETX, 0, 0, 0, 0);
@@ -2402,11 +2432,14 @@
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		unsigned long flags;
 		spin_lock_irqsave(&epca_lock, flags);
-		/* Just in case output was resumed because of a change in Digi-flow */
-		if (ch->statusflags & TXSTOPPED)  { /* Begin transmit resume requested */
+		/* Just in case output was resumed because of a change
+		   in Digi-flow */
+		if (ch->statusflags & TXSTOPPED)  {
+			/* Begin transmit resume requested */
 			struct board_chan __iomem *bc;
 			globalwinon(ch);
 			bc = ch->brdchan;
@@ -2436,7 +2469,8 @@
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
 		if ((ch->statusflags & RXSTOPPED) == 0) {
 			globalwinon(ch);
@@ -2456,8 +2490,10 @@
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
-		/* Just in case output was resumed because of a change in Digi-flow */
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
+		/* Just in case output was resumed because of a change
+		   in Digi-flow */
 		spin_lock_irqsave(&epca_lock, flags);
 		if (ch->statusflags & RXSTOPPED) {
 			globalwinon(ch);
@@ -2502,7 +2538,7 @@
 	memoff(ch);
 }
 
-void epca_setup(char *str, int *ints)
+static void epca_setup(char *str, int *ints)
 {
 	struct board_info board;
 	int               index, loop, last;
@@ -2531,14 +2567,16 @@
 			 * instructing the driver to ignore epcaconfig.) For
 			 * this reason we check for 2.
 			 */
-			if (board.status == 2) { /* Begin ignore epcaconfig as well as lilo cmd line */
+			if (board.status == 2) {
+			/* Begin ignore epcaconfig as well as lilo cmd line */
 				nbdevs = 0;
 				num_cards = 0;
 				return;
 			} /* End ignore epcaconfig as well as lilo cmd line */
 
 			if (board.status > 2) {
-				printk(KERN_ERR "epca_setup: Invalid board status 0x%x\n", board.status);
+				printk(KERN_ERR "epca_setup: Invalid board status 0x%x\n",
+						board.status);
 				invalid_lilo_config = 1;
 				setup_error_code |= INVALID_BOARD_STATUS;
 				return;
@@ -2592,7 +2630,8 @@
 		case 6:
 			board.membase = ints[index];
 			if (ints[index] <= 0) {
-				printk(KERN_ERR "epca_setup: Invalid memory base 0x%x\n",(unsigned int)board.membase);
+				printk(KERN_ERR "epca_setup: Invalid memory base 0x%x\n",
+					(unsigned int)board.membase);
 				invalid_lilo_config = 1;
 				setup_error_code |= INVALID_MEM_BASE;
 				return;
@@ -2723,7 +2762,7 @@
 				t2++;
 
 			if (*t2) {
-				printk(KERN_ERR "epca_setup: Invalid memory base %s\n",str);
+				printk(KERN_ERR "epca_setup: Invalid memory base %s\n", str);
 				invalid_lilo_config = 1;
 				setup_error_code |= INVALID_MEM_BASE;
 				return;
@@ -2745,7 +2784,7 @@
 
 	/* I should REALLY validate the stuff here */
 	/* Copies our local copy of board into boards */
-	memcpy((void *)&boards[num_cards],(void *)&board, sizeof(board));
+	memcpy((void *)&boards[num_cards], (void *)&board, sizeof(board));
 	/* Does this get called once per lilo arg are what ? */
 	printk(KERN_INFO "PC/Xx: Added board %i, %s %i ports at 0x%4.4X base 0x%6.6X\n",
 		num_cards, board_desc[board.type],
@@ -2786,9 +2825,9 @@
 	if (board_idx >= MAXBOARDS)
 		goto err_out;
 
-	addr = pci_resource_start (pdev, epca_info_tbl[info_idx].bar_idx);
+	addr = pci_resource_start(pdev, epca_info_tbl[info_idx].bar_idx);
 	if (!addr) {
-		printk (KERN_ERR PFX "PCI region #%d not available (size 0)\n",
+		printk(KERN_ERR PFX "PCI region #%d not available (size 0)\n",
 			epca_info_tbl[info_idx].bar_idx);
 		goto err_out;
 	}
@@ -2799,28 +2838,29 @@
 	boards[board_idx].port = addr + PCI_IO_OFFSET;
 	boards[board_idx].membase = addr;
 
-	if (!request_mem_region (addr + PCI_IO_OFFSET, 0x200000, "epca")) {
-		printk (KERN_ERR PFX "resource 0x%x @ 0x%lx unavailable\n",
+	if (!request_mem_region(addr + PCI_IO_OFFSET, 0x200000, "epca")) {
+		printk(KERN_ERR PFX "resource 0x%x @ 0x%lx unavailable\n",
 			0x200000, addr + PCI_IO_OFFSET);
 		goto err_out;
 	}
 
-	boards[board_idx].re_map_port = ioremap(addr + PCI_IO_OFFSET, 0x200000);
+	boards[board_idx].re_map_port = ioremap_nocache(addr + PCI_IO_OFFSET,
+								0x200000);
 	if (!boards[board_idx].re_map_port) {
-		printk (KERN_ERR PFX "cannot map 0x%x @ 0x%lx\n",
+		printk(KERN_ERR PFX "cannot map 0x%x @ 0x%lx\n",
 			0x200000, addr + PCI_IO_OFFSET);
 		goto err_out_free_pciio;
 	}
 
-	if (!request_mem_region (addr, 0x200000, "epca")) {
-		printk (KERN_ERR PFX "resource 0x%x @ 0x%lx unavailable\n",
+	if (!request_mem_region(addr, 0x200000, "epca")) {
+		printk(KERN_ERR PFX "resource 0x%x @ 0x%lx unavailable\n",
 			0x200000, addr);
 		goto err_out_free_iounmap;
 	}
 
-	boards[board_idx].re_map_membase = ioremap(addr, 0x200000);
+	boards[board_idx].re_map_membase = ioremap_nocache(addr, 0x200000);
 	if (!boards[board_idx].re_map_membase) {
-		printk (KERN_ERR PFX "cannot map 0x%x @ 0x%lx\n",
+		printk(KERN_ERR PFX "cannot map 0x%x @ 0x%lx\n",
 			0x200000, addr + PCI_IO_OFFSET);
 		goto err_out_free_memregion;
 	}
@@ -2837,11 +2877,11 @@
 	return 0;
 
 err_out_free_memregion:
-	release_mem_region (addr, 0x200000);
+	release_mem_region(addr, 0x200000);
 err_out_free_iounmap:
-	iounmap (boards[board_idx].re_map_port);
+	iounmap(boards[board_idx].re_map_port);
 err_out_free_pciio:
-	release_mem_region (addr + PCI_IO_OFFSET, 0x200000);
+	release_mem_region(addr + PCI_IO_OFFSET, 0x200000);
 err_out:
 	return -ENODEV;
 }
@@ -2859,7 +2899,7 @@
 
 static int __init init_PCI(void)
 {
-	memset (&epca_driver, 0, sizeof (epca_driver));
+	memset(&epca_driver, 0, sizeof(epca_driver));
 	epca_driver.name = "epca";
 	epca_driver.id_table = epca_pci_tbl;
 	epca_driver.probe = epca_init_one;
