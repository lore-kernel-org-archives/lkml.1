Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYHAVVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYHAVVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761510AbYHAVN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:13:26 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:43972 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761496AbYHAVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:13:23 -0400
X-Greylist: delayed 1322 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 17:13:23 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18579.30533.807970.739285@stoffel.org>
Date: Fri, 1 Aug 2008 16:51:17 -0400
From: "John Stoffel" <john@stoffel.org>
To: linasvepstas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
In-Reply-To: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linas> I'm seeing strong, easily reproducible (and silent) corruption
Linas> on a sata-attached disk drive on an amd64 board.  It might be
Linas> the disk itself, but I doubt it; googling suggests that its
Linas> somehow iommu-related but I cannot confirm this.

Interesting.  I've got the same motherboard and chipset and memory and
I'm NOT seeing errors.  I just did a quick setup of a 10gb partition
on a Seagate 250gb disk at the end, copied over the latest kernel tree
along with the ubuntu-7.10 ISO image.  No errors on an ext2
filesystem.

Linas> quickie summary:
Linas> -- disk is a brand new WDC WD5000AAKS-00YGA0 500GB disk (well, it
Linas>     was brand new a few months ago -- unusued, at any rate)
Linas> -- passes smartmon with flying colors, including many repeated short and long
Linas>    self-tests. Been passing for months.  No hint of bad sectors or other errors
Linas>    in smartctl -a display
Linas> -- no ide, sata errors in syslog -- no block device errors, no
Linas> fs errors, etc.
Linas> -- No oopses anywhere to be found
Linas> -- system works flawlessly with an old PATA disk. (although I'm
Linas>    running it with dma turned off with hdparm, out of paranoia)
Linas> -- system is amd64 dual core, ASUS M2N-E mobo, 4GB RAM
Linas>    Northbridge is nVidia Corporation MCP55 Memory Controller
Linas>    (rev a3)

Are you running the latest BIOS?  As I recall, my motherboard is an
M2N-SLI Deluxe, which is slightly different from yours.

Linas> -- I tried moving the sata cable around to other ports, no
Linas>    effect; also tried reseating it on hard drive, no effect.

Linas> corruption is *easily* observed copying files with cp or
Linas> dd. Also, typically filesystem metadata is corrupted
Linas> too. Creating even a small ext2 filesystem, say 1GB, then
Linas> copying 300MB of files onto it, unmounting it, and running fsk
Linas> will return many dozens of errors. Rerunning e2fsck over and
Linas> over (as e2fsck -f -y /dev/sda6) will report new errors about 1
Linas> out of every 3 times (on small fs'es -- on big one's it will
Linas> find new errors every time)

Linas> This behaviour has been observed with two different kernels:
Linas> with 2.6.23.9, compiled for 32-bit, and also 2.6.26 complied
Linas> for 64-bit.

I've been running a variety of RC kernels since Mid-Febuary 2008 on my
box and I have not been seeing problems.  

Linas> Googling this uncovers some Dec 2006 LKML emails suggesting an
Linas> iommu problem, which I explored:
Linas> -- My default boot complains
Linas>     Your BIOS doesn't leave a aperture memory hole
Linas>     Please enable the IOMMU option in the BIOS setup
Linas>     This costs you 64 MB of RAM
Linas> -- I cannot find any option in BIOS that even vaguely hints at
Linas>     IOMMU-like function; at best, I can assign interrupts to
Linas>     PCI slots, but that's it.  There's a bunch of IO options
Linas>     for olde-fashioned superio-like stuff: serial,parallel
Linas>     ports, USB stuff, etc. but that's all.
Linas> -- booting with iommu=soft does get rid of the aperature memory hole
Linas>    messsage, but does not solve the corruption problem.
Linas> -- booting with iommu=force seems to have no effect.

Linas> I'm running the powernow-k8 cpu frequency regulator. On a hunch,
Linas> I wondered if this might be the source of the problem; however,
Linas> using the "performance" regulator to keep the clock speed nailed
Linas> at maximum had no effect on the corruption bug.

I'm running the same freq regulator, but I let mine float up and down
from 1ghz to 2.6ghz (my max, not overclocked at all).

Linas> Also of note:
Linas> -- problem was observed earlier, when system had 3GB RAM in it.

What did you do to upgrade to 4gb of ram?  Just pull the second pair
of 512mb DIMMs and put in fresh 1gb DIMMs?  I've got a pair of 2gb
DIMMs in my box.  I suspect you are seeing memory problems of some
sort.

Linas> -- The integrated nvidia ethernet seems to work great, no errors, etc.

Same here.

Linas> -- A different PCI ethernet card works great too.

Never bothered to try.

Linas> -- I'm running graphics on an anceint matrox card in a PCI
Linas>     slot, and there's no hint of trouble there.

I could do this too as a test, but I'm running a PCIe Radeon X1600
without problems either.  

Linas> -- I'm using this system as my day-to-day desktop, and there seem to
Linas>    be no other problems. This suggests that if its some pci iommu
Linas>    wackiness, it certainly not affecting anything that isn't sata.

Linas> I really doubt the problem is the hard-drive; but I'll have to
Linas> buy another one to rule this out. Its possible that there's
Linas> some problem with the sata_nv driver, but there have been
Linas> historical reports of corruption on amd64 with other sata
Linas> controllers. I can buy another sata controller if needed, to
Linas> experiment.

Linas> Other than that, any ideas for any further experiments? What can
Linas> I do to narrow the problem?

Pull all your old memory, just put in the bare minimum and see if the
problem repeats.  

Also, what kind of power supply do you have installed?  Not that I
think you're overloading it with what you list.  

Next, I'd upgraded the BIOS to the latest release, and then reset the
BIOS to the factory default or safe settings to see if that helps.

Good luck!  Let me know if you need me to run tests or get BIOS
information.

John
