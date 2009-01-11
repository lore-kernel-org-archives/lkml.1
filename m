Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbZAKMZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbZAKMZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZAKMZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:25:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:51983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZAKMZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:25:21 -0500
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: Valdis.Kletnieks@vt.edu, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20090111.040842.86784676.davem@davemloft.net>
References: <5a4c581d0901090930j5d4760b0x730b5609fa2b5614@mail.gmail.com>
	 <20090109.140422.60087297.davem@davemloft.net>
	 <43805.1231672258@turing-police.cc.vt.edu>
	 <20090111.040842.86784676.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 12:24:58 +0000
Message-Id: <1231676698.25018.147.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 04:08 -0800, David Miller wrote:
> From: Valdis.Kletnieks@vt.edu
> Date: Sun, 11 Jan 2009 06:10:58 -0500
> 
> > On Fri, 09 Jan 2009 14:04:22 PST, David Miller said:
> > > From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
> > > Date: Fri, 9 Jan 2009 18:30:40 +0100
> > > 
> > > > Clearly the requirement changed in -git8, AFAICS.
> > > 
> > > Because -git8 is where the firmware requirement got added.
> > > 
> > > If you build the TG3 driver statically into your kernel,
> > > the only way to get the firmware properly loaded is to
> > > enable that CONFIG_FIRMWARE_IN_KERNEL option.
> > 
> > Maybe this is one of those cases where we actually do want a SELECT?
> > 
> > 	select FIRMWARE_IN_KERNEL if TIGON3=y
> > 
> > or similar?
> 
> I have no idea how this is intended to work, David will know.

Actually, I think the real issue here might be that the tg3 driver is
now behaving _differently_ to how other modern drivers work. It tries to
obtain the firmware once at initialisation time and if that fails it
doesn't register the device.

Other drivers will load the firmware later, at the time the device is
brought up. This means that even if you build the driver into the kernel
without its firmware, it can still request the firmware later, when you
try to start _using_ it. And when the file system is available.

I'll take a look and see if I can remedy that. Then we wouldn't _need_
the FIRMWARE_IN_KERNEL option.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

