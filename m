Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbXE1Ru6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbXE1Ru6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbXE1Ruv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:50:51 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:21537 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXE1Ruu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bM56oUKh8D0+lHP8tsqocj1m2Kp8o50XZtQLLn332JgioVm031+gNsNeOJXUzpw1ttVrotyAbqz022D1v/mzr7jPhm5S6fNLdc2lgmpyQPIFPxFHSp9TIeKvarKUFR64y0kaePnq8jHdMh+HfI0ywT8IPRgi4zt7qKnIso8zQ8E=
Message-ID: <86802c440705281050i1ef8e56ek74ebeb004afe3353@mail.gmail.com>
Date: Mon, 28 May 2007 10:50:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Yinghai Lu" <Yinghai.Lu@sun.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       bjorn.helgaas@hp.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH] serial: convert early_uart to earlycon for 8250
In-Reply-To: <20070528105153.GE26046@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	 <4648B2CC.2020403@sun.com> <200705151348.15355.yinghai.lu@sun.com>
	 <200705221231.59694.yinghai.lu@sun.com>
	 <20070528105153.GE26046@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> I can't comment on the arch specific bits.  As a general note, I think
> this is over complex.  For instance, the additional hook in serial_core
> to call the find_port_for_earlycon method isn't needed because you can
> call serial8250_find_port_for_earlycon() from within
> serial8250_console_setup().  You can also modify co->index from
> within there without needing update_console_cmdline_console_index().

Good point, I will try to remove that hook.

>
> Bjorn needs to review the 8250_early changes.
>
> Apart from that, two other comments:
>
> On Tue, May 22, 2007 at 12:31:59PM -0700, Yinghai Lu wrote:
> > diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> > index c84dab0..e341fb9 100644
> > --- a/drivers/serial/8250.c
> > +++ b/drivers/serial/8250.c
> > @@ -2402,6 +2405,7 @@ static void __init serial8250_isa_init_ports(void)
> >       for (i = 0, up = serial8250_ports;
> >            i < ARRAY_SIZE(old_serial_port) && i < nr_uarts;
> >            i++, up++) {
> > +             printk(KERN_INFO "serial8250_isa_init_ports 2  idx=%d\n",i);
>
> Is this a debugging printk?

Oh.

>
> >               up->port.iobase   = old_serial_port[i].port;
> >               up->port.irq      = irq_canonicalize(old_serial_port[i].irq);
> >               up->port.uartclk  = old_serial_port[i].baud_base * 16;
> > @@ -2533,7 +2537,7 @@ static int __init serial8250_console_init(void)
> >  }
> >  console_initcall(serial8250_console_init);
> >
> > -static int __init find_port(struct uart_port *p)
> > +int __init find_port_serial8250(struct uart_port *p)
>
> If this is going to become globally visible, please name it
> serial8250_find_port to match the style of the rest of the file.

I see.

YH
