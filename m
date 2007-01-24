Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbXAXQtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbXAXQtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXAXQtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:49:01 -0500
Received: from mother.pmc-sierra.com ([216.241.224.12]:55267 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752012AbXAXQtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:49:00 -0500
Message-ID: <45B78DF5.9000203@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
	 er
Date: Wed, 24 Jan 2007 08:48:53 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 24 Jan 2007 16:48:54.0136 (UTC) FILETIME=[88585F80:01C73FD7]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> 
>  >>This I would hope you can hide in the platform specific
>  >>serial_in/serial_out functions. If you write the UART_LCR save it in
>  >>serial_out(), if you read IER etc.
> 
>  > I couldn't find hooks for platform specific serial_in/out functions.
> 
>     It's because there are none. :-)
> 
>  > Do you mean using the up->port.iotype's in serial_in/out from 8250.c?
> 
>     Not sure what Alan meant, but this seems the only option for now.

That's the conclusion I came to. I've rewritten the patch to use port.type
instead of iotype since one of the fix is SoC and not UART specific. I guess
I could use both iotype and type with a test on each for the appropriate
bug, what do you recommend?


>   >>And we might want to add a void * for board specific insanity to the 
> 8250
>  >>structures if we really have to so you can hang your brain damage
>  >>privately off that ?
> 
>  > Sounds good to me, it would give us a location to store the address 
> of the
>  > UART_STATUS_REG required by this UART variant.
> 
>     I doubt we really need to *store* it somewhere. Isn't it an fixed 
> offset
> from UART's base (I haven't seen the header)?

Unfortunately it's not a constant offset from the UART in the SoC register
space. I've used Alan suggestion and added a classic, on some other OSes %-|,
void "user" pointer.

I'll repost as soon I complete testing and try the new timer patch.

Marc
