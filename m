Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZCKIqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZCKIqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZCKIqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:46:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:33494 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZCKIqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dhy2O7QsqSxTgmqDkEPY8DU3b+3MMegL+oSaMSJgNQk3Yv077ks8cxfqCON0zazz4j
         KKeSv59LPWvirzPAH0AqHnTBVqoabsQrlCwdHN5Ai/YB8EcbZ8EsItV1b8WHrLC4fDNJ
         ySeczqsBYehu1jTNcbSUj2+CJcZ2OaFGAuFzw=
MIME-Version: 1.0
In-Reply-To: <7d86d44a0903110117m4fc28b8bl5011493428d5a348@mail.gmail.com>
References: <1236756563-20633-1-git-send-email-graff.yang@gmail.com>
	 <386072610903110037k53bc659awdd6d1093ce6eaba2@mail.gmail.com>
	 <7d86d44a0903110117m4fc28b8bl5011493428d5a348@mail.gmail.com>
Date: Wed, 11 Mar 2009 16:46:14 +0800
X-Google-Sender-Auth: c8119670acff04a2
Message-ID: <386072610903110146h31e92d58qbd4258e09818ad47@mail.gmail.com>
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: Bryan Wu <cooloney@kernel.org>
To: graff yang <graff.yang@gmail.com>
Cc: samuel@sortiz.org, irda-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, graf.yang@analog.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 4:17 PM, graff yang <graff.yang@gmail.com> wrote:
> OK, thank you very much.
>
> Can I add the changed items here?
> It is the v3 version since the first patch on 2009-03-06.
>
> v1-v2: Revised according suggestions from Andrew Morton
>   1. Use schedule_timeout_uninterruptible() instead of
> schedule_timeout_interruptible() in function turnaround_delay()
>   2. Add cpu_relax() in bfin_sir_stop_tx()
>   3. Add spin lock/unlock in bfin_sir_tx_int() and bfin_sir_rx_int()
>   4. Use flush_work() instead of flush_scheduled_work() in bfin_sir_stop()
> and bfin_sir_suspend()
>   5. Remove GFP_DMA when calling kmalloc() in bfin_sir_init_iobuf()
>   6. Some revisions for coding style
>
> v2-v3: Revised according suggestions from Mike Frysinger
>   1. Change the BFIN_SIRx order in Kconfig
>   2. Add ANOMALY_05000230 when calculate baud rate divisor
>   3. Add a degressive counter to wait the byte sending out when going to
> change speed
>   4. Fixed the peripheral resource leakage
>   5. Some revision for coding style
>
> -Graff
>

IMHO, this is good enough, -:))
-Bryan

