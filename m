Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbZIAOKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbZIAOKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZIAOKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:10:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:2313 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbZIAOKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:10:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pDC7nT2SUVDwAYm5CR3s7bC3DfYQA37LuetpZn+UGYpNh3mRJUllaUb6wKybc9GXqM
         x6IwKK+N4lE2LnmJdWihbMuc3AH4vAtIksuXS329RJjL6tQEhzpXSazgiQKG/Lazpuxj
         sOa0XBdyothB1UOSF/5d8bYaGA37ahW/ZeYbk=
MIME-Version: 1.0
In-Reply-To: <20090828150545.5cf9dae5@lxorguk.ukuu.org.uk>
References: <ce9ab5790908280649n77765dedm9161316a181b6a07@mail.gmail.com>
	 <20090828150545.5cf9dae5@lxorguk.ukuu.org.uk>
Date: Tue, 1 Sep 2009 19:40:24 +0530
Message-ID: <d6a0f7aa0909010710o13021e7hd186f62195d63cdf@mail.gmail.com>
Subject: Re: [RFC][PATCH]: Adding support for omap-serail driver
From: Govindraj <govindraj.ti@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: vimal singh <vimal.newwork@gmail.com>, linux-omap@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 7:35 PM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
>> +#define UART_BASE(uart_no)           (uart_no == UART1) ? OMAP_UART1_BASE :\
>> +                                     (uart_no == UART2) ? OMAP_UART2_BASE :\
>> +                                      OMAP_UART3_BASE
>
> Would be cleaner if this was simply an array (and probably faster)
>
>> +
>> +#define UART_MODULE_BASE(uart_no)    (UART1 == uart_no ? \
>> +                                             IO_ADDRESS(OMAP_UART1_BASE) :\
>> +                                     (UART2 == uart_no ? \
>> +                                             IO_ADDRESS(OMAP_UART2_BASE) :\
>> +                                             IO_ADDRESS(OMAP_UART3_BASE)))
>
> Ditto
>
>> +extern unsigned int fcr[MAX_UARTS];
>> +extern char *saved_command_line;
>
> We really don't wang globals floating around with names like fcr - and
> why is saved command line needed when we have module option parsing
> functions ?
>
>
>> +unsigned int fcr[MAX_UARTS];
>> +unsigned long up_activity;
>
> Not acceptable as global names - too big a risk of clashes
>
>
>
>> +static int serial_omap_startup(struct uart_port *port)
>> +{
>> +     struct uart_omap_port *up = (struct uart_omap_port *)port;
>> +     unsigned long flags;
>> +     int irq_flags = 0;
>> +     int retval;
>> +
>> +     /* Zoom2 has GPIO_102 connected to Serial device:
>> +      * Active High
>> +      */
>> +     if (up->port.flags & UPF_IOREMAP)
>> +             irq_flags |= IRQF_TRIGGER_HIGH;
>
> Don't hijack flags here - especially as a patch is pending that adds a
> separate field for IRQ flags to clean that up properly. Build on top of
> that fix instead


Can you provide me the link to that patch.

-----
Regards,
Govindraj.R
