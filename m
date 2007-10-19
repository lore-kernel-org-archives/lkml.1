Return-Path: <linux-kernel-owner+w=401wt.eu-S934314AbXJSSUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314AbXJSSUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbXJSSUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:20:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51277 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbXJSSUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:20:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] irq-remove: driver non-trivial
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075640.GE6407@havoc.gtf.org>
Date: Fri, 19 Oct 2007 12:19:53 -0600
In-Reply-To: <20071019075640.GE6407@havoc.gtf.org> (Jeff Garzik's message of
	"Fri, 19 Oct 2007 03:56:40 -0400")
Message-ID: <m1hcknge5y.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> commit 654f4a242cac0148ffe98ce288c9116e65b08e44
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Oct 19 00:47:17 2007 -0400
>
>     [IRQ ARG REMOVAL] non-trivial driver updates

Ok.  You have some random cleanups as buried in this patch
as well as the necessary changes to remove the irq argument
of the interrupt handler.

>  drivers/atm/ambassador.c             |    5 +++--
>  drivers/bluetooth/btuart_cs.c        |    2 +-
>  drivers/bluetooth/dtl1_cs.c          |    2 +-
>  drivers/char/cyclades.c              |   21 +++------------------
>  drivers/char/ip2/ip2main.c           |   10 +++++-----
>  drivers/char/mwave/tp3780i.c         |   10 ++++++----
>  drivers/char/pcmcia/synclink_cs.c    |    8 ++++----
>  drivers/char/rio/rio_linux.c         |   14 ++++++++------
>  drivers/char/riscom8.c               |    4 ++--
>  drivers/char/specialix.c             |    7 ++++---
>  drivers/char/sx.c                    |   14 +++++++-------
>  drivers/char/synclink.c              |    4 ++--
>  drivers/char/synclink_gt.c           |    9 ++++-----
>  drivers/char/synclinkmp.c            |    7 +++----
>  drivers/char/tpm/tpm_tis.c           |    6 +++---
>  drivers/ide/ide-io.c                 |    8 ++++----
>  drivers/input/serio/i8042.c          |    9 +++++----
>  drivers/isdn/act2000/act2000_isa.c   |    3 ++-
>  drivers/isdn/hisax/amd7930_fn.c      |    2 +-
>  drivers/isdn/hisax/hisax.h           |    2 +-
>  drivers/isdn/hisax/icc.c             |    2 +-
>  drivers/isdn/hisax/isac.c            |    2 +-
>  drivers/isdn/hisax/w6692.c           |    4 ++--
>  drivers/isdn/sc/interrupt.c          |    3 ++-
>  drivers/macintosh/via-macii.c        |    6 +++---
>  drivers/macintosh/via-maciisi.c      |    9 ++++-----
>  drivers/macintosh/via-pmu68k.c       |   10 +++++-----
>  drivers/media/video/planb.c          |    7 ++++---
>  drivers/net/eexpress.c               |    5 +++--
>  drivers/net/forcedeth.c              |   26 +++++++++++++-------------
>  drivers/net/hamradio/scc.c           |    6 +++---
>  drivers/net/irda/au1k_ir.c           |    8 +++++---
>  drivers/net/irda/smsc-ircc2.c        |    6 +++---
>  drivers/net/irda/via-ircc.c          |    6 +++---
>  drivers/net/lib82596.c               |    2 +-
>  drivers/net/netxen/netxen_nic_main.c |    4 ++--
>  drivers/net/pcmcia/fmvj18x_cs.c      |    6 +++---
>  drivers/net/phy/phy.c                |    4 ++--
>  drivers/net/wan/sdla.c               |    5 +++--
>  drivers/pcmcia/i82365.c              |   13 +++++++------
>  drivers/pcmcia/tcic.c                |   10 +++++-----
>  drivers/rtc/rtc-ds1374.c             |    3 ++-
>  drivers/scsi/NCR5380.c               |    6 +++---
>  drivers/scsi/NCR53C9x.c              |    7 ++++---
>  drivers/scsi/aha152x.c               |    4 ++--
>  drivers/scsi/aha1542.c               |    5 +++--
>  drivers/scsi/eata.c                  |   19 ++++++++++---------
>  drivers/scsi/psi240i.c               |   10 +++++-----
>  drivers/scsi/sym53c416.c             |    3 ++-
>  drivers/scsi/u14-34f.c               |   12 +++++++-----
>  drivers/serial/8250.c                |    4 ++--
>  include/linux/uio_driver.h           |    3 ++-
>  sound/drivers/mts64.c                |    2 ++
>  sound/drivers/portman2x4.c           |    2 ++
>  54 files changed, 190 insertions(+), 181 deletions(-)

