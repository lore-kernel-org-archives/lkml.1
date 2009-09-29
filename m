Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZI2IKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZI2IKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 04:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZI2IKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 04:10:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:43749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbZI2IKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 04:10:47 -0400
Date: Tue, 29 Sep 2009 10:11:14 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: "Lennart Baruschka" <FunFlyer@gmx.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Disabling DMA with ICH10?
Message-ID: <20090929101114.1712314b@infradead.org>
In-Reply-To: <20090929075416.77960@gmx.net>
References: <1254173481.4454.32.camel@goodbyte.homelinux.com>
	<20090928234025.6dc4e3f7@lxorguk.ukuu.org.uk>
	<20090929075416.77960@gmx.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 09:54:16 +0200
"Lennart Baruschka" <FunFlyer@gmx.net> wrote:

> Hi, 
> 
> On Mon, 2009-09-28 at 23:40 +0100, Alan Cox wrote:
> > > 2. My system uses an ICH10 chipset, the harddrive is connected to
> > > the Intel SATA controller. Is there a way to disable DMA and
> > > switch back to PIO? I tried compiling with libata support and
> > > without SCSI support, but the kernel is unable to mount root (no
> > > matter if /dev/sda1 or /dev/hda1), then.
> > 
> > If you disable DMA you will make your performance and latency worse
> > not better as the PIO transfers will stall the bus and thus the
> > processor.
> 
> I thought that PIO transfers (which I understand to be
> write32()/read32()'s) unlike DMA transfers could be interrupted by an
> high-priority interrupt. Is that wrong?

a single PIO instruction will NOT be interrupted by an interrupt.
And can easily take several microseconds (remember: 8Mhz bus emulation)

while DMA is going on, the CPU on the other hand is just happy
executing instructions, fetching stuff from memory etc etc.


> Actually, that's what I do - except for locking the page, yet. I do
> need to access the PCI bus in real time, though. So I wonder what
> happens when the RT CPU is getting data from the PCI device, doing
> some calculations on it and then writing back some data to the device,
> __while at the same time__ another (non-RT) CPU starts a DMA
> transfer. I figured the DMA would block the PCI bus, having my
> interrupt wait for it to finish. That's why I'm trying to avoid DMA. 

the PCI bus is time sliced, with typical transfer sizes being like 256
byte bursts...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
