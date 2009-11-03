Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbZKCT6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbZKCT6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZKCT6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:58:07 -0500
Received: from relais.videotron.ca ([24.201.245.36]:59071 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZKCT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:58:06 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 03 Nov 2009 14:58:10 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Cox <alan@linux.intel.com>
Cc: linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] Sort out sdio_uart - stage two
In-reply-to: <20091103141525.31032.45206.stgit@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0911031401170.13333@xanadu.home>
References: <20091103141525.31032.45206.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009, Alan Cox wrote:

> With the bugs Nicolas reported hopefully now nailed.

Progress, but still not there yet.

I'm still using the same "cat /dev/ttySDIO0" test with a GPS card.

Yanking the card out does terminate the cat process properly.  Inserting 
the card back in and restarting cat always fails with:

	cat: /dev/ttySDIO0: Input/output error

The same thing occurs if I terminate cat with ^C instead of pulling the 
card out.

>From what I can see, sdio_uart_open() and sdio_uart_activate() are 
called on the first cat invocation, and then sdio_uart_close() and 
sdio_uart_shutdown() when cat is stopped with ^C.  However neither 
sdio_uart_open() nor sdio_uart_activate() is ever called anymore with 
any subsequent cat invocations until a reboot.  Some upper layer must 
have taken upon itself to return -EIO to user space.


Nicolas
