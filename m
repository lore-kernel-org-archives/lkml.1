Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXCYTJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXCYTJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbXCYTJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:09:38 -0400
Received: from mail.chilan.com ([82.160.212.9]:58829 "EHLO mail.chilan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXCYTJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:09:36 -0400
From: "Grzegorz Chwesewicz" <grzegorz.chwesewicz@chilan.com>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Gabriel C" <nix.or.die@googlemail.com>
Cc: "Kevin P. Fleming" <lkml@kpfleming.us>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust BAR0 (not I/O)' on NVidia MCP51
Date: Sun, 25 Mar 2007 21:09:36 +0200
Message-Id: <20070325190119.M81172@chilan.com>
In-Reply-To: <64bb37e0703251113v4d4e6acdg92faf6722e9bc2df@mail.gmail.com>
References: <460693EB.9080203@kpfleming.us> <4606A6B0.4010601@googlemail.com> <64bb37e0703251113v4d4e6acdg92faf6722e9bc2df@mail.gmail.com>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 82.160.213.5 (ceho)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 19:13:50 +0100, Torsten Kaiser wrote
> On 3/25/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> > Kevin P. Fleming wrote:
> > > I just upgraded from 2.6.20.2 to 2.6.20.4 on my Compaq V6000 laptop,
> > > which has an NVidia core chipset. It has the MCP51 and uses it for PATA
> > > and SATA.
> > >
> > > Booting the 2.6.20.4 kernel causes two messages (and a kernel lockup)
> > > like this:
> > >
> > > 0000:00:0d.0: cannot adjust BAR0 (not I/O)
> > > 0000:00:0d.0: cannot adjust BAR1 (not I/O)
> > >
> > [   18.754623] Enabling SiS 96x SMBus.
> > [   18.754812] 0000:00:02.5: cannot adjust BAR0 (not I/O)
> > [   18.754816] 0000:00:02.5: cannot adjust BAR1 (not I/O)
> > [   18.754819] 0000:00:02.5: cannot adjust BAR2 (not I/O)
> > [   18.754822] 0000:00:02.5: cannot adjust BAR3 (not I/O)
> 

I am seeing this also on

00:09.0 IDE interface: nVidia Corporation nForce2 IDE (rev a2) (prog-if 8a
[Master SecP PriP])
        Subsystem: EPoX Computer Co., Ltd. Unknown device 1000
        Flags: bus master, 66MHz, fast devsel, latency 0
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled]
[size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled]
[size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled]
[size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled]
[size=1]
        I/O ports at f000 [size=16]
        Capabilities: [44] Power Management version 2

I have epox 8rda3+ motherboard.

0000:00:09.0: cannot adjust BAR0 (not I/O)
0000:00:09.0: cannot adjust BAR1 (not I/O)
0000:00:09.0: cannot adjust BAR2 (not I/O)
0000:00:09.0: cannot adjust BAR3 (not I/O)

Kernel boots, IDE cdrom, and hdd works ok.

###############################

I also have some BAR staff in dmesg on second computer (HP nx6325):

00:14.1 IDE interface: ATI Technologies Inc Standard Dual Channel PCI IDE
Controller (rev 80) (prog-if 82 [Master PriP])
        Subsystem: Hewlett-Packard Company Unknown device 30b0
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
        I/O ports at 01f0 [size=8]
        I/O ports at 03f4 [size=1]
        I/O ports at 0170 [size=8]
        I/O ports at 0374 [size=1]
        I/O ports at 7040 [size=16]
        Capabilities: [70] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

0000:00:14.1: trying to change BAR0 from 0000 to 01F0
0000:00:14.1: trying to change BAR1 from 0000 to 03F4
0000:00:14.1: trying to change BAR2 from 0000 to 0170
0000:00:14.1: trying to change BAR3 from 0000 to 0374

Kernel boots, everything works ok.

--
Greetings - Grzegorz Chwesewicz
