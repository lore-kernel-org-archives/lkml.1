Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXBBLI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXBBLI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXBBLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:08:58 -0500
Received: from dtp.xs4all.nl ([80.126.206.180]:24363 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751945AbXBBLI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:08:57 -0500
Date: Fri, 2 Feb 2007 12:08:54 +0100
From: Erik Mouw <erik@harddisk-recovery.com>
To: Lapo TIN <lapolapolapo@tin.it>
Cc: linux-smp@vger.kernel.org, linux-kernel@vger.kernel.org,
       "'Robert Hancock'" <hancockr@shaw.ca>
Subject: Re: smp and irq conflict
Message-ID: <20070202110853.GA16296@harddisk-recovery.com>
References: <45C277E0.2040604@shaw.ca> <45C0FAE300242D46@vsmtp14.tin.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C0FAE300242D46@vsmtp14.tin.it>
Organization: Harddisk-recovery.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 01:04:53AM +0100, Lapo TIN wrote:
> I need to capture at 25 frame per second from each channel...
> So 25 x 8 total frames per second on the pci.

Each PAL frame takes about 800k, so that makes 20MB/s per channel. With
8 channels that makes 160 MB/s. That will most certainly overwhelm a
normal 33 MHz 32 bit PCI bus which has a theoretical bandwidth of 132
MB/s (90MB/s max in practice). Modern PCs have faster PCI busses
(66MHz, 64 bit, PCI-X, or PCI-e) so there's less chance on bus
contention.

On the other hand, I suppose you will store the video streams on disk.
That will use another 20MB/s per channel on the bus so the total
becomes 320 MB/s. You need some careful system design in order to get
that right. Especially look carefully at bus contention, if the system
has multiple busses, distribute the bttv cards over those busses. Also
be sure to have enough bandwidth for the disk subsystem.

> So do you think I have to change the motherboard ?
> What is important ? the chipset ? is there specification I need ?

Last time I had to record frame-synchronous video from 3 streams (8
years ago) PCs could hardly manage 2 streams over their bus and there
was no way to guarantee frame sync. The only way out was to use an SGI
Onyx2 with 3 digital video option cards and a large disk subsystem.
That made the whole system much more expensive but at that time it was
the only way to meet all requirements.

I don't know about current PCs, bus speeds have improved. It is however
still important how those busses are connected together and to the
chipset. You have to figure out from your motherboard documentation if
there is enough bandwidth available. If there isn't, get a faster
motherboard, or consider using compressing grabber cards like the
Hauppauge PVR 150 or PVR 500.


Erik
-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
