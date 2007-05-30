Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbXE3INe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbXE3INe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1749667AbXE3INV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:13:21 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbXE3INR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:13:17 -0400
Date: Wed, 30 May 2007 01:12:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] zs: Move to the serial subsystem
Message-Id: <20070530011224.bf36d2df.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64N.0705291258390.14456@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0705291258390.14456@blysk.ds.pg.gda.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 14:03:54 +0100 (BST) "Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  This is a reimplementation of the zs driver for the serial subsystem.  
> Any resemblance to the old driver is purely coincidential. ;-)  I do hope 
> I got the handling of modem lines right -- better do not tackle me about 
> the issue unless you feel too good...
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
> 
>  Any users of the old driver: please note the numbers of the serial lines 
> have now been swapped, i.e. ttyS0 <-> ttyS1 and ttyS2 <-> ttyS3.  It has 
> to do with the modem lines mentioned above; basically the port A in a 
> given chip has to be initialised before the port B if you want to use the 
> latter as the serial console (which is usually the case), as operations on 
> modem lines of the serial line associated with the port B access both 
> ports (see the comment at the top of the driver for the details of wiring 
> used).  Please update your scripts.
> 
>  This is also the reason each SCC now requests an IRQ once only (as seen 
> in "/proc/interrupts") -- the handler takes care of both ports at once as 
> the line associated with the port B has to take status update interrupts 
> from both ports (and yet the line of the port A takes its own for itself 
> too).  The old driver never got it right...
> 
>  Please apply.  RIP, the old bits, you served us well.
> 

So..  how many people use this, and how do we know when it's been tested
enough?

For starters, let's see what the new checkpatch.pl says:

Use #include <linux/bug.h> instead of <asm/bug.h>
PATCH: patches/zs-move-to-the-serial-subsystem.patch:274:
FILE: a/drivers/serial/zs.c:65:
+#include <asm/bug.h>

Use #include <linux/io.h> instead of <asm/io.h>
PATCH: patches/zs-move-to-the-serial-subsystem.patch:275:
FILE: a/drivers/serial/zs.c:66:
+#include <asm/io.h>

line over 80 characters
PATCH: patches/zs-move-to-the-serial-subsystem.patch:298:
FILE: a/drivers/serial/zs.c:89:
+#define ZS_CHAN_IO_OFFSET 1		/* The SCC resides on the high byte						   of the 16-bit IOBUS.  */

printk() should include KERN_ facility level
PATCH: patches/zs-move-to-the-serial-subsystem.patch:398:
FILE: a/drivers/serial/zs.c:189:
+			printk("W%-2d = 0x%02x\t", j, zport->regs[j]);

printk() should include KERN_ facility level
PATCH: patches/zs-move-to-the-serial-subsystem.patch:399:
FILE: a/drivers/serial/zs.c:190:
+		printk("\n");

printk() should include KERN_ facility level
PATCH: patches/zs-move-to-the-serial-subsystem.patch:401:
FILE: a/drivers/serial/zs.c:192:
+			printk("R%-2d = 0x%02x\t", j, read_zsreg(zport, j));

printk() should include KERN_ facility level
PATCH: patches/zs-move-to-the-serial-subsystem.patch:402:
FILE: a/drivers/serial/zs.c:193:
+		printk("\n\n");

"foo* bar" should be "foo *bar"
PATCH: patches/zs-move-to-the-serial-subsystem.patch:408:
FILE: a/drivers/serial/zs.c:199:
+static inline void zs_spin_lock_cond_irq(spinlock_t* lock, int irq)

