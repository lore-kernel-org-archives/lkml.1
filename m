Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbXC1MmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbXC1MmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXC1MmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:42:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbXC1MmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:42:13 -0400
Date: Wed, 28 Mar 2007 14:41:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Meyer <thomas@m3y3r.de>, Frederic Riss <frederic.riss@gmail.com>,
       Marcus Better <marcus@better.se>
Subject: Re: [4/5] 2.6.21-rc5: known regressions
Message-ID: <20070328124121.GA23564@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015949.GB16477@stusta.de> <20070328121958.GA11290@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328121958.GA11290@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>          entry = get_irq_msi(dev->irq);
>          pos = entry->msi_attrib.pos; <-------- crash on NULL dereference
> 
> 
> i.e. 'entry' is NULL after get_irq_msi(). (i can see the crash only on 
> the VGA screen so no dump of it available. Can write down more info if 
> it's helpful.)
> 
> I have tried Eric's patch above but now i always get a hang after 
> "system 00:00: resuming", already upon the first suspend-resume. Not 
> even the NMI watchdog can get the system out of that hang.

find below the PM log of a successful suspend/resume cycle. (I've marked 
the place that hangs with '[hard hang]')

	Ingo

---------------->
PM: Preparing system for mem sleep
Stopping tasks ... done.
psmouse serio2: suspend
psmouse serio1: suspend
atkbd serio0: suspend
i8042 i8042: suspend
sd 0:0:0:0: suspend
ide 0.0: suspend
serial8250 serial8250: suspend
platform vesafb.0: suspend
pci_express 0000:00:1c.3:pcie03: suspend
pci_express 0000:00:1c.3:pcie02: suspend
pci_express 0000:00:1c.3:pcie00: suspend
pci_express 0000:00:1c.2:pcie03: suspend
pci_express 0000:00:1c.2:pcie02: suspend
pci_express 0000:00:1c.2:pcie00: suspend
pci_express 0000:00:1c.1:pcie03: suspend
pci_express 0000:00:1c.1:pcie02: suspend
pci_express 0000:00:1c.1:pcie00: suspend
pci_express 0000:00:1c.0:pcie03: suspend
pci_express 0000:00:1c.0:pcie02: suspend
pci_express 0000:00:1c.0:pcie00: suspend
platform pcspkr: suspend
pnp 00:0a: suspend
i8042 aux 00:09: suspend
i8042 kbd 00:08: suspend
pnp 00:07: suspend
pnp 00:06: suspend
pnp 00:05: suspend
pnp 00:04: suspend
pnp 00:03: suspend
system 00:02: suspend
pnp 00:01: suspend
system 00:00: suspend
yenta_cardbus 0000:15:00.0: suspend
pci 0000:03:00.0: suspend
e1000 0000:02:00.0: suspend
pci 0000:03:00.0: resuming
yenta_cardbus 0000:15:00.0: resuming
PM: Writing back config space on device 0000:15:00.0 at offset f (was 34001ff, writing 5c0010b)
PM: Writing back config space on device 0000:15:00.0 at offset e (was 0, writing 94fc)
PM: Writing back config space on device 0000:15:00.0 at offset d (was 0, writing 9400)
PM: Writing back config space on device 0000:15:00.0 at offset c (was 0, writing 90fc)
PM: Writing back config space on device 0000:15:00.0 at offset b (was 0, writing 9000)
PM: Writing back config space on device 0000:15:00.0 at offset a (was 0, writing 8bfff000)
PM: Writing back config space on device 0000:15:00.0 at offset 9 (was 0, writing 88000000)
PM: Writing back config space on device 0000:15:00.0 at offset 8 (was 0, writing e3fff000)
PM: Writing back config space on device 0000:15:00.0 at offset 7 (was 0, writing e0000000)
PM: Writing back config space on device 0000:15:00.0 at offset 6 (was 0, writing b0171615)
PM: Writing back config space on device 0000:15:00.0 at offset 4 (was 0, writing e4300000)
PM: Writing back config space on device 0000:15:00.0 at offset 3 (was 20000, writing 2a820)
PM: Writing back config space on device 0000:15:00.0 at offset 1 (was 2100000, writing 2100007)
system 00:00: resuming <-------------- [ hard hang ]
pnp 00:01: resuming
system 00:02: resuming
pnp 00:03: resuming
pnp 00:04: resuming
pnp 00:05: resuming
pnp 00:06: resuming
pnp 00:07: resuming
i8042 kbd 00:08: resuming
i8042 aux 00:09: resuming
pnp 00:0a: resuming
platform pcspkr: resuming
pci_express 0000:00:1c.0:pcie00: resuming
pci_express 0000:00:1c.0:pcie02: resuming
pci_express 0000:00:1c.0:pcie03: resuming
pci_express 0000:00:1c.1:pcie00: resuming
pci_express 0000:00:1c.1:pcie02: resuming
pci_express 0000:00:1c.1:pcie03: resuming
pci_express 0000:00:1c.2:pcie00: resuming
pci_express 0000:00:1c.2:pcie02: resuming
pci_express 0000:00:1c.2:pcie03: resuming
pci_express 0000:00:1c.3:pcie00: resuming
pci_express 0000:00:1c.3:pcie02: resuming
pci_express 0000:00:1c.3:pcie03: resuming
platform vesafb.0: resuming
serial8250 serial8250: resuming
ide 0.0: resuming
sd 0:0:0:0: resuming
i8042 i8042: resuming
atkbd serio0: resuming
psmouse serio1: resuming
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
psmouse serio2: resuming
ata1: waiting for device to spin up (7 secs)
Restarting tasks ... done.
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
PM: Preparing system for mem sleep
