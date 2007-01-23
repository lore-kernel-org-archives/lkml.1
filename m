Return-Path: <linux-kernel-owner+w=401wt.eu-S965595AbXAWXcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965595AbXAWXcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965597AbXAWXcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:32:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51333 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965594AbXAWXck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:32:40 -0500
Date: Tue, 23 Jan 2007 23:41:53 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
 er
Message-ID: <20070123234153.66fbeac6@localhost.localdomain>
In-Reply-To: <45B68E23.7080800@pmc-sierra.com>
References: <45B68E23.7080800@pmc-sierra.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 14:37:23 -0800
Marc St-Jean <Marc_St-Jean@pmc-sierra.com> wrote:
> > This I would hope you can hide in the platform specific
> > serial_in/serial_out functions. If you write the UART_LCR save it in
> > serial_out(), if you read IER etc.
> 
> I couldn't find hooks for platform specific serial_in/out functions.
> Do you mean using the up->port.iotype's in serial_in/out from 8250.c?

If you can have other uarts as well then yes. Basically I want all the
ugliness to belong to you not to the 8250 driver (and ditto for any other
half baked uart or demented piece of broken glue logic). If we don't do
that then 8250.c will end up unmanagable. So long as you crap in your own
pond everyone else is fine ;)

> A serial_in(up, UART_IIR) calls occur in more places that just the interrupt
> handler (i.e. autoconfig*, serial8250_start_tx, etc). We will need to check
> if we are in an interrupt on each IIR read, hopefully that won't be too much
> overhead!

Or if need be we make that hint generally available as we can do that bit
cleanly.

> > 
> > And we might want to add a void * for board specific insanity to the 8250
> > structures if we really have to so you can hang your brain damage
> > privately off that ?
> 
> Sounds good to me, it would give us a location to store the address of the
> UART_STATUS_REG required by this UART variant.

and for anything harder people can hang a struct off it.

Alan