need space before that '*' here: static inline void zs_spin_lock_cond_irq(spinlock_t* lock
PATCH: patches/zs-move-to-the-serial-subsystem.patch:408:
FILE: a/drivers/serial/zs.c:199:
+static inline void zs_spin_lock_cond_irq(spinlock_t* lock, int irq)

"foo* bar" should be "foo *bar"
PATCH: patches/zs-move-to-the-serial-subsystem.patch:416:
FILE: a/drivers/serial/zs.c:207:
+static inline void zs_spin_unlock_cond_irq(spinlock_t* lock, int irq)

need space before that '*' here: static inline void zs_spin_unlock_cond_irq(spinlock_t* lock
PATCH: patches/zs-move-to-the-serial-subsystem.patch:416:
FILE: a/drivers/serial/zs.c:207:
+static inline void zs_spin_unlock_cond_irq(spinlock_t* lock, int irq)

printk() should include KERN_ facility level
PATCH: patches/zs-move-to-the-serial-subsystem.patch:1415:
FILE: a/drivers/serial/zs.c:1206:
+	printk("%s%s\n", zs_name, zs_version);

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

tsk.


Hey, you have volatiles and checkpatch.pl didn't complain.  Andy, a
reference to Documentation/volatile-considered-harmful.txt would suit.

(That's
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/broken-out/volatile-considered-harmful-take-3.patch)


> +#define RECOVERY_DELAY  udelay(2)

static inline void recovery_delay(void)
{
	udelay(2);
}

?

> +#define to_zport(uport) container_of(uport, struct zs_port, port)

This could be a C function too.

> +static u8 zs_init_regs[ZS_NUM_REGS] __initdata = {
> +	0,				/* write 0 */
> +	PAR_SPEC,			/* write 1 */
> +	0,				/* write 2 */
> +	0,				/* write 3 */
> +	X16CLK | SB1,			/* write 4 */
> +	0,				/* write 5 */
> +	0, 0, 0,			/* write 6, 7, 8 */
> +	MIE | DLC | NV,			/* write 9 */
> +	NRZ,				/* write 10 */
> +	TCBR | RCBR,			/* write 11 */
> +	0, 0,				/* BRG time constant, write 12 + 13 */
> +	BRSRC | BRENABL,		/* write 14 */
> +	0,				/* write 15 */
> +};

one could use the [1] = PAR_SPEC, thingy here, but the above seems clear
enough to me.
	
> +/*
> + * Debugging.
> + */
> +#undef ZS_DEBUG_REGS
> +
> +
> +/*
> + * Reading and writing Z85C30 registers.
> + */
> +static inline u8 read_zsreg(struct zs_port *zport, int reg)
> +{
> +	volatile void __iomem *control = zport->port.membase +
> +					 ZS_CHAN_IO_OFFSET;
> +	u8 retval;
> +
> +	if (reg != 0) {
> +		writeb(reg & 0xf, control);
> +		fast_iob(); RECOVERY_DELAY;
> +	}
> +	retval = readb(control);
> +	RECOVERY_DELAY;
> +	return retval;
> +}

This is too large to inline (I suspect) and it has many callsites, and some
of those callsites are inlined too.

You'll probably get some nice savings by nuking the lot.

> +static inline void write_zsreg(struct zs_port *zport, int reg, u8 value)
> +{
> +	volatile void __iomem *control = zport->port.membase +
> +					 ZS_CHAN_IO_OFFSET;
> +
> +	if (reg != 0) {
> +		writeb(reg & 0xf, control);
> +		fast_iob(); RECOVERY_DELAY;
> +	}
> +	writeb(value, control);
> +	fast_iob(); RECOVERY_DELAY;
> +	return;
> +}

Ditto.

> +static inline u8 read_zsdata(struct zs_port *zport)
> +{
> +	volatile void __iomem *data = zport->port.membase +
> +				      ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
> +	u8 retval;
> +
> +	retval = readb(data);
> +	RECOVERY_DELAY;
> +	return retval;
> +}
> +
> +static inline void write_zsdata(struct zs_port *zport, u8 value)
> +{
> +	volatile void __iomem *data = zport->port.membase +
> +				      ZS_CHAN_IO_STRIDE + ZS_CHAN_IO_OFFSET;
> +
> +	writeb(value, data);
> +	fast_iob(); RECOVERY_DELAY;
> +	return;
> +}

That RECOVERY_DELAY thing has to go!

> +#ifdef ZS_DEBUG_REGS
> +void zs_dump(void)
> +{
> +	struct zs_port *zport;
> +	int i, j;
> +
> +	for (i = 0; i < zs_channels_found; i++) {
> +		zport = &zs_sccs[i / ZS_NUM_CHAN].zport[i % ZS_NUM_CHAN];
> +
> +		for (j = 0; j < 16; j++)
> +			printk("W%-2d = 0x%02x\t", j, zport->regs[j]);
> +		printk("\n");
> +		for (j = 0; j < 16; j++)
> +			printk("R%-2d = 0x%02x\t", j, read_zsreg(zport, j));
> +		printk("\n\n");
> +	}
> +}
> +#endif

Make this static?

> +
> +static inline void zs_spin_lock_cond_irq(spinlock_t* lock, int irq)
> +{
> +	if (irq)
> +		spin_lock_irq(lock);
> +	else
> +		spin_lock(lock);
> +}

This `irq' thing looks a bit hacky.

> +static inline void zs_spin_unlock_cond_irq(spinlock_t* lock, int irq)
> +{
> +	if (irq)
> +		spin_unlock_irq(lock);
> +	else
> +		spin_unlock(lock);
> +}
> +
> +static int zs_receive_drain(struct zs_port *zport)
> +{
> +	int loops = 10000;
> +
> +	while ((read_zsreg(zport, R0) & Rx_CH_AV) && loops--)
> +		read_zsdata(zport);
> +	return loops;
> +}
> +
> +static int zs_transmit_drain(struct zs_port *zport, int irq)
> +{
> +	struct zs_scc *scc = zport->scc;
> +	int loops = 10000;
> +
> +	while (!(read_zsreg(zport, R0) & Tx_BUF_EMP) && loops--) {
> +		zs_spin_unlock_cond_irq(&scc->zlock, irq);
> +		udelay(2);
> +		zs_spin_lock_cond_irq(&scc->zlock, irq);
> +	}
> +	return loops;
> +}
> +
> +
> +static inline void load_zsregs(struct zs_port *zport, u8 *regs, int irq)
> +{
> +	zs_transmit_drain(zport, irq);
> +	/* Load 'em up.  */
> +	write_zsreg(zport, R3, regs[3] & ~RxENABLE);
> +	write_zsreg(zport, R5, regs[5] & ~TxENAB);
> +	write_zsreg(zport, R4, regs[4]);
> +	write_zsreg(zport, R9, regs[9]);
> +	write_zsreg(zport, R1, regs[1]);
> +	write_zsreg(zport, R2, regs[2]);
> +	write_zsreg(zport, R10, regs[10]);
> +	write_zsreg(zport, R14, regs[14] & ~BRENABL);
> +	write_zsreg(zport, R11, regs[11]);
> +	write_zsreg(zport, R12, regs[12]);
> +	write_zsreg(zport, R13, regs[13]);
> +	write_zsreg(zport, R14, regs[14]);
> +	write_zsreg(zport, R15, regs[15]);
> +	if (regs[3] & RxENABLE)
> +		write_zsreg(zport, R3, regs[3]);
> +	if (regs[5] & TxENAB)
> +		write_zsreg(zport, R5, regs[5]);
> +	return;
> +}

two callsites, should be uninlined.

> +
> +/*
> + * Status handling routines.
> + */
> +
> +/*
> + * zs_tx_empty() -- get the transmitter empty status
> + *
> + * Purpose: Let user call ioctl() to get info when the UART physically
> + * 	    is emptied.  On bus types like RS485, the transmitter must
> + * 	    release the bus after transmitting.  This must be done when
> + * 	    the transmit shift register is empty, not be done when the
> + * 	    transmit holding register is empty.  This functionality
> + * 	    allows an RS485 driver to be written in user space.
> + */
> +static unsigned int zs_tx_empty(struct uart_port *uport)
> +{
> +	struct zs_port *zport = to_zport(uport);
> +	struct zs_scc *scc = zport->scc;
> +	unsigned long flags;
> +	u8 status;
> +
> +	spin_lock_irqsave(&scc->zlock, flags);
> +	status = read_zsreg(zport, R1);
> +	spin_unlock_irqrestore(&scc->zlock, flags);

How come this read_zsreg() needs the lock

> +	return status & ALL_SNT ? TIOCSER_TEMT : 0;
> +}
> +
> +static inline unsigned int zs_raw_get_ab_mctrl(struct zs_port *zport_a,
> +					       struct zs_port *zport_b)
> +{
> +	u8 status_a, status_b;
> +	unsigned int mctrl;
> +
> +	status_a = read_zsreg(zport_a, R0);
> +	status_b = read_zsreg(zport_b, R0);

and these apparently don't?

<double checks>

Actually the callers _do_ seem kinda OK, but please chech that carefully.

Some of the callers are using spin_lock(zlock) and some others are using
spin_lock_irq().  Could be deadlocky - please review all of that.


> +	mctrl = ((status_b & CTS) ? TIOCM_CTS : 0) |
> +		((status_b & DCD) ? TIOCM_CAR : 0) |
> +		((status_a & DCD) ? TIOCM_RNG : 0) |
> +		((status_a & SYNC_HUNT) ? TIOCM_DSR : 0);
> +
> +	return mctrl;
> +}

Too much inlining here too.

> +static void zs_receive_chars(struct zs_port *zport)
> +{
> +	struct uart_port *uport = &zport->port;
> +	struct zs_scc *scc = zport->scc;
> +	struct uart_icount *icount;
> +	unsigned int avail, status, ch, flag;
> +	int count;
> +
> +	for (count = 16; count; count--) {
> +		spin_lock(&scc->zlock);
> +		avail = read_zsreg(zport, R0) & Rx_CH_AV;
> +		spin_unlock(&scc->zlock);
> +		if (!avail)
> +			break;
> +
> +		spin_lock(&scc->zlock);
> +		status = read_zsreg(zport, R1) & (Rx_OVR | FRM_ERR | PAR_ERR);
> +		ch = read_zsdata(zport);
> +		spin_unlock(&scc->zlock);
> +
> +		flag = TTY_NORMAL;
> +
> +		icount = &uport->icount;
> +		icount->rx++;
> +
> +		/* Handle the null char got when BREAK is removed.  */
> +		if (!ch)
> +			status |= zport->tty_break;
> +		if (unlikely(status &
> +			     (Rx_OVR | FRM_ERR | PAR_ERR | Rx_SYS | Rx_BRK))) {
> +			zport->tty_break = 0;
> +
> +			/* Reset the error indication.  */
> +			if (status & (Rx_OVR | FRM_ERR | PAR_ERR)) {
> +				spin_lock(&scc->zlock);
> +				write_zsreg(zport, R0, ERR_RES);
> +				spin_unlock(&scc->zlock);
> +			}
> +
> +			if (status & (Rx_SYS | Rx_BRK))
> +				icount->brk++;
> +			else if (status & FRM_ERR)
> +				icount->frame++;
> +			else if (status & PAR_ERR)
> +				icount->parity++;

FRM_ERR and PAR_ERR are mutually exclusive, and cannot be set if either
Rx_SYS or Rx_BRK are set?

> +			if (status & Rx_OVR)
> +				icount->overrun++;
> +
> +			/* Discard the null char.  */
> +			if (status & Rx_SYS)
> +				continue;
> +
> +			status &= uport->read_status_mask;
> +			if (status & Rx_BRK)
> +				flag = TTY_BREAK;
> +			else if (status & FRM_ERR)
> +				flag = TTY_FRAME;
> +			else if (status & PAR_ERR)
> +				flag = TTY_PARITY;
> +		}
> +
> +		if (uart_handle_sysrq_char(uport, ch))
> +			continue;
> +
> +		uart_insert_char(uport, status, Rx_OVR, ch, flag);
> +	}
> +
> +	tty_flip_buffer_push(uport->info->tty);
> +}
>
> ...
>
> +/*
> + * Finally, routines used to initialize the serial port.
> + */
> +static int zs_startup(struct uart_port *uport)
> +{
> +	struct zs_port *zport = to_zport(uport);
> +	struct zs_scc *scc = zport->scc;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (!scc->irq_guard) {
> +		ret = request_irq(zport->port.irq, zs_interrupt,
> +				  IRQF_SHARED, "scc", scc);
> +		if (ret) {
> +			printk(KERN_ERR "zs: can't get irq %d\n",
> +			       zport->port.irq);
> +			return ret;
> +		}
> +	}
> +	scc->irq_guard++;

The ->irq_guard handling looks a little racy?

Perhaps higher-level locks prevent this.  If so, a comment explaining this
would be reassuring.

> +	spin_lock_irqsave(&scc->zlock, flags);
> +
> +	/* Clear the receive FIFO.  */
> +	zs_receive_drain(zport);
> +
> +	/* Clear the interrupt registers.  */
> +	write_zsreg(zport, R0, ERR_RES);
> +	write_zsreg(zport, R0, RES_Tx_P);
> +	/* But Ext only if not being handled already.  */
> +	if (!(zport->regs[1] & EXT_INT_ENAB))
> +		write_zsreg(zport, R0, RES_EXT_INT);
> +
> +	/* Finally, enable sequencing and interrupts.  */
> +	zport->regs[1] &= ~RxINT_MASK;
> +	zport->regs[1] |= RxINT_ALL | TxINT_ENAB | EXT_INT_ENAB;
> +	zport->regs[3] |= RxENABLE;
> +	zport->regs[5] |= TxENAB;
> +	zport->regs[15] |= BRKIE;
> +	write_zsreg(zport, R1, zport->regs[1]);
> +	write_zsreg(zport, R3, zport->regs[3]);
> +	write_zsreg(zport, R5, zport->regs[5]);
> +	write_zsreg(zport, R15, zport->regs[15]);
> +
> +	/* Record the current state of RR0.  */
> +	zport->mctrl = zs_raw_get_mctrl(zport);
> +	zport->brk = read_zsreg(zport, R0) & BRK_ABRT;
> +
> +	zport->tx_stopped = 1;
> +
> +	spin_unlock_irqrestore(&scc->zlock, flags);
> +
> +	return 0;
> +}
> +
> +static void zs_shutdown(struct uart_port *uport)
> +{
> +	struct zs_port *zport = to_zport(uport);
> +	struct zs_scc *scc = zport->scc;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&scc->zlock, flags);
> +
> +	zport->regs[5] &= ~TxENAB;
> +	zport->regs[3] &= ~RxENABLE;
> +	write_zsreg(zport, R5, zport->regs[5]);
> +	write_zsreg(zport, R3, zport->regs[3]);
> +
> +	spin_unlock_irqrestore(&scc->zlock, flags);
> +
> +	scc->irq_guard--;

Ditto.

> +	if (!scc->irq_guard)
> +		free_irq(zport->port.irq, scc);
> +}
> +
> +
> +static void zs_reset(struct zs_port *zport)
> +{
> +	struct zs_scc *scc = zport->scc;
> +	int irq;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&scc->zlock, flags);
> +	irq = !irqs_disabled_flags(flags);

hacky?

> +	if (!scc->initialised) {
> +		write_zsreg(zport, R9, FHWRES);
> +		udelay(10);
> +		write_zsreg(zport, R9, 0);
> +		scc->initialised = 1;
> +	}
> +	load_zsregs(zport, zport->regs, irq);
> +	spin_unlock_irqrestore(&scc->zlock, flags);
> +}
> +
> +static void zs_set_termios(struct uart_port *uport, struct ktermios *termios,
> +			   struct ktermios *old_termios)
> +{
> +	struct zs_port *zport = to_zport(uport);
> +	struct zs_scc *scc = zport->scc;
> +	struct zs_port *zport_a = &scc->zport[ZS_CHAN_A];
> +	int irq;
> +	unsigned int baud, brg;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&scc->zlock, flags);
> +	irq = !irqs_disabled_flags(flags);
> +
> +	/* Byte size.  */
> +	zport->regs[3] &= ~RxNBITS_MASK;
> +	zport->regs[5] &= ~TxNBITS_MASK;
> +	switch (termios->c_cflag & CSIZE) {
> +	case CS5:
> +		zport->regs[3] |= Rx5;
> +		zport->regs[5] |= Tx5;
> +		break;
> +	case CS6:
> +		zport->regs[3] |= Rx6;
> +		zport->regs[5] |= Tx6;
> +		break;
> +	case CS7:
> +		zport->regs[3] |= Rx7;
> +		zport->regs[5] |= Tx7;
> +		break;
> +	case CS8:
> +	default:
> +		zport->regs[3] |= Rx8;
> +		zport->regs[5] |= Tx8;
> +		break;
> +	}
> +
> +	/* Parity and stop bits.  */
> +	zport->regs[4] &= ~(XCLK_MASK | SB_MASK | PAR_ENA | PAR_EVEN);
> +	if (termios->c_cflag & CSTOPB)
> +		zport->regs[4] |= SB2;
> +	else
> +		zport->regs[4] |= SB1;
> +	if (termios->c_cflag & PARENB)
> +		zport->regs[4] |= PAR_ENA;
> +	if (!(termios->c_cflag & PARODD))
> +		zport->regs[4] |= PAR_EVEN;
> +	switch (zport->clk_mode) {
> +	case 64:
> +		zport->regs[4] |= X64CLK;
> +		break;
> +	case 32:
> +		zport->regs[4] |= X32CLK;
> +		break;
> +	case 16:
> +		zport->regs[4] |= X16CLK;
> +		break;
> +	case 1:
> +		zport->regs[4] |= X1CLK;
> +		break;
> +	default:
> +		BUG();
> +	}

afacit clk_mode = 16 is the only value possible in this driver.

> +	baud = uart_get_baud_rate(uport, termios, old_termios, 0,
> +				  uport->uartclk / zport->clk_mode / 4);
> +
> +	brg = ZS_BPS_TO_BRG(baud, uport->uartclk / zport->clk_mode);
> +	zport->regs[12] = brg & 0xff;
> +	zport->regs[13] = (brg >> 8) & 0xff;
> +
> +	uart_update_timeout(uport, termios->c_cflag, baud);
> +
> +	uport->read_status_mask = Rx_OVR;
> +	if (termios->c_iflag & INPCK)
> +		uport->read_status_mask |= FRM_ERR | PAR_ERR;
> +
> +	uport->ignore_status_mask = 0;
> +	if (termios->c_iflag & IGNPAR)
> +		uport->ignore_status_mask |= FRM_ERR | PAR_ERR;
> +
> +	if (termios->c_cflag & CREAD)
> +		zport->regs[3] |= RxENABLE;
> +	else
> +		zport->regs[3] &= ~RxENABLE;
> +
> +	if (zport != zport_a) {
> +		if (!(termios->c_cflag & CLOCAL)) {
> +			zport->regs[15] |= DCDIE;
> +		} else
> +			zport->regs[15] &= ~DCDIE;
> +		if (termios->c_cflag & CRTSCTS) {
> +			zport->regs[15] |= CTSIE;
> +		} else
> +			zport->regs[15] &= ~CTSIE;
> +		zs_raw_xor_mctrl(zport);
> +	}
> +
> +	/* Load up the new values.  */
> +	load_zsregs(zport, zport->regs, irq);
> +
> +	spin_unlock_irqrestore(&scc->zlock, flags);
> +}
> +	int bits = 8;
> +	int parity = 'n';
> +	int flow = 'n';
> +	int ret;
> +
> +	ret = zs_map_port(uport);
> +	if (ret)
> +		return ret;
> +
> +	zs_reset(zport);
> +
> +	if (options)
> +		uart_parse_options(options, &baud, &parity, &bits, &flow);
> +	return uart_set_options(uport, co, baud, parity, bits, flow);
> +}
> +
> +static struct uart_driver zs_reg;
> +static struct console zs_sercons = {
> +	.name	= "ttyS",
> +	.write	= zs_console_write,
> +	.device	= uart_console_device,
> +	.setup	= zs_console_setup,
> +	.flags	= CON_PRINTBUFFER,

You might want to set CON_BOOT here.  See the recently-merged
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch

> +	.index	= -1,
> +	.data	= &zs_reg,
> +};
>
> ...
>
> +static struct uart_driver zs_reg = {
> +	.owner			= THIS_MODULE,
> +	.driver_name		= "serial",
> +	.dev_name		= "ttyS",
> +	.major			= TTY_MAJOR,
> +	.minor			= 64,
> +	.nr			= ZS_NUM_SCCS * ZS_NUM_CHAN,
> +	.cons			= SERIAL_ZS_CONSOLE,
> +};

I think there was some great controversy recently concerning the naming of
the device which the z8530 driver drives.  Perhaps you're not affected
here.  It was dwmw2 vs Stephen Rothwell ;)


