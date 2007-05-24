Return-Path: <linux-kernel-owner+w=401wt.eu-S1751264AbXEXUIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbXEXUIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXEXUI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:08:28 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbXEXUI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:08:27 -0400
Date: Thu, 24 May 2007 13:06:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Message-Id: <20070524130659.de435bd4.akpm@linux-foundation.org>
In-Reply-To: <20070524195616.234280@gmx.net>
References: <20070524195616.234280@gmx.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 21:56:16 +0200
"Uwe Bugla" <uwe.bugla@gmx.de> wrote:

> Hi everybody,

(added linux-wireless, others)

> The patch against b44.c contained in 2.6.22-rc2-mm1 has two consequences:
> 
> 1. a tight binding to module ssb whose function or necessity I neither see through nor do comprehend
> 
> 2. a breakdown (disfunctionality) of my onboard NIC.
> 
> lspci -v looks like this:
> 
> 00:00.0 Host bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM Controller/Host-Hub Interface (rev 02)
> 	Subsystem: ASUSTeK Computer Inc. Unknown device 80b2
> 	Flags: bus master, fast devsel, latency 0
> 	Memory at f8000000 (32-bit, prefetchable) [size=64M]
> 	Capabilities: [e4] Vendor Specific Information
> 	Capabilities: [a0] AGP version 2.0
> 
> 00:01.0 PCI bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE Host-to-AGP Bridge (rev 02) (prog-if 00 [Normal decode])
> 	Flags: bus master, 66MHz, fast devsel, latency 64
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
> 	I/O behind bridge: 0000d000-0000dfff
> 	Memory behind bridge: f2000000-f27fffff
> 	Prefetchable memory behind bridge: f3f00000-f7ffffff
> 
> 00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
> 	Subsystem: ASUSTeK Computer Inc. Unknown device 8089
> 	Flags: bus master, medium devsel, latency 0, IRQ 17
> 	I/O ports at b800 [size=32]
> 
> 00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
> 	Subsystem: ASUSTeK Computer Inc. Unknown device 8089
> 	Flags: bus master, medium devsel, latency 0, IRQ 20
> 	I/O ports at b400 [size=32]
> 
> 00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
> 	Subsystem: ASUSTeK Computer Inc. Unknown device 8089
> 	Flags: bus master, medium devsel, latency 0, IRQ 16
> 	I/O ports at b000 [size=32]
> 
> 00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
> 	Subsystem: ASUSTeK Computer Inc. Unknown device 8089
> 	Flags: bus master, medium devsel, latency 0, IRQ 18
> 	Memory at f1800000 (32-bit, non-prefetchable) [size=1K]
> 	Capabilities: [50] Power Management version 2
> 	Capabilities: [58] Debug port
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 82) (prog-if 00 [Normal decode])
> 	Flags: bus master, fast devsel, latency 0
> 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
> 	Memory behind bridge: f1000000-f17fffff
> 	Prefetchable memory behind bridge: f2800000-f3efffff
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge (rev 02)
> 	Flags: bus master, medium devsel, latency 0
> 
> 00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
> 	Subsystem: ASUSTeK Computer Inc. Unknown device 8089
> 	Flags: bus master, medium devsel, latency 0, IRQ 16
> 	I/O ports at 01f0 [size=8]
> 	I/O ports at 03f4 [size=1]
> 	I/O ports at 0170 [size=8]
> 	I/O ports at 0374 [size=1]
> 	I/O ports at f000 [size=16]
> 	Memory at 30000000 (32-bit, non-prefetchable) [size=1K]
> 
> 00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 02)
> 	Subsystem: ASUSTeK Computer Inc. Unknown device 8089
> 	Flags: medium devsel, IRQ 19
> 	I/O ports at e800 [size=32]
> 
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 02)
> 	Subsystem: ASUSTeK Computer Inc. Unknown device 80b0
> 	Flags: bus master, medium devsel, latency 0, IRQ 19
> 	I/O ports at a800 [size=256]
> 	I/O ports at a400 [size=64]
> 	Memory at f0800000 (32-bit, non-prefetchable) [size=512]
> 	Memory at f0000000 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [50] Power Management version 2
> 
> 01:00.0 VGA compatible controller: ATI Technologies Inc Rage 128 PF/PRO AGP 4x TMDS (prog-if 00 [VGA])
> 	Subsystem: ATI Technologies Inc Rage Fury Pro/Xpert 2000 Pro
> 	Flags: bus master, stepping, 66MHz, medium devsel, latency 64, IRQ 17
> 	Memory at f4000000 (32-bit, prefetchable) [size=64M]
> 	I/O ports at d800 [size=256]
> 	Memory at f2000000 (32-bit, non-prefetchable) [size=16K]
> 	Expansion ROM at f3fe0000 [disabled] [size=128K]
> 	Capabilities: [50] AGP version 2.0
> 	Capabilities: [5c] Power Management version 2
> 
> 02:05.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 01)
> 	Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
> 	Flags: bus master, fast devsel, latency 32, IRQ 255
> 	Memory at f1000000 (32-bit, non-prefetchable) [disabled] [size=8K]
> 	Capabilities: [40] Power Management version 2
> 
> 02:0b.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
> 	Subsystem: Pinnacle Systems Inc. PCTV Sat (DBC receiver)
> 	Flags: bus master, medium devsel, latency 32, IRQ 18
> 	Memory at f3000000 (32-bit, prefetchable) [size=4K]
> 	Capabilities: [44] Vital Product Data
> 	Capabilities: [4c] Power Management version 2
> 
> 02:0b.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
> 	Subsystem: Pinnacle Systems Inc. PCTV Sat (DBC receiver)
> 	Flags: bus master, medium devsel, latency 32, IRQ 18
> 	Memory at f2800000 (32-bit, prefetchable) [size=4K]
> 	Capabilities: [44] Vital Product Data
> 	Capabilities: [4c] Power Management version 2
> 
> Please note:
> 
> 1. IRQ 255 looks very idiotic, doesn't it? It does not exist at all, does it?
> 
> Questions:
> 
> 1. What is the technical need / progress of module ssb please?
> 
> 2. If Andrew Morton's guidelines clearly say: "Do test your patches on three different machines" and this guideline seems to be strictly ignored by some sparetime hackers:
> 
> What is the master plan then to avoid the fact that such a crap is being sent in to Andrew?
> 
> Yours sincerely
> 
> Uwe
> 
> P. S.: There is an important saying going like this:
> 
> Too many cooks do mess up the pap.
> 
> Regarding the patch in mm-tree I can see SIX (!) Copyright owners.
> The last one of them (i. e. the one of 2007) obviuosly does not seem to understand what he is doing (see that nonsense interrupt please, just incredible!) :(
> 
> In so far I would deeply appreciate Andrew Morton to throw that b44.c patch into the trashbox as soon as possible :)
> 

The code presumably worked for the developer.  The reason for merging it
into -mm is to allow others to identify problems such as these before the
code hits mainline.

Having bugs in -mm is normal, natural and expected.  What I _do_ very much
prefer to see is that these bugs get fixed promptly and, critically, that
the code doesn't go into Linus's tree until all the known bugs are
repaired.

Also, it's really bad when a bug makes the entire -mm release unusable for
testers.  Because this means that all the _other_ people who have code
being tested in -mm just lost a tester.  And it can cause people to just
not bother testing -mm kernels at all, which means that more badness will
get into mainline.


