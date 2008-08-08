Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbYHHXDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbYHHXDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758506AbYHHXDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:03:18 -0400
Received: from smtp-01.datacomm.ch ([212.40.2.26]:57730 "EHLO
	smtp-01.datacomm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445AbYHHXDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:03:16 -0400
X-Greylist: delayed 1390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2008 19:03:16 EDT
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
From: Patrick <ragamuffin@datacomm.ch>
To: Pavel Machek <pavel@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20080807081747.GC1647@elf.ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain>
	 <200806090036.32267.rjw@sisk.pl>
	 <1213184587.6376.37.camel@localhost.localdomain>
	 <200806111638.50933.rjw@sisk.pl> <484FE97D.4040805@firstfloor.org>
	 <1215106548.5194.22.camel@localhost.localdomain>
	 <20080807081747.GC1647@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 09 Aug 2008 00:40:04 +0200
Message-Id: <1218235204.5590.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 10:17 +0200, Pavel Machek wrote:

> Can you test 2.6.27-rc2? It should be all there...

Ja, sure! I noticed that it's there already... thank you all!

So as you requested, I got myself a -rc2 tree, compiled and tested
#s2ram and #s2disk. It works!

pat@babar:~/tmp/dmesg$ grep -C3 GART dmesg.2.6.27-rc2-gart-suspend.txt

[    0.208013] PCI: Using ACPI for IRQ routing
[    0.228126] PCI-DMA: Disabling AGP.
[    0.228918] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.228956] PCI-DMA: using GART IOMMU.
[    0.228993] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.229429] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.229615] hpet0: 4 32-bit timers, 14318180 Hz
--
[   45.170754] [drm] Initialized drm 1.1.0 20060810
[   45.199305] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ
18
[   45.199447] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   46.127083] [drm] Setting GART location based on new memory map
[   46.128083] [drm] Loading RS690 Microcode
[   46.128116] [drm] Num pipes: 1
[   46.128123] [drm] writeback test succeeded in 1 usecs
--
[ 5341.902040]   groups: 0
[ 5341.902511] CPU1 is down
[ 5341.902511] Back to C!
[ 5341.902535] PCI-DMA: Resuming GART IOMMU
[ 5341.902537] PCI-DMA: Restoring GART aperture settings
[ 5341.902831] Enabling non-boot CPUs ...
[ 5341.903244] SMP alternatives: switching to SMP code
[ 5341.914231] Booting processor 1/1 ip 6000
--
[ 5778.246557] CPU1 is down
[ 5778.246726] PM: Creating hibernation image:
[ 5778.256008] PM: Need to copy 236714 pages
[ 5778.256008] PCI-DMA: Resuming GART IOMMU
[ 5778.256008] PCI-DMA: Restoring GART aperture settings
[ 5778.256008] Enabling non-boot CPUs ...
[ 5778.256008] SMP alternatives: switching to SMP code
[ 5778.267186] Booting processor 1/1 ip 6000

--------

full log and small test report is here:
http://zefir.890m.com/kernel-testing/
http://zefir.890m.com/kernel-testing/dmesg.2.6.27-rc2.txt

I have no clue what caused the oops (see dmesg), but I think it's
unrelated (look at the time stamps).

Maybe it's got something to do with the fact that I'm using
https://launchpad.net/~xorg-edgers xserver now to have 3d acceleration
working for my radeon X1200 (RS690 builtin) and the drm module versions
don't match. Xserver wants 1.30 but starts anyway. I can't fix this
because the script can't compile the
git://anongit.freedesktop.org/git/mesa/drm modules for 2.6.27-rc2 ....
This creates some unpredictable problems with the X server process when
I log into my account (can't find out what triggers it ... cpu usage
goes to 100%, have to reboot) As a workaround, I could log into a guest
account to do the tests but switched back to my patched 2.6.26-rc5 for
now for everyday PC usage.

BTW, if somebody would like to explain to me, why the simultanious usage
of the GART by drm and as iommu DON'T bite each other, I'd be quiet
interrested to learn.

Patrick

