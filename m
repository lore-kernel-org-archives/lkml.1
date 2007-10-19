Return-Path: <linux-kernel-owner+w=401wt.eu-S967051AbXJSH5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967051AbXJSH5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966994AbXJSH4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:56:49 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43382 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966978AbXJSH4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:56:42 -0400
Date: Fri, 19 Oct 2007 03:56:40 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 4/9] irq-remove: driver non-trivial
Message-ID: <20071019075640.GE6407@havoc.gtf.org>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 654f4a242cac0148ffe98ce288c9116e65b08e44
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 00:47:17 2007 -0400

    [IRQ ARG REMOVAL] non-trivial driver updates

 drivers/atm/ambassador.c             |    5 +++--
 drivers/bluetooth/btuart_cs.c        |    2 +-
 drivers/bluetooth/dtl1_cs.c          |    2 +-
 drivers/char/cyclades.c              |   21 +++------------------
 drivers/char/ip2/ip2main.c           |   10 +++++-----
 drivers/char/mwave/tp3780i.c         |   10 ++++++----
 drivers/char/pcmcia/synclink_cs.c    |    8 ++++----
 drivers/char/rio/rio_linux.c         |   14 ++++++++------
 drivers/char/riscom8.c               |    4 ++--
 drivers/char/specialix.c             |    7 ++++---
 drivers/char/sx.c                    |   14 +++++++-------
 drivers/char/synclink.c              |    4 ++--
 drivers/char/synclink_gt.c           |    9 ++++-----
 drivers/char/synclinkmp.c            |    7 +++----
 drivers/char/tpm/tpm_tis.c           |    6 +++---
 drivers/ide/ide-io.c                 |    8 ++++----
 drivers/input/serio/i8042.c          |    9 +++++----
 drivers/isdn/act2000/act2000_isa.c   |    3 ++-
 drivers/isdn/hisax/amd7930_fn.c      |    2 +-
 drivers/isdn/hisax/hisax.h           |    2 +-
 drivers/isdn/hisax/icc.c             |    2 +-
 drivers/isdn/hisax/isac.c            |    2 +-
 drivers/isdn/hisax/w6692.c           |    4 ++--
 drivers/isdn/sc/interrupt.c          |    3 ++-
 drivers/macintosh/via-macii.c        |    6 +++---
 drivers/macintosh/via-maciisi.c      |    9 ++++-----
 drivers/macintosh/via-pmu68k.c       |   10 +++++-----
 drivers/media/video/planb.c          |    7 ++++---
 drivers/net/eexpress.c               |    5 +++--
 drivers/net/forcedeth.c              |   26 +++++++++++++-------------
 drivers/net/hamradio/scc.c           |    6 +++---
 drivers/net/irda/au1k_ir.c           |    8 +++++---
 drivers/net/irda/smsc-ircc2.c        |    6 +++---
 drivers/net/irda/via-ircc.c          |    6 +++---
 drivers/net/lib82596.c               |    2 +-
 drivers/net/netxen/netxen_nic_main.c |    4 ++--
 drivers/net/pcmcia/fmvj18x_cs.c      |    6 +++---
 drivers/net/phy/phy.c                |    4 ++--
 drivers/net/wan/sdla.c               |    5 +++--
 drivers/pcmcia/i82365.c              |   13 +++++++------
 drivers/pcmcia/tcic.c                |   10 +++++-----
 drivers/rtc/rtc-ds1374.c             |    3 ++-
 drivers/scsi/NCR5380.c               |    6 +++---
 drivers/scsi/NCR53C9x.c              |    7 ++++---
 drivers/scsi/aha152x.c               |    4 ++--
 drivers/scsi/aha1542.c               |    5 +++--
 drivers/scsi/eata.c                  |   19 ++++++++++---------
 drivers/scsi/psi240i.c               |   10 +++++-----
 drivers/scsi/sym53c416.c             |    3 ++-
 drivers/scsi/u14-34f.c               |   12 +++++++-----
 drivers/serial/8250.c                |    4 ++--
 include/linux/uio_driver.h           |    3 ++-
 sound/drivers/mts64.c                |    2 ++
 sound/drivers/portman2x4.c           |    2 ++
 54 files changed, 190 insertions(+), 181 deletions(-)

