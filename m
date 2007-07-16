Return-Path: <linux-kernel-owner+w=401wt.eu-S1764053AbXGPGze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764053AbXGPGze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbXGPGz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:55:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54292 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXGPGz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:55:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <469B164F.4070308@s5r6.in-berlin.de>
Date: Mon, 16 Jul 2007 08:55:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: linux1394-user@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: irq 9: nobody cared (try booting with the "irqpoll" option)
References: <20070716030343.GC30349@shallowsky.com>
In-Reply-To: <20070716030343.GC30349@shallowsky.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Full quote for LKML)

Akkana Peck wrote:
> I've been participating in a thread on the linux-usb list about an
> IRQ conflict problem several of us have seen with 2.6.21 and 2.6.22
> (which didn't happen with earlier kernels).
> 
> The full thread starts at
> http://www.mail-archive.com/linux-usb-users@lists.sourceforge.net/msg18856.html
> but I'll summarize: at boot time, the kernel finds contention over
> an IRQ (23 for the original poster, 9 for me), prints the "nobody
> cared" message and a list of handlers, then disables the IRQ (which
> of course makes things fail). My machine is a Vaio SR17, while the
> OP's is a Lenovo T61. booting with irqpoll does solve the problem,
> but it's not a solution I wanted to run with in the long term.
> 
> I got suspicious because one of the handlers was reported as
> [<c02c1e50>] (ohci_irq_handler+0x0/0x920)
> which seemed odd because my machine uses UHCI for USB and doesn't
> have OHCI in the kernel at all. But it turned out the problem wasn't
> UHCI for USB, but OHCI1394, and building a kernel without that driver
> made everything else work fine.
> 
> I don't use Firewire much, so that solves the problem for me, but
> I wanted to report this since it seems like 1394 has a problem on
> some machines. (I've seen reports of the problem elsewhere too --
> there's an ubuntu bug, and googling found a few other examples.)
> 
> I'd be happy to post further details or run tests, if anyone
> is interested.
> 
> 	...Akkana

I am not aware of anything that a PCI driver like ohci1394 could do
about it.  Somebody correct me if I'm wrong, but this is between the
BIOS and low-level code for the x86 PC platform.

Is anybody aware of relevant changes from 2.6.20 to 2.6.21 that could
have introduced this regression?
-- 
Stefan Richter
-=====-=-=== -=== =----
http://arcgraph.de/sr/
