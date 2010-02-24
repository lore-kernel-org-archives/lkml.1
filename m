Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab0BXVul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:50:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59641 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758203Ab0BXVuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:50:39 -0500
Date: Wed, 24 Feb 2010 16:50:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       <linux-usb@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: USB mass storage and ARM cache coherency
In-Reply-To: <1267046036.23523.1693.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.1002241641370.1253-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Benjamin Herrenschmidt wrote:

> I'm surprised that usb-storage has an issue here. It shouldn't afaik,
> since it's just a SCSI driver (or not anymore ?)

It still is.  There's also the ub driver, which is a non-SCSI block 
device driver for some of the same devices handled by usb-storage.

> and the BIO or
> filesystems handle things there no ? I haven't seen a single call to
> flush_dcache_page() in any of drivers/scsi, drivers/ata or drivers/ide
> when I looked...

There is no real issue; it's just that the problem was first noted in 
connection with usb-storage reading in executable pages, so Catalin's 
initial post was oriented toward modifying usb-storage.

The main issue here is that the same host controller will use PIO
sometimes and DMA sometimes, depending on the details of the transfer.  
The USB core didn't expect this and consequently we violated the rules
for DMA mapping.  The question is: If the core is fixed so that the
rules aren't violated, will everything work correctly?

Alan Stern