654f4a242cac0148ffe98ce288c9116e65b08e44
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index c2b9464..8f6a8a2 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -862,9 +862,10 @@ static inline void interrupts_off (amb_dev * dev) {
 
 /********** interrupt handling **********/
 
-static irqreturn_t interrupt_handler(int irq, void *dev_id) {
+static irqreturn_t interrupt_handler(void *dev_id)
+{
   amb_dev * dev = dev_id;
-  
+
   PRINTD (DBG_IRQ|DBG_FLOW, "interrupt_handler: %p", dev_id);
   
   {
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index 08f48d5..1fdf756 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -287,7 +287,7 @@ static void btuart_receive(btuart_info_t *info)
 }
 
 
-static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
+static irqreturn_t btuart_interrupt(void *dev_inst)
 {
 	btuart_info_t *info = dev_inst;
 	unsigned int iobase;
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index dae45cd..3f9d5b9 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -290,7 +290,7 @@ static void dtl1_receive(dtl1_info_t *info)
 }
 
 
-static irqreturn_t dtl1_interrupt(int irq, void *dev_inst)
+static irqreturn_t dtl1_interrupt(void *dev_inst)
 {
 	dtl1_info_t *info = dev_inst;
 	unsigned int iobase;
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index d15234c..7e8fe35 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1312,7 +1312,7 @@ end:
    whenever the card wants its hand held--chars
    received, out buffer empty, modem change, etc.
  */
-static irqreturn_t cyy_interrupt(int irq, void *dev_id)
+static irqreturn_t cyy_interrupt(void *dev_id)
 {
 	int status;
 	struct cyclades_card *cinfo = dev_id;
@@ -1320,13 +1320,6 @@ static irqreturn_t cyy_interrupt(int irq, void *dev_id)
 	unsigned int chip, too_many, had_work;
 	int index;
 
-	if (unlikely(cinfo == NULL)) {
-#ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyy_interrupt: spurious interrupt %d\n",irq);
-#endif
-		return IRQ_NONE;	/* spurious interrupt */
-	}
-
 	card_base_addr = cinfo->base_addr;
 	index = cinfo->bus_index;
 
@@ -1728,21 +1721,13 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 }
 
 #ifdef CONFIG_CYZ_INTR
-static irqreturn_t cyz_interrupt(int irq, void *dev_id)
+static irqreturn_t cyz_interrupt(void *dev_id)
 {
 	struct cyclades_card *cinfo = dev_id;
 
-	if (unlikely(cinfo == NULL)) {
-#ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",irq);
-#endif
-		return IRQ_NONE;	/* spurious interrupt */
-	}
-
 	if (unlikely(!ISZLOADED(*cinfo))) {
 #ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
-				"(IRQ%d).\n", irq);
+		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded\n");
 #endif
 		return IRQ_NONE;
 	}
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 2124dce..1d4c528 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -190,7 +190,7 @@ static int  ip2_tiocmset(struct tty_struct *tty, struct file *file,
 
 static void set_irq(int, int);
 static void ip2_interrupt_bh(struct work_struct *work);
-static irqreturn_t ip2_interrupt(int irq, void *dev_id);
+static irqreturn_t ip2_interrupt(void *dev_id);
 static void ip2_poll(unsigned long arg);
 static inline void service_all_boards(void);
 static void do_input(struct work_struct *);
@@ -1149,7 +1149,7 @@ ip2_interrupt_bh(struct work_struct *work)
 
 
 /******************************************************************************/
-/* Function:   ip2_interrupt(int irq, void *dev_id)    */
+/* Function:   ip2_interrupt(void *dev_id)    */
 /* Parameters: irq - interrupt number                                         */
 /*             pointer to optional device ID structure                        */
 /* Returns:    Nothing                                                        */
@@ -1167,7 +1167,7 @@ ip2_interrupt_bh(struct work_struct *work)
 /*                                                                            */
 /******************************************************************************/
 static irqreturn_t
-ip2_interrupt(int irq, void *dev_id)
+ip2_interrupt(void *dev_id)
 {
 	int i;
 	i2eBordStrPtr  pB;
@@ -1182,7 +1182,7 @@ ip2_interrupt(int irq, void *dev_id)
 //		Only process those boards which match our IRQ.
 //			IRQ = 0 for polled boards, we won't poll "IRQ" boards
 
-		if ( pB && (pB->i2eUsingIrq == irq) ) {
+		if ( pB && (pB->i2eUsingIrq == get_irqfunc_irq()) ) {
 			handled = 1;
 #ifdef USE_IQI
 
@@ -1231,7 +1231,7 @@ ip2_poll(unsigned long arg)
 	// Just polled boards, IRQ = 0 will hit all non-interrupt boards.
 	// It will NOT poll boards handled by hard interrupts.
 	// The issue of queued BH interrups is handled in ip2_interrupt().
-	ip2_interrupt(0, NULL);
+	ip2_interrupt(NULL);
 
 	PollTimer.expires = POLL_TIMEOUT;
 	add_timer( &PollTimer );
diff --git a/drivers/char/mwave/tp3780i.c b/drivers/char/mwave/tp3780i.c
index f282976..ff57eb1 100644
--- a/drivers/char/mwave/tp3780i.c
+++ b/drivers/char/mwave/tp3780i.c
@@ -95,14 +95,15 @@ static void EnableSRAM(THINKPAD_BD_DATA * pBDData)
 }
 
 
-static irqreturn_t UartInterrupt(int irq, void *dev_id)
+static irqreturn_t UartInterrupt(void *dev_id)
 {
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::UartInterrupt entry irq %x dev_id %p\n", irq, dev_id);
+		"tp3780i::UartInterrupt entry irq %x dev_id %p\n",
+		get_irqfunc_irq(), dev_id);
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t DspInterrupt(int irq, void *dev_id)
+static irqreturn_t DspInterrupt(void *dev_id)
 {
 	pMWAVE_DEVICE_DATA pDrvData = &mwave_s_mdd;
 	DSP_3780I_CONFIG_SETTINGS *pSettings = &pDrvData->rBDData.rDspSettings;
@@ -110,7 +111,8 @@ static irqreturn_t DspInterrupt(int irq, void *dev_id)
 	unsigned short usIPCSource = 0, usIsolationMask, usPCNum;
 
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::DspInterrupt entry irq %x dev_id %p\n", irq, dev_id);
+		"tp3780i::DspInterrupt entry irq %x dev_id %p\n",
+		get_irqfunc_irq(), dev_id);
 
 	if (dsp3780I_GetIPCSource(usDspBaseIO, &usIPCSource) == 0) {
 		PRINTK_2(TRACE_TP3780I,
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 2b88931..922cf60 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -417,7 +417,7 @@ static void rx_reset_buffers(MGSLPC_INFO *info);
 static int  rx_alloc_buffers(MGSLPC_INFO *info);
 static void rx_free_buffers(MGSLPC_INFO *info);
 
-static irqreturn_t mgslpc_isr(int irq, void *dev_id);
+static irqreturn_t mgslpc_isr(void *dev_id);
 
 /*
  * Bottom half interrupt handlers
@@ -1226,7 +1226,7 @@ static void ri_change(MGSLPC_INFO *info)
  * irq     interrupt number that caused interrupt
  * dev_id  device ID supplied during interrupt registration
  */
-static irqreturn_t mgslpc_isr(int irq, void *dev_id)
+static irqreturn_t mgslpc_isr(void *dev_id)
 {
 	MGSLPC_INFO * info = (MGSLPC_INFO *)dev_id;
 	unsigned short isr;
@@ -1234,7 +1234,7 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 	int count=0;
 
 	if (debug_level >= DEBUG_LEVEL_ISR)	
-		printk("mgslpc_isr(%d) entry.\n", irq);
+		printk("mgslpc_isr(%d) entry.\n", get_irqfunc_irq());
 	if (!info)
 		return IRQ_NONE;
 		
@@ -1328,7 +1328,7 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 	
 	if (debug_level >= DEBUG_LEVEL_ISR)	
 		printk("%s(%d):mgslpc_isr(%d)exit.\n",
-		       __FILE__,__LINE__,irq);
+		       __FILE__, __LINE__, get_irqfunc_irq());
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 0ce9667..616a1cf 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -363,13 +363,14 @@ static void rio_reset_interrupt(struct Host *HostP)
 }
 
 
-static irqreturn_t rio_interrupt(int irq, void *ptr)
+static irqreturn_t rio_interrupt(void *ptr)
 {
 	struct Host *HostP;
 	func_enter();
 
-	HostP = ptr;			/* &p->RIOHosts[(long)ptr]; */
-	rio_dprintk(RIO_DEBUG_IFLOW, "rio: enter rio_interrupt (%d/%d)\n", irq, HostP->Ivec);
+	HostP = ptr;	/* &p->RIOHosts[(long)ptr]; */
+	rio_dprintk(RIO_DEBUG_IFLOW, "rio: enter rio_interrupt (%d/%d)\n",
+		    get_irqfunc_irq(), HostP->Ivec);
 
 	/* AAargh! The order in which to do these things is essential and
 	   not trivial.
@@ -389,7 +390,7 @@ static irqreturn_t rio_interrupt(int irq, void *ptr)
 	 */
 
 	rio_dprintk(RIO_DEBUG_IFLOW, "rio: We've have noticed the interrupt\n");
-	if (HostP->Ivec == irq) {
+	if (HostP->Ivec == get_irqfunc_irq()) {
 		/* Tell the card we've noticed the interrupt. */
 		rio_reset_interrupt(HostP);
 	}
@@ -407,7 +408,8 @@ static irqreturn_t rio_interrupt(int irq, void *ptr)
 	rio_dprintk(RIO_DEBUG_IFLOW, "riointr() doing host %p type %d\n", ptr, HostP->Type);
 
 	clear_bit(RIO_BOARD_INTR_LOCK, &HostP->locks);
-	rio_dprintk(RIO_DEBUG_IFLOW, "rio: exit rio_interrupt (%d/%d)\n", irq, HostP->Ivec);
+	rio_dprintk(RIO_DEBUG_IFLOW, "rio: exit rio_interrupt (%d/%d)\n",
+		    get_irqfunc_irq(), HostP->Ivec);
 	func_exit();
 	return IRQ_HANDLED;
 }
@@ -417,7 +419,7 @@ static void rio_pollfunc(unsigned long data)
 {
 	func_enter();
 
-	rio_interrupt(0, &p->RIOHosts[data]);
+	rio_interrupt(&p->RIOHosts[data]);
 	mod_timer(&p->RIOHosts[data].timer, jiffies + rio_poll);
 
 	func_exit();
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index b37e626..1c0741a 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -537,7 +537,7 @@ static inline void rc_check_modem(struct riscom_board const * bp)
 }
 
 /* The main interrupt processing routine */
-static irqreturn_t rc_interrupt(int irq, void * dev_id)
+static irqreturn_t rc_interrupt(void * dev_id)
 {
 	unsigned char status;
 	unsigned char ack;
@@ -545,7 +545,7 @@ static irqreturn_t rc_interrupt(int irq, void * dev_id)
 	unsigned long loop = 0;
 	int handled = 0;
 
-	bp = IRQ_to_board[irq];
+	bp = IRQ_to_board[get_irqfunc_irq()];
 
 	if (!(bp->flags & RC_BOARD_ACTIVE))
 		return IRQ_NONE;
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 4558556..bad86e0 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -195,7 +195,7 @@ static struct specialix_port sx_port[SX_NBOARD * SX_NPORT];
 
 #ifdef SPECIALIX_TIMER
 static struct timer_list missed_irq_timer;
-static irqreturn_t sx_interrupt(int irq, void * dev_id);
+static irqreturn_t sx_interrupt(void * dev_id);
 #endif
 
 
@@ -876,7 +876,7 @@ static inline void sx_check_modem(struct specialix_board * bp)
 
 
 /* The main interrupt processing routine */
-static irqreturn_t sx_interrupt(int irq, void *dev_id)
+static irqreturn_t sx_interrupt(void *dev_id)
 {
 	unsigned char status;
 	unsigned char ack;
@@ -892,7 +892,8 @@ static irqreturn_t sx_interrupt(int irq, void *dev_id)
 
 	dprintk (SX_DEBUG_FLOW, "enter %s port %d room: %ld\n", __FUNCTION__, port_No(sx_get_port(bp, "INT")), SERIAL_XMIT_SIZE - sx_get_port(bp, "ITN")->xmit_cnt - 1);
 	if (!(bp->flags & SX_BOARD_ACTIVE)) {
-		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n", irq);
+		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n",
+			 get_irqfunc_irq());
 		spin_unlock_irqrestore(&bp->lock, flags);
 		func_exit();
 		return IRQ_NONE;
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 85a2328..ff7fac3 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -1241,15 +1241,15 @@ static inline void sx_check_modem_signals(struct sx_port *port)
  * Small, elegant, clear.
  */
 
-static irqreturn_t sx_interrupt(int irq, void *ptr)
+static irqreturn_t sx_interrupt(void *ptr)
 {
 	struct sx_board *board = ptr;
 	struct sx_port *port;
 	int i;
 
 	func_enter();
-	sx_dprintk(SX_DEBUG_FLOW, "sx: enter sx_interrupt (%d/%d)\n", irq,
-			board->irq);
+	sx_dprintk(SX_DEBUG_FLOW, "sx: enter sx_interrupt (%d/%d)\n",
+		   get_irqfunc_irq(), board->irq);
 
 	/* AAargh! The order in which to do these things is essential and
 	   not trivial. 
@@ -1293,7 +1293,7 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 	}
 #endif
 
-	if (board->irq == irq) {
+	if (board->irq == get_irqfunc_irq()) {
 		/* Tell the card we've noticed the interrupt. */
 
 		sx_write_board_word(board, cc_int_pending, 0);
@@ -1339,8 +1339,8 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 
 	clear_bit(SX_BOARD_INTR_LOCK, &board->locks);
 
-	sx_dprintk(SX_DEBUG_FLOW, "sx: exit sx_interrupt (%d/%d)\n", irq,
-			board->irq);
+	sx_dprintk(SX_DEBUG_FLOW, "sx: exit sx_interrupt (%d/%d)\n",
+		   get_irqfunc_irq(), board->irq);
 	func_exit();
 	return IRQ_HANDLED;
 }
@@ -1351,7 +1351,7 @@ static void sx_pollfunc(unsigned long data)
 
 	func_enter();
 
-	sx_interrupt(0, board);
+	sx_interrupt(board);
 
 	mod_timer(&board->timer, jiffies + sx_poll);
 	func_exit();
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 905d1f5..6b1ff07 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -1691,16 +1691,16 @@ static void mgsl_isr_transmit_dma( struct mgsl_struct *info )
  * 	
  * Arguments:
  * 
- * 	irq		interrupt number that caused interrupt
  * 	dev_id		device ID supplied during interrupt registration
  * 	
  * Return Value: None
  */
-static irqreturn_t mgsl_interrupt(int irq, void *dev_id)
+static irqreturn_t mgsl_interrupt(void *dev_id)
 {
 	struct mgsl_struct * info;
 	u16 UscVector;
 	u16 DmaVector;
+	int irq = get_irqfunc_irq();
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )	
 		printk("%s(%d):mgsl_interrupt(%d)entry.\n",
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 64e835f..ecc5b0c 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -492,7 +492,7 @@ static void isr_serial(struct slgt_info *info);
 static void isr_rdma(struct slgt_info *info);
 static void isr_txeom(struct slgt_info *info, unsigned short status);
 static void isr_tdma(struct slgt_info *info);
-static irqreturn_t slgt_interrupt(int irq, void *dev_id);
+static irqreturn_t slgt_interrupt(void *dev_id);
 
 static int  alloc_dma_bufs(struct slgt_info *info);
 static void free_dma_bufs(struct slgt_info *info);
@@ -2318,16 +2318,15 @@ static void isr_gpio(struct slgt_info *info, unsigned int changed, unsigned int
 
 /* interrupt service routine
  *
- * 	irq	interrupt number
  * 	dev_id	device ID supplied during interrupt registration
  */
-static irqreturn_t slgt_interrupt(int irq, void *dev_id)
+static irqreturn_t slgt_interrupt(void *dev_id)
 {
 	struct slgt_info *info;
 	unsigned int gsr;
 	unsigned int i;
 
-	DBGISR(("slgt_interrupt irq=%d entry\n", irq));
+	DBGISR(("slgt_interrupt irq=%d entry\n", get_irqfunc_irq()));
 
 	info = dev_id;
 	if (!info)
@@ -2380,7 +2379,7 @@ static irqreturn_t slgt_interrupt(int irq, void *dev_id)
 
 	spin_unlock(&info->lock);
 
-	DBGISR(("slgt_interrupt irq=%d exit\n", irq));
+	DBGISR(("slgt_interrupt irq=%d exit\n", get_irqfunc_irq()));
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index c63013b..2173e5c 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -2583,11 +2583,10 @@ void isr_io_pin( SLMP_INFO *info, u16 status )
 /* Interrupt service routine entry point.
  *
  * Arguments:
- * 	irq		interrupt number that caused interrupt
  * 	dev_id		device ID supplied during interrupt registration
  * 	regs		interrupted processor context
  */
-static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
+static irqreturn_t synclinkmp_interrupt(void *dev_id)
 {
 	SLMP_INFO * info;
 	unsigned char status, status0, status1=0;
@@ -2599,7 +2598,7 @@ static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )
 		printk("%s(%d): synclinkmp_interrupt(%d)entry.\n",
-			__FILE__,__LINE__,irq);
+			__FILE__, __LINE__, get_irqfunc_irq());
 
 	info = (SLMP_INFO *)dev_id;
 	if (!info)
@@ -2704,7 +2703,7 @@ static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )
 		printk("%s(%d):synclinkmp_interrupt(%d)exit.\n",
-			__FILE__,__LINE__,irq);
+			__FILE__, __LINE__, get_irqfunc_irq());
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index fd771a4..4b7e738 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -379,7 +379,7 @@ static struct tpm_vendor_specific tpm_tis = {
 		    .fops = &tis_ops,},
 };
 
-static irqreturn_t tis_int_probe(int irq, void *dev_id)
+static irqreturn_t tis_int_probe(void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
 	u32 interrupt;
@@ -390,7 +390,7 @@ static irqreturn_t tis_int_probe(int irq, void *dev_id)
 	if (interrupt == 0)
 		return IRQ_NONE;
 
-	chip->vendor.irq = irq;
+	chip->vendor.irq = get_irqfunc_irq();
 
 	/* Clear interrupts handled with TPM_EOI */
 	iowrite32(interrupt,
@@ -399,7 +399,7 @@ static irqreturn_t tis_int_probe(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t tis_int_handler(int irq, void *dev_id)
+static irqreturn_t tis_int_handler(void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
 	u32 interrupt;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 5c8b008..9b6e5e2 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1533,7 +1533,7 @@ void ide_timer_expiry (unsigned long data)
  *	mysteriously.
  */
  
-static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
+static void unexpected_intr (ide_hwgroup_t *hwgroup)
 {
 	u8 stat;
 	ide_hwif_t *hwif = hwgroup->hwif;
@@ -1542,7 +1542,7 @@ static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
 	 * handle the unexpected interrupt
 	 */
 	do {
-		if (hwif->irq == irq) {
+		if (hwif->irq == get_irqfunc_irq()) {
 			stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
 			if (!OK_STAT(stat, READY_STAT, BAD_STAT)) {
 				/* Try to not flood the console with msgs */
@@ -1585,7 +1585,7 @@ static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
  *	on the hwgroup and the process begins again.
  */
  
-irqreturn_t ide_intr (int irq, void *dev_id)
+irqreturn_t ide_intr (void *dev_id)
 {
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = (ide_hwgroup_t *)dev_id;
@@ -1626,7 +1626,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 			 * Probably not a shared PCI interrupt,
 			 * so we can safely try to do something about it:
 			 */
-			unexpected_intr(irq, hwgroup);
+			unexpected_intr(hwgroup);
 #ifdef CONFIG_BLK_DEV_IDEPCI
 		} else {
 			/*
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 11dafc0..660964c 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -102,7 +102,7 @@ static unsigned char i8042_aux_irq_registered;
 static unsigned char i8042_suppress_kbd_ack;
 static struct platform_device *i8042_platform_device;
 
-static irqreturn_t i8042_interrupt(int irq, void *dev_id);
+static irqreturn_t i8042_interrupt(void *dev_id);
 
 /*
  * The i8042_wait_read() and i8042_wait_write functions wait for the i8042 to
@@ -288,7 +288,7 @@ static void i8042_stop(struct serio *serio)
  * to the upper layers.
  */
 
-static irqreturn_t i8042_interrupt(int irq, void *dev_id)
+static irqreturn_t i8042_interrupt(void *dev_id)
 {
 	struct i8042_port *port;
 	unsigned long flags;
@@ -296,6 +296,7 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 	unsigned int dfl;
 	unsigned int port_no;
 	int ret = 1;
+	int irq = get_irqfunc_irq();
 
 	spin_lock_irqsave(&i8042_lock, flags);
 	str = i8042_read_status();
@@ -512,7 +513,7 @@ static int __devinit i8042_check_mux(void)
 static struct completion i8042_aux_irq_delivered __devinitdata;
 static int i8042_irq_being_tested __devinitdata;
 
-static irqreturn_t __devinit i8042_aux_test_irq(int irq, void *dev_id)
+static irqreturn_t __devinit i8042_aux_test_irq(void *dev_id)
 {
 	unsigned long flags;
 	unsigned char str, data;
@@ -939,7 +940,7 @@ static int i8042_resume(struct platform_device *dev)
 	if (i8042_ports[I8042_KBD_PORT_NO].serio)
 		i8042_enable_kbd_port();
 
-	i8042_interrupt(0, NULL);
+	i8042_interrupt(NULL);
 
 	dev->dev.power.power_state = PMSG_ON;
 
diff --git a/drivers/isdn/act2000/act2000_isa.c b/drivers/isdn/act2000/act2000_isa.c
index 09ea50d..a3756d9 100644
--- a/drivers/isdn/act2000/act2000_isa.c
+++ b/drivers/isdn/act2000/act2000_isa.c
@@ -61,8 +61,9 @@ act2000_isa_detect(unsigned short portbase)
 }
 
 static irqreturn_t
-act2000_isa_interrupt(int irq, void *dev_id)
+act2000_isa_interrupt(void *dev_id)
 {
+	unsigned int irq = get_irqfunc_irq();
         act2000_card *card = dev_id;
         u_char istatus;
 
diff --git a/drivers/isdn/hisax/amd7930_fn.c b/drivers/isdn/hisax/amd7930_fn.c
index 3b19cae..0d9e8cb 100644
--- a/drivers/isdn/hisax/amd7930_fn.c
+++ b/drivers/isdn/hisax/amd7930_fn.c
@@ -734,7 +734,7 @@ dbusy_timer_handler(struct IsdnCardState *cs)
 			wByteAMD(cs, 0x21, 0x82);
 			wByteAMD(cs, 0x21, 0x02);
 			spin_unlock_irqrestore(&cs->lock, flags);
-			cs->irq_func(cs->irq, cs);
+			cs->irq_func(cs);
 
                         if (cs->debug & L1_DEB_ISAC)
 				debugl1(cs, "Amd7930: dbusy_timer_handler: Transmitter reset");
diff --git a/drivers/isdn/hisax/hisax.h b/drivers/isdn/hisax/hisax.h
index 34733c9..e8d429f 100644
--- a/drivers/isdn/hisax/hisax.h
+++ b/drivers/isdn/hisax/hisax.h
@@ -925,7 +925,7 @@ struct IsdnCardState {
 	int		(*cardmsg) (struct IsdnCardState *, int, void *);
 	void		(*setstack_d) (struct PStack *, struct IsdnCardState *);
 	void		(*DC_Close) (struct IsdnCardState *);
-	int		(*irq_func) (int, void *);
+	irq_handler_t	irq_func;
 	int		(*auxcmd) (struct IsdnCardState *, isdn_ctrl *);
 	struct Channel	channel[2+MAX_WAITING_CALLS];
 	struct BCState	bcs[2+MAX_WAITING_CALLS];
diff --git a/drivers/isdn/hisax/icc.c b/drivers/isdn/hisax/icc.c
index 682cac3..b2ea701 100644
--- a/drivers/isdn/hisax/icc.c
+++ b/drivers/isdn/hisax/icc.c
@@ -610,7 +610,7 @@ dbusy_timer_handler(struct IsdnCardState *cs)
 				debugl1(cs, "D-Channel Busy no skb");
 			}
 			cs->writeisac(cs, ICC_CMDR, 0x01); /* Transmitter reset */
-			cs->irq_func(cs->irq, cs);
+			cs->irq_func(cs);
 		}
 	}
 }
diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index 4e9f238..6b30b24 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -611,7 +611,7 @@ dbusy_timer_handler(struct IsdnCardState *cs)
 				debugl1(cs, "D-Channel Busy no skb");
 			}
 			cs->writeisac(cs, ISAC_CMDR, 0x01); /* Transmitter reset */
-			cs->irq_func(cs->irq, cs);
+			cs->irq_func(cs);
 		}
 	}
 }
diff --git a/drivers/isdn/hisax/w6692.c b/drivers/isdn/hisax/w6692.c
index 39129b9..470afc7 100644
--- a/drivers/isdn/hisax/w6692.c
+++ b/drivers/isdn/hisax/w6692.c
@@ -402,7 +402,7 @@ W6692B_interrupt(struct IsdnCardState *cs, u_char bchan)
 }
 
 static irqreturn_t
-W6692_interrupt(int intno, void *dev_id)
+W6692_interrupt(void *dev_id)
 {
 	struct IsdnCardState	*cs = dev_id;
 	u_char			val, exval, v1;
@@ -717,7 +717,7 @@ dbusy_timer_handler(struct IsdnCardState *cs)
 			}
 			cs->writeW6692(cs, W_D_CMDR, W_D_CMDR_XRST);	/* Transmitter reset */
 			spin_unlock_irqrestore(&cs->lock, flags);
-			cs->irq_func(cs->irq, cs);
+			cs->irq_func(cs);
 			return;
 		}
 	}
diff --git a/drivers/isdn/sc/interrupt.c b/drivers/isdn/sc/interrupt.c
index bef7963..2a43e27 100644
--- a/drivers/isdn/sc/interrupt.c
+++ b/drivers/isdn/sc/interrupt.c
@@ -35,12 +35,13 @@ static int get_card_from_irq(int irq)
 /*
  * 
  */
-irqreturn_t interrupt_handler(int interrupt, void *cardptr)
+irqreturn_t interrupt_handler(void *cardptr)
 {
 
 	RspMessage rcvmsg;
 	int channel;
 	int card;
+	unsigned int interrupt = get_irqfunc_irq();
 
 	card = get_card_from_irq(interrupt);
 
diff --git a/drivers/macintosh/via-macii.c b/drivers/macintosh/via-macii.c
index 01b8eca..1c015b3 100644
--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -80,7 +80,7 @@ static volatile unsigned char *via;
 
 static int  macii_init_via(void);
 static void macii_start(void);
-static irqreturn_t macii_interrupt(int irq, void *arg);
+static irqreturn_t macii_interrupt(void *arg);
 static void macii_queue_poll(void);
 
 static int macii_probe(void);
@@ -319,7 +319,7 @@ static inline int need_autopoll(void) {
 static void macii_poll(void)
 {
 	disable_irq(IRQ_MAC_ADB);
-	macii_interrupt(0, NULL);
+	macii_interrupt(NULL);
 	enable_irq(IRQ_MAC_ADB);
 }
 
@@ -385,7 +385,7 @@ static void macii_start(void)
  * with the VIA shift register interrupt. /IRQ never actually interrupts the
  * processor, it's just an ordinary input.)
  */
-static irqreturn_t macii_interrupt(int irq, void *arg)
+static irqreturn_t macii_interrupt(void *arg)
 {
 	int x;
 	static int entered;
diff --git a/drivers/macintosh/via-maciisi.c b/drivers/macintosh/via-maciisi.c
index 2dc7880..a970f62 100644
--- a/drivers/macintosh/via-maciisi.c
+++ b/drivers/macintosh/via-maciisi.c
@@ -83,7 +83,7 @@ static int maciisi_init(void);
 static int maciisi_send_request(struct adb_request* req, int sync);
 static void maciisi_sync(struct adb_request *req);
 static int maciisi_write(struct adb_request* req);
-static irqreturn_t maciisi_interrupt(int irq, void* arg);
+static irqreturn_t maciisi_interrupt(void* arg);
 static void maciisi_input(unsigned char *buf, int nb);
 static int maciisi_init_via(void);
 static void maciisi_poll(void);
@@ -419,9 +419,8 @@ maciisi_poll(void)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	if (via[IFR] & SR_INT) {
-		maciisi_interrupt(0, NULL);
-	}
+	if (via[IFR] & SR_INT)
+		maciisi_interrupt(NULL);
 	else /* avoid calling this function too quickly in a loop */
 		udelay(ADB_DELAY);
 
@@ -432,7 +431,7 @@ maciisi_poll(void)
    register is either full or empty. In practice, I have no idea what
    it means :( */
 static irqreturn_t
-maciisi_interrupt(int irq, void* arg)
+maciisi_interrupt(void* arg)
 {
 	int status;
 	struct adb_request *req;
diff --git a/drivers/macintosh/via-pmu68k.c b/drivers/macintosh/via-pmu68k.c
index e2f84da..67b609d 100644
--- a/drivers/macintosh/via-pmu68k.c
+++ b/drivers/macintosh/via-pmu68k.c
@@ -106,7 +106,7 @@ BLOCKING_NOTIFIER_HEAD(sleep_notifier_list);
 static int pmu_probe(void);
 static int pmu_init(void);
 static void pmu_start(void);
-static irqreturn_t pmu_interrupt(int irq, void *arg);
+static irqreturn_t pmu_interrupt(void *arg);
 static int pmu_send_request(struct adb_request *req, int sync);
 static int pmu_autopoll(int devs);
 void pmu_poll(void);
@@ -219,7 +219,7 @@ pmu_init(void)
 		}
 		if (pmu_state == idle) {
 			adb_int_pending = 1;
-			pmu_interrupt(0, NULL);
+			pmu_interrupt(NULL);
 		}
 		pmu_poll();
 		udelay(10);
@@ -560,17 +560,17 @@ pmu_poll(void)
 	local_irq_save(flags);
 	if (via1[IFR] & SR_INT) {
 		via1[IFR] = SR_INT;
-		pmu_interrupt(IRQ_MAC_ADB_SR, NULL);
+		pmu_interrupt(NULL);
 	}
 	if (via1[IFR] & CB1_INT) {
 		via1[IFR] = CB1_INT;
-		pmu_interrupt(IRQ_MAC_ADB_CL, NULL);
+		pmu_interrupt(NULL);
 	}
 	local_irq_restore(flags);
 }
 
 static irqreturn_t
-pmu_interrupt(int irq, void *dev_id)
+pmu_interrupt(void *dev_id)
 {
 	struct adb_request *req;
 	int timeout, bite = 0;	/* to prevent compiler warning */
diff --git a/drivers/media/video/planb.c b/drivers/media/video/planb.c
index 0ef73d9..83796bd 100644
--- a/drivers/media/video/planb.c
+++ b/drivers/media/video/planb.c
@@ -91,7 +91,7 @@ static void planb_close(struct video_device *);
 static int planb_ioctl(struct video_device *, unsigned int, void *);
 static int planb_init_done(struct video_device *);
 static int planb_mmap(struct video_device *, const char *, unsigned long);
-static void planb_irq(int, void *);
+static irqreturn_t planb_irq(void *);
 static void release_planb(void);
 int init_planbs(struct video_init *);
 
@@ -1315,7 +1315,7 @@ cmd_tab_data_end:
 	return c1;
 }
 
-static void planb_irq(int irq, void *dev_id)
+static irqreturn_t planb_irq(void *dev_id)
 {
 	unsigned int stat, astat;
 	struct planb *pb = (struct planb *)dev_id;
@@ -1358,13 +1358,14 @@ static void planb_irq(int irq, void *dev_id)
 		pb->frame_stat[fr] = GBUFFER_DONE;
 		pb->grabbing--;
 		wake_up_interruptible(&pb->capq);
-		return;
+		return IRQ_HANDLED;
 	}
 	/* incorrect interrupts? */
 	pb->intr_mask = PLANB_CLR_IRQ;
 	out_le32(&pb->planb_base->intr_stat, PLANB_CLR_IRQ);
 	printk(KERN_ERR "PlanB: IRQ lockup, cleared intrrupts"
 							" unconditionally\n");
+	return IRQ_HANDLED;
 }
 
 /*******************************
diff --git a/drivers/net/eexpress.c b/drivers/net/eexpress.c
index 9c85e50..627adbf 100644
--- a/drivers/net/eexpress.c
+++ b/drivers/net/eexpress.c
@@ -248,7 +248,7 @@ static int eexp_close(struct net_device *dev);
 static void eexp_timeout(struct net_device *dev);
 static int eexp_xmit(struct sk_buff *buf, struct net_device *dev);
 
-static irqreturn_t eexp_irq(int irq, void *dev_addr);
+static irqreturn_t eexp_irq(void *dev_addr);
 static void eexp_set_multicast(struct net_device *dev);
 
 /*
@@ -768,12 +768,13 @@ static void eexp_cmd_clear(struct net_device *dev)
 	}
 }
 
-static irqreturn_t eexp_irq(int irq, void *dev_info)
+static irqreturn_t eexp_irq(void *dev_info)
 {
 	struct net_device *dev = dev_info;
 	struct net_local *lp;
 	unsigned short ioaddr,status,ack_cmd;
 	unsigned short old_read_ptr, old_write_ptr;
+	unsigned int irq = get_irqfunc_irq();
 
 	lp = netdev_priv(dev);
 	ioaddr = dev->base_addr;
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index cfbb7aa..2764f8d 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -2977,7 +2977,7 @@ static void nv_link_irq(struct net_device *dev)
 	dprintk(KERN_DEBUG "%s: link change notification done.\n", dev->name);
 }
 
-static irqreturn_t nv_nic_irq(int foo, void *data)
+static irqreturn_t nv_nic_irq(void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
@@ -3092,7 +3092,7 @@ static irqreturn_t nv_nic_irq(int foo, void *data)
  * (reduce CPU and increase throughput). They use descripter version 3,
  * compiler directives, and reduce memory accesses.
  */
-static irqreturn_t nv_nic_irq_optimized(int foo, void *data)
+static irqreturn_t nv_nic_irq_optimized(void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
@@ -3203,7 +3203,7 @@ static irqreturn_t nv_nic_irq_optimized(int foo, void *data)
 	return IRQ_RETVAL(i);
 }
 
-static irqreturn_t nv_nic_irq_tx(int foo, void *data)
+static irqreturn_t nv_nic_irq_tx(void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
@@ -3293,7 +3293,7 @@ static int nv_napi_poll(struct napi_struct *napi, int budget)
 #endif
 
 #ifdef CONFIG_FORCEDETH_NAPI
-static irqreturn_t nv_nic_irq_rx(int foo, void *data)
+static irqreturn_t nv_nic_irq_rx(void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
@@ -3312,7 +3312,7 @@ static irqreturn_t nv_nic_irq_rx(int foo, void *data)
 	return IRQ_HANDLED;
 }
 #else
-static irqreturn_t nv_nic_irq_rx(int foo, void *data)
+static irqreturn_t nv_nic_irq_rx(void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
@@ -3360,7 +3360,7 @@ static irqreturn_t nv_nic_irq_rx(int foo, void *data)
 }
 #endif
 
-static irqreturn_t nv_nic_irq_other(int foo, void *data)
+static irqreturn_t nv_nic_irq_other(void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
@@ -3433,7 +3433,7 @@ static irqreturn_t nv_nic_irq_other(int foo, void *data)
 	return IRQ_RETVAL(i);
 }
 
-static irqreturn_t nv_nic_irq_test(int foo, void *data)
+static irqreturn_t nv_nic_irq_test(void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
@@ -3495,7 +3495,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 	u8 __iomem *base = get_hwbase(dev);
 	int ret = 1;
 	int i;
-	irqreturn_t (*handler)(int foo, void *data);
+	irq_handler_t handler;
 
 	if (intr_test) {
 		handler = nv_nic_irq_test;
@@ -3685,24 +3685,24 @@ static void nv_do_nic_poll(unsigned long data)
 
 	if (!using_multi_irqs(dev)) {
 		if (np->desc_ver == DESC_VER_3)
-			nv_nic_irq_optimized(0, dev);
+			nv_nic_irq_optimized(dev);
 		else
-			nv_nic_irq(0, dev);
+			nv_nic_irq(dev);
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
 			enable_irq_lockdep(dev->irq);
 	} else {
 		if (np->nic_poll_irq & NVREG_IRQ_RX_ALL) {
-			nv_nic_irq_rx(0, dev);
+			nv_nic_irq_rx(dev);
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 		}
 		if (np->nic_poll_irq & NVREG_IRQ_TX_ALL) {
-			nv_nic_irq_tx(0, dev);
+			nv_nic_irq_tx(dev);
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_TX].vector);
 		}
 		if (np->nic_poll_irq & NVREG_IRQ_OTHER) {
-			nv_nic_irq_other(0, dev);
+			nv_nic_irq_other(dev);
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_OTHER].vector);
 		}
 	}
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 353d13e..18b56de 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -201,7 +201,7 @@ static void z8530_init(void);
 
 static void init_channel(struct scc_channel *scc);
 static void scc_key_trx (struct scc_channel *scc, char tx);
-static irqreturn_t scc_isr(int irq, void *dev_id);
+static irqreturn_t scc_isr(void *dev_id);
 static void scc_init_timer(struct scc_channel *scc);
 
 static int scc_net_alloc(const char *name, struct scc_channel *scc);
@@ -627,7 +627,7 @@ static void scc_isr_dispatch(struct scc_channel *scc, int vector)
 
 #define SCC_IRQTIMEOUT 30000
 
-static irqreturn_t scc_isr(int irq, void *dev_id)
+static irqreturn_t scc_isr(void *dev_id)
 {
 	unsigned char vector;	
 	struct scc_channel *scc;
@@ -665,7 +665,7 @@ static irqreturn_t scc_isr(int irq, void *dev_id)
 	ctrl = SCC_ctrl;
 	while (ctrl->chan_A)
 	{
-		if (ctrl->irq != irq)
+		if (ctrl->irq != get_irqfunc_irq())
 		{
 			ctrl++;
 			continue;
diff --git a/drivers/net/irda/au1k_ir.c b/drivers/net/irda/au1k_ir.c
index 4dbdfaa..f0e50bd 100644
--- a/drivers/net/irda/au1k_ir.c
+++ b/drivers/net/irda/au1k_ir.c
@@ -51,7 +51,7 @@ static int au1k_irda_start(struct net_device *);
 static int au1k_irda_stop(struct net_device *dev);
 static int au1k_irda_hard_xmit(struct sk_buff *, struct net_device *);
 static int au1k_irda_rx(struct net_device *);
-static void au1k_irda_interrupt(int, void *);
+static irqreturn_t au1k_irda_interrupt(int, void *);
 static void au1k_tx_timeout(struct net_device *);
 static struct net_device_stats *au1k_irda_stats(struct net_device *);
 static int au1k_irda_ioctl(struct net_device *, struct ifreq *, int);
@@ -627,19 +627,21 @@ static int au1k_irda_rx(struct net_device *dev)
 }
 
 
-void au1k_irda_interrupt(int irq, void *dev_id)
+irqreturn_t au1k_irda_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 
 	if (dev == NULL) {
 		printk(KERN_ERR "%s: isr: null dev ptr\n", dev->name);
-		return;
+		return IRQ_NONE;
 	}
 
 	writel(0, IR_INT_CLEAR); /* ack irda interrupts */
 
 	au1k_irda_rx(dev);
 	au1k_tx_ack(dev);
+
+	return IRQ_HANDLED;
 }
 
 
diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index 7e7b582..f2a918e 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -202,7 +202,7 @@ static void smsc_ircc_dma_xmit(struct smsc_ircc_cb *self, int bofs);
 static void smsc_ircc_dma_xmit_complete(struct smsc_ircc_cb *self);
 static void smsc_ircc_change_speed(struct smsc_ircc_cb *self, u32 speed);
 static void smsc_ircc_set_sir_speed(struct smsc_ircc_cb *self, u32 speed);
-static irqreturn_t smsc_ircc_interrupt(int irq, void *dev_id);
+static irqreturn_t smsc_ircc_interrupt(void *dev_id);
 static irqreturn_t smsc_ircc_interrupt_sir(struct net_device *dev);
 static void smsc_ircc_sir_start(struct smsc_ircc_cb *self);
 #if SMSC_IRCC2_C_SIR_STOP
@@ -1505,7 +1505,7 @@ static void smsc_ircc_sir_receive(struct smsc_ircc_cb *self)
  *    An interrupt from the chip has arrived. Time to do some work
  *
  */
-static irqreturn_t smsc_ircc_interrupt(int irq, void *dev_id)
+static irqreturn_t smsc_ircc_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct smsc_ircc_cb *self;
@@ -1514,7 +1514,7 @@ static irqreturn_t smsc_ircc_interrupt(int irq, void *dev_id)
 
 	if (dev == NULL) {
 		printk(KERN_WARNING "%s: irq %d for unknown device.\n",
-		       driver_name, irq);
+		       driver_name, get_irqfunc_irq());
 		goto irq_ret;
 	}
 
diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
index 126ec7c..d850c7d 100644
--- a/drivers/net/irda/via-ircc.c
+++ b/drivers/net/irda/via-ircc.c
@@ -93,7 +93,7 @@ static int via_ircc_hard_xmit_fir(struct sk_buff *skb,
 				  struct net_device *dev);
 static void via_hw_init(struct via_ircc_cb *self);
 static void via_ircc_change_speed(struct via_ircc_cb *self, __u32 baud);
-static irqreturn_t via_ircc_interrupt(int irq, void *dev_id);
+static irqreturn_t via_ircc_interrupt(void *dev_id);
 static int via_ircc_is_receiving(struct via_ircc_cb *self);
 static int via_ircc_read_dongle_id(int iobase);
 
@@ -1346,7 +1346,7 @@ static int RxTimerHandler(struct via_ircc_cb *self, int iobase)
  *    An interrupt from the chip has arrived. Time to do some work
  *
  */
-static irqreturn_t via_ircc_interrupt(int irq, void *dev_id)
+static irqreturn_t via_ircc_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct via_ircc_cb *self;
@@ -1355,7 +1355,7 @@ static irqreturn_t via_ircc_interrupt(int irq, void *dev_id)
 
 	if (!dev) {
 		IRDA_WARNING("%s: irq %d for unknown device.\n", driver_name,
-			     irq);
+			     get_irqfunc_irq());
 		return IRQ_NONE;
 	}
 	self = (struct via_ircc_cb *) dev->priv;
diff --git a/drivers/net/lib82596.c b/drivers/net/lib82596.c
index 9a855e5..ea4c6e3 100644
--- a/drivers/net/lib82596.c
+++ b/drivers/net/lib82596.c
@@ -349,7 +349,7 @@ static const char init_setup[] =
 
 static int i596_open(struct net_device *dev);
 static int i596_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t i596_interrupt(int irq, void *dev_id);
+static irqreturn_t i596_interrupt(void *dev_id);
 static int i596_close(struct net_device *dev);
 static void i596_add_cmd(struct net_device *dev, struct i596_cmd *cmd);
 static void i596_tx_timeout (struct net_device *dev);
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index a80f0cd..c506398 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -68,7 +68,7 @@ static int netxen_nic_poll(struct napi_struct *napi, int budget);
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void netxen_nic_poll_controller(struct net_device *netdev);
 #endif
-static irqreturn_t netxen_intr(int irq, void *data);
+static irqreturn_t netxen_intr(void *data);
 
 int physical_port[] = {0, 1, 2, 3};
 
@@ -1342,7 +1342,7 @@ static void netxen_nic_poll_controller(struct net_device *netdev)
 {
 	struct netxen_adapter *adapter = netdev_priv(netdev);
 	disable_irq(adapter->irq);
-	netxen_intr(adapter->irq, adapter);
+	netxen_intr(adapter);
 	enable_irq(adapter->irq);
 }
 #endif
diff --git a/drivers/net/pcmcia/fmvj18x_cs.c b/drivers/net/pcmcia/fmvj18x_cs.c
index 6284467..8076d5b 100644
--- a/drivers/net/pcmcia/fmvj18x_cs.c
+++ b/drivers/net/pcmcia/fmvj18x_cs.c
@@ -97,7 +97,7 @@ static int fjn_config(struct net_device *dev, struct ifmap *map);
 static int fjn_open(struct net_device *dev);
 static int fjn_close(struct net_device *dev);
 static int fjn_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t fjn_interrupt(int irq, void *dev_id);
+static irqreturn_t fjn_interrupt(void *dev_id);
 static void fjn_rx(struct net_device *dev);
 static void fjn_reset(struct net_device *dev);
 static struct net_device_stats *fjn_get_stats(struct net_device *dev);
@@ -731,7 +731,7 @@ module_exit(exit_fmvj18x_cs);
 
 /*====================================================================*/
 
-static irqreturn_t fjn_interrupt(int irq, void *dev_id)
+static irqreturn_t fjn_interrupt(void *dev_id)
 {
     struct net_device *dev = dev_id;
     local_info_t *lp = netdev_priv(dev);
@@ -740,7 +740,7 @@ static irqreturn_t fjn_interrupt(int irq, void *dev_id)
 
     if (lp == NULL) {
         printk(KERN_NOTICE "fjn_interrupt(): irq %d for "
-	       "unknown device.\n", irq);
+	       "unknown device.\n", get_irqfunc_irq());
         return IRQ_NONE;
     }
     ioaddr = dev->base_addr;
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 9bc1177..f985fcd 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -551,7 +551,7 @@ void phy_error(struct phy_device *phydev)
  * Description: When a PHY interrupt occurs, the handler disables
  * interrupts, and schedules a work task to clear the interrupt.
  */
-static irqreturn_t phy_interrupt(int irq, void *phy_dat)
+static irqreturn_t phy_interrupt(void *phy_dat)
 {
 	struct phy_device *phydev = phy_dat;
 
@@ -562,7 +562,7 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	 * context, so we need to disable the irq here.  A work
 	 * queue will write the PHY to disable and clear the
 	 * interrupt, and then reenable the irq line. */
-	disable_irq_nosync(irq);
+	disable_irq_nosync(phydev->irq);
 	atomic_inc(&phydev->irq_disable);
 
 	schedule_work(&phydev->phy_queue);
diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index 05df0a3..f15ef66 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -867,7 +867,7 @@ static void sdla_receive(struct net_device *dev)
 	spin_unlock_irqrestore(&sdla_lock, flags);
 }
 
-static irqreturn_t sdla_isr(int irq, void *dev_id)
+static irqreturn_t sdla_isr(void *dev_id)
 {
 	struct net_device     *dev;
 	struct frad_local *flp;
@@ -879,7 +879,8 @@ static irqreturn_t sdla_isr(int irq, void *dev_id)
 
 	if (!flp->initialized)
 	{
-		printk(KERN_WARNING "%s: irq %d for uninitialized device.\n", dev->name, irq);
+		printk(KERN_WARNING "%s: irq %d for uninitialized device.\n",
+			dev->name, get_irqfunc_irq());
 		return IRQ_NONE;
 	}
 
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 839bb1c..d4a529d 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -79,7 +79,7 @@ module_param(pc_debug, int, 0644);
 #define debug(lvl, fmt, arg...) do { } while (0)
 #endif
 
-static irqreturn_t i365_count_irq(int, void *);
+static irqreturn_t i365_count_irq(void *);
 static inline int _check_irq(int irq, int flags)
 {
     if (request_irq(irq, i365_count_irq, flags, "x", i365_count_irq) != 0)
@@ -497,11 +497,11 @@ static u_int __init set_bridge_opts(u_short s, u_short ns)
 static volatile u_int irq_hits;
 static u_short irq_sock;
 
-static irqreturn_t i365_count_irq(int irq, void *dev)
+static irqreturn_t i365_count_irq(void *dev)
 {
     i365_get(irq_sock, I365_CSC);
     irq_hits++;
-    debug(2, "-> hit on irq %d\n", irq);
+    debug(2, "-> hit on irq %d\n", get_irqfunc_irq());
     return IRQ_HANDLED;
 }
 
@@ -847,14 +847,15 @@ static void __init isa_probe(void)
 
 /*====================================================================*/
 
-static irqreturn_t pcic_interrupt(int irq, void *dev)
+static irqreturn_t pcic_interrupt(void *dev)
 {
     int i, j, csc;
     u_int events, active;
     u_long flags = 0;
     int handled = 0;
+    unsigned int irq = get_irqfunc_irq();
 
-    debug(4, "pcic_interrupt(%d)\n", irq);
+    debug(4, "pcic_interrupt(%u)\n", irq);
 
     for (j = 0; j < 20; j++) {
 	active = 0;
@@ -896,7 +897,7 @@ static irqreturn_t pcic_interrupt(int irq, void *dev)
 
 static void pcic_interrupt_wrapper(u_long data)
 {
-    pcic_interrupt(0, NULL);
+    pcic_interrupt(NULL);
     poll_timer.expires = jiffies + poll_interval;
     add_timer(&poll_timer);
 }
diff --git a/drivers/pcmcia/tcic.c b/drivers/pcmcia/tcic.c
index 749ac37..8b0b73e 100644
--- a/drivers/pcmcia/tcic.c
+++ b/drivers/pcmcia/tcic.c
@@ -116,7 +116,7 @@ module_param(cycle_time, int, 0444);
 
 /*====================================================================*/
 
-static irqreturn_t tcic_interrupt(int irq, void *dev);
+static irqreturn_t tcic_interrupt(void *dev);
 static void tcic_timer(u_long data);
 static struct pccard_operations tcic_operations;
 
@@ -218,7 +218,7 @@ static int to_cycles(int ns)
 
 static volatile u_int irq_hits;
 
-static irqreturn_t __init tcic_irq_count(int irq, void *dev)
+static irqreturn_t __init tcic_irq_count(void *dev)
 {
     irq_hits++;
     return IRQ_HANDLED;
@@ -505,7 +505,7 @@ static int __init init_tcic(void)
     }
     
     /* jump start interrupt handler, if needed */
-    tcic_interrupt(0, NULL);
+    tcic_interrupt(NULL);
 
     platform_device_register(&tcic_device);
 
@@ -547,7 +547,7 @@ static void __exit exit_tcic(void)
 
 /*====================================================================*/
 
-static irqreturn_t tcic_interrupt(int irq, void *dev)
+static irqreturn_t tcic_interrupt(void *dev)
 {
     int i, quick = 0;
     u_char latch, sstat;
@@ -606,7 +606,7 @@ static void tcic_timer(u_long data)
 {
     debug(2, "tcic_timer()\n");
     tcic_timer_pending = 0;
-    tcic_interrupt(0, NULL);
+    tcic_interrupt(NULL);
 } /* tcic_timer */
 
 /*====================================================================*/
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 45bda18..c24c733 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -257,10 +257,11 @@ out:
 	return ret;
 }
 
-static irqreturn_t ds1374_irq(int irq, void *dev_id)
+static irqreturn_t ds1374_irq(void *dev_id)
 {
 	struct i2c_client *client = dev_id;
 	struct ds1374 *ds1374 = i2c_get_clientdata(client);
+	int irq = get_irqfunc_irq();
 
 	disable_irq_nosync(irq);
 	schedule_work(&ds1374->work);
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 988f0bc..c310438 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -558,9 +558,9 @@ static int probe_irq __initdata = 0;
  *	used by the IRQ probe code.
  */
  
-static irqreturn_t __init probe_intr(int irq, void *dev_id)
+static irqreturn_t __init probe_intr(void *dev_id)
 {
-	probe_irq = irq;
+	probe_irq = get_irqfunc_irq();
 	return IRQ_HANDLED;
 }
 
@@ -1158,7 +1158,7 @@ static void NCR5380_main(struct work_struct *work)
  *	Locks: takes the needed instance locks
  */
 
-static irqreturn_t NCR5380_intr(int irq, void *dev_id) 
+static irqreturn_t NCR5380_intr(void *dev_id) 
 {
 	NCR5380_local_declare();
 	struct Scsi_Host *instance = (struct Scsi_Host *)dev_id;
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 96e8e29..c46e4d7 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -98,7 +98,7 @@ int nesps = 0, esps_in_use = 0, esps_running = 0;
 EXPORT_SYMBOL(nesps);
 EXPORT_SYMBOL(esps_running);
 
-irqreturn_t esp_intr(int irq, void *dev_id);
+irqreturn_t esp_intr(void *dev_id);
 
 /* Debugging routines */
 static struct esp_cmdstrings {
@@ -3543,12 +3543,13 @@ state_machine:
 EXPORT_SYMBOL(esp_handle);
 
 #ifndef CONFIG_SMP
-irqreturn_t esp_intr(int irq, void *dev_id)
+irqreturn_t esp_intr(void *dev_id)
 {
 	struct NCR_ESP *esp;
 	unsigned long flags;
 	int again;
 	struct Scsi_Host *dev = dev_id;
+	unsigned int irq = get_irqfunc_irq();
 
 	/* Handle all ESP interrupts showing at this IRQ level. */
 	spin_lock_irqsave(dev->host_lock, flags);
@@ -3580,7 +3581,7 @@ repeat:
 }
 #else
 /* For SMP we only service one ESP on the list list at our IRQ level! */
-irqreturn_t esp_intr(int irq, void *dev_id)
+irqreturn_t esp_intr(void *dev_id)
 {
 	struct NCR_ESP *esp;
 	unsigned long flags;
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 973778a..6609bfe 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -675,7 +675,7 @@ static struct {
 };
 
 /* setup & interrupt */
-static irqreturn_t intr(int irq, void *dev_id);
+static irqreturn_t intr(void *dev_id);
 static void reset_ports(struct Scsi_Host *shpnt);
 static void aha152x_error(struct Scsi_Host *shpnt, char *msg);
 static void done(struct Scsi_Host *shpnt, int error);
@@ -759,7 +759,7 @@ static inline Scsi_Cmnd *remove_SC(Scsi_Cmnd **SC, Scsi_Cmnd *SCp)
 	return ptr;
 }
 
-static irqreturn_t swintr(int irqno, void *dev_id)
+static irqreturn_t swintr(void *dev_id)
 {
 	struct Scsi_Host *shpnt = dev_id;
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 961a188..770d88a 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -174,7 +174,7 @@ static DEFINE_SPINLOCK(aha1542_lock);
 static void setup_mailboxes(int base_io, struct Scsi_Host *shpnt);
 static int aha1542_restart(struct Scsi_Host *shost);
 static void aha1542_intr_handle(struct Scsi_Host *shost, void *dev_id);
-static irqreturn_t do_aha1542_intr_handle(int irq, void *dev_id);
+static irqreturn_t do_aha1542_intr_handle(void *dev_id);
 
 #define aha1542_intr_reset(base)  outb(IRST, CONTROL(base))
 
@@ -414,10 +414,11 @@ fail:
 }
 
 /* A quick wrapper for do_aha1542_intr_handle to grab the spin lock */
-static irqreturn_t do_aha1542_intr_handle(int irq, void *dev_id)
+static irqreturn_t do_aha1542_intr_handle(void *dev_id)
 {
 	unsigned long flags;
 	struct Scsi_Host *shost;
+	unsigned int irq = get_irqfunc_irq();
 
 	shost = aha_host[irq - 9];
 	if (!shost)
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 7ead521..650ef10 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -876,7 +876,7 @@ static unsigned long io_port[] = {
 /* But transfer orientation from the 16 bit data register is Little Endian */
 #define REG2H(x)   le16_to_cpu(x)
 
-static irqreturn_t do_interrupt_handler(int, void *);
+static irqreturn_t do_interrupt_handler(void *);
 static void flush_dev(struct scsi_device *, unsigned long, struct hostdata *,
 		      unsigned int);
 static int do_trace = 0;
@@ -2287,17 +2287,18 @@ static void flush_dev(struct scsi_device *dev, unsigned long cursec,
 	}
 }
 
-static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
+static irqreturn_t ihdlr(struct Scsi_Host *shost)
 {
 	struct scsi_cmnd *SCpnt;
 	unsigned int i, k, c, status, tstatus, reg;
 	struct mssp *spp;
 	struct mscp *cpp;
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	int irq = get_irqfunc_irq();
 
-	if (shost->irq != irq)
-		panic("%s: ihdlr, irq %d, shost->irq %d.\n", ha->board_name, irq,
-		      shost->irq);
+	if (shost->irq != get_irqfunc_irq())
+		panic("%s: ihdlr, irq %d, shost->irq %d.\n", ha->board_name,
+			irq, shost->irq);
 
 	/* Check if this board need to be serviced */
 	if (!(inb(shost->io_port + REG_AUX_STATUS) & IRQ_ASSERTED))
@@ -2306,8 +2307,8 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 	ha->iocount++;
 
 	if (do_trace)
-		printk("%s: ihdlr, enter, irq %d, count %d.\n", ha->board_name, irq,
-		       ha->iocount);
+		printk("%s: ihdlr, enter, irq %d, count %d.\n", ha->board_name,
+			irq, ha->iocount);
 
 	/* Check if this board is still busy */
 	if (wait_on_busy(shost->io_port, 20 * MAXLOOP)) {
@@ -2536,7 +2537,7 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 	return IRQ_NONE;
 }
 
-static irqreturn_t do_interrupt_handler(int irq, void *shap)
+static irqreturn_t do_interrupt_handler(void *shap)
 {
 	struct Scsi_Host *shost;
 	unsigned int j;
@@ -2549,7 +2550,7 @@ static irqreturn_t do_interrupt_handler(int irq, void *shap)
 	shost = sh[j];
 
 	spin_lock_irqsave(shost->host_lock, spin_flags);
-	ret = ihdlr(irq, shost);
+	ret = ihdlr(shost);
 	spin_unlock_irqrestore(shost->host_lock, spin_flags);
 	return ret;
 }
diff --git a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
index 899e89d..a22796f 100644
--- a/drivers/scsi/psi240i.c
+++ b/drivers/scsi/psi240i.c
@@ -245,13 +245,12 @@ static ULONG DecodeError (struct Scsi_Host *pshost, UCHAR status)
  *
  *	Description:	Interrupt handler.
  *
- *	Parameters:		irq		- Hardware IRQ number.
- *					dev_id	-
+ *	Parameters:		dev_id	- instance structure
  *
  *	Returns:		TRUE if drive is not ready in time.
  *
  ****************************************************************/
-static void Irq_Handler (int irq, void *dev_id)
+static void Irq_Handler (void *dev_id)
 	{
 	struct Scsi_Host *shost;	// Pointer to host data block
 	PADAPTER240I padapter;		// Pointer to adapter control structure
@@ -259,6 +258,7 @@ static void Irq_Handler (int irq, void *dev_id)
 	struct scsi_cmnd *SCpnt;
 	UCHAR status;
 	int z;
+	unsigned int		irq = get_irqfunc_irq();
 
 	DEB(printk ("\npsi240i received interrupt\n"));
 
@@ -367,13 +367,13 @@ irqerror:;
 	SCpnt->scsi_done (SCpnt);
 	}
 
-static irqreturn_t do_Irq_Handler (int irq, void *dev_id)
+static irqreturn_t do_Irq_Handler (void *dev_id)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	spin_lock_irqsave(dev->host_lock, flags);
-	Irq_Handler(irq, dev_id);
+	Irq_Handler(dev_id);
 	spin_unlock_irqrestore(dev->host_lock, flags);
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 8befab7..079c525 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -325,7 +325,7 @@ static __inline__ unsigned int sym53c416_write(int base, unsigned char *buffer,
 	return orig_len - len;
 }
 
-static irqreturn_t sym53c416_intr_handle(int irq, void *dev_id)
+static irqreturn_t sym53c416_intr_handle(void *dev_id)
 {
 	struct Scsi_Host *dev = dev_id;
 	int base = 0;
@@ -334,6 +334,7 @@ static irqreturn_t sym53c416_intr_handle(int irq, void *dev_id)
 	unsigned char status_reg, pio_int_reg, int_reg;
 	struct scatterlist *sg;
 	unsigned int tot_trans = 0;
+	unsigned int irq = get_irqfunc_irq();
 
 	/* We search the base address of the host adapter which caused the interrupt */
 	/* FIXME: should pass dev_id sensibly as hosts[i] */
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 7edd6ce..ad20bba 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -635,7 +635,7 @@ static unsigned long io_port[] = {
 #define H2DEV(x) cpu_to_le32(x)
 #define DEV2H(x) le32_to_cpu(x)
 
-static irqreturn_t do_interrupt_handler(int, void *);
+static irqreturn_t do_interrupt_handler(void *);
 static void flush_dev(struct scsi_device *, unsigned long, unsigned int, unsigned int);
 static int do_trace = FALSE;
 static int setup_done = FALSE;
@@ -1716,10 +1716,11 @@ static void flush_dev(struct scsi_device *dev, unsigned long cursec, unsigned in
 
 }
 
-static irqreturn_t ihdlr(int irq, unsigned int j) {
+static irqreturn_t ihdlr(unsigned int j) {
    struct scsi_cmnd *SCpnt;
    unsigned int i, k, c, status, tstatus, reg, ret;
    struct mscp *spp, *cpp;
+   unsigned int irq = get_irqfunc_irq();
 
    if (sh[j]->irq != irq)
        panic("%s: ihdlr, irq %d, sh[j]->irq %d.\n", BN(j), irq, sh[j]->irq);
@@ -1927,16 +1928,17 @@ none:
    return IRQ_NONE;
 }
 
-static irqreturn_t do_interrupt_handler(int irq, void *shap) {
+static irqreturn_t do_interrupt_handler(void *shap) {
    unsigned int j;
    unsigned long spin_flags;
    irqreturn_t ret;
 
    /* Check if the interrupt must be processed by this handler */
-   if ((j = (unsigned int)((char *)shap - sha)) >= num_boards) return IRQ_NONE;
+   if ((j = (unsigned int)((char *)shap - sha)) >= num_boards)
+   	return IRQ_NONE;
 
    spin_lock_irqsave(sh[j]->host_lock, spin_flags);
-   ret = ihdlr(irq, j);
+   ret = ihdlr(j);
    spin_unlock_irqrestore(sh[j]->host_lock, spin_flags);
    return ret;
 }
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index f94109c..88ed53d 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1451,7 +1451,7 @@ serial8250_handle_port(struct uart_8250_port *up)
  * This means we need to loop through all ports. checking that they
  * don't have an interrupt pending.
  */
-static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
+static irqreturn_t serial8250_interrupt(void *dev_id)
 {
 	struct irq_info *i = dev_id;
 	struct list_head *l, *end = NULL;
@@ -1496,7 +1496,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 		if (l == i->head && pass_counter++ > PASS_LIMIT) {
 			/* If we hit this, we're dead. */
 			printk(KERN_ERR "serial8250: too much work for "
-				"irq%d\n", irq);
+				"irq%d\n", get_irqfunc_irq());
 			break;
 		}
 	} while (l != end);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 44c28e9..6813285 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -60,7 +60,8 @@ struct uio_info {
 	long			irq;
 	unsigned long		irq_flags;
 	void			*priv;
-	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
+
+	irq_handler_t		handler;
 	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
diff --git a/sound/drivers/mts64.c b/sound/drivers/mts64.c
index dcc90f9..4990b35 100644
--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -853,6 +853,8 @@ static void snd_mts64_interrupt(void *private)
 	}
 __out:
 	spin_unlock(&mts->lock);
+
+	return IRQ_HANDLED;
 }
 
 static int __devinit snd_mts64_probe_port(struct parport *p)
diff --git a/sound/drivers/portman2x4.c b/sound/drivers/portman2x4.c
index e065b2a..7e4ac0b 100644
--- a/sound/drivers/portman2x4.c
+++ b/sound/drivers/portman2x4.c
@@ -645,6 +645,8 @@ static void snd_portman_interrupt(void *userdata)
 	}
 
 	spin_unlock(&pm->reg_lock);
+
+	return IRQ_HANDLED;
 }
 
 static int __devinit snd_portman_probe_port(struct parport *p)
