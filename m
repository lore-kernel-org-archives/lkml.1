Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbXJUHxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbXJUHxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXJUHw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:27 -0400
Received: from havoc.gtf.org ([69.61.125.42]:56472 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbXJUHwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:20 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: paulkf@microgate.com
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 4/17] char/pcmcia/synclink_cs: trim trailing whitespace
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075219.3657F190418@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:17 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit b81d07c9cc372d7c6e8ea4f854330e860db8801c
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 15:45:35 2007 -0400

    char/pcmcia/synclink_cs: trim trailing whitespace
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/char/pcmcia/synclink_cs.c |  706 +++++++++++++++++++-------------------
 1 file changed, 353 insertions(+), 353 deletions(-)

b81d07c9cc372d7c6e8ea4f854330e860db8801c
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 2b88931..8caff0c 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -123,7 +123,7 @@ typedef struct
 #define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
 
 struct _input_signal_events {
-	int	ri_up;	
+	int	ri_up;
 	int	ri_down;
 	int	dsr_up;
 	int	dsr_down;
@@ -137,7 +137,7 @@ struct _input_signal_events {
 /*
  * Device instance data structure
  */
- 
+
 typedef struct _mgslpc_info {
 	void *if_ptr;	/* General purpose pointer (used by SPPP) */
 	int			magic;
@@ -146,15 +146,15 @@ typedef struct _mgslpc_info {
 	int			line;
 	unsigned short		close_delay;
 	unsigned short		closing_wait;	/* time to wait before closing */
-	
+
 	struct mgsl_icount	icount;
-	
+
 	struct tty_struct 	*tty;
 	int			timeout;
 	int			x_char;		/* xon/xoff character */
 	int			blocked_open;	/* # of blocked opens */
 	unsigned char		read_status_mask;
-	unsigned char		ignore_status_mask;	
+	unsigned char		ignore_status_mask;
 
 	unsigned char *tx_buf;
 	int            tx_put;
@@ -170,10 +170,10 @@ typedef struct _mgslpc_info {
 	int            rx_buf_size;    /* size in bytes of single rx buffer */
 	int            rx_buf_count;   /* total number of rx buffers */
 	int            rx_frame_count; /* number of full rx buffers */
-	
+
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
-	
+
 	wait_queue_head_t	status_event_wait_q;
 	wait_queue_head_t	event_wait_q;
 	struct timer_list	tx_timer;	/* HDLC transmit timeout timer */
@@ -192,7 +192,7 @@ typedef struct _mgslpc_info {
 
 	int bh_running;
 	int bh_requested;
-	
+
 	int dcd_chkcount; /* check counts to prevent */
 	int cts_chkcount; /* too many IRQs if a signal */
 	int dsr_chkcount; /* is floating */
@@ -212,7 +212,7 @@ typedef struct _mgslpc_info {
 
 	unsigned int io_base;	/* base I/O address of adapter */
 	unsigned int irq_level;
-	
+
 	MGSL_PARAMS params;		/* communications parameters */
 
 	unsigned char serial_signals;	/* current serial signal states */
@@ -249,7 +249,7 @@ typedef struct _mgslpc_info {
  */
 #define TXBUFSIZE 4096
 
-    
+
 #define CHA     0x00   /* channel A offset */
 #define CHB     0x40   /* channel B offset */
 
@@ -298,9 +298,9 @@ typedef struct _mgslpc_info {
 #define PIM     0x3d
 #define PCR     0x3e
 #define CCR4    0x3f
-    
+
 // IMR/ISR
-    
+
 #define IRQ_BREAK_ON    BIT15   // rx break detected
 #define IRQ_DATAOVERRUN BIT14	// receive data overflow
 #define IRQ_ALLSENT     BIT13	// all sent
@@ -315,13 +315,13 @@ typedef struct _mgslpc_info {
 #define IRQ_DCD         BIT2	// carrier detect status change
 #define IRQ_OVERRUN     BIT1	// receive frame overflow
 #define IRQ_RXFIFO      BIT0	// receive pool full
-    
+
 // STAR
-    
+
 #define XFW   BIT6		// transmit FIFO write enable
 #define CEC   BIT2		// command executing
 #define CTS   BIT1		// CTS state
-    
+
 #define PVR_DTR      BIT0
 #define PVR_DSR      BIT1
 #define PVR_RI       BIT2
@@ -329,25 +329,25 @@ typedef struct _mgslpc_info {
 #define PVR_RS232    0x20   /* 0010b */
 #define PVR_V35      0xe0   /* 1110b */
 #define PVR_RS422    0x40   /* 0100b */
-    
-/* Register access functions */ 
-    
+
+/* Register access functions */
+
 #define write_reg(info, reg, val) outb((val),(info)->io_base + (reg))
 #define read_reg(info, reg) inb((info)->io_base + (reg))
 
-#define read_reg16(info, reg) inw((info)->io_base + (reg))  
+#define read_reg16(info, reg) inw((info)->io_base + (reg))
 #define write_reg16(info, reg, val) outw((val), (info)->io_base + (reg))
-    
+
 #define set_reg_bits(info, reg, mask) \
     write_reg(info, (reg), \
-		 (unsigned char) (read_reg(info, (reg)) | (mask)))  
+		 (unsigned char) (read_reg(info, (reg)) | (mask)))
 #define clear_reg_bits(info, reg, mask) \
     write_reg(info, (reg), \
-		 (unsigned char) (read_reg(info, (reg)) & ~(mask)))  
+		 (unsigned char) (read_reg(info, (reg)) & ~(mask)))
 /*
  * interrupt enable/disable routines
- */ 
-static void irq_disable(MGSLPC_INFO *info, unsigned char channel, unsigned short mask) 
+ */
+static void irq_disable(MGSLPC_INFO *info, unsigned char channel, unsigned short mask)
 {
 	if (channel == CHA) {
 		info->imra_value |= mask;
@@ -357,7 +357,7 @@ static void irq_disable(MGSLPC_INFO *info, unsigned char channel, unsigned short
 		write_reg16(info, CHB + IMR, info->imrb_value);
 	}
 }
-static void irq_enable(MGSLPC_INFO *info, unsigned char channel, unsigned short mask) 
+static void irq_enable(MGSLPC_INFO *info, unsigned char channel, unsigned short mask)
 {
 	if (channel == CHA) {
 		info->imra_value &= ~mask;
@@ -558,7 +558,7 @@ static int mgslpc_probe(struct pcmcia_device *link)
     spin_lock_init(&info->lock);
     spin_lock_init(&info->netlock);
     memcpy(&info->params,&default_params,sizeof(MGSL_PARAMS));
-    info->idle_mode = HDLC_TXIDLE_FLAGS;		
+    info->idle_mode = HDLC_TXIDLE_FLAGS;
     info->imra_value = 0xffff;
     info->imrb_value = 0xffff;
     info->pim_value = 0xff;
@@ -600,7 +600,7 @@ static int mgslpc_config(struct pcmcia_device *link)
     u_char buf[64];
     cistpl_cftable_entry_t dflt = { 0 };
     cistpl_cftable_entry_t *cfg;
-    
+
     if (debug_level >= DEBUG_LEVEL_INFO)
 	    printk("mgslpc_config(0x%p)\n", link);
 
@@ -624,7 +624,7 @@ static int mgslpc_config(struct pcmcia_device *link)
 
     link->conf.ConfigIndex = cfg->index;
     link->conf.Attributes |= CONF_ENABLE_IRQ;
-	
+
     /* IO window settings */
     link->io.NumPorts1 = 0;
     if ((cfg->io.nwin > 0) || (dflt.io.nwin > 0)) {
@@ -644,7 +644,7 @@ static int mgslpc_config(struct pcmcia_device *link)
     link->conf.IntType = INT_MEMORY_AND_IO;
     link->conf.ConfigIndex = 8;
     link->conf.Present = PRESENT_OPTION;
-    
+
     link->irq.Attributes |= IRQ_HANDLE_PRESENT;
     link->irq.Handler     = mgslpc_isr;
     link->irq.Instance    = info;
@@ -753,10 +753,10 @@ static inline int mgslpc_paranoia_check(MGSLPC_INFO *info,
 #define CMD_TXEOM       BIT1	// transmit end message
 #define CMD_TXRESET     BIT0	// transmit reset
 
-static BOOLEAN wait_command_complete(MGSLPC_INFO *info, unsigned char channel) 
+static BOOLEAN wait_command_complete(MGSLPC_INFO *info, unsigned char channel)
 {
 	int i = 0;
-	/* wait for command completion */ 
+	/* wait for command completion */
 	while (read_reg(info, (unsigned char)(channel+STAR)) & BIT2) {
 		udelay(1);
 		if (i++ == 1000)
@@ -765,7 +765,7 @@ static BOOLEAN wait_command_complete(MGSLPC_INFO *info, unsigned char channel)
 	return TRUE;
 }
 
-static void issue_command(MGSLPC_INFO *info, unsigned char channel, unsigned char cmd) 
+static void issue_command(MGSLPC_INFO *info, unsigned char channel, unsigned char cmd)
 {
 	wait_command_complete(info, channel);
 	write_reg(info, (unsigned char) (channel + CMDR), cmd);
@@ -775,12 +775,12 @@ static void tx_pause(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "tx_pause"))
 		return;
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("tx_pause(%s)\n",info->device_name);	
-		
+		printk("tx_pause(%s)\n",info->device_name);
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (info->tx_enabled)
 	 	tx_stop(info);
@@ -791,12 +791,12 @@ static void tx_release(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "tx_release"))
 		return;
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("tx_release(%s)\n",info->device_name);	
-		
+		printk("tx_release(%s)\n",info->device_name);
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (!info->tx_enabled)
 	 	tx_start(info);
@@ -810,7 +810,7 @@ static int bh_action(MGSLPC_INFO *info)
 {
 	unsigned long flags;
 	int rc = 0;
-	
+
 	spin_lock_irqsave(&info->lock,flags);
 
 	if (info->pending_bh & BH_RECEIVE) {
@@ -829,9 +829,9 @@ static int bh_action(MGSLPC_INFO *info)
 		info->bh_running   = 0;
 		info->bh_requested = 0;
 	}
-	
+
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
 	return rc;
 }
 
@@ -842,22 +842,22 @@ static void bh_handler(struct work_struct *work)
 
 	if (!info)
 		return;
-		
+
 	if (debug_level >= DEBUG_LEVEL_BH)
 		printk( "%s(%d):bh_handler(%s) entry\n",
 			__FILE__,__LINE__,info->device_name);
-	
+
 	info->bh_running = 1;
 
 	while((action = bh_action(info)) != 0) {
-	
+
 		/* Process work item */
 		if ( debug_level >= DEBUG_LEVEL_BH )
 			printk( "%s(%d):bh_handler() work item action=%d\n",
 				__FILE__,__LINE__,action);
 
 		switch (action) {
-		
+
 		case BH_RECEIVE:
 			while(rx_get_frame(info));
 			break;
@@ -897,7 +897,7 @@ static void bh_status(MGSLPC_INFO *info)
 	info->cts_chkcount = 0;
 }
 
-/* eom: non-zero = end of frame */ 
+/* eom: non-zero = end of frame */
 static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 {
 	unsigned char data[2];
@@ -906,7 +906,7 @@ static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):rx_ready_hdlc(eom=%d)\n",__FILE__,__LINE__,eom);
-	
+
 	if (!info->rx_enabled)
 		return;
 
@@ -920,12 +920,12 @@ static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 	}
 
 	if (eom) {
-		/* end of frame, get FIFO count from RBCL register */ 
+		/* end of frame, get FIFO count from RBCL register */
 		if (!(fifo_count = (unsigned char)(read_reg(info, CHA+RBCL) & 0x1f)))
 			fifo_count = 32;
 	} else
 		fifo_count = 32;
-	
+
 	do {
 		if (fifo_count == 1) {
 			read_count = 1;
@@ -969,7 +969,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
  	struct mgsl_icount *icount = &info->icount;
 
 	if (tcd) {
-		/* early termination, get FIFO count from RBCL register */ 
+		/* early termination, get FIFO count from RBCL register */
 		fifo_count = (unsigned char)(read_reg(info, CHA+RBCL) & 0x1f);
 
 		/* Zero fifo count could mean 0 or 32 bytes available.
@@ -981,7 +981,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
 		fifo_count = 32;
 
 	tty_buffer_request_room(tty, fifo_count);
-	/* Flush received async data to receive data buffer. */ 
+	/* Flush received async data to receive data buffer. */
 	while (fifo_count) {
 		data   = read_reg(info, CHA + RXFIFO);
 		status = read_reg(info, CHA + RXFIFO);
@@ -995,7 +995,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
 		// BIT6:framing error
 
 		if (status & (BIT7 + BIT6)) {
-			if (status & BIT7) 
+			if (status & BIT7)
 				icount->parity++;
 			else
 				icount->frame++;
@@ -1003,7 +1003,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
 			/* discard char if tty control flags say so */
 			if (status & info->ignore_status_mask)
 				continue;
-				
+
 			status &= info->read_status_mask;
 
 			if (status & BIT7)
@@ -1022,7 +1022,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
 			__FILE__,__LINE__,icount->rx,icount->brk,
 			icount->parity,icount->frame,icount->overrun);
 	}
-			
+
 	if (work)
 		tty_flip_buffer_push(tty);
 }
@@ -1032,7 +1032,7 @@ static void tx_done(MGSLPC_INFO *info)
 {
 	if (!info->tx_active)
 		return;
-			
+
 	info->tx_active = 0;
 	info->tx_aborting = 0;
 
@@ -1040,8 +1040,8 @@ static void tx_done(MGSLPC_INFO *info)
 		return;
 
 	info->tx_count = info->tx_put = info->tx_get = 0;
-	del_timer(&info->tx_timer);	
-	
+	del_timer(&info->tx_timer);
+
 	if (info->drop_rts_on_tx_done) {
 		get_signals(info);
 		if (info->serial_signals & SerialSignal_RTS) {
@@ -1054,7 +1054,7 @@ static void tx_done(MGSLPC_INFO *info)
 #if SYNCLINK_GENERIC_HDLC
 	if (info->netcount)
 		hdlcdev_tx_done(info);
-	else 
+	else
 #endif
 	{
 		if (info->tty->stopped || info->tty->hw_stopped) {
@@ -1090,7 +1090,7 @@ static void tx_ready(MGSLPC_INFO *info)
 
 	while (info->tx_count && fifo_count) {
 		c = min(2, min_t(int, fifo_count, min(info->tx_count, TXBUFSIZE - info->tx_get)));
-		
+
 		if (c == 1) {
 			write_reg(info, CHA + TXFIFO, *(info->tx_buf + info->tx_get));
 		} else {
@@ -1220,9 +1220,9 @@ static void ri_change(MGSLPC_INFO *info)
 }
 
 /* Interrupt service routine entry point.
- * 	
+ *
  * Arguments:
- * 
+ *
  * irq     interrupt number that caused interrupt
  * dev_id  device ID supplied during interrupt registration
  */
@@ -1233,18 +1233,18 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 	unsigned char gis, pis;
 	int count=0;
 
-	if (debug_level >= DEBUG_LEVEL_ISR)	
+	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("mgslpc_isr(%d) entry.\n", irq);
 	if (!info)
 		return IRQ_NONE;
-		
+
 	if (!(info->p_dev->_locked))
 		return IRQ_HANDLED;
 
 	spin_lock(&info->lock);
 
 	while ((gis = read_reg(info, CHA + GIS))) {
-		if (debug_level >= DEBUG_LEVEL_ISR)	
+		if (debug_level >= DEBUG_LEVEL_ISR)
 			printk("mgslpc_isr %s gis=%04X\n", info->device_name,gis);
 
 		if ((gis & 0x70) || count > 1000) {
@@ -1268,7 +1268,7 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 				irq_disable(info, CHA, IRQ_TIMER);
 			}
 
-			/* receive IRQs */ 
+			/* receive IRQs */
 			if (isr & IRQ_EXITHUNT) {
 				info->icount.exithunt++;
 				wake_up_interruptible(&info->event_wait_q);
@@ -1283,12 +1283,12 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 			}
 			if (isr & (IRQ_RXEOM + IRQ_RXFIFO)) {
 				if (info->params.mode == MGSL_MODE_HDLC)
-					rx_ready_hdlc(info, isr & IRQ_RXEOM); 
+					rx_ready_hdlc(info, isr & IRQ_RXEOM);
 				else
 					rx_ready_async(info, isr & IRQ_RXEOM);
 			}
 
-			/* transmit IRQs */ 
+			/* transmit IRQs */
 			if (isr & IRQ_UNDERRUN) {
 				if (info->tx_aborting)
 					info->icount.txabort++;
@@ -1311,13 +1311,13 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 				ri_change(info);
 		}
 	}
-	
-	/* Request bottom half processing if there's something 
+
+	/* Request bottom half processing if there's something
 	 * for it to do and the bh is not already running
 	 */
 
 	if (info->pending_bh && !info->bh_running && !info->bh_requested) {
-		if ( debug_level >= DEBUG_LEVEL_ISR )	
+		if ( debug_level >= DEBUG_LEVEL_ISR )
 			printk("%s(%d):%s queueing bh task.\n",
 				__FILE__,__LINE__,info->device_name);
 		schedule_work(&info->task);
@@ -1325,8 +1325,8 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 	}
 
 	spin_unlock(&info->lock);
-	
-	if (debug_level >= DEBUG_LEVEL_ISR)	
+
+	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):mgslpc_isr(%d)exit.\n",
 		       __FILE__,__LINE__,irq);
 
@@ -1338,13 +1338,13 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 static int startup(MGSLPC_INFO * info)
 {
 	int retval = 0;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):startup(%s)\n",__FILE__,__LINE__,info->device_name);
-		
+
 	if (info->flags & ASYNC_INITIALIZED)
 		return 0;
-	
+
 	if (!info->tx_buf) {
 		/* allocate a page of memory for a transmit buffer */
 		info->tx_buf = (unsigned char *)get_zeroed_page(GFP_KERNEL);
@@ -1356,18 +1356,18 @@ static int startup(MGSLPC_INFO * info)
 	}
 
 	info->pending_bh = 0;
-	
+
 	memset(&info->icount, 0, sizeof(info->icount));
 
 	setup_timer(&info->tx_timer, tx_timeout, (unsigned long)info);
 
 	/* Allocate and claim adapter resources */
 	retval = claim_resources(info);
-	
+
 	/* perform existance check and diagnostics */
 	if ( !retval )
 		retval = adapter_test(info);
-		
+
 	if ( retval ) {
   		if (capable(CAP_SYS_ADMIN) && info->tty)
 			set_bit(TTY_IO_ERROR, &info->tty->flags);
@@ -1377,12 +1377,12 @@ static int startup(MGSLPC_INFO * info)
 
 	/* program hardware for current parameters */
 	mgslpc_change_params(info);
-	
+
 	if (info->tty)
 		clear_bit(TTY_IO_ERROR, &info->tty->flags);
 
 	info->flags |= ASYNC_INITIALIZED;
-	
+
 	return 0;
 }
 
@@ -1391,7 +1391,7 @@ static int startup(MGSLPC_INFO * info)
 static void shutdown(MGSLPC_INFO * info)
 {
 	unsigned long flags;
-	
+
 	if (!(info->flags & ASYNC_INITIALIZED))
 		return;
 
@@ -1418,16 +1418,16 @@ static void shutdown(MGSLPC_INFO * info)
 
 	/* TODO:disable interrupts instead of reset to preserve signal states */
 	reset_device(info);
-	
+
  	if (!info->tty || info->tty->termios->c_cflag & HUPCL) {
  		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
 		set_signals(info);
 	}
-	
+
 	spin_unlock_irqrestore(&info->lock,flags);
 
-	release_resources(info);	
-	
+	release_resources(info);
+
 	if (info->tty)
 		set_bit(TTY_IO_ERROR, &info->tty->flags);
 
@@ -1439,18 +1439,18 @@ static void mgslpc_program_hw(MGSLPC_INFO *info)
 	unsigned long flags;
 
 	spin_lock_irqsave(&info->lock,flags);
-	
+
 	rx_stop(info);
 	tx_stop(info);
 	info->tx_count = info->tx_put = info->tx_get = 0;
-	
+
 	if (info->params.mode == MGSL_MODE_HDLC || info->netcount)
 		hdlc_mode(info);
 	else
 		async_mode(info);
-		
+
 	set_signals(info);
-	
+
 	info->dcd_chkcount = 0;
 	info->cts_chkcount = 0;
 	info->ri_chkcount = 0;
@@ -1459,10 +1459,10 @@ static void mgslpc_program_hw(MGSLPC_INFO *info)
 	irq_enable(info, CHB, IRQ_DCD | IRQ_CTS);
 	port_irq_enable(info, (unsigned char) PVR_DSR | PVR_RI);
 	get_signals(info);
-		
+
 	if (info->netcount || info->tty->termios->c_cflag & CREAD)
 		rx_start(info);
-		
+
 	spin_unlock_irqrestore(&info->lock,flags);
 }
 
@@ -1475,11 +1475,11 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 
 	if (!info->tty || !info->tty->termios)
 		return;
-		
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_change_params(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
+
 	cflag = info->tty->termios->c_cflag;
 
 	/* if B0 rate (hangup) specified then negate DTR and RTS */
@@ -1488,9 +1488,9 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
 	else
 		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
-	
+
 	/* byte size and parity */
-	
+
 	switch (cflag & CSIZE) {
 	case CS5: info->params.data_bits = 5; break;
 	case CS6: info->params.data_bits = 6; break;
@@ -1498,7 +1498,7 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 	case CS8: info->params.data_bits = 8; break;
 	default:  info->params.data_bits = 7; break;
 	}
-	      
+
 	if (cflag & CSTOPB)
 		info->params.stop_bits = 2;
 	else
@@ -1519,7 +1519,7 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 	/* calculate number of jiffies to transmit a full
 	 * FIFO (32 bytes) at specified data rate
 	 */
-	bits_per_char = info->params.data_bits + 
+	bits_per_char = info->params.data_bits +
 			info->params.stop_bits + 1;
 
 	/* if port data rate is set to 460800 or less then
@@ -1529,9 +1529,9 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 	if (info->params.data_rate <= 460800) {
 		info->params.data_rate = tty_get_baud_rate(info->tty);
 	}
-	
+
 	if ( info->params.data_rate ) {
-		info->timeout = (32*HZ*bits_per_char) / 
+		info->timeout = (32*HZ*bits_per_char) /
 				info->params.data_rate;
 	}
 	info->timeout += HZ/50;		/* Add .02 seconds of slop */
@@ -1540,14 +1540,14 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 		info->flags |= ASYNC_CTS_FLOW;
 	else
 		info->flags &= ~ASYNC_CTS_FLOW;
-		
+
 	if (cflag & CLOCAL)
 		info->flags &= ~ASYNC_CHECK_CD;
 	else
 		info->flags |= ASYNC_CHECK_CD;
 
 	/* process tty input control flags */
-	
+
 	info->read_status_mask = 0;
 	if (I_INPCK(info->tty))
 		info->read_status_mask |= BIT7 | BIT6;
@@ -1576,7 +1576,7 @@ static void mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
 		return;
 
 	spin_lock_irqsave(&info->lock,flags);
-	
+
 	if (info->params.mode == MGSL_MODE_ASYNC || !info->tx_active) {
 		if (info->tx_count < TXBUFSIZE - 1) {
 			info->tx_buf[info->tx_put++] = ch;
@@ -1584,7 +1584,7 @@ static void mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
 			info->tx_count++;
 		}
 	}
-	
+
 	spin_unlock_irqrestore(&info->lock,flags);
 }
 
@@ -1595,11 +1595,11 @@ static void mgslpc_flush_chars(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-				
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk( "%s(%d):mgslpc_flush_chars() entry on %s tx_count=%d\n",
 			__FILE__,__LINE__,info->device_name,info->tx_count);
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_flush_chars"))
 		return;
 
@@ -1618,13 +1618,13 @@ static void mgslpc_flush_chars(struct tty_struct *tty)
 }
 
 /* Send a block of data
- * 	
+ *
  * Arguments:
- * 
+ *
  * tty        pointer to tty information structure
  * buf	      pointer to buffer containing send data
  * count      size of send data in bytes
- * 	
+ *
  * Returns: number of characters written
  */
 static int mgslpc_write(struct tty_struct * tty,
@@ -1633,11 +1633,11 @@ static int mgslpc_write(struct tty_struct * tty,
 	int c, ret = 0;
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk( "%s(%d):mgslpc_write(%s) count=%d\n",
 			__FILE__,__LINE__,info->device_name,count);
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_write") ||
 		!info->tx_buf)
 		goto cleanup;
@@ -1659,7 +1659,7 @@ static int mgslpc_write(struct tty_struct * tty,
 			    TXBUFSIZE - info->tx_put));
 		if (c <= 0)
 			break;
-			
+
 		memcpy(info->tx_buf + info->tx_put, buf, c);
 
 		spin_lock_irqsave(&info->lock,flags);
@@ -1678,7 +1678,7 @@ start:
 		 	tx_start(info);
 		spin_unlock_irqrestore(&info->lock,flags);
  	}
-cleanup:	
+cleanup:
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk( "%s(%d):mgslpc_write(%s) returning=%d\n",
 			__FILE__,__LINE__,info->device_name,ret);
@@ -1691,7 +1691,7 @@ static int mgslpc_write_room(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	int ret;
-				
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_write_room"))
 		return 0;
 
@@ -1706,7 +1706,7 @@ static int mgslpc_write_room(struct tty_struct *tty)
 		if (ret < 0)
 			ret = 0;
 	}
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_write_room(%s)=%d\n",
 			 __FILE__,__LINE__, info->device_name, ret);
@@ -1719,14 +1719,14 @@ static int mgslpc_chars_in_buffer(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	int rc;
-		 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_chars_in_buffer(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_chars_in_buffer"))
 		return 0;
-		
+
 	if (info->params.mode == MGSL_MODE_HDLC)
 		rc = info->tx_active ? info->max_frame_size : 0;
 	else
@@ -1735,7 +1735,7 @@ static int mgslpc_chars_in_buffer(struct tty_struct *tty)
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_chars_in_buffer(%s)=%d\n",
 			 __FILE__,__LINE__, info->device_name, rc);
-			 
+
 	return rc;
 }
 
@@ -1745,17 +1745,17 @@ static void mgslpc_flush_buffer(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_flush_buffer(%s) entry\n",
 			 __FILE__,__LINE__, info->device_name );
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_flush_buffer"))
 		return;
-		
-	spin_lock_irqsave(&info->lock,flags); 
+
+	spin_lock_irqsave(&info->lock,flags);
 	info->tx_count = info->tx_put = info->tx_get = 0;
-	del_timer(&info->tx_timer);	
+	del_timer(&info->tx_timer);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 	wake_up_interruptible(&tty->write_wait);
@@ -1772,7 +1772,7 @@ static void mgslpc_send_xchar(struct tty_struct *tty, char ch)
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_send_xchar(%s,%d)\n",
 			 __FILE__,__LINE__, info->device_name, ch );
-			 
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_send_xchar"))
 		return;
 
@@ -1791,17 +1791,17 @@ static void mgslpc_throttle(struct tty_struct * tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_throttle(%s) entry\n",
 			 __FILE__,__LINE__, info->device_name );
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_throttle"))
 		return;
-	
+
 	if (I_IXOFF(tty))
 		mgslpc_send_xchar(tty, STOP_CHAR(tty));
- 
+
  	if (tty->termios->c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->serial_signals &= ~SerialSignal_RTS;
@@ -1816,21 +1816,21 @@ static void mgslpc_unthrottle(struct tty_struct * tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_unthrottle(%s) entry\n",
 			 __FILE__,__LINE__, info->device_name );
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_unthrottle"))
 		return;
-	
+
 	if (I_IXOFF(tty)) {
 		if (info->x_char)
 			info->x_char = 0;
 		else
 			mgslpc_send_xchar(tty, START_CHAR(tty));
 	}
-	
+
  	if (tty->termios->c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->serial_signals |= SerialSignal_RTS;
@@ -1870,9 +1870,9 @@ static int get_params(MGSLPC_INFO * info, MGSL_PARAMS __user *user_params)
 }
 
 /* set the serial parameters
- * 	
+ *
  * Arguments:
- * 
+ *
  * 	info		pointer to device instance data
  * 	new_params	user buffer containing new serial params
  *
@@ -1883,7 +1883,7 @@ static int set_params(MGSLPC_INFO * info, MGSL_PARAMS __user *new_params)
  	unsigned long flags;
 	MGSL_PARAMS tmp_params;
 	int err;
- 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):set_params %s\n", __FILE__,__LINE__,
 			info->device_name );
@@ -1894,13 +1894,13 @@ static int set_params(MGSLPC_INFO * info, MGSL_PARAMS __user *new_params)
 				__FILE__,__LINE__,info->device_name);
 		return -EFAULT;
 	}
-	
+
 	spin_lock_irqsave(&info->lock,flags);
 	memcpy(&info->params,&tmp_params,sizeof(MGSL_PARAMS));
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
  	mgslpc_change_params(info);
-	
+
 	return 0;
 }
 
@@ -1963,10 +1963,10 @@ static int set_interface(MGSLPC_INFO * info, int if_mode)
 static int set_txenable(MGSLPC_INFO * info, int enable)
 {
  	unsigned long flags;
- 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("set_txenable(%s,%d)\n", info->device_name, enable);
-			
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (enable) {
 		if (!info->tx_enabled)
@@ -1982,10 +1982,10 @@ static int set_txenable(MGSLPC_INFO * info, int enable)
 static int tx_abort(MGSLPC_INFO * info)
 {
  	unsigned long flags;
- 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("tx_abort(%s)\n", info->device_name);
-			
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (info->tx_active && info->tx_count &&
 	    info->params.mode == MGSL_MODE_HDLC) {
@@ -2002,10 +2002,10 @@ static int tx_abort(MGSLPC_INFO * info)
 static int set_rxenable(MGSLPC_INFO * info, int enable)
 {
  	unsigned long flags;
- 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("set_rxenable(%s,%d)\n", info->device_name, enable);
-			
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (enable) {
 		if (!info->rx_enabled)
@@ -2019,7 +2019,7 @@ static int set_rxenable(MGSLPC_INFO * info, int enable)
 }
 
 /* wait for specified event to occur
- * 	
+ *
  * Arguments:	 	info	pointer to device instance data
  * 			mask	pointer to bitmask of events to wait for
  * Return Value:	0 	if successful and bit mask updated with
@@ -2040,7 +2040,7 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 	COPY_FROM_USER(rc,&mask, mask_ptr, sizeof(int));
 	if (rc)
 		return  -EFAULT;
-		 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("wait_events(%s,%d)\n", info->device_name, mask);
 
@@ -2062,24 +2062,24 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 	/* save current irq counts */
 	cprev = info->icount;
 	oldsigs = info->input_signal_events;
-	
+
 	if ((info->params.mode == MGSL_MODE_HDLC) &&
 	    (mask & MgslEvent_ExitHuntMode))
 		irq_enable(info, CHA, IRQ_EXITHUNT);
-	
+
 	set_current_state(TASK_INTERRUPTIBLE);
 	add_wait_queue(&info->event_wait_q, &wait);
-	
+
 	spin_unlock_irqrestore(&info->lock,flags);
-	
-	
+
+
 	for(;;) {
 		schedule();
 		if (signal_pending(current)) {
 			rc = -ERESTARTSYS;
 			break;
 		}
-			
+
 		/* get current irq counts */
 		spin_lock_irqsave(&info->lock,flags);
 		cnow = info->icount;
@@ -2115,11 +2115,11 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 			  (cnow.rxidle      != cprev.rxidle     ? MgslEvent_IdleReceived:0) );
 		if (events)
 			break;
-		
+
 		cprev = cnow;
 		oldsigs = newsigs;
 	}
-	
+
 	remove_wait_queue(&info->event_wait_q, &wait);
 	set_current_state(TASK_RUNNING);
 
@@ -2247,42 +2247,42 @@ static void mgslpc_break(struct tty_struct *tty, int break_state)
 {
 	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_break(%s,%d)\n",
 			 __FILE__,__LINE__, info->device_name, break_state);
-			 
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_break"))
 		return;
 
 	spin_lock_irqsave(&info->lock,flags);
  	if (break_state == -1)
 		set_reg_bits(info, CHA+DAFO, BIT6);
-	else 
+	else
 		clear_reg_bits(info, CHA+DAFO, BIT6);
 	spin_unlock_irqrestore(&info->lock,flags);
 }
 
 /* Service an IOCTL request
- * 	
+ *
  * Arguments:
- * 
+ *
  * 	tty	pointer to tty instance data
  * 	file	pointer to associated file object for device
  * 	cmd	IOCTL command code
  * 	arg	command argument/context
- * 	
+ *
  * Return Value:	0 if success, otherwise error code
  */
 static int mgslpc_ioctl(struct tty_struct *tty, struct file * file,
 			unsigned int cmd, unsigned long arg)
 {
 	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_ioctl %s cmd=%08X\n", __FILE__,__LINE__,
 			info->device_name, cmd );
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_ioctl"))
 		return -ENODEV;
 
@@ -2302,7 +2302,7 @@ static int ioctl_common(MGSLPC_INFO *info, unsigned int cmd, unsigned long arg)
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	void __user *argp = (void __user *)arg;
 	unsigned long flags;
-	
+
 	switch (cmd) {
 	case MGSL_IOCGPARAMS:
 		return get_params(info, argp);
@@ -2363,9 +2363,9 @@ static int ioctl_common(MGSLPC_INFO *info, unsigned int cmd, unsigned long arg)
 }
 
 /* Set new termios settings
- * 	
+ *
  * Arguments:
- * 
+ *
  * 	tty		pointer to tty structure
  * 	termios		pointer to buffer to hold returned old termios
  */
@@ -2373,14 +2373,14 @@ static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_term
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_set_termios %s\n", __FILE__,__LINE__,
 			tty->driver->name );
-	
+
 	/* just return if nothing has changed */
 	if ((tty->termios->c_cflag == old_termios->c_cflag)
-	    && (RELEVANT_IFLAG(tty->termios->c_iflag) 
+	    && (RELEVANT_IFLAG(tty->termios->c_iflag)
 		== RELEVANT_IFLAG(old_termios->c_iflag)))
 	  return;
 
@@ -2394,12 +2394,12 @@ static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_term
 	 	set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
-	
+
 	/* Handle transition away from B0 status */
 	if (!(old_termios->c_cflag & CBAUD) &&
 	    tty->termios->c_cflag & CBAUD) {
 		info->serial_signals |= SerialSignal_DTR;
- 		if (!(tty->termios->c_cflag & CRTSCTS) || 
+ 		if (!(tty->termios->c_cflag & CRTSCTS) ||
  		    !test_bit(TTY_THROTTLED, &tty->flags)) {
 			info->serial_signals |= SerialSignal_RTS;
  		}
@@ -2407,7 +2407,7 @@ static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_term
 	 	set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
-	
+
 	/* Handle turning off CRTSCTS */
 	if (old_termios->c_cflag & CRTSCTS &&
 	    !(tty->termios->c_cflag & CRTSCTS)) {
@@ -2422,17 +2422,17 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_close"))
 		return;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_close(%s) entry, count=%d\n",
 			 __FILE__,__LINE__, info->device_name, info->count);
-			 
+
 	if (!info->count)
 		return;
 
 	if (tty_hung_up_p(filp))
 		goto cleanup;
-			
+
 	if ((tty->count == 1) && (info->count != 1)) {
 		/*
 		 * tty->count is 1 and the tty structure will be freed.
@@ -2443,30 +2443,30 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 		       "info->count is %d\n", info->count);
 		info->count = 1;
 	}
-	
+
 	info->count--;
-	
+
 	/* if at least one open remaining, leave hardware active */
 	if (info->count)
 		goto cleanup;
-	
+
 	info->flags |= ASYNC_CLOSING;
-	
-	/* set tty->closing to notify line discipline to 
+
+	/* set tty->closing to notify line discipline to
 	 * only process XON/XOFF characters. Only the N_TTY
 	 * discipline appears to use this (ppp does not).
 	 */
 	tty->closing = 1;
-	
+
 	/* wait for transmit data to clear all layers */
-	
+
 	if (info->closing_wait != ASYNC_CLOSING_WAIT_NONE) {
 		if (debug_level >= DEBUG_LEVEL_INFO)
 			printk("%s(%d):mgslpc_close(%s) calling tty_wait_until_sent\n",
 				 __FILE__,__LINE__, info->device_name );
 		tty_wait_until_sent(tty, info->closing_wait);
 	}
-		
+
  	if (info->flags & ASYNC_INITIALIZED)
  		mgslpc_wait_until_sent(tty, info->timeout);
 
@@ -2474,24 +2474,24 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 		tty->driver->flush_buffer(tty);
 
 	ldisc_flush_buffer(tty);
-		
+
 	shutdown(info);
-	
+
 	tty->closing = 0;
 	info->tty = NULL;
-	
+
 	if (info->blocked_open) {
 		if (info->close_delay) {
 			msleep_interruptible(jiffies_to_msecs(info->close_delay));
 		}
 		wake_up_interruptible(&info->open_wait);
 	}
-	
+
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-			 
+
 	wake_up_interruptible(&info->close_wait);
-	
-cleanup:			
+
+cleanup:
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_close(%s) exit, count=%d\n", __FILE__,__LINE__,
 			tty->driver->name, info->count);
@@ -2510,31 +2510,31 @@ static void mgslpc_wait_until_sent(struct tty_struct *tty, int timeout)
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_wait_until_sent(%s) entry\n",
 			 __FILE__,__LINE__, info->device_name );
-      
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_wait_until_sent"))
 		return;
 
 	if (!(info->flags & ASYNC_INITIALIZED))
 		goto exit;
-	 
+
 	orig_jiffies = jiffies;
-      
+
 	/* Set check interval to 1/5 of estimated time to
 	 * send a character, and make it at least 1. The check
 	 * interval should also be less than the timeout.
 	 * Note: use tight timings here to satisfy the NIST-PCTS.
-	 */ 
-       
+	 */
+
 	if ( info->params.data_rate ) {
 	       	char_time = info->timeout/(32 * 5);
 		if (!char_time)
 			char_time++;
 	} else
 		char_time = 1;
-		
+
 	if (timeout)
 		char_time = min_t(unsigned long, char_time, timeout);
-		
+
 	if (info->params.mode == MGSL_MODE_HDLC) {
 		while (info->tx_active) {
 			msleep_interruptible(jiffies_to_msecs(char_time));
@@ -2553,7 +2553,7 @@ static void mgslpc_wait_until_sent(struct tty_struct *tty, int timeout)
 				break;
 		}
 	}
-      
+
 exit:
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_wait_until_sent(%s) exit\n",
@@ -2566,18 +2566,18 @@ exit:
 static void mgslpc_hangup(struct tty_struct *tty)
 {
 	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_hangup(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_hangup"))
 		return;
 
 	mgslpc_flush_buffer(tty);
 	shutdown(info);
-	
-	info->count = 0;	
+
+	info->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 
@@ -2594,7 +2594,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	int		retval;
 	int		do_clocal = 0, extra_count = 0;
 	unsigned long	flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):block_til_ready on %s\n",
 			 __FILE__,__LINE__, tty->driver->name );
@@ -2615,10 +2615,10 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	 * mgslpc_close() knows when to free things.  We restore it upon
 	 * exit, either normal or abnormal.
 	 */
-	 
+
 	retval = 0;
 	add_wait_queue(&info->open_wait, &wait);
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):block_til_ready before block on %s count=%d\n",
 			 __FILE__,__LINE__, tty->driver->name, info->count );
@@ -2630,7 +2630,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
 	info->blocked_open++;
-	
+
 	while (1) {
 		if ((tty->termios->c_cflag & CBAUD)) {
 			spin_lock_irqsave(&info->lock,flags);
@@ -2638,50 +2638,50 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		 	set_signals(info);
 			spin_unlock_irqrestore(&info->lock,flags);
 		}
-		
+
 		set_current_state(TASK_INTERRUPTIBLE);
-		
+
 		if (tty_hung_up_p(filp) || !(info->flags & ASYNC_INITIALIZED)){
 			retval = (info->flags & ASYNC_HUP_NOTIFY) ?
 					-EAGAIN : -ERESTARTSYS;
 			break;
 		}
-		
+
 		spin_lock_irqsave(&info->lock,flags);
 	 	get_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
-		
+
  		if (!(info->flags & ASYNC_CLOSING) &&
  		    (do_clocal || (info->serial_signals & SerialSignal_DCD)) ) {
  			break;
 		}
-			
+
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
 			break;
 		}
-		
+
 		if (debug_level >= DEBUG_LEVEL_INFO)
 			printk("%s(%d):block_til_ready blocking on %s count=%d\n",
 				 __FILE__,__LINE__, tty->driver->name, info->count );
-				 
+
 		schedule();
 	}
-	
+
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
-	
+
 	if (extra_count)
 		info->count++;
 	info->blocked_open--;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):block_til_ready after blocking on %s count=%d\n",
 			 __FILE__,__LINE__, tty->driver->name, info->count );
-			 
+
 	if (!retval)
 		info->flags |= ASYNC_NORMAL_ACTIVE;
-		
+
 	return retval;
 }
 
@@ -2691,7 +2691,7 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 	int 			retval, line;
 	unsigned long flags;
 
-	/* verify range of specified line number */	
+	/* verify range of specified line number */
 	line = tty->index;
 	if ((line < 0) || (line >= mgslpc_device_count)) {
 		printk("%s(%d):mgslpc_open with invalid line #%d.\n",
@@ -2705,10 +2705,10 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 		info = info->next_device;
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_open"))
 		return -ENODEV;
-	
+
 	tty->driver_data = info;
 	info->tty = tty;
-		
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_open(%s), old ref count = %d\n",
 			 __FILE__,__LINE__,tty->driver->name, info->count);
@@ -2721,7 +2721,7 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 			-EAGAIN : -ERESTARTSYS);
 		goto cleanup;
 	}
-	
+
 	info->tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
@@ -2752,15 +2752,15 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 		printk("%s(%d):mgslpc_open(%s) success\n",
 			 __FILE__,__LINE__, info->device_name);
 	retval = 0;
-	
-cleanup:			
+
+cleanup:
 	if (retval) {
 		if (tty->count == 1)
 			info->tty = NULL; /* tty layer will release tty struct */
 		if(info->count)
 			info->count--;
 	}
-	
+
 	return retval;
 }
 
@@ -2781,7 +2781,7 @@ static inline int line_info(char *buf, MGSLPC_INFO *info)
 	spin_lock_irqsave(&info->lock,flags);
  	get_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
 	stat_buf[0] = 0;
 	stat_buf[1] = 0;
 	if (info->serial_signals & SerialSignal_RTS)
@@ -2805,7 +2805,7 @@ static inline int line_info(char *buf, MGSLPC_INFO *info)
 		if (info->icount.txabort)
 			ret += sprintf(buf+ret, " txabort:%d", info->icount.txabort);
 		if (info->icount.rxshort)
-			ret += sprintf(buf+ret, " rxshort:%d", info->icount.rxshort);	
+			ret += sprintf(buf+ret, " rxshort:%d", info->icount.rxshort);
 		if (info->icount.rxlong)
 			ret += sprintf(buf+ret, " rxlong:%d", info->icount.rxlong);
 		if (info->icount.rxover)
@@ -2820,18 +2820,18 @@ static inline int line_info(char *buf, MGSLPC_INFO *info)
 		if (info->icount.parity)
 			ret += sprintf(buf+ret, " pe:%d", info->icount.parity);
 		if (info->icount.brk)
-			ret += sprintf(buf+ret, " brk:%d", info->icount.brk);	
+			ret += sprintf(buf+ret, " brk:%d", info->icount.brk);
 		if (info->icount.overrun)
 			ret += sprintf(buf+ret, " oe:%d", info->icount.overrun);
 	}
-	
+
 	/* Append serial signal status to end */
 	ret += sprintf(buf+ret, " %s\n", stat_buf+1);
-	
+
 	ret += sprintf(buf+ret, "txactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
 		       info->tx_active,info->bh_requested,info->bh_running,
 		       info->pending_bh);
-	
+
 	return ret;
 }
 
@@ -2843,9 +2843,9 @@ static int mgslpc_read_proc(char *page, char **start, off_t off, int count,
 	int len = 0, l;
 	off_t	begin = 0;
 	MGSLPC_INFO *info;
-	
+
 	len += sprintf(page, "synclink driver:%s\n", driver_version);
-	
+
 	info = mgslpc_device_list;
 	while( info ) {
 		l = line_info(page + len, info);
@@ -2902,7 +2902,7 @@ static int claim_resources(MGSLPC_INFO *info)
 		printk( "Cant allocate rx buffer %s\n", info->device_name);
 		release_resources(info);
 		return -ENODEV;
-	}	
+	}
 	return 0;
 }
 
@@ -2915,7 +2915,7 @@ static void release_resources(MGSLPC_INFO *info)
 
 /* Add the specified device instance data structure to the
  * global linked list of devices and increment the device count.
- * 	
+ *
  * Arguments:		info	pointer to device instance data
  */
 static void mgslpc_add_device(MGSLPC_INFO *info)
@@ -2923,7 +2923,7 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 	info->next_device = NULL;
 	info->line = mgslpc_device_count;
 	sprintf(info->device_name,"ttySLP%d",info->line);
-	
+
 	if (info->line < MAX_DEVICE_COUNT) {
 		if (maxframe[info->line])
 			info->max_frame_size = maxframe[info->line];
@@ -2931,21 +2931,21 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 	}
 
 	mgslpc_device_count++;
-	
+
 	if (!mgslpc_device_list)
 		mgslpc_device_list = info;
-	else {	
+	else {
 		MGSLPC_INFO *current_dev = mgslpc_device_list;
 		while( current_dev->next_device )
 			current_dev = current_dev->next_device;
 		current_dev->next_device = info;
 	}
-	
+
 	if (info->max_frame_size < 4096)
 		info->max_frame_size = 4096;
 	else if (info->max_frame_size > 65535)
 		info->max_frame_size = 65535;
-	
+
 	printk( "SyncLink PC Card %s:IO=%04X IRQ=%d\n",
 		info->device_name, info->io_base, info->irq_level);
 
@@ -3060,7 +3060,7 @@ static int __init synclink_cs_init(void)
     }
 
     /* Initialize the tty_driver structure */
-	
+
     serial_driver->owner = THIS_MODULE;
     serial_driver->driver_name = "synclink_cs";
     serial_driver->name = "ttySLP";
@@ -3081,11 +3081,11 @@ static int __init synclink_cs_init(void)
 	    serial_driver = NULL;
 	    goto error;
     }
-			
+
     printk("%s %s, tty major#%d\n",
 	   driver_name, driver_version,
 	   serial_driver->major);
-	
+
     return 0;
 
 error:
@@ -3093,7 +3093,7 @@ error:
     return rc;
 }
 
-static void __exit synclink_cs_exit(void) 
+static void __exit synclink_cs_exit(void)
 {
 	synclink_cs_cleanup();
 }
@@ -3106,8 +3106,8 @@ static void mgslpc_set_rate(MGSLPC_INFO *info, unsigned char channel, unsigned i
 	unsigned int M, N;
 	unsigned char val;
 
-	/* note:standard BRG mode is broken in V3.2 chip 
-	 * so enhanced mode is always used 
+	/* note:standard BRG mode is broken in V3.2 chip
+	 * so enhanced mode is always used
 	 */
 
 	if (rate) {
@@ -3126,7 +3126,7 @@ static void mgslpc_set_rate(MGSLPC_INFO *info, unsigned char channel, unsigned i
 		 * divisor = (N+1)*2^M
 		 *
 		 * Note: M *must* not be zero (causes asymetric duty cycle)
-		 */ 
+		 */
 		write_reg(info, (unsigned char) (channel + BGR),
 				  (unsigned char) ((M << 6) + N));
 		val = read_reg(info, (unsigned char) (channel + CCR2)) & 0x3f;
@@ -3140,7 +3140,7 @@ static void mgslpc_set_rate(MGSLPC_INFO *info, unsigned char channel, unsigned i
 static void enable_auxclk(MGSLPC_INFO *info)
 {
 	unsigned char val;
-	
+
 	/* MODE
 	 *
 	 * 07..06  MDS[1..0] 10 = transparent HDLC mode
@@ -3152,14 +3152,14 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 00      TLP Test Loop, 0 = no loop
 	 *
 	 * 1000 0010
-	 */ 
+	 */
 	val = 0x82;
-	
-	/* channel B RTS is used to enable AUXCLK driver on SP505 */ 
+
+	/* channel B RTS is used to enable AUXCLK driver on SP505 */
 	if (info->params.mode == MGSL_MODE_HDLC && info->params.clock_speed)
 		val |= BIT2;
 	write_reg(info, CHB + MODE, val);
-	
+
 	/* CCR0
 	 *
 	 * 07      PU Power Up, 1=active, 0=power down
@@ -3169,9 +3169,9 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 01..00  SM[1..0] Serial Mode, 00=HDLC
 	 *
 	 * 11000000
-	 */ 
+	 */
 	write_reg(info, CHB + CCR0, 0xc0);
-	
+
 	/* CCR1
 	 *
 	 * 07      SFLG Shared Flag, 0 = disable shared flags
@@ -3182,9 +3182,9 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 02..00  CM[2..0] Clock Mode
 	 *
 	 * 0001 0111
-	 */ 
+	 */
 	write_reg(info, CHB + CCR1, 0x17);
-	
+
 	/* CCR2 (Channel B)
 	 *
 	 * 07..06  BGR[9..8] Baud rate bits 9..8
@@ -3196,12 +3196,12 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 00      DIV, data inversion 0=disabled, 1=enabled
 	 *
 	 * 0011 1000
-	 */ 
+	 */
 	if (info->params.mode == MGSL_MODE_HDLC && info->params.clock_speed)
 		write_reg(info, CHB + CCR2, 0x38);
 	else
 		write_reg(info, CHB + CCR2, 0x30);
-	
+
 	/* CCR4
 	 *
 	 * 07      MCK4 Master Clock Divide by 4, 1=enabled
@@ -3212,37 +3212,37 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 01..00  RFT[1..0] RxFIFO Threshold 00=32 bytes
 	 *
 	 * 0101 0000
-	 */ 
+	 */
 	write_reg(info, CHB + CCR4, 0x50);
-	
+
 	/* if auxclk not enabled, set internal BRG so
 	 * CTS transitions can be detected (requires TxC)
-	 */ 
+	 */
 	if (info->params.mode == MGSL_MODE_HDLC && info->params.clock_speed)
 		mgslpc_set_rate(info, CHB, info->params.clock_speed);
 	else
 		mgslpc_set_rate(info, CHB, 921600);
 }
 
-static void loopback_enable(MGSLPC_INFO *info) 
+static void loopback_enable(MGSLPC_INFO *info)
 {
 	unsigned char val;
-	
-	/* CCR1:02..00  CM[2..0] Clock Mode = 111 (clock mode 7) */ 
+
+	/* CCR1:02..00  CM[2..0] Clock Mode = 111 (clock mode 7) */
 	val = read_reg(info, CHA + CCR1) | (BIT2 + BIT1 + BIT0);
 	write_reg(info, CHA + CCR1, val);
-	
-	/* CCR2:04 SSEL Clock source select, 1=submode b */ 
+
+	/* CCR2:04 SSEL Clock source select, 1=submode b */
 	val = read_reg(info, CHA + CCR2) | (BIT4 + BIT5);
 	write_reg(info, CHA + CCR2, val);
-	
-	/* set LinkSpeed if available, otherwise default to 2Mbps */ 
+
+	/* set LinkSpeed if available, otherwise default to 2Mbps */
 	if (info->params.clock_speed)
 		mgslpc_set_rate(info, CHA, info->params.clock_speed);
 	else
 		mgslpc_set_rate(info, CHA, 1843200);
-	
-	/* MODE:00 TLP Test Loop, 1=loopback enabled */ 
+
+	/* MODE:00 TLP Test Loop, 1=loopback enabled */
 	val = read_reg(info, CHA + MODE) | BIT0;
 	write_reg(info, CHA + MODE, val);
 }
@@ -3252,36 +3252,36 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	unsigned char val;
 	unsigned char clkmode, clksubmode;
 
-	/* disable all interrupts */ 
+	/* disable all interrupts */
 	irq_disable(info, CHA, 0xffff);
 	irq_disable(info, CHB, 0xffff);
 	port_irq_disable(info, 0xff);
-	
-	/* assume clock mode 0a, rcv=RxC xmt=TxC */ 
+
+	/* assume clock mode 0a, rcv=RxC xmt=TxC */
 	clkmode = clksubmode = 0;
 	if (info->params.flags & HDLC_FLAG_RXC_DPLL
 	    && info->params.flags & HDLC_FLAG_TXC_DPLL) {
-		/* clock mode 7a, rcv = DPLL, xmt = DPLL */ 
+		/* clock mode 7a, rcv = DPLL, xmt = DPLL */
 		clkmode = 7;
 	} else if (info->params.flags & HDLC_FLAG_RXC_BRG
 		 && info->params.flags & HDLC_FLAG_TXC_BRG) {
-		/* clock mode 7b, rcv = BRG, xmt = BRG */ 
+		/* clock mode 7b, rcv = BRG, xmt = BRG */
 		clkmode = 7;
 		clksubmode = 1;
 	} else if (info->params.flags & HDLC_FLAG_RXC_DPLL) {
 		if (info->params.flags & HDLC_FLAG_TXC_BRG) {
-			/* clock mode 6b, rcv = DPLL, xmt = BRG/16 */ 
+			/* clock mode 6b, rcv = DPLL, xmt = BRG/16 */
 			clkmode = 6;
 			clksubmode = 1;
 		} else {
-			/* clock mode 6a, rcv = DPLL, xmt = TxC */ 
+			/* clock mode 6a, rcv = DPLL, xmt = TxC */
 			clkmode = 6;
 		}
 	} else if (info->params.flags & HDLC_FLAG_TXC_BRG) {
-		/* clock mode 0b, rcv = RxC, xmt = BRG */ 
+		/* clock mode 0b, rcv = RxC, xmt = BRG */
 		clksubmode = 1;
 	}
-	
+
 	/* MODE
 	 *
 	 * 07..06  MDS[1..0] 10 = transparent HDLC mode
@@ -3293,16 +3293,16 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 00      TLP Test Loop, 0 = no loop
 	 *
 	 * 1000 0010
-	 */ 
+	 */
 	val = 0x82;
 	if (info->params.loopback)
 		val |= BIT0;
-	
-	/* preserve RTS state */ 
+
+	/* preserve RTS state */
 	if (info->serial_signals & SerialSignal_RTS)
 		val |= BIT2;
 	write_reg(info, CHA + MODE, val);
-	
+
 	/* CCR0
 	 *
 	 * 07      PU Power Up, 1=active, 0=power down
@@ -3312,7 +3312,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 01..00  SM[1..0] Serial Mode, 00=HDLC
 	 *
 	 * 11000000
-	 */ 
+	 */
 	val = 0xc0;
 	switch (info->params.encoding)
 	{
@@ -3330,7 +3330,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 		break;		// Manchester
 	}
 	write_reg(info, CHA + CCR0, val);
-	
+
 	/* CCR1
 	 *
 	 * 07      SFLG Shared Flag, 0 = disable shared flags
@@ -3341,10 +3341,10 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 02..00  CM[2..0] Clock Mode
 	 *
 	 * 0001 0000
-	 */ 
+	 */
 	val = 0x10 + clkmode;
 	write_reg(info, CHA + CCR1, val);
-	
+
 	/* CCR2
 	 *
 	 * 07..06  BGR[9..8] Baud rate bits 9..8
@@ -3356,7 +3356,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 00      DIV, data inversion 0=disabled, 1=enabled
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	val = 0x00;
 	if (clkmode == 2 || clkmode == 3 || clkmode == 6
 	    || clkmode == 7 || (clkmode == 0 && clksubmode == 1))
@@ -3368,7 +3368,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	if (info->params.encoding == HDLC_ENCODING_NRZB)
 		val |= BIT0;
 	write_reg(info, CHA + CCR2, val);
-	
+
 	/* CCR3
 	 *
 	 * 07..06  PRE[1..0] Preamble count 00=1, 01=2, 10=4, 11=8
@@ -3380,7 +3380,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 00      PSD DPLL Phase Shift Disable
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	val = 0x00;
 	if (info->params.crc_type == HDLC_CRC_NONE)
 		val |= BIT2 + BIT1;
@@ -3399,8 +3399,8 @@ static void hdlc_mode(MGSLPC_INFO *info)
 		break;
 	}
 	write_reg(info, CHA + CCR3, val);
-	
-	/* PRE - Preamble pattern */ 
+
+	/* PRE - Preamble pattern */
 	val = 0;
 	switch (info->params.preamble)
 	{
@@ -3410,7 +3410,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	case HDLC_PREAMBLE_PATTERN_ONES:  val = 0xff; break;
 	}
 	write_reg(info, CHA + PRE, val);
-	
+
 	/* CCR4
 	 *
 	 * 07      MCK4 Master Clock Divide by 4, 1=enabled
@@ -3421,21 +3421,21 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 01..00  RFT[1..0] RxFIFO Threshold 00=32 bytes
 	 *
 	 * 0101 0000
-	 */ 
+	 */
 	val = 0x50;
 	write_reg(info, CHA + CCR4, val);
 	if (info->params.flags & HDLC_FLAG_RXC_DPLL)
 		mgslpc_set_rate(info, CHA, info->params.clock_speed * 16);
 	else
 		mgslpc_set_rate(info, CHA, info->params.clock_speed);
-	
+
 	/* RLCR Receive length check register
 	 *
 	 * 7     1=enable receive length check
 	 * 6..0  Max frame length = (RL + 1) * 32
-	 */ 
+	 */
 	write_reg(info, CHA + RLCR, 0);
-	
+
 	/* XBCH Transmit Byte Count High
 	 *
 	 * 07      DMA mode, 0 = interrupt driven
@@ -3445,7 +3445,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 03..00  XBC[10..8] Transmit byte count bits 10..8
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	val = 0x00;
 	if (info->params.flags & HDLC_FLAG_AUTO_DCD)
 		val |= BIT5;
@@ -3456,7 +3456,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	if (info->params.flags & HDLC_FLAG_AUTO_CTS)
 	{
 		irq_enable(info, CHB, IRQ_CTS);
-		/* PVR[3] 1=AUTO CTS active */ 
+		/* PVR[3] 1=AUTO CTS active */
 		set_reg_bits(info, CHA + PVR, BIT3);
 	} else
 		clear_reg_bits(info, CHA + PVR, BIT3);
@@ -3467,7 +3467,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	issue_command(info, CHA, CMD_TXRESET + CMD_RXRESET);
 	wait_command_complete(info, CHA);
 	read_reg16(info, CHA + ISR);	/* clear pending IRQs */
-	
+
 	/* Master clock mode enabled above to allow reset commands
 	 * to complete even if no data clocks are present.
 	 *
@@ -3477,7 +3477,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 *
 	 * Leave master clock mode enabled for IRQ test because the
 	 * timer IRQ used by the test can only happen in master clock mode.
-	 */ 
+	 */
 	if (!info->testing_irq)
 		clear_reg_bits(info, CHA + CCR0, BIT6);
 
@@ -3492,8 +3492,8 @@ static void rx_stop(MGSLPC_INFO *info)
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):rx_stop(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
-	/* MODE:03 RAC Receiver Active, 0=inactive */ 
+
+	/* MODE:03 RAC Receiver Active, 0=inactive */
 	clear_reg_bits(info, CHA + MODE, BIT3);
 
 	info->rx_enabled = 0;
@@ -3510,7 +3510,7 @@ static void rx_start(MGSLPC_INFO *info)
 	info->rx_enabled = 0;
 	info->rx_overflow = 0;
 
-	/* MODE:03 RAC Receiver Active, 1=active */ 
+	/* MODE:03 RAC Receiver Active, 1=active */
 	set_reg_bits(info, CHA + MODE, BIT3);
 
 	info->rx_enabled = 1;
@@ -3521,7 +3521,7 @@ static void tx_start(MGSLPC_INFO *info)
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):tx_start(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
+
 	if (info->tx_count) {
 		/* If auto RTS enabled and RTS is inactive, then assert */
 		/* RTS and set a flag indicating that the driver should */
@@ -3559,8 +3559,8 @@ static void tx_stop(MGSLPC_INFO *info)
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):tx_stop(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
-	del_timer(&info->tx_timer);	
+
+	del_timer(&info->tx_timer);
 
 	info->tx_enabled = 0;
 	info->tx_active  = 0;
@@ -3570,17 +3570,17 @@ static void tx_stop(MGSLPC_INFO *info)
  */
 static void reset_device(MGSLPC_INFO *info)
 {
-	/* power up both channels (set BIT7) */ 
+	/* power up both channels (set BIT7) */
 	write_reg(info, CHA + CCR0, 0x80);
 	write_reg(info, CHB + CCR0, 0x80);
 	write_reg(info, CHA + MODE, 0);
 	write_reg(info, CHB + MODE, 0);
-	
-	/* disable all interrupts */ 
+
+	/* disable all interrupts */
 	irq_disable(info, CHA, 0xffff);
 	irq_disable(info, CHB, 0xffff);
 	port_irq_disable(info, 0xff);
-	
+
 	/* PCR Port Configuration Register
 	 *
 	 * 07..04  DEC[3..0] Serial I/F select outputs
@@ -3590,9 +3590,9 @@ static void reset_device(MGSLPC_INFO *info)
 	 * 00      DTR output 0=active
 	 *
 	 * 0000 0110
-	 */ 
+	 */
 	write_reg(info, PCR, 0x06);
-	
+
 	/* PVR Port Value Register
 	 *
 	 * 07..04  DEC[3..0] Serial I/F select (0000=disabled)
@@ -3604,7 +3604,7 @@ static void reset_device(MGSLPC_INFO *info)
 	 * 0000 0001
 	 */
 //	write_reg(info, PVR, PVR_DTR);
-	
+
 	/* IPC Interrupt Port Configuration
 	 *
 	 * 07      VIS 1=Masked interrupts visible
@@ -3614,7 +3614,7 @@ static void reset_device(MGSLPC_INFO *info)
 	 * 01..00  IC[1..0] Interrupt Config, 01=push-pull output, active low
 	 *
 	 * 0000 0101
-	 */ 
+	 */
 	write_reg(info, IPC, 0x05);
 }
 
@@ -3622,11 +3622,11 @@ static void async_mode(MGSLPC_INFO *info)
 {
 	unsigned char val;
 
-	/* disable all interrupts */ 
+	/* disable all interrupts */
 	irq_disable(info, CHA, 0xffff);
 	irq_disable(info, CHB, 0xffff);
 	port_irq_disable(info, 0xff);
-	
+
 	/* MODE
 	 *
 	 * 07      Reserved, 0
@@ -3639,16 +3639,16 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 00      TLP Test Loop, 0 = no loop
 	 *
 	 * 0000 0110
-	 */ 
+	 */
 	val = 0x06;
 	if (info->params.loopback)
 		val |= BIT0;
-	
-	/* preserve RTS state */ 
+
+	/* preserve RTS state */
 	if (!(info->serial_signals & SerialSignal_RTS))
 		val |= BIT6;
 	write_reg(info, CHA + MODE, val);
-	
+
 	/* CCR0
 	 *
 	 * 07      PU Power Up, 1=active, 0=power down
@@ -3658,9 +3658,9 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 01..00  SM[1..0] Serial Mode, 11=Async
 	 *
 	 * 1000 0011
-	 */ 
+	 */
 	write_reg(info, CHA + CCR0, 0x83);
-	
+
 	/* CCR1
 	 *
 	 * 07..05  Reserved, 0
@@ -3669,9 +3669,9 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 02..00  CM[2..0] Clock Mode, 111=BRG
 	 *
 	 * 0001 1111
-	 */ 
+	 */
 	write_reg(info, CHA + CCR1, 0x1f);
-	
+
 	/* CCR2 (channel A)
 	 *
 	 * 07..06  BGR[9..8] Baud rate bits 9..8
@@ -3683,18 +3683,18 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 00      DIV, data inversion 0=disabled, 1=enabled
 	 *
 	 * 0001 0000
-	 */ 
+	 */
 	write_reg(info, CHA + CCR2, 0x10);
-	
+
 	/* CCR3
 	 *
 	 * 07..01  Reserved, 0
 	 * 00      PSD DPLL Phase Shift Disable
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	write_reg(info, CHA + CCR3, 0);
-	
+
 	/* CCR4
 	 *
 	 * 07      MCK4 Master Clock Divide by 4, 1=enabled
@@ -3704,10 +3704,10 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 03..00  Reserved, must be 0
 	 *
 	 * 0101 0000
-	 */ 
+	 */
 	write_reg(info, CHA + CCR4, 0x50);
 	mgslpc_set_rate(info, CHA, info->params.data_rate * 16);
-	
+
 	/* DAFO Data Format
 	 *
 	 * 07      Reserved, 0
@@ -3717,7 +3717,7 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 02      PAREN Parity Enable
 	 * 01..00  CHL[1..0] Character Length (00=8, 01=7)
 	 *
-	 */ 
+	 */
 	val = 0x00;
 	if (info->params.data_bits != 8)
 		val |= BIT0;	/* 7 bits */
@@ -3732,7 +3732,7 @@ static void async_mode(MGSLPC_INFO *info)
 			val |= BIT4;
 	}
 	write_reg(info, CHA + DAFO, val);
-	
+
 	/* RFC Rx FIFO Control
 	 *
 	 * 07      Reserved, 0
@@ -3744,15 +3744,15 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 00      TCDE Terminate Char Detect Enable, 0=disabled
 	 *
 	 * 0101 1100
-	 */ 
+	 */
 	write_reg(info, CHA + RFC, 0x5c);
-	
+
 	/* RLCR Receive length check register
 	 *
 	 * Max frame length = (RL + 1) * 32
-	 */ 
+	 */
 	write_reg(info, CHA + RLCR, 0);
-	
+
 	/* XBCH Transmit Byte Count High
 	 *
 	 * 07      DMA mode, 0 = interrupt driven
@@ -3762,20 +3762,20 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 03..00  XBC[10..8] Transmit byte count bits 10..8
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	val = 0x00;
 	if (info->params.flags & HDLC_FLAG_AUTO_DCD)
 		val |= BIT5;
 	write_reg(info, CHA + XBCH, val);
 	if (info->params.flags & HDLC_FLAG_AUTO_CTS)
 		irq_enable(info, CHA, IRQ_CTS);
-	
-	/* MODE:03 RAC Receiver Active, 1=active */ 
+
+	/* MODE:03 RAC Receiver Active, 1=active */
 	set_reg_bits(info, CHA + MODE, BIT3);
 	enable_auxclk(info);
 	if (info->params.flags & HDLC_FLAG_AUTO_CTS) {
 		irq_enable(info, CHB, IRQ_CTS);
-		/* PVR[3] 1=AUTO CTS active */ 
+		/* PVR[3] 1=AUTO CTS active */
 		set_reg_bits(info, CHA + PVR, BIT3);
 	} else
 		clear_reg_bits(info, CHA + PVR, BIT3);
@@ -3791,7 +3791,7 @@ static void async_mode(MGSLPC_INFO *info)
  */
 static void tx_set_idle(MGSLPC_INFO *info)
 {
-	/* Note: ESCC2 only supports flags and one idle modes */ 
+	/* Note: ESCC2 only supports flags and one idle modes */
 	if (info->idle_mode == HDLC_TXIDLE_FLAGS)
 		set_reg_bits(info, CHA + CCR1, BIT3);
 	else
@@ -3803,8 +3803,8 @@ static void tx_set_idle(MGSLPC_INFO *info)
 static void get_signals(MGSLPC_INFO *info)
 {
 	unsigned char status = 0;
-	
-	/* preserve DTR and RTS */ 
+
+	/* preserve DTR and RTS */
 	info->serial_signals &= SerialSignal_DTR + SerialSignal_RTS;
 
 	if (read_reg(info, CHB + VSTR) & BIT7)
@@ -3873,7 +3873,7 @@ static int rx_get_frame(MGSLPC_INFO *info)
 	unsigned long flags;
 	struct tty_struct *tty = info->tty;
 	int return_frame = 0;
-	
+
 	if (info->rx_frame_count == 0)
 		return 0;
 
@@ -3913,10 +3913,10 @@ static int rx_get_frame(MGSLPC_INFO *info)
 	if (debug_level >= DEBUG_LEVEL_BH)
 		printk("%s(%d):rx_get_frame(%s) status=%04X size=%d\n",
 			__FILE__,__LINE__,info->device_name,status,framesize);
-			
+
 	if (debug_level >= DEBUG_LEVEL_DATA)
-		trace_block(info, buf->data, framesize, 0);	
-		
+		trace_block(info, buf->data, framesize, 0);
+
 	if (framesize) {
 		if ((info->params.crc_type & HDLC_CRC_RETURN_EX &&
 		      framesize+1 > info->max_frame_size) ||
@@ -3953,7 +3953,7 @@ static int rx_get_frame(MGSLPC_INFO *info)
 
 static BOOLEAN register_test(MGSLPC_INFO *info)
 {
-	static unsigned char patterns[] = 
+	static unsigned char patterns[] =
 	    { 0x00, 0xff, 0xaa, 0x55, 0x69, 0x96, 0x0f };
 	static unsigned int count = ARRAY_SIZE(patterns);
 	unsigned int i;
@@ -4002,13 +4002,13 @@ static BOOLEAN irq_test(MGSLPC_INFO *info)
 	while(end_time-- && !info->irq_occurred) {
 		msleep_interruptible(10);
 	}
-	
+
 	info->testing_irq = FALSE;
 
 	spin_lock_irqsave(&info->lock,flags);
 	reset_device(info);
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
 	return info->irq_occurred ? TRUE : FALSE;
 }
 
@@ -4042,13 +4042,13 @@ static void trace_block(MGSLPC_INFO *info,const char* data, int count, int xmit)
 		printk("%s tx data:\n",info->device_name);
 	else
 		printk("%s rx data:\n",info->device_name);
-		
+
 	while(count) {
 		if (count > 16)
 			linecount = 16;
 		else
 			linecount = count;
-			
+
 		for(i=0;i<linecount;i++)
 			printk("%02X ",(unsigned char)data[i]);
 		for(;i<17;i++)
@@ -4060,7 +4060,7 @@ static void trace_block(MGSLPC_INFO *info,const char* data, int count, int xmit)
 				printk(".");
 		}
 		printk("\n");
-		
+
 		data  += linecount;
 		count -= linecount;
 	}
@@ -4073,7 +4073,7 @@ static void tx_timeout(unsigned long context)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO*)context;
 	unsigned long flags;
-	
+
 	if ( debug_level >= DEBUG_LEVEL_INFO )
 		printk( "%s(%d):tx_timeout(%s)\n",
 			__FILE__,__LINE__,info->device_name);
@@ -4086,7 +4086,7 @@ static void tx_timeout(unsigned long context)
 	info->tx_count = info->tx_put = info->tx_get = 0;
 
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
 #if SYNCLINK_GENERIC_HDLC
 	if (info->netcount)
 		hdlcdev_tx_done(info);
