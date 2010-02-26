Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235Ab0BZQAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:00:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60765 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965060Ab0BZQAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:00:52 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
In-Reply-To: <1267046036.23523.1693.camel@pasglop>
References: <Pine.LNX.4.44L0.1002241100190.2436-100000@iolanthe.rowland.org>
	 <1267046036.23523.1693.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 26 Feb 2010 16:00:44 +0000
Message-ID: <1267200044.14703.31.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2010 16:00:45.0778 (UTC) FILETIME=[DB1FAB20:01CAB6FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 21:13 +0000, Benjamin Herrenschmidt wrote:
> On Wed, 2010-02-24 at 11:19 -0500, Alan Stern wrote:
> > > It is but I'm not confident the responsibility for doing that cleanup
> > > is at the HCD level. That would impact a lot of HCD activities that
> > > don't need such flushing since the use of the page is purely in-kernel.
> >
> > That's right.  The HCD merely puts data wherever it's told to.  It
> > doesn't know whether the destination is in the page cache, in
> > userspace, or anywhere else.  The same is true for usb-storage.
> 
> I'm surprised that usb-storage has an issue here. It shouldn't afaik,
> since it's just a SCSI driver (or not anymore ?) and the BIO or
> filesystems handle things there no ? I haven't seen a single call to
> flush_dcache_page() in any of drivers/scsi, drivers/ata or drivers/ide
> when I looked...

The BIO or filesystem code don't call flush_dcache_page() either (well
some do like cramfs or jffs but they decompress the data received from
the block device).

-- 
Catalin