> On Wed, Mar 11, 2009 at 3:37 PM, Bryan Wu <cooloney@kernel.org> wrote:
>>
>> On Wed, Mar 11, 2009 at 3:29 PM,  <graff.yang@gmail.com> wrote:
>> > From: Graff Yang <graff.yang@gmail.com>
>> >
>>
>> Generally, you need to change the title to '[PATCH] [net/irda]: new
>> Blackfin on-chip SIR IrDA driver (v2)" and add some change log here.
>> Because people don't want to review the whole code again and they just
>> want to know you updated something according to the LKML discussion.
>>
>> v1-v2:
>>  - item1
>>  - item2
>>
>> Something like this. Hope this is helpful, -:))
>> -Bryan
>>
>> > Signed-off-by: Graff Yang <graff.yang@gmail.com>
>> > ---
>> >  drivers/net/irda/Kconfig    |   45 +++
>> >  drivers/net/irda/Makefile   |    1 +
>> >  drivers/net/irda/bfin_sir.c |  814
>> > +++++++++++++++++++++++++++++++++++++++++++
>> >  drivers/net/irda/bfin_sir.h |  147 ++++++++
>> >  4 files changed, 1007 insertions(+), 0 deletions(-)
>> >  create mode 100644 drivers/net/irda/bfin_sir.c
>> >  create mode 100644 drivers/net/irda/bfin_sir.h
>> >
>> > diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
>> > index e631755..985fec9 100644
>> > --- a/drivers/net/irda/Kconfig
>> > +++ b/drivers/net/irda/Kconfig
>> > @@ -17,6 +17,51 @@ config IRTTY_SIR
>> >
>> >          If unsure, say Y.
>> >
>> > +config BFIN_SIR
>> > +       tristate "Blackfin SIR on UART"
>> > +       depends on BLACKFIN && IRDA
>> > +       default n
>> > +       help
>> > +         Say Y here if your want to enable SIR function on Blackfin
>> > UART
>> > +         devices.
>> > +
>> > +         To activate this driver you can start irattach like:
>> > +         "irattach irda0 -s"
>> > +
>> > +         Saying M, it will be built as a module named bfin_sir.
>> > +
>> > +         Note that you need to turn off one of the serial drivers for
>> > SIR
>> > +         to use that UART.
>> > +
>> > +config BFIN_SIR0
>> > +       bool "Blackfin SIR on UART0"
>> > +       depends on BFIN_SIR && !SERIAL_BFIN_UART0
>> > +
>> > +config BFIN_SIR1
>> > +       bool "Blackfin SIR on UART1"
>> > +       depends on BFIN_SIR && !SERIAL_BFIN_UART1 && (!BF531 && !BF532
>> > && !BF533 && !BF561)
>> > +
>> > +config BFIN_SIR2
>> > +       bool "Blackfin SIR on UART2"
>> > +       depends on BFIN_SIR && !SERIAL_BFIN_UART2 && (BF54x || BF538 ||
>> > BF539)
>> > +
>> > +config BFIN_SIR3
>> > +       bool "Blackfin SIR on UART3"
>> > +       depends on BFIN_SIR && !SERIAL_BFIN_UART3 && (BF54x)
>> > +
>> > +choice
>> > +       prompt "SIR Mode"
>> > +       depends on BFIN_SIR
>> > +       default SIR_BFIN_DMA
>> > +
>> > +config SIR_BFIN_DMA
>> > +       bool "DMA mode"
>> > +       depends on !DMA_UNCACHED_NONE
>> > +
>> > +config SIR_BFIN_PIO
>> > +       bool "PIO mode"
>> > +endchoice
>> > +
>> >  comment "Dongle support"
>> >
>> >  config DONGLE
>> > diff --git a/drivers/net/irda/Makefile b/drivers/net/irda/Makefile
>> > index 5d20fde..d82e1e3 100644
>> > --- a/drivers/net/irda/Makefile
>> > +++ b/drivers/net/irda/Makefile
>> > @@ -21,6 +21,7 @@ obj-$(CONFIG_MCS_FIR)         += mcs7780.o
>> >  obj-$(CONFIG_AU1000_FIR)       += au1k_ir.o
>> >  # SIR drivers
>> >  obj-$(CONFIG_IRTTY_SIR)                += irtty-sir.o  sir-dev.o
>> > +obj-$(CONFIG_BFIN_SIR)         += bfin_sir.o
>> >  # dongle drivers for SIR drivers
>> >  obj-$(CONFIG_ESI_DONGLE)       += esi-sir.o
>> >  obj-$(CONFIG_TEKRAM_DONGLE)    += tekram-sir.o
>> > diff --git a/drivers/net/irda/bfin_sir.c b/drivers/net/irda/bfin_sir.c
>> > new file mode 100644
>> > index 0000000..38584cc
>> > --- /dev/null
>> > +++ b/drivers/net/irda/bfin_sir.c
>> > @@ -0,0 +1,814 @@
>> > +/*
>> > + * Blackfin Infra-red Driver
>> > + *
>> > + * Copyright 2006-2009 Analog Devices Inc.
>> > + *
>> > + * Enter bugs at http://blackfin.uclinux.org/
>> > + *
>> > + * Licensed under the GPL-2 or later.
>> > + *
>> > + */
>> > +#include "bfin_sir.h"
>> > +
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +#define DMA_SIR_RX_XCNT        10
>> > +#define DMA_SIR_RX_YCNT        (PAGE_SIZE / DMA_SIR_RX_XCNT)
>> > +#define DMA_SIR_RX_FLUSH_JIFS  (HZ * 4 / 250)
>> > +#endif
>> > +
>> > +#if ANOMALY_05000447
>> > +static int max_rate = 57600;
>> > +#else
>> > +static int max_rate = 115200;
>> > +#endif
>> > +
>> > +static void turnaround_delay(unsigned long last_jif, int mtt)
>> > +{
>> > +       long ticks;
>> > +
>> > +       mtt = mtt < 10000 ? 10000 : mtt;
>> > +       ticks = 1 + mtt / (USEC_PER_SEC / HZ);
>> > +       schedule_timeout_uninterruptible(ticks);
>> > +}
>> > +
>> > +static void __devinit bfin_sir_init_ports(struct bfin_sir_port *sp,
>> > struct platform_device *pdev)
>> > +{
>> > +       int i;
>> > +       struct resource *res;
>> > +
>> > +       for (i = 0; i < pdev->num_resources; i++) {
>> > +               res = &pdev->resource[i];
>> > +               switch (res->flags) {
>> > +               case IORESOURCE_MEM:
>> > +                       sp->membase   = (void __iomem *)res->start;
>> > +                       break;
>> > +               case IORESOURCE_IRQ:
>> > +                       sp->irq = res->start;
>> > +                       break;
>> > +               case IORESOURCE_DMA:
>> > +                       sp->rx_dma_channel = res->start;
>> > +                       sp->tx_dma_channel = res->end;
>> > +                       break;
>> > +               default:
>> > +                       break;
>> > +               }
>> > +       }
>> > +
>> > +       sp->clk = get_sclk();
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +       sp->tx_done        = 1;
>> > +       init_timer(&(sp->rx_dma_timer));
>> > +#endif
>> > +}
>> > +
>> > +static void bfin_sir_stop_tx(struct bfin_sir_port *port)
>> > +{
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +       disable_dma(port->tx_dma_channel);
>> > +#endif
>> > +
>> > +       while (!(SIR_UART_GET_LSR(port) & THRE)) {
>> > +               cpu_relax();
>> > +               continue;
>> > +       }
>> > +
>> > +       SIR_UART_STOP_TX(port);
>> > +}
>> > +
>> > +static void bfin_sir_enable_tx(struct bfin_sir_port *port)
>> > +{
>> > +       SIR_UART_ENABLE_TX(port);
>> > +}
>> > +
>> > +static void bfin_sir_stop_rx(struct bfin_sir_port *port)
>> > +{
>> > +       SIR_UART_STOP_RX(port);
>> > +}
>> > +
>> > +static void bfin_sir_enable_rx(struct bfin_sir_port *port)
>> > +{
>> > +       SIR_UART_ENABLE_RX(port);
>> > +}
>> > +
>> > +static int bfin_sir_set_speed(struct bfin_sir_port *port, int speed)
>> > +{
>> > +       int ret = -EINVAL;
>> > +       unsigned int quot;
>> > +       unsigned short val, lsr, lcr;
>> > +       static int utime;
>> > +       int count = 10;
>> > +
>> > +       lcr = WLS(8);
>> > +
>> > +       switch (speed) {
>> > +       case 9600:
>> > +       case 19200:
>> > +       case 38400:
>> > +       case 57600:
>> > +       case 115200:
>> > +
>> > +               quot = (port->clk + (8 * speed)) / (16 * speed)\
>> > +                                               - ANOMALY_05000230;
>> > +
>> > +               do {
>> > +                       udelay(utime);
>> > +                       lsr = SIR_UART_GET_LSR(port);
>> > +               } while (!(lsr & TEMT) && count--);
>> > +
>> > +               /* The useconds for 1 bits to transmit */
>> > +               utime = 1000000 / speed + 1;
>> > +
>> > +               /* Clear UCEN bit to reset the UART state machine
>> > +                * and control registers
>> > +                */
>> > +               val = SIR_UART_GET_GCTL(port);
>> > +               val &= ~UCEN;
>> > +               SIR_UART_PUT_GCTL(port, val);
>> > +
>> > +               /* Set DLAB in LCR to Access THR RBR IER */
>> > +               SIR_UART_SET_DLAB(port);
>> > +               SSYNC();
>> > +
>> > +               SIR_UART_PUT_DLL(port, quot & 0xFF);
>> > +               SIR_UART_PUT_DLH(port, (quot >> 8) & 0xFF);
>> > +               SSYNC();
>> > +
>> > +               /* Clear DLAB in LCR */
>> > +               SIR_UART_CLEAR_DLAB(port);
>> > +               SSYNC();
>> > +
>> > +               SIR_UART_PUT_LCR(port, lcr);
>> > +
>> > +               val = SIR_UART_GET_GCTL(port);
>> > +               val |= UCEN;
>> > +               SIR_UART_PUT_GCTL(port, val);
>> > +
>> > +               ret = 0;
>> > +               break;
>> > +       default:
>> > +               printk(KERN_WARNING "bfin_sir: Invalid speed %d\n",
>> > speed);
>> > +               break;
>> > +       }
>> > +
>> > +       val = SIR_UART_GET_GCTL(port);
>> > +       /* If not add the 'RPOLC', we can't catch the receive interrupt.
>> > +        * It's related with the HW layout and the IR transiver.
>> > +        */
>> > +       val |= IREN | RPOLC;
>> > +       SIR_UART_PUT_GCTL(port, val);
>> > +       return ret;
>> > +}
>> > +
>> > +static int bfin_sir_is_receiving(struct net_device *dev)
>> > +{
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +
>> > +       if (!(SIR_UART_GET_IER(port) & ERBFI))
>> > +               return 0;
>> > +       return self->rx_buff.state != OUTSIDE_FRAME;
>> > +}
>> > +
>> > +#ifdef CONFIG_SIR_BFIN_PIO
>> > +static void bfin_sir_tx_chars(struct net_device *dev)
>> > +{
>> > +       unsigned int chr;
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +
>> > +       if (self->tx_buff.len != 0) {
>> > +               chr = *(self->tx_buff.data);
>> > +               SIR_UART_PUT_CHAR(port, chr);
>> > +               self->tx_buff.data++;
>> > +               self->tx_buff.len--;
>> > +       } else {
>> > +               self->stats.tx_packets++;
>> > +               self->stats.tx_bytes += self->tx_buff.data -
>> > self->tx_buff.head;
>> > +               if (self->newspeed) {
>> > +                       bfin_sir_set_speed(port, self->newspeed);
>> > +                       self->speed = self->newspeed;
>> > +                       self->newspeed = 0;
>> > +               }
>> > +               bfin_sir_stop_tx(port);
>> > +               bfin_sir_enable_rx(port);
>> > +               /* I'm hungry! */
>> > +               netif_wake_queue(dev);
>> > +       }
>> > +}
>> > +
>> > +static void bfin_sir_rx_chars(struct net_device *dev)
>> > +{
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +       unsigned char ch;
>> > +
>> > +       SIR_UART_CLEAR_LSR(port);
>> > +       ch = SIR_UART_GET_CHAR(port);
>> > +       async_unwrap_char(dev, &self->stats, &self->rx_buff, ch);
>> > +       dev->last_rx = jiffies;
>> > +}
>> > +
>> > +static irqreturn_t bfin_sir_rx_int(int irq, void *dev_id)
>> > +{
>> > +       struct net_device *dev = dev_id;
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +
>> > +       spin_lock(&self->lock);
>> > +       while ((SIR_UART_GET_LSR(port) & DR))
>> > +               bfin_sir_rx_chars(dev);
>> > +       spin_unlock(&self->lock);
>> > +
>> > +       return IRQ_HANDLED;
>> > +}
>> > +
>> > +static irqreturn_t bfin_sir_tx_int(int irq, void *dev_id)
>> > +{
>> > +       struct net_device *dev = dev_id;
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +
>> > +       spin_lock(&self->lock);
>> > +       if (SIR_UART_GET_LSR(port) & THRE)
>> > +               bfin_sir_tx_chars(dev);
>> > +       spin_unlock(&self->lock);
>> > +
>> > +       return IRQ_HANDLED;
>> > +}
>> > +#endif /* CONFIG_SIR_BFIN_PIO */
>> > +
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +static void bfin_sir_dma_tx_chars(struct net_device *dev)
>> > +{
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +
>> > +       if (!port->tx_done)
>> > +               return;
>> > +       port->tx_done = 0;
>> > +
>> > +       if (self->tx_buff.len == 0) {
>> > +               self->stats.tx_packets++;
>> > +               if (self->newspeed) {
>> > +                       bfin_sir_set_speed(port, self->newspeed);
>> > +                       self->speed = self->newspeed;
>> > +                       self->newspeed = 0;
>> > +               }
>> > +               bfin_sir_enable_rx(port);
>> > +               port->tx_done = 1;
>> > +               netif_wake_queue(dev);
>> > +               return;
>> > +       }
>> > +
>> > +       blackfin_dcache_flush_range((unsigned long)(self->tx_buff.data),
>> > +               (unsigned long)(self->tx_buff.data+self->tx_buff.len));
>> > +       set_dma_config(port->tx_dma_channel,
>> > +               set_bfin_dma_config(DIR_READ, DMA_FLOW_STOP,
>> > +                       INTR_ON_BUF, DIMENSION_LINEAR, DATA_SIZE_8,
>> > +                       DMA_SYNC_RESTART));
>> > +       set_dma_start_addr(port->tx_dma_channel,
>> > +               (unsigned long)(self->tx_buff.data));
>> > +       set_dma_x_count(port->tx_dma_channel, self->tx_buff.len);
>> > +       set_dma_x_modify(port->tx_dma_channel, 1);
>> > +       enable_dma(port->tx_dma_channel);
>> > +}
>> > +
>> > +static irqreturn_t bfin_sir_dma_tx_int(int irq, void *dev_id)
>> > +{
>> > +       struct net_device *dev = dev_id;
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +
>> > +       spin_lock(&self->lock);
>> > +       if (!(get_dma_curr_irqstat(port->tx_dma_channel) & DMA_RUN)) {
>> > +               clear_dma_irqstat(port->tx_dma_channel);
>> > +               bfin_sir_stop_tx(port);
>> > +
>> > +               self->stats.tx_packets++;
>> > +               self->stats.tx_bytes += self->tx_buff.len;
>> > +               self->tx_buff.len = 0;
>> > +               if (self->newspeed) {
>> > +                       bfin_sir_set_speed(port, self->newspeed);
>> > +                       self->speed = self->newspeed;
>> > +                       self->newspeed = 0;
>> > +               }
>> > +               bfin_sir_enable_rx(port);
>> > +               /* I'm hungry! */
>> > +               netif_wake_queue(dev);
>> > +               port->tx_done = 1;
>> > +       }
>> > +       spin_unlock(&self->lock);
>> > +
>> > +       return IRQ_HANDLED;
>> > +}
>> > +
>> > +static void bfin_sir_dma_rx_chars(struct net_device *dev)
>> > +{
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +       int i;
>> > +
>> > +       SIR_UART_CLEAR_LSR(port);
>> > +
>> > +       for (i = port->rx_dma_buf.head; i < port->rx_dma_buf.tail; i++)
>> > +               async_unwrap_char(dev, &self->stats, &self->rx_buff,
>> > port->rx_dma_buf.buf[i]);
>> > +}
>> > +
>> > +void bfin_sir_rx_dma_timeout(struct net_device *dev)
>> > +{
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +       int x_pos, pos;
>> > +       unsigned long flags;
>> > +
>> > +       spin_lock_irqsave(&self->lock, flags);
>> > +       x_pos = DMA_SIR_RX_XCNT -
>> > get_dma_curr_xcount(port->rx_dma_channel);
>> > +       if (x_pos == DMA_SIR_RX_XCNT)
>> > +               x_pos = 0;
>> > +
>> > +       pos = port->rx_dma_nrows * DMA_SIR_RX_XCNT + x_pos;
>> > +
>> > +       if (pos > port->rx_dma_buf.tail) {
>> > +               port->rx_dma_buf.tail = pos;
>> > +               bfin_sir_dma_rx_chars(dev);
>> > +               port->rx_dma_buf.head = port->rx_dma_buf.tail;
>> > +       }
>> > +       spin_unlock_irqrestore(&self->lock, flags);
>> > +}
>> > +
>> > +static irqreturn_t bfin_sir_dma_rx_int(int irq, void *dev_id)
>> > +{
>> > +       struct net_device *dev = dev_id;
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +       unsigned short irqstat;
>> > +
>> > +       spin_lock(&self->lock);
>> > +
>> > +       port->rx_dma_nrows++;
>> > +       port->rx_dma_buf.tail = DMA_SIR_RX_XCNT * port->rx_dma_nrows;
>> > +       bfin_sir_dma_rx_chars(dev);
>> > +       if (port->rx_dma_nrows >= DMA_SIR_RX_YCNT) {
>> > +               port->rx_dma_nrows = 0;
>> > +               port->rx_dma_buf.tail = 0;
>> > +       }
>> > +       port->rx_dma_buf.head = port->rx_dma_buf.tail;
>> > +
>> > +       irqstat = get_dma_curr_irqstat(port->rx_dma_channel);
>> > +       clear_dma_irqstat(port->rx_dma_channel);
>> > +       spin_unlock(&self->lock);
>> > +
>> > +       mod_timer(&port->rx_dma_timer, jiffies + DMA_SIR_RX_FLUSH_JIFS);
>> > +       return IRQ_HANDLED;
>> > +}
>> > +#endif /* CONFIG_SIR_BFIN_DMA */
>> > +
>> > +static int bfin_sir_startup(struct bfin_sir_port *port, struct
>> > net_device *dev)
>> > +{
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +       dma_addr_t dma_handle;
>> > +#endif /* CONFIG_SIR_BFIN_DMA */
>> > +
>> > +       if (request_dma(port->rx_dma_channel, "BFIN_UART_RX") < 0) {
>> > +               dev_warn(&dev->dev, "Unable to attach SIR RX DMA
>> > channel\n");
>> > +               return -EBUSY;
>> > +       }
>> > +
>> > +       if (request_dma(port->tx_dma_channel, "BFIN_UART_TX") < 0) {
>> > +               dev_warn(&dev->dev, "Unable to attach SIR TX DMA
>> > channel\n");
>> > +               free_dma(port->rx_dma_channel);
>> > +               return -EBUSY;
>> > +       }
>> > +
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +
>> > +       set_dma_callback(port->rx_dma_channel, bfin_sir_dma_rx_int,
>> > dev);
>> > +       set_dma_callback(port->tx_dma_channel, bfin_sir_dma_tx_int,
>> > dev);
>> > +
>> > +       port->rx_dma_buf.buf = (unsigned char *)dma_alloc_coherent(NULL,
>> > PAGE_SIZE, &dma_handle, GFP_DMA);
>> > +       port->rx_dma_buf.head = 0;
>> > +       port->rx_dma_buf.tail = 0;
>> > +       port->rx_dma_nrows = 0;
>> > +
>> > +       set_dma_config(port->rx_dma_channel,
>> > +                               set_bfin_dma_config(DIR_WRITE,
>> > DMA_FLOW_AUTO,
>> > +
>> > INTR_ON_ROW, DIMENSION_2D,
>> > +
>> > DATA_SIZE_8, DMA_SYNC_RESTART));
>> > +       set_dma_x_count(port->rx_dma_channel, DMA_SIR_RX_XCNT);
>> > +       set_dma_x_modify(port->rx_dma_channel, 1);
>> > +       set_dma_y_count(port->rx_dma_channel, DMA_SIR_RX_YCNT);
>> > +       set_dma_y_modify(port->rx_dma_channel, 1);
>> > +       set_dma_start_addr(port->rx_dma_channel, (unsigned
>> > long)port->rx_dma_buf.buf);
>> > +       enable_dma(port->rx_dma_channel);
>> > +
>> > +       port->rx_dma_timer.data = (unsigned long)(dev);
>> > +       port->rx_dma_timer.function = (void *)bfin_sir_rx_dma_timeout;
>> > +
>> > +#else
>> > +
>> > +       if (request_irq(port->irq, bfin_sir_rx_int, IRQF_DISABLED,
>> > "BFIN_SIR_RX", dev)) {
>> > +               dev_warn(&dev->dev, "Unable to attach SIR RX
>> > interrupt\n");
>> > +               return -EBUSY;
>> > +       }
>> > +
>> > +       if (request_irq(port->irq+1, bfin_sir_tx_int, IRQF_DISABLED,
>> > "BFIN_SIR_TX", dev)) {
>> > +               dev_warn(&dev->dev, "Unable to attach SIR TX
>> > interrupt\n");
>> > +               free_irq(port->irq, dev);
>> > +               return -EBUSY;
>> > +       }
>> > +#endif
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +static void bfin_sir_shutdown(struct bfin_sir_port *port, struct
>> > net_device *dev)
>> > +{
>> > +       unsigned short val;
>> > +
>> > +       bfin_sir_stop_rx(port);
>> > +       SIR_UART_DISABLE_INTS(port);
>> > +
>> > +       val = SIR_UART_GET_GCTL(port);
>> > +       val &= ~(UCEN | IREN | RPOLC);
>> > +       SIR_UART_PUT_GCTL(port, val);
>> > +
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +       disable_dma(port->tx_dma_channel);
>> > +       disable_dma(port->rx_dma_channel);
>> > +       del_timer(&(port->rx_dma_timer));
>> > +       dma_free_coherent(NULL, PAGE_SIZE, port->rx_dma_buf.buf, 0);
>> > +#else
>> > +       free_irq(port->irq+1, dev);
>> > +       free_irq(port->irq, dev);
>> > +#endif
>> > +       free_dma(port->tx_dma_channel);
>> > +       free_dma(port->rx_dma_channel);
>> > +}
>> > +
>> > +#ifdef CONFIG_PM
>> > +static int bfin_sir_suspend(struct platform_device *pdev, pm_message_t
>> > state)
>> > +{
>> > +       struct bfin_sir_port *sir_port;
>> > +       struct net_device *dev;
>> > +       struct bfin_sir_self *self;
>> > +
>> > +       sir_port = platform_get_drvdata(pdev);
>> > +       if (!sir_port)
>> > +               return 0;
>> > +
>> > +       dev = sir_port->dev;
>> > +       self = netdev_priv(dev);
>> > +       if (self->open) {
>> > +               flush_work(&self->work);
>> > +               bfin_sir_shutdown(self->sir_port, dev);
>> > +               netif_device_detach(dev);
>> > +       }
>> > +
>> > +       return 0;
>> > +}
>> > +static int bfin_sir_resume(struct platform_device *pdev)
>> > +{
>> > +       struct bfin_sir_port *sir_port;
>> > +       struct net_device *dev;
>> > +       struct bfin_sir_self *self;
>> > +       struct bfin_sir_port *port;
>> > +
>> > +       sir_port = platform_get_drvdata(pdev);
>> > +       if (!sir_port)
>> > +               return 0;
>> > +
>> > +       dev = sir_port->dev;
>> > +       self = netdev_priv(dev);
>> > +       port = self->sir_port;
>> > +       if (self->open) {
>> > +               if (self->newspeed) {
>> > +                       self->speed = self->newspeed;
>> > +                       self->newspeed = 0;
>> > +               }
>> > +               bfin_sir_startup(port, dev);
>> > +               bfin_sir_set_speed(port, 9600);
>> > +               bfin_sir_enable_rx(port);
>> > +               netif_device_attach(dev);
>> > +       }
>> > +       return 0;
>> > +}
>> > +#else
>> > +#define bfin_sir_suspend   NULL
>> > +#define bfin_sir_resume    NULL
>> > +#endif
>> > +
>> > +static void bfin_sir_send_work(struct work_struct *work)
>> > +{
>> > +       struct bfin_sir_self  *self = container_of(work, struct
>> > bfin_sir_self, work);
>> > +       struct net_device *dev = self->sir_port->dev;
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +       unsigned short val;
>> > +       int tx_cnt = 10;
>> > +
>> > +       while (bfin_sir_is_receiving(dev) && --tx_cnt)
>> > +               turnaround_delay(dev->last_rx, self->mtt);
>> > +
>> > +       bfin_sir_stop_rx(port);
>> > +
>> > +       /* To avoid losting RX interrupt, we reset IR function before
>> > +        * sending data. We also can set the speed, which will
>> > +        * reset all the UART.
>> > +        */
>> > +       val = SIR_UART_GET_GCTL(port);
>> > +       val &= ~(IREN | RPOLC);
>> > +       SIR_UART_PUT_GCTL(port, val);
>> > +       SSYNC();
>> > +       val |= IREN | RPOLC;
>> > +       SIR_UART_PUT_GCTL(port, val);
>> > +       SSYNC();
>> > +       /* bfin_sir_set_speed(port, self->speed); */
>> > +
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +       bfin_sir_dma_tx_chars(dev);
>> > +#endif
>> > +       bfin_sir_enable_tx(port);
>> > +       dev->trans_start = jiffies;
>> > +}
>> > +
>> > +static int bfin_sir_hard_xmit(struct sk_buff *skb, struct net_device
>> > *dev)
>> > +{
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       int speed = irda_get_next_speed(skb);
>> > +
>> > +       netif_stop_queue(dev);
>> > +
>> > +       self->mtt = irda_get_mtt(skb);
>> > +
>> > +       if (speed != self->speed && speed != -1)
>> > +               self->newspeed = speed;
>> > +
>> > +       self->tx_buff.data = self->tx_buff.head;
>> > +       if (skb->len == 0)
>> > +               self->tx_buff.len = 0;
>> > +       else
>> > +               self->tx_buff.len = async_wrap_skb(skb,
>> > self->tx_buff.data, self->tx_buff.truesize);
>> > +
>> > +       schedule_work(&self->work);
>> > +       dev_kfree_skb(skb);
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +static int bfin_sir_ioctl(struct net_device *dev, struct ifreq *ifreq,
>> > int cmd)
>> > +{
>> > +       struct if_irda_req *rq = (struct if_irda_req *)ifreq;
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +       int ret = 0;
>> > +
>> > +       switch (cmd) {
>> > +       case SIOCSBANDWIDTH:
>> > +               if (capable(CAP_NET_ADMIN)) {
>> > +                       if (self->open) {
>> > +                               ret = bfin_sir_set_speed(port,
>> > rq->ifr_baudrate);
>> > +                               bfin_sir_enable_rx(port);
>> > +                       } else {
>> > +                               dev_warn(&dev->dev, "SIOCSBANDWIDTH:
>> > !netif_running\n");
>> > +                               ret = 0;
>> > +                       }
>> > +               }
>> > +               break;
>> > +
>> > +       case SIOCSMEDIABUSY:
>> > +               ret = -EPERM;
>> > +               if (capable(CAP_NET_ADMIN)) {
>> > +                       irda_device_set_media_busy(dev, TRUE);
>> > +                       ret = 0;
>> > +               }
>> > +               break;
>> > +
>> > +       case SIOCGRECEIVING:
>> > +               rq->ifr_receiving = bfin_sir_is_receiving(dev);
>> > +               break;
>> > +
>> > +       default:
>> > +               ret = -EOPNOTSUPP;
>> > +               break;
>> > +       }
>> > +
>> > +       return ret;
>> > +}
>> > +
>> > +static struct net_device_stats *bfin_sir_stats(struct net_device *dev)
>> > +{
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +
>> > +       return &self->stats;
>> > +}
>> > +
>> > +static int bfin_sir_open(struct net_device *dev)
>> > +{
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +       struct bfin_sir_port *port = self->sir_port;
>> > +       int err = -ENOMEM;
>> > +
>> > +       self->newspeed = 0;
>> > +       self->speed = 9600;
>> > +
>> > +       spin_lock_init(&self->lock);
>> > +
>> > +       err = bfin_sir_startup(port, dev);
>> > +       if (err)
>> > +               goto err_startup;
>> > +
>> > +       bfin_sir_set_speed(port, 9600);
>> > +
>> > +       self->irlap = irlap_open(dev, &self->qos, DRIVER_NAME);
>> > +       if (!self->irlap)
>> > +               goto err_irlap;
>> > +
>> > +       INIT_WORK(&self->work, bfin_sir_send_work);
>> > +
>> > +       /*
>> > +        * Now enable the interrupt then start the queue
>> > +        */
>> > +       self->open = 1;
>> > +       bfin_sir_enable_rx(port);
>> > +
>> > +       netif_start_queue(dev);
>> > +
>> > +       return 0;
>> > +
>> > +err_irlap:
>> > +       self->open = 0;
>> > +       bfin_sir_shutdown(port, dev);
>> > +err_startup:
>> > +       return err;
>> > +}
>> > +
>> > +static int bfin_sir_stop(struct net_device *dev)
>> > +{
>> > +       struct bfin_sir_self *self = netdev_priv(dev);
>> > +
>> > +       flush_work(&self->work);
>> > +       bfin_sir_shutdown(self->sir_port, dev);
>> > +
>> > +       if (self->rxskb) {
>> > +               dev_kfree_skb(self->rxskb);
>> > +               self->rxskb = NULL;
>> > +       }
>> > +
>> > +       /* Stop IrLAP */
>> > +       if (self->irlap) {
>> > +               irlap_close(self->irlap);
>> > +               self->irlap = NULL;
>> > +       }
>> > +
>> > +       netif_stop_queue(dev);
>> > +       self->open = 0;
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +static int bfin_sir_init_iobuf(iobuff_t *io, int size)
>> > +{
>> > +       io->head = kmalloc(size, GFP_KERNEL);
>> > +       if (!io->head)
>> > +               return -ENOMEM;
>> > +       io->truesize = size;
>> > +       io->in_frame = FALSE;
>> > +       io->state    = OUTSIDE_FRAME;
>> > +       io->data     = io->head;
>> > +       return 0;
>> > +}
>> > +
>> > +static int __devinit bfin_sir_probe(struct platform_device *pdev)
>> > +{
>> > +       struct net_device *dev;
>> > +       struct bfin_sir_self *self;
>> > +       unsigned int baudrate_mask;
>> > +       struct bfin_sir_port *sir_port;
>> > +       int err;
>> > +
>> > +       err = peripheral_request_list(per[pdev->id], DRIVER_NAME);
>> > +       if (err)
>> > +               return err;
>> > +
>> > +       err = -ENOMEM;
>> > +       sir_port = kmalloc(sizeof(*sir_port), GFP_KERNEL);
>> > +       if (!sir_port)
>> > +               goto err_mem_0;
>> > +
>> > +       bfin_sir_init_ports(sir_port, pdev);
>> > +
>> > +       dev = alloc_irdadev(sizeof(*self));
>> > +       if (!dev)
>> > +               goto err_mem_1;
>> > +
>> > +       self = netdev_priv(dev);
>> > +       self->dev = &pdev->dev;
>> > +       self->sir_port = sir_port;
>> > +       sir_port->dev = dev;
>> > +
>> > +       err = bfin_sir_init_iobuf(&self->rx_buff, IRDA_SKB_MAX_MTU);
>> > +       if (err)
>> > +               goto err_mem_2;
>> > +       err = bfin_sir_init_iobuf(&self->tx_buff, IRDA_SIR_MAX_FRAME);
>> > +       if (err)
>> > +               goto err_mem_3;
>> > +
>> > +       dev->hard_start_xmit = bfin_sir_hard_xmit;
>> > +       dev->open            = bfin_sir_open;
>> > +       dev->stop            = bfin_sir_stop;
>> > +       dev->do_ioctl        = bfin_sir_ioctl;
>> > +       dev->get_stats       = bfin_sir_stats;
>> > +       dev->irq             = sir_port->irq;
>> > +
>> > +       irda_init_max_qos_capabilies(&self->qos);
>> > +
>> > +       baudrate_mask = IR_9600;
>> > +
>> > +       switch (max_rate) {
>> > +       case 115200:
>> > +               baudrate_mask |= IR_115200;
>> > +       case 57600:
>> > +               baudrate_mask |= IR_57600;
>> > +       case 38400:
>> > +               baudrate_mask |= IR_38400;
>> > +       case 19200:
>> > +               baudrate_mask |= IR_19200;
>> > +       case 9600:
>> > +               break;
>> > +       default:
>> > +               printk(KERN_WARNING "bfin_sir: Invalid maximum baud
>> > rate, using 9600\n");
>> > +       }
>> > +
>> > +       self->qos.baud_rate.bits &= baudrate_mask;
>> > +
>> > +       self->qos.min_turn_time.bits = 1; /* 10 ms or more */
>> > +
>> > +       irda_qos_bits_to_value(&self->qos);
>> > +
>> > +       err = register_netdev(dev);
>> > +
>> > +       if (err) {
>> > +               kfree(self->tx_buff.head);
>> > +err_mem_3:
>> > +               kfree(self->rx_buff.head);
>> > +err_mem_2:
>> > +               free_netdev(dev);
>> > +err_mem_1:
>> > +               kfree(sir_port);
>> > +err_mem_0:
>> > +               peripheral_free_list(per[pdev->id]);
>> > +       } else
>> > +               platform_set_drvdata(pdev, sir_port);
>> > +
>> > +       return err;
>> > +}
>> > +
>> > +static int __devexit bfin_sir_remove(struct platform_device *pdev)
>> > +{
>> > +       struct bfin_sir_port *sir_port;
>> > +       struct net_device *dev = NULL;
>> > +       struct bfin_sir_self *self;
>> > +
>> > +       sir_port = platform_get_drvdata(pdev);
>> > +       if (!sir_port)
>> > +               return 0;
>> > +       dev = sir_port->dev;
>> > +       self = netdev_priv(dev);
>> > +       unregister_netdev(dev);
>> > +       kfree(self->tx_buff.head);
>> > +       kfree(self->rx_buff.head);
>> > +       free_netdev(dev);
>> > +       kfree(sir_port);
>> > +       platform_set_drvdata(pdev, NULL);
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +static struct platform_driver bfin_ir_driver = {
>> > +       .probe   = bfin_sir_probe,
>> > +       .remove  = __devexit_p(bfin_sir_remove),
>> > +       .suspend = bfin_sir_suspend,
>> > +       .resume  = bfin_sir_resume,
>> > +       .driver  = {
>> > +               .name = DRIVER_NAME,
>> > +       },
>> > +};
>> > +
>> > +static int __init bfin_sir_init(void)
>> > +{
>> > +       return platform_driver_register(&bfin_ir_driver);
>> > +}
>> > +
>> > +static void __exit bfin_sir_exit(void)
>> > +{
>> > +       platform_driver_unregister(&bfin_ir_driver);
>> > +}
>> > +
>> > +module_init(bfin_sir_init);
>> > +module_exit(bfin_sir_exit);
>> > +
>> > +module_param(max_rate, int, 0);
>> > +MODULE_PARM_DESC(max_rate, "Maximum baud rate (115200, 57600, 38400,
>> > 19200, 9600)");
>> > +
>> > +MODULE_AUTHOR("Graf Yang <graf.yang@analog.com>");
>> > +MODULE_DESCRIPTION("Blackfin IrDA driver");
>> > +MODULE_LICENSE("GPL");
>> > diff --git a/drivers/net/irda/bfin_sir.h b/drivers/net/irda/bfin_sir.h
>> > new file mode 100644
>> > index 0000000..a723257
>> > --- /dev/null
>> > +++ b/drivers/net/irda/bfin_sir.h
>> > @@ -0,0 +1,147 @@
>> > +/*
>> > + * Blackfin Infra-red Driver
>> > + *
>> > + * Copyright 2006-2009 Analog Devices Inc.
>> > + *
>> > + * Enter bugs at http://blackfin.uclinux.org/
>> > + *
>> > + * Licensed under the GPL-2 or later.
>> > + *
>> > + */
>> > +
>> > +#include <linux/serial.h>
>> > +#include <linux/module.h>
>> > +#include <linux/netdevice.h>
>> > +#include <linux/interrupt.h>
>> > +#include <linux/delay.h>
>> > +#include <linux/platform_device.h>
>> > +#include <linux/dma-mapping.h>
>> > +
>> > +#include <net/irda/irda.h>
>> > +#include <net/irda/wrapper.h>
>> > +#include <net/irda/irda_device.h>
>> > +
>> > +#include <asm/irq.h>
>> > +#include <asm/cacheflush.h>
>> > +#include <asm/dma.h>
>> > +#include <asm/portmux.h>
>> > +
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +struct dma_rx_buf {
>> > +       char *buf;
>> > +       int head;
>> > +       int tail;
>> > +};
>> > +#endif
>> > +
>> > +struct bfin_sir_port {
>> > +       unsigned char __iomem   *membase;
>> > +       unsigned int            irq;
>> > +       unsigned int            lsr;
>> > +       unsigned long           clk;
>> > +       struct net_device       *dev;
>> > +#ifdef CONFIG_SIR_BFIN_DMA
>> > +       int                     tx_done;
>> > +       struct dma_rx_buf       rx_dma_buf;
>> > +       struct timer_list       rx_dma_timer;
>> > +       int                     rx_dma_nrows;
>> > +#endif
>> > +       unsigned int            tx_dma_channel;
>> > +       unsigned int            rx_dma_channel;
>> > +};
>> > +
>> > +struct bfin_sir_port_res {
>> > +       unsigned long   base_addr;
>> > +       int             irq;
>> > +       unsigned int    rx_dma_channel;
>> > +       unsigned int    tx_dma_channel;
>> > +};
>> > +
>> > +struct bfin_sir_self {
>> > +       struct bfin_sir_port    *sir_port;
>> > +       spinlock_t              lock;
>> > +       unsigned int            open;
>> > +       int                     speed;
>> > +       int                     newspeed;
>> > +
>> > +       struct sk_buff          *txskb;
>> > +       struct sk_buff          *rxskb;
>> > +       struct net_device_stats stats;
>> > +       struct device           *dev;
>> > +       struct irlap_cb         *irlap;
>> > +       struct qos_info         qos;
>> > +
>> > +       iobuff_t                tx_buff;
>> > +       iobuff_t                rx_buff;
>> > +
>> > +       struct work_struct      work;
>> > +       int                     mtt;
>> > +};
>> > +
>> > +#define DRIVER_NAME "bfin_sir"
>> > +
>> > +#define SIR_UART_GET_CHAR(port)    bfin_read16((port)->membase +
>> > OFFSET_RBR)
>> > +#define SIR_UART_GET_DLL(port)     bfin_read16((port)->membase +
>> > OFFSET_DLL)
>> > +#define SIR_UART_GET_DLH(port)     bfin_read16((port)->membase +
>> > OFFSET_DLH)
>> > +#define SIR_UART_GET_LCR(port)     bfin_read16((port)->membase +
>> > OFFSET_LCR)
>> > +#define SIR_UART_GET_GCTL(port)    bfin_read16((port)->membase +
>> > OFFSET_GCTL)
>> > +
>> > +#define SIR_UART_PUT_CHAR(port, v) bfin_write16(((port)->membase +
>> > OFFSET_THR), v)
>> > +#define SIR_UART_PUT_DLL(port, v)  bfin_write16(((port)->membase +
>> > OFFSET_DLL), v)
>> > +#define SIR_UART_PUT_DLH(port, v)  bfin_write16(((port)->membase +
>> > OFFSET_DLH), v)
>> > +#define SIR_UART_PUT_LCR(port, v)  bfin_write16(((port)->membase +
>> > OFFSET_LCR), v)
>> > +#define SIR_UART_PUT_GCTL(port, v) bfin_write16(((port)->membase +
>> > OFFSET_GCTL), v)
>> > +
>> > +#ifdef CONFIG_BF54x
>> > +#define SIR_UART_GET_LSR(port)     bfin_read16((port)->membase +
>> > OFFSET_LSR)
>> > +#define SIR_UART_GET_IER(port)     bfin_read16((port)->membase +
>> > OFFSET_IER_SET)
>> > +#define SIR_UART_SET_IER(port, v)  bfin_write16(((port)->membase +
>> > OFFSET_IER_SET), v)
>> > +#define SIR_UART_CLEAR_IER(port, v) bfin_write16(((port)->membase +
>> > OFFSET_IER_CLEAR), v)
>> > +#define SIR_UART_PUT_LSR(port, v)  bfin_write16(((port)->membase +
>> > OFFSET_LSR), v)
>> > +#define SIR_UART_CLEAR_LSR(port)   bfin_write16(((port)->membase +
>> > OFFSET_LSR), -1)
>> > +
>> > +#define SIR_UART_SET_DLAB(port)
>> > +#define SIR_UART_CLEAR_DLAB(port)
>> > +
>> > +#define SIR_UART_ENABLE_INTS(port, v) SIR_UART_SET_IER(port, v)
>> > +#define SIR_UART_DISABLE_INTS(port)   SIR_UART_CLEAR_IER(port, 0xF)
>> > +#define SIR_UART_STOP_TX(port)     do { SIR_UART_PUT_LSR(port, TFI);
>> > SIR_UART_CLEAR_IER(port, ETBEI); } while (0)
>> > +#define SIR_UART_ENABLE_TX(port)   do { SIR_UART_SET_IER(port, ETBEI);
>> > } while (0)
>> > +#define SIR_UART_STOP_RX(port)     do { SIR_UART_CLEAR_IER(port,
>> > ERBFI); } while (0)
>> > +#define SIR_UART_ENABLE_RX(port)   do { SIR_UART_SET_IER(port, ERBFI);
>> > } while (0)
>> > +#else
>> > +
>> > +#define SIR_UART_GET_IIR(port)     bfin_read16((port)->membase +
>> > OFFSET_IIR)
>> > +#define SIR_UART_GET_IER(port)     bfin_read16((port)->membase +
>> > OFFSET_IER)
>> > +#define SIR_UART_PUT_IER(port, v)  bfin_write16(((port)->membase +
>> > OFFSET_IER), v)
>> > +
>> > +#define SIR_UART_SET_DLAB(port)    do { SIR_UART_PUT_LCR(port,
>> > SIR_UART_GET_LCR(port) | DLAB); } while (0)
>> > +#define SIR_UART_CLEAR_DLAB(port)  do { SIR_UART_PUT_LCR(port,
>> > SIR_UART_GET_LCR(port) & ~DLAB); } while (0)
>> > +
>> > +#define SIR_UART_ENABLE_INTS(port, v) SIR_UART_PUT_IER(port, v)
>> > +#define SIR_UART_DISABLE_INTS(port)   SIR_UART_PUT_IER(port, 0)
>> > +#define SIR_UART_STOP_TX(port)     do { SIR_UART_PUT_IER(port,
>> > SIR_UART_GET_IER(port) & ~ETBEI); } while (0)
>> > +#define SIR_UART_ENABLE_TX(port)   do { SIR_UART_PUT_IER(port,
>> > SIR_UART_GET_IER(port) | ETBEI); } while (0)
>> > +#define SIR_UART_STOP_RX(port)     do { SIR_UART_PUT_IER(port,
>> > SIR_UART_GET_IER(port) & ~ERBFI); } while (0)
>> > +#define SIR_UART_ENABLE_RX(port)   do { SIR_UART_PUT_IER(port,
>> > SIR_UART_GET_IER(port) | ERBFI); } while (0)
>> > +
>> > +static inline unsigned int SIR_UART_GET_LSR(struct bfin_sir_port *port)
>> > +{
>> > +       unsigned int lsr = bfin_read16(port->membase + OFFSET_LSR);
>> > +       port->lsr |= (lsr & (BI|FE|PE|OE));
>> > +       return lsr | port->lsr;
>> > +}
>> > +
>> > +static inline void SIR_UART_CLEAR_LSR(struct bfin_sir_port *port)
>> > +{
>> > +       port->lsr = 0;
>> > +       bfin_read16(port->membase + OFFSET_LSR);
>> > +}
>> > +#endif
>> > +
>> > +static const unsigned short per[][3] = {
>> > +       {P_UART0_RX, P_UART0_TX, 0},
>> > +       {P_UART1_RX, P_UART1_TX, 0},
>> > +       {P_UART2_RX, P_UART2_TX, 0},
>> > +       {P_UART3_RX, P_UART3_TX, 0},
>> > +};
>> > --
>> > 1.6.1
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> > in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>
>
>
> --
> -Graff
>
