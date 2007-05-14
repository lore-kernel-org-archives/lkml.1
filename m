Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbXENRug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbXENRug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbXENRu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:50:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53595 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXENRu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:50:28 -0400
Date: Mon, 14 May 2007 10:54:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Yinghai.Lu@Sun.COM
Cc: Andrew Morton <akpm@linux-foundation.org>, rmk@arm.linux.org.uk,
       Andi Kleen <ak@suse.de>, bjorn.helgaas@hp.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: set RTS and DTR if flow is 'r'
Message-Id: <20070514105411.f4165511.randy.dunlap@oracle.com>
In-Reply-To: <46489BC2.6040403@sun.com>
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	<m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
	<46489BC2.6040403@sun.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 10:26:26 -0700 Yinghai Lu wrote:

> [PATCH] serial: set RTS and DTR if flow is 'r'
> 
> if the serial console flow is set to 'r', We need to set RTS and DTR.
> Some UARTs on other side need these bit set, otherwise will send char to or
> receive char from the host that kernel is runing esp for kernel boot stage.
> 
> BTW:
> earlyprintk and early_uart are hard coded to set DTR/RTS.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 48e259a..439a00a 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -2154,6 +2154,16 @@ serial8250_set_termios(struct uart_port *port, 
> struct ktermios *termios,
> }
> serial_outp(up, UART_FCR, fcr); /* set fcr */

Something is eating tabs above and presumably in the new patch lines...

> }
> +
> + /* if serial console flow is 'r', we need to set RTS and DTR to MCR.
> + * some uarts on other side don't support no flow control. So we state
> + * console=ttyS0,9600n8r in kernel command line to make those uart can
> + * work.
> + */

/*
 * Linux long comment style is
 * like this.
 */

> + if (termios->c_cflag & CRTSCTS) {
> + up->port.mctrl |= TIOCM_RTS | TIOCM_DTR;
> + }

Don't use braces on one-statement blocks.

> +
> serial8250_set_mctrl(&up->port, up->port.mctrl);
> spin_unlock_irqrestore(&up->port.lock, flags);
> }



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
