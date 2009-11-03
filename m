Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZKCOP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZKCOP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZKCOP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:15:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41665 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979AbZKCOP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:15:56 -0500
Date: Tue, 3 Nov 2009 14:17:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Vrabel <david.vrabel@csr.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Alan Cox <alan@linux.intel.com>,
       linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com
Subject: Re: [PATCH 0/6] Clean up the sdio_uart driver and fix the tty code
Message-ID: <20091103141723.21c2bea1@lxorguk.ukuu.org.uk>
In-Reply-To: <4AF03720.5070506@csr.com>
References: <20091102164039.11877.88825.stgit@localhost.localdomain>
	<alpine.LFD.2.00.0911021243040.13333@xanadu.home>
	<20091102191604.010acbc9@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0911021542520.13333@xanadu.home>
	<20091103120618.26b669be@lxorguk.ukuu.org.uk>
	<4AF03720.5070506@csr.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	sdio_uart_irq
> > 					sdio_uart_port_remove
> > 					port->func = NULL;
> > 	sdio_in
> > 	BUG_ON
> 
> This is actually happening?  sdio_claim_host()/sdio_release_host() act

Found by inspection

> like a mutex so sdio_uart_port_remove() will wait in sdio_claim_host()
> until sdio_uart_irq() returns (SDIO interrupt handlers are called with
> the host claimed).

Ok that was a detail I was missing. That part of the locking now makes
sense.

Ok so I think I have it fixed up barring stuff which is "feature add" -
such as implementing TIOCMIWAIT and blocking on no carrier.
