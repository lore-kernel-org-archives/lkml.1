Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZI1Wi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZI1Wi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZI1Wi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:38:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38717 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751575AbZI1Wi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:38:59 -0400
Date: Mon, 28 Sep 2009 23:40:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disabling DMA with ICH10?
Message-ID: <20090928234025.6dc4e3f7@lxorguk.ukuu.org.uk>
In-Reply-To: <1254173481.4454.32.camel@goodbyte.homelinux.com>
References: <1254173481.4454.32.camel@goodbyte.homelinux.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. Is there a way to completely disable DMA usage system-wide?

No

> 2. My system uses an ICH10 chipset, the harddrive is connected to the
> Intel SATA controller. Is there a way to disable DMA and switch back to
> PIO? I tried compiling with libata support and without SCSI support, but
> the kernel is unable to mount root (no matter if /dev/sda1
> or /dev/hda1), then.

If you disable DMA you will make your performance and latency worse not
better as the PIO transfers will stall the bus and thus the processor.

> If disabling DMA is impossible for some reason for one or both drivers,
> is it at least possible to reduce the burst sizes so the bus gets free
> for a short time during which I could access it from my real time kernel
> module?

You want the disk controller in AHCI mode to minimise CPU stalls and
then any burst size configuration and the like is down to the PCI
configuration. On some systems where memory or bus bandwidth is an issue
then forcing the disk to run at a lower speed can help, at least for
PATA. What effect it will have on SATA I am less sure.

If you really are that latency sensitive then the more normal approach
would be to lock one core for real time use, load the critical code into
that core CPU cache and run from cache. If you are utterly pushing the
limit you might even do crazy stuff like use on thread on the core to
execute RT stuff and the other to issue any I/O accesses that might stall.

And then on many systems things like BIOS SMI glue will still clobber you
8(

Alan
