Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977AbZKDAws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbZKDAws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZKDAws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:52:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51284 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbZKDAwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:52:47 -0500
Date: Wed, 4 Nov 2009 00:54:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Alan Cox <alan@linux.intel.com>, linux-mmc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] Sort out sdio_uart - stage two
Message-ID: <20091104005432.3cdc924f@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0911031401170.13333@xanadu.home>
References: <20091103141525.31032.45206.stgit@localhost.localdomain>
	<alpine.LFD.2.00.0911031401170.13333@xanadu.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From what I can see, sdio_uart_open() and sdio_uart_activate() are 
> called on the first cat invocation, and then sdio_uart_close() and 
> sdio_uart_shutdown() when cat is stopped with ^C.  However neither 

I would have expected the cat to terminate when the port is unplugged
(and the uart remove method called - doing a hangup)

> sdio_uart_open() nor sdio_uart_activate() is ever called anymore with 
> any subsequent cat invocations until a reboot.  Some upper layer must 
> have taken upon itself to return -EIO to user space.

The first call into the driver is to sdio_uart_install which looks up the
port from tty->index and would blow up if for some reason the get method
failed.

Still digging.
