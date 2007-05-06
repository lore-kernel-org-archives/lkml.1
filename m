Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbXEFVvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbXEFVvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXEFVvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:51:14 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3797 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751630AbXEFVvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:51:13 -0400
Date: Sun, 6 May 2007 17:51:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Antonino Ingargiola <tritemio@gmail.com>,
       Paul Fulghum <paulkf@microgate.com>, Oliver Neukum <oliver@neukum.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb-users@lists.sourceforge.net>
Subject: Re: [Linux-usb-users] [SOLVED] Serial buffer corruption [was Re:
 FTDI usb-serial possible bug]
In-Reply-To: <20070506132849.62e1e218@the-village.bc.nu>
Message-ID: <Pine.LNX.4.44L0.0705061744540.21407-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007, Alan Cox wrote:

> > However, whatever policy the buffer uses, the fundamental point it's that
> > when I flush the input buffer I should be sure that each byte read
> > after the flush is *new* (current) data and not old one. This because
> 
> Define "new" and "old" in this case. I don't believe you can give a
> precise definition or that such a thing is physically possible.

One can come close.  It would make sense to say that after a flush,
subsequent reads should retrieve _contiguous_ bytes from the input stream.  
In other words, rule out the possibility that the read would get bytes
1-10 (from some buffer somewhere) followed by bytes 30-60 (because bytes
11-29 were dropped by the flush).  By contrast, it would be permissible
for the read to obtain bytes 20-60, even though 20-29 may have been
entered the input stream before the flush occurred.

> The hardware itself has buffers at both ends of the link, there may be
> buffers in modems, muxes and the like as well. We can certainly flush
> input buffers in the kernel but it isn't clear we can always do so at the
> hardware level, let alone at the remote end or buffers on devices on the
> link.

This is of course the fly in the ointment.

Alan Stern

