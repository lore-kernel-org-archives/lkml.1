Return-Path: <linux-kernel-owner+w=401wt.eu-S1764158AbXFRPKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764158AbXFRPKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763524AbXFRPKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:10:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763349AbXFRPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:10:09 -0400
Date: Mon, 18 Jun 2007 08:10:00 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: =?ISO-8859-2?Q?Marcin_=A6lusarz?= <marcin.slusarz@gmail.com>,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070618081000.14da5186@localhost.localdomain>
In-Reply-To: <20070618110849.GA2450@ff.dom.local>
References: <4bacf17f0706161435g1bb7c08bpd427901f64d57fa@mail.gmail.com>
	<20070618110849.GA2450@ff.dom.local>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 13:08:49 +0200
Jarek Poplawski <jarkao2@o2.pl> wrote:

> On 16-06-2007 23:35, Marcin .lusarz wrote:
> > hi
> > after upgrading kernel from 2.6.20 to 2.6.21.3 i'm experiencing really
> > strange problem - my _both_ network cards dies after random uptime -
> > sometimes it's a few minutes, sometimes hours, sometimes it does not
> > happen for a couple of days...
> > today it happened for the first time without nvidia module and almost
> > immediately after system start
> > 
> > here is the output of some commands which might help debug this:
> ...
> > [   21.726533] Write protecting the kernel read-only data: 1457k
> > [   25.734316] ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 17 (level,
> > low) -> IRQ 17
> > [   25.734367] skge 1.10 addr 0xfab00000 irq 17 chip Yukon-Lite rev 9
> > [   25.734763] skge eth0: addr 00:11:d8:60:74:55
> > [   25.971279] ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker
> > [   25.971282]   http://www.scyld.com/network/ne2k-pci.html
> > [   25.971364] ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level,
> > low) -> IRQ 17
> > [   25.971691] eth1: Compex RL2000 found at 0xb000, IRQ 17, 
> > 00:80:48:DE:5E:89.
> > [   26.888372] Linux video capture interface: v2.00
> > [   26.906732] bttv: driver version 0.9.17 loaded
> ...
> > [   31.659572] Adding 1020112k swap on /dev/sda2.  Priority:-1
> > extents:1 across:1020112k
> > [   42.681974] skge eth1: enabling interface
> > [   43.228729] NET: Registered protocol family 17
> > [   46.429756] Time: acpi_pm clocksource has been installed.
> > [   50.743512] NETDEV WATCHDOG: eth0: transmit timed out
> > [   50.743521] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=574.
> ...
> 
> It looks like skge driver enables different device than probbed.
> Maybe you've something old/wrong about eth0/eth1 in /etc configs?

More likely it is just user level device renaming. Most distro's
rename devices (if needed) using udev.

> You can also try with netdev= or pci= kernel parameters.

Bad idea. 

> If no result - resend it, please - maybe with some debugging on
> (modinfo skge). BTW - netdev seems to be preferred for this.

What is the contents of /proc/interrupts

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
