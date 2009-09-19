Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZISQUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZISQUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 12:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZISQUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 12:20:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51957 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751571AbZISQUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 12:20:50 -0400
Date: Sat, 19 Sep 2009 12:20:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Johan Hovold <jhovold@gmail.com>
cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       <linux-usb@vger.kernel.org>, e9hack <e9hack@googlemail.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: ftdi_sio: Fix read regression in 2.6.31.
In-Reply-To: <20090919160347.GA14156@localhost>
Message-ID: <Pine.LNX.4.44L0.0909191217430.15223-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Sep 2009, Johan Hovold wrote:

> Use ASYNCB_INITIALIZED to determine when to stop reading.
> 
> Since 335f8514f200e63d689113d29cb7253a5c282967 port count can no longer
> be used to determine when to stop reading from the device as it can be
> zero when the first read callbacks are made (see tty_port_block_til_read
> where port count is temporarily decremented during serial_open).
> 
> This fixes the regression where reads fail after connecting the device
> and opening the port more than once (reads usually succeed after the
> first open due to the device latency timer then being set to the default
> 16ms rather than 1ms).

This is a good change.  It should be made in all the serial drivers, 
not just ftdi_sio.  How'd you like to submit patches for all the rest 
of the drivers?

Alan Stern

