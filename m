Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYA2EYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYA2EYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYA2EYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:24:35 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44277 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbYA2EYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:24:33 -0500
Subject: Re: Problem with ata layer in 2.6.24
From: Kasper Sandberg <lkml@metanurb.dk>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
In-Reply-To: <200801281135.14555.gene.heskett@gmail.com>
References: <200801272122.21823.gene.heskett@gmail.com>
	 <200801280754.53768.gene.heskett@gmail.com>
	 <18333.57152.472830.608248@harpo.it.uu.se>
	 <200801281135.14555.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 05:23:36 +0100
Message-Id: <1201580616.12795.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-28 at 11:35 -0500, Gene Heskett wrote:
> On Monday 28 January 2008, Mikael Pettersson wrote:
> >Gene Heskett writes:
> > > On Monday 28 January 2008, Peter Zijlstra wrote:
> > > >On Mon, 2008-01-28 at 09:17 +0100, Mikael Pettersson wrote:
> > > >> 1. Wrong mailing list; use linux-ide (@vger) instead.
> > > >
> > > >What, and keep all us other interested people in the dark?
> > >
> > > As a test, I tried rebooting to the latest fedora kernel and found it
> > > kills X, so I'm back to the second to last fedora version ATM, and the
> > > third 'smartctl -t lng /dev/sda' in 24 hours is running now.  The first
> > > two completed with no errors.
> > >
> > > I've added the linux-ide list to refresh those people of the problem,
> > > the logs are being spammed by this message stanza:
> > >
> > >  Jan 28 04:46:25 coyote kernel: [26550.290016] ata1.00: exception Emask
> > > 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen Jan 28 04:46:25 coyote kernel:
> > > [26550.290028] ata1.00: cmd 35/00:58:c9:9c:0a/00:01:00:00:00/e0 tag 0 dma
> > > 176128 out Jan 28 04:46:25 coyote kernel: [26550.290029]          res
> > > 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout) Jan 28 04:46:25
> > > coyote kernel: [26550.290032] ata1.00: status: { DRDY } Jan 28 04:46:25
> > > coyote kernel: [26550.290060] ata1: soft resetting link Jan 28 04:46:25
> > > coyote kernel: [26550.452301] ata1.00: configured for UDMA/100 Jan 28
> > > 04:46:25 coyote kernel: [26550.452318] ata1: EH complete
> > > Jan 28 04:46:25 coyote kernel: [26550.455898] sd 0:0:0:0: [sda] 390721968
> > > 512-byte hardware sectors (200050 MB) Jan 28 04:46:25 coyote kernel:
> > > [26550.456151] sd 0:0:0:0: [sda] Write Protect is off Jan 28 04:46:25
> > > coyote kernel: [26550.456403] sd 0:0:0:0: [sda] Write cache: enabled,
> > > read cache: enabled, doesn't support DPO or FUA
> >
> >It's not obvious from this incomplete dmesg log what HW or driver
> >is behind ata1, but if the 2.6.24-rc7 kernel matches the 2.6.24 one,
> >
> >it should be pata_amd driving a WDC disk:
> > > [   30.702887] pata_amd 0000:00:09.0: version 0.3.10
> > > [   30.703052] PCI: Setting latency timer of device 0000:00:09.0 to 64
> > > [   30.703188] scsi0 : pata_amd
> > > [   30.709313] scsi1 : pata_amd
> > > [   30.710076] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000
> > > irq 14 [   30.710079] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma
> > > 0xf008 irq 15 [   30.864753] ata1.00: ATA-6: WDC WD2000JB-00EVA0,
> > > 15.05R15, max UDMA/100 [   30.864756] ata1.00: 390721968 sectors, multi
> > > 16: LBA48
> > > [   30.871629] ata1.00: configured for UDMA/100
> >
> >Unfortunately we also see:
> > > [   48.285456] nvidia: module license 'NVIDIA' taints kernel.
> > > [   48.549725] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC4] -> GSI
> > > 19 (level, high) -> IRQ 20 [   48.550149] NVRM: loading NVIDIA UNIX x86
> > > Kernel Module  169.07  Thu Dec 13 18:42:56 PST 2007
> >
> >We have no way of debugging that module, so please try 2.6.24 without it.
> 
> Sorry, I can't do this and have a working machine.  The nv driver has suffered 
> bit rot or something since the FC2 days when it COULD run a 19" crt at 
> 1600x1200, and will not drive this 20" wide screen lcd 1680x1050 monitor at 
> more than 800x600, which is absolutely butt ugly fuzzy, looking like a jpg 
> compressed to 10%.  The system is not usable on a day to basis without the 
> nvidia driver.
> 
> Fix the nv driver so it will run this screen at its native resolution and I'll 
> be glad to run it even if it won't run google earth, which I do use from time 
> to time.  Now, if in all the hits you can get from google on this, currently 
> 14,800 just for 'exception Emask', apparently caused by a timeout, if 100% of 
> the complainers are running nvidia drivers also, then I see a legit 
I can invalidate this theory...
i helped a guy on irc debug this problem, and he had ati. I tried having
him stop using fglrx, and go to r300.. same problem, and same problem
even with vesa.. :)

also, i have this on my fileserver with .20, which doesent even run X,
or module support in kernel :)

> complaint.  Again, fix the nv driver so it will run my screen & I'll be glad 
> to switch.  I can see the reason, sure, but the machine must be capable of 
> doing its common day to day stuff, while using that driver, like running kde 
> for kmail, and browsers that work.
> 
> >If the problems persist, please try to capture a complete log from the
> >failing kernel -- the interesting bits are everything from initial boot
> >up to and including the first few errors. You may need to increase the
> >kernel's log buffer size if the log gets truncated (CONFIG_LOG_BUF_SHIFT).
> 
> If by log you mean /var/log/messages, I have several megabytes of those.
> If you mean a live dmesg capture taken right now, its attached. It contains 
> several of these at the bottom.  I long ago made the kernel log buffer 
> bigger, cuz it couldn't even show the start immediately after the boot, and 
> even the dump to syslog was truncated.
> 
> >There are no pata_amd changes from 2.6.24-rc7 to 2.6.24 final.
> 
> That is what I was afraid of.  I've done some limited grepping in that branch 
> of the kernel tree, and cannot seem to locate where this EH handler is being 
> invoked from.
> 
> There is 2 lines of interest in the dmesg:
> 
> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
> [    0.000000] If you got timer trouble try acpi_use_timer_override
> 
> But I have NDI what it means, kernel argument/xconfig option?
> 
> I've also done some googling, and it appears this problem is fairly widespread 
> since the switchover to libata was encouraged.  A stock fedora F8 kernel 
> suffers the same freezes and eventually locks up, but does it without the 
> error messages being logged, it just freezes, feeling identical to this in 
> the minutes before the total freeze.  I've tried 2 of those too, but the 
> newest one won't even run X.
> 

