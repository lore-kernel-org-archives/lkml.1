Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZI2Kpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZI2Kpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZI2Kpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:45:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59043 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753890AbZI2Kpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:45:31 -0400
Date: Tue, 29 Sep 2009 11:46:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Lennart Baruschka" <FunFlyer@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disabling DMA with ICH10?
Message-ID: <20090929114656.05053387@lxorguk.ukuu.org.uk>
In-Reply-To: <20090929075416.77960@gmx.net>
References: <1254173481.4454.32.camel@goodbyte.homelinux.com>
	<20090928234025.6dc4e3f7@lxorguk.ukuu.org.uk>
	<20090929075416.77960@gmx.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought that PIO transfers (which I understand to be
> write32()/read32()'s) unlike DMA transfers could be interrupted by an
> high-priority interrupt. Is that wrong?

Yes. An I/O cycle will stall that CPU thread (and sometimes more) until
it completes. Not only that but the only way to do PIO only at the
hardware level is to take the controller out of AHCI mode into legacy
mode which means doing a lot of PIO accesses routed to the drive.

> Actually, that's what I do - except for locking the page, yet. I do need
> to access the PCI bus in real time, though. So I wonder what happens

I didnt think any system with an ICH10 even had a legacy PCI bus.

> when the RT CPU is getting data from the PCI device, doing some
> calculations on it and then writing back some data to the device,
> __while at the same time__ another (non-RT) CPU starts a DMA transfer. I
> figured the DMA would block the PCI bus,

It depends upon how you have configured the bus, devices and chipset what
priority rules are active and also what size bursts are used for the
transfers. In particular read up on the PCI latency setting for legacy
PCI bus devices.

Alan