>
> 654f4a242cac0148ffe98ce288c9116e65b08e44
> diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
> index c2b9464..8f6a8a2 100644
> --- a/drivers/atm/ambassador.c
> +++ b/drivers/atm/ambassador.c
> @@ -862,9 +862,10 @@ static inline void interrupts_off (amb_dev * dev) {
>  
>  /********** interrupt handling **********/
>  
> -static irqreturn_t interrupt_handler(int irq, void *dev_id) {
> +static irqreturn_t interrupt_handler(void *dev_id)
> +{
>    amb_dev * dev = dev_id;
> -  
> +
>    PRINTD (DBG_IRQ|DBG_FLOW, "interrupt_handler: %p", dev_id);
>    
>    {

White space cleanup.

> diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
> index 08f48d5..1fdf756 100644
> --- a/drivers/bluetooth/btuart_cs.c
> +++ b/drivers/bluetooth/btuart_cs.c
> @@ -287,7 +287,7 @@ static void btuart_receive(btuart_info_t *info)
>  }
>  
>  
> -static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
> +static irqreturn_t btuart_interrupt(void *dev_inst)
>  {
>  	btuart_info_t *info = dev_inst;
>  	unsigned int iobase;

Trivial

> diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
> index dae45cd..3f9d5b9 100644
> --- a/drivers/bluetooth/dtl1_cs.c
> +++ b/drivers/bluetooth/dtl1_cs.c
> @@ -290,7 +290,7 @@ static void dtl1_receive(dtl1_info_t *info)
>  }
>  
>  
> -static irqreturn_t dtl1_interrupt(int irq, void *dev_inst)
> +static irqreturn_t dtl1_interrupt(void *dev_inst)
>  {
>  	dtl1_info_t *info = dev_inst;
>  	unsigned int iobase;

Trivial

> diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
> index d15234c..7e8fe35 100644
> --- a/drivers/char/cyclades.c
> +++ b/drivers/char/cyclades.c
> @@ -1312,7 +1312,7 @@ end:
>     whenever the card wants its hand held--chars
>     received, out buffer empty, modem change, etc.
>   */
> -static irqreturn_t cyy_interrupt(int irq, void *dev_id)
> +static irqreturn_t cyy_interrupt(void *dev_id)
>  {
>  	int status;
>  	struct cyclades_card *cinfo = dev_id;
> @@ -1320,13 +1320,6 @@ static irqreturn_t cyy_interrupt(int irq, void *dev_id)
>  	unsigned int chip, too_many, had_work;
>  	int index;
>  
> -	if (unlikely(cinfo == NULL)) {
> -#ifdef CY_DEBUG_INTERRUPTS
> - printk(KERN_DEBUG "cyy_interrupt: spurious interrupt %d\n",irq);
> -#endif
> -		return IRQ_NONE;	/* spurious interrupt */
> -	}
> -
>  	card_base_addr = cinfo->base_addr;
>  	index = cinfo->bus_index;
>  
> @@ -1728,21 +1721,13 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
>  }
>  
>  #ifdef CONFIG_CYZ_INTR
> -static irqreturn_t cyz_interrupt(int irq, void *dev_id)
> +static irqreturn_t cyz_interrupt(void *dev_id)
>  {
>  	struct cyclades_card *cinfo = dev_id;
>  
> -	if (unlikely(cinfo == NULL)) {
> -#ifdef CY_DEBUG_INTERRUPTS
> - printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",irq);
> -#endif
> -		return IRQ_NONE;	/* spurious interrupt */
> -	}
> -
>  	if (unlikely(!ISZLOADED(*cinfo))) {
>  #ifdef CY_DEBUG_INTERRUPTS
> -		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
> -				"(IRQ%d).\n", irq);
> +		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded\n");
>  #endif
>  		return IRQ_NONE;
>  	}


Removal of impossible case?  aka cleanup.

> diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
> index 2124dce..1d4c528 100644
> --- a/drivers/char/ip2/ip2main.c
> +++ b/drivers/char/ip2/ip2main.c
> @@ -190,7 +190,7 @@ static int ip2_tiocmset(struct tty_struct *tty, struct file
> *file,
>  
>  static void set_irq(int, int);
>  static void ip2_interrupt_bh(struct work_struct *work);
> -static irqreturn_t ip2_interrupt(int irq, void *dev_id);
> +static irqreturn_t ip2_interrupt(void *dev_id);
>  static void ip2_poll(unsigned long arg);
>  static inline void service_all_boards(void);
>  static void do_input(struct work_struct *);
> @@ -1149,7 +1149,7 @@ ip2_interrupt_bh(struct work_struct *work)
>  
>  
>  /******************************************************************************/
> -/* Function:   ip2_interrupt(int irq, void *dev_id)    */
> +/* Function:   ip2_interrupt(void *dev_id)    */
>  /* Parameters: irq - interrupt number */
>  /* pointer to optional device ID structure */
>  /* Returns: Nothing */
> @@ -1167,7 +1167,7 @@ ip2_interrupt_bh(struct work_struct *work)
>  /* */
>  /******************************************************************************/
>  static irqreturn_t
> -ip2_interrupt(int irq, void *dev_id)
> +ip2_interrupt(void *dev_id)
>  {
>  	int i;
>  	i2eBordStrPtr  pB;
> @@ -1182,7 +1182,7 @@ ip2_interrupt(int irq, void *dev_id)
>  //		Only process those boards which match our IRQ.
>  //			IRQ = 0 for polled boards, we won't poll "IRQ" boards
>  
> -		if ( pB && (pB->i2eUsingIrq == irq) ) {
> +		if ( pB && (pB->i2eUsingIrq == get_irqfunc_irq()) ) {
>  			handled = 1;
>  #ifdef USE_IQI
>  
> @@ -1231,7 +1231,7 @@ ip2_poll(unsigned long arg)
>  	// Just polled boards, IRQ = 0 will hit all non-interrupt boards.
>  	// It will NOT poll boards handled by hard interrupts.
>  	// The issue of queued BH interrups is handled in ip2_interrupt().
> -	ip2_interrupt(0, NULL);
> +	ip2_interrupt(NULL);

Ouch!  What will get_irqfunc return here?

>  	PollTimer.expires = POLL_TIMEOUT;
>  	add_timer( &PollTimer );
> diff --git a/drivers/char/mwave/tp3780i.c b/drivers/char/mwave/tp3780i.c
> index f282976..ff57eb1 100644
> --- a/drivers/char/mwave/tp3780i.c
> +++ b/drivers/char/mwave/tp3780i.c
> @@ -95,14 +95,15 @@ static void EnableSRAM(THINKPAD_BD_DATA * pBDData)
>  }
>  
>  
> -static irqreturn_t UartInterrupt(int irq, void *dev_id)
> +static irqreturn_t UartInterrupt(void *dev_id)
>  {
>  	PRINTK_3(TRACE_TP3780I,
> - "tp3780i::UartInterrupt entry irq %x dev_id %p\n", irq, dev_id);
> +		"tp3780i::UartInterrupt entry irq %x dev_id %p\n",
> +		get_irqfunc_irq(), dev_id);
>  	return IRQ_HANDLED;
>  }
>  
> -static irqreturn_t DspInterrupt(int irq, void *dev_id)
> +static irqreturn_t DspInterrupt(void *dev_id)
>  {
>  	pMWAVE_DEVICE_DATA pDrvData = &mwave_s_mdd;
>  	DSP_3780I_CONFIG_SETTINGS *pSettings = &pDrvData->rBDData.rDspSettings;
> @@ -110,7 +111,8 @@ static irqreturn_t DspInterrupt(int irq, void *dev_id)
>  	unsigned short usIPCSource = 0, usIsolationMask, usPCNum;
>  
>  	PRINTK_3(TRACE_TP3780I,
> -		"tp3780i::DspInterrupt entry irq %x dev_id %p\n", irq, dev_id);
> +		"tp3780i::DspInterrupt entry irq %x dev_id %p\n",
> +		get_irqfunc_irq(), dev_id);
>  
>  	if (dsp3780I_GetIPCSource(usDspBaseIO, &usIPCSource) == 0) {
>  		PRINTK_2(TRACE_TP3780I,

Needed but just printk seems to be the only user.

> diff --git a/drivers/char/pcmcia/synclink_cs.c
> b/drivers/char/pcmcia/synclink_cs.c
> index 2b88931..922cf60 100644
> --- a/drivers/char/pcmcia/synclink_cs.c
> +++ b/drivers/char/pcmcia/synclink_cs.c
> @@ -417,7 +417,7 @@ static void rx_reset_buffers(MGSLPC_INFO *info);
>  static int  rx_alloc_buffers(MGSLPC_INFO *info);
>  static void rx_free_buffers(MGSLPC_INFO *info);
>  
> -static irqreturn_t mgslpc_isr(int irq, void *dev_id);
> +static irqreturn_t mgslpc_isr(void *dev_id);
>  
>  /*
>   * Bottom half interrupt handlers
> @@ -1226,7 +1226,7 @@ static void ri_change(MGSLPC_INFO *info)
>   * irq     interrupt number that caused interrupt
>   * dev_id  device ID supplied during interrupt registration
>   */
> -static irqreturn_t mgslpc_isr(int irq, void *dev_id)
> +static irqreturn_t mgslpc_isr(void *dev_id)
>  {
>  	MGSLPC_INFO * info = (MGSLPC_INFO *)dev_id;
>  	unsigned short isr;
> @@ -1234,7 +1234,7 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
>  	int count=0;
>  
>  	if (debug_level >= DEBUG_LEVEL_ISR)	
> -		printk("mgslpc_isr(%d) entry.\n", irq);
> +		printk("mgslpc_isr(%d) entry.\n", get_irqfunc_irq());
>  	if (!info)
>  		return IRQ_NONE;
>  		
> @@ -1328,7 +1328,7 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
>  	
>  	if (debug_level >= DEBUG_LEVEL_ISR)	
>  		printk("%s(%d):mgslpc_isr(%d)exit.\n",
> -		       __FILE__,__LINE__,irq);
> +		       __FILE__, __LINE__, get_irqfunc_irq());
>  
>  	return IRQ_HANDLED;
>  }

Ok.  Just fixing printk again.

> diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
> index 0ce9667..616a1cf 100644
> --- a/drivers/char/rio/rio_linux.c
> +++ b/drivers/char/rio/rio_linux.c
> @@ -363,13 +363,14 @@ static void rio_reset_interrupt(struct Host *HostP)
>  }
>  
>  
> -static irqreturn_t rio_interrupt(int irq, void *ptr)
> +static irqreturn_t rio_interrupt(void *ptr)
>  {
>  	struct Host *HostP;
>  	func_enter();
>  
> -	HostP = ptr;			/* &p->RIOHosts[(long)ptr]; */
> - rio_dprintk(RIO_DEBUG_IFLOW, "rio: enter rio_interrupt (%d/%d)\n", irq,
> HostP->Ivec);
> +	HostP = ptr;	/* &p->RIOHosts[(long)ptr]; */
> +	rio_dprintk(RIO_DEBUG_IFLOW, "rio: enter rio_interrupt (%d/%d)\n",
> +		    get_irqfunc_irq(), HostP->Ivec);
>  
>  	/* AAargh! The order in which to do these things is essential and
>  	   not trivial.
> @@ -389,7 +390,7 @@ static irqreturn_t rio_interrupt(int irq, void *ptr)
>  	 */
>  
>  	rio_dprintk(RIO_DEBUG_IFLOW, "rio: We've have noticed the interrupt\n");
> -	if (HostP->Ivec == irq) {
> +	if (HostP->Ivec == get_irqfunc_irq()) {
>  		/* Tell the card we've noticed the interrupt. */
>  		rio_reset_interrupt(HostP);
>  	}

Ok.  This is to detect to see if we are being called from the poll
function, ouch.


> @@ -407,7 +408,8 @@ static irqreturn_t rio_interrupt(int irq, void *ptr)
>  	rio_dprintk(RIO_DEBUG_IFLOW, "riointr() doing host %p type %d\n", ptr,
> HostP->Type);
>  
>  	clear_bit(RIO_BOARD_INTR_LOCK, &HostP->locks);
> - rio_dprintk(RIO_DEBUG_IFLOW, "rio: exit rio_interrupt (%d/%d)\n", irq,
> HostP->Ivec);
> +	rio_dprintk(RIO_DEBUG_IFLOW, "rio: exit rio_interrupt (%d/%d)\n",
> +		    get_irqfunc_irq(), HostP->Ivec);
>  	func_exit();
>  	return IRQ_HANDLED;
>  }
> @@ -417,7 +419,7 @@ static void rio_pollfunc(unsigned long data)
>  {
>  	func_enter();
>  
> -	rio_interrupt(0, &p->RIOHosts[data]);
> +	rio_interrupt(&p->RIOHosts[data]);
Bug because now we don't know if we are being called from the poll
function.
>  	mod_timer(&p->RIOHosts[data].timer, jiffies + rio_poll);
>  
>  	func_exit();
> diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
> index b37e626..1c0741a 100644
> --- a/drivers/char/riscom8.c
> +++ b/drivers/char/riscom8.c
> @@ -537,7 +537,7 @@ static inline void rc_check_modem(struct riscom_board const
> * bp)
>  }
>  
>  /* The main interrupt processing routine */
> -static irqreturn_t rc_interrupt(int irq, void * dev_id)
> +static irqreturn_t rc_interrupt(void * dev_id)
>  {
>  	unsigned char status;
>  	unsigned char ack;
> @@ -545,7 +545,7 @@ static irqreturn_t rc_interrupt(int irq, void * dev_id)
>  	unsigned long loop = 0;
>  	int handled = 0;
>  
> -	bp = IRQ_to_board[irq];
> +	bp = IRQ_to_board[get_irqfunc_irq()];
>  
>  	if (!(bp->flags & RC_BOARD_ACTIVE))
>  		return IRQ_NONE;

Reasonable.  Grumble we should just pass bp to request_irq.

> diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
> index 4558556..bad86e0 100644
> --- a/drivers/char/specialix.c
> +++ b/drivers/char/specialix.c
> @@ -195,7 +195,7 @@ static struct specialix_port sx_port[SX_NBOARD * SX_NPORT];
>  
>  #ifdef SPECIALIX_TIMER
>  static struct timer_list missed_irq_timer;
> -static irqreturn_t sx_interrupt(int irq, void * dev_id);
> +static irqreturn_t sx_interrupt(void * dev_id);
>  #endif
>  
>  
> @@ -876,7 +876,7 @@ static inline void sx_check_modem(struct specialix_board *
> bp)
>  
>  
>  /* The main interrupt processing routine */
> -static irqreturn_t sx_interrupt(int irq, void *dev_id)
> +static irqreturn_t sx_interrupt(void *dev_id)
>  {
>  	unsigned char status;
>  	unsigned char ack;
> @@ -892,7 +892,8 @@ static irqreturn_t sx_interrupt(int irq, void *dev_id)
>  
>  	dprintk (SX_DEBUG_FLOW, "enter %s port %d room: %ld\n", __FUNCTION__,
> port_No(sx_get_port(bp, "INT")), SERIAL_XMIT_SIZE - sx_get_port(bp,
> "ITN")->xmit_cnt - 1);
>  	if (!(bp->flags & SX_BOARD_ACTIVE)) {
> -		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n", irq);
> +		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n",
> +			 get_irqfunc_irq());
>  		spin_unlock_irqrestore(&bp->lock, flags);
>  		func_exit();
>  		return IRQ_NONE;

Ok...

> diff --git a/drivers/char/sx.c b/drivers/char/sx.c
> index 85a2328..ff7fac3 100644
> --- a/drivers/char/sx.c
> +++ b/drivers/char/sx.c
> @@ -1241,15 +1241,15 @@ static inline void sx_check_modem_signals(struct sx_port
> *port)
>   * Small, elegant, clear.
>   */
>  
> -static irqreturn_t sx_interrupt(int irq, void *ptr)
> +static irqreturn_t sx_interrupt(void *ptr)
>  {
>  	struct sx_board *board = ptr;
>  	struct sx_port *port;
>  	int i;
>  
>  	func_enter();
> -	sx_dprintk(SX_DEBUG_FLOW, "sx: enter sx_interrupt (%d/%d)\n", irq,
> -			board->irq);
> +	sx_dprintk(SX_DEBUG_FLOW, "sx: enter sx_interrupt (%d/%d)\n",
> +		   get_irqfunc_irq(), board->irq);
>  
>  	/* AAargh! The order in which to do these things is essential and
>  	   not trivial. 
> @@ -1293,7 +1293,7 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
>  	}
>  #endif
>  
> -	if (board->irq == irq) {
> +	if (board->irq == get_irqfunc_irq()) {
>  		/* Tell the card we've noticed the interrupt. */
>  
>  		sx_write_board_word(board, cc_int_pending, 0);
> @@ -1339,8 +1339,8 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
>  
>  	clear_bit(SX_BOARD_INTR_LOCK, &board->locks);
>  
> -	sx_dprintk(SX_DEBUG_FLOW, "sx: exit sx_interrupt (%d/%d)\n", irq,
> -			board->irq);
> +	sx_dprintk(SX_DEBUG_FLOW, "sx: exit sx_interrupt (%d/%d)\n",
> +		   get_irqfunc_irq(), board->irq);
>  	func_exit();
>  	return IRQ_HANDLED;
>  }
> @@ -1351,7 +1351,7 @@ static void sx_pollfunc(unsigned long data)
>  
>  	func_enter();
>  
> -	sx_interrupt(0, board);
> +	sx_interrupt(board);
Bug because we can't detect if we are being called from the poll
function after this change.
>  
>  	mod_timer(&board->timer, jiffies + sx_poll);
>  	func_exit();

[snip] Found issues and ran out of review bandwidth.

> diff --git a/sound/drivers/mts64.c b/sound/drivers/mts64.c
> index dcc90f9..4990b35 100644
> --- a/sound/drivers/mts64.c
> +++ b/sound/drivers/mts64.c
> @@ -853,6 +853,8 @@ static void snd_mts64_interrupt(void *private)
>  	}
>  __out:
>  	spin_unlock(&mts->lock);
> +
> +	return IRQ_HANDLED;

Missing parport code change, see below.
>  }
>  
>  static int __devinit snd_mts64_probe_port(struct parport *p)
> diff --git a/sound/drivers/portman2x4.c b/sound/drivers/portman2x4.c
> index e065b2a..7e4ac0b 100644
> --- a/sound/drivers/portman2x4.c
> +++ b/sound/drivers/portman2x4.c
> @@ -645,6 +645,8 @@ static void snd_portman_interrupt(void *userdata)
>  	}
>  
>  	spin_unlock(&pm->reg_lock);
> +
> +	return IRQ_HANDLED;

Hmm.  The corresponding change to prototype is missing and
the change to the parport code is missing.

Eric
