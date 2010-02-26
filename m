Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966392Ab0BZWAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 17:00:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:56052 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966380Ab0BZWAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 17:00:08 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org,
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
In-Reply-To: <1267200044.14703.31.camel@e102109-lin.cambridge.arm.com>
References: <Pine.LNX.4.44L0.1002241100190.2436-100000@iolanthe.rowland.org>
	 <1267046036.23523.1693.camel@pasglop>
	 <1267200044.14703.31.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 08:36:03 +1100
Message-ID: <1267220163.23523.1806.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 16:00 +0000, Catalin Marinas wrote:
> > I'm surprised that usb-storage has an issue here. It shouldn't
> afaik,
> > since it's just a SCSI driver (or not anymore ?) and the BIO or
> > filesystems handle things there no ? I haven't seen a single call to
> > flush_dcache_page() in any of drivers/scsi, drivers/ata or
> drivers/ide
> > when I looked...
> 
> The BIO or filesystem code don't call flush_dcache_page() either (well
> some do like cramfs or jffs but they decompress the data received from
> the block device). 

That's weird... that would mean that all existing PIO IDE or SCSI is
broken etc... Including I$/D$ cache coherency on powerpc and more. That
surprises me :-)

On an older kernel tree here:

$ grep -r flush_dcache_page fs | wc -l
118

So maybe that's where things need fixing ?

Cheers,
Ben.




