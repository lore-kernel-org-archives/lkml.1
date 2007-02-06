Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbXBFQwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbXBFQwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXBFQww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:52:52 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:52660 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751916AbXBFQwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:52:51 -0500
Message-ID: <45C8B24B.1000204@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
	er
Date: Tue, 6 Feb 2007 08:52:27 -0800 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 06 Feb 2007 16:52:28.0427 (UTC) FILETIME=[2F7155B0:01C74A0F]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank Alan. I made the changes yesterday but I'll wait another day
before reposting, in case other interested people have more comments.

Marc

Alan wrote:
>  >       unsigned char           hub6;                   /* this should 
> be in the 8250 driver */
>  >       unsigned char           unused[3];
>  > +     void                            *data;                  /* 
> generic platform data pointer */
>  >   };
> 
> Convention is "private_data"
> 
>  >
>  >   /*
>  > diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
>  > index 3c8a6aa..b3550cc 100644
>  > --- a/include/linux/serial_reg.h
>  > +++ b/include/linux/serial_reg.h
>  > @@ -37,6 +37,7 @@ #define UART_IIR_MSI                0x00 /* Modem stat
>  >   #define UART_IIR_THRI               0x02 /* Transmitter holding 
> register empty */
>  >   #define UART_IIR_RDI                0x04 /* Receiver data interrupt */
>  >   #define UART_IIR_RLSI               0x06 /* Receiver line status 
> interrupt */
>  > +#define UART_IIR_BUSY                0x07 /* DesignWare APB Busy 
> Detect */
> 
> Please move this down a line to break it from "official" values and call
> it DESIGNWARE_UART_IIR_BUSY, so it is obviously designware specific.
> 
> Otherwise looks much less invasive and messy
> 
