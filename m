Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZKDBsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZKDBsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZKDBsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:48:09 -0500
Received: from relais.videotron.ca ([24.201.245.36]:41852 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZKDBsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:48:09 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 03 Nov 2009 20:48:13 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-mmc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] Sort out sdio_uart - stage two
In-reply-to: <20091104005432.3cdc924f@lxorguk.ukuu.org.uk>
Message-id: <alpine.LFD.2.00.0911032042240.13333@xanadu.home>
References: <20091103141525.31032.45206.stgit@localhost.localdomain>
 <alpine.LFD.2.00.0911031401170.13333@xanadu.home>
 <20091104005432.3cdc924f@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, Alan Cox wrote:

> > >From what I can see, sdio_uart_open() and sdio_uart_activate() are 
> > called on the first cat invocation, and then sdio_uart_close() and 
> > sdio_uart_shutdown() when cat is stopped with ^C.  However neither 
> 
> I would have expected the cat to terminate when the port is unplugged
> (and the uart remove method called - doing a hangup)

That works fine... the first time only.  After the card is inserted back 
then -EIO is always returned on open() from user space, same thing as 
subsequent open() after ^C.

> > sdio_uart_open() nor sdio_uart_activate() is ever called anymore with 
> > any subsequent cat invocations until a reboot.  Some upper layer must 
> > have taken upon itself to return -EIO to user space.
> 
> The first call into the driver is to sdio_uart_install which looks up the
> port from tty->index and would blow up if for some reason the get method
> failed.

Well, same issue: I see it being called the first time.  No calls what 
so ever afterward until the next reboot.


Nicolas
