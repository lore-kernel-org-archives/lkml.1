Return-Path: <linux-kernel-owner+w=401wt.eu-S933958AbXEEVsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958AbXEEVsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933921AbXEEVsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:48:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56563 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933960AbXEEVsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:48:40 -0400
Date: Sat, 5 May 2007 22:52:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Paul Fulghum <paulkf@microgate.com>,
       Antonino Ingargiola <tritemio@gmail.com>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
 possible bug]
Message-ID: <20070505225241.54a5d01d@the-village.bc.nu>
In-Reply-To: <200705052007.16742.oliver@neukum.org>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	<1178381287.3379.8.camel@x2>
	<20070505173647.544f6707@the-village.bc.nu>
	<200705052007.16742.oliver@neukum.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 20:07:15 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> Am Samstag, 5. Mai 2007 18:36 schrieb Alan Cox:
> > > In the serial driver this usually just results in dropping
> > > RTS to signal the remote end to stop sending. The serial
> > > driver always immediately gives receive data to the tty buffering
> > > without regard to the throttled state.
> > > 
> > > I would argue that cdc-acm should do the same as the serial driver.
> > 
> > This is a bug in cdc-acm really. It should not double buffer, but to be
> > fair to the authors prior to the new tty buffering it *had* to do this.
> 
> Hi,
> 
> should I understand this so that, if tty_buffer_request_room() returns
> less than requested, the rest of the data should be dropped on the
> floor?

If it returns NULL then either there is > 64K buffered (we can adjust
that if anyone shows need - its just for sanity) or the system is out of
RAM. 

Alan
