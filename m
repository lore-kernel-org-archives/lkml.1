Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbZASVmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbZASVmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZASVmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:42:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53889 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbZASVmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:42:06 -0500
Date: Mon, 19 Jan 2009 22:44:11 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com,
       trenn@suse.de, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.29-rc2: thinkpad dock -- cdrom vs. s2ram
Message-ID: <20090119214410.GA2016@elf.ucw.cz>
References: <20090119202423.GA7070@ucw.cz> <200901192150.59438.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901192150.59438.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-19 21:50:58, Rafael J. Wysocki wrote:
> On Monday 19 January 2009, Pavel Machek wrote:
> > Hi!
> > 
> > In 2.6.29 (and probably earlier) kernels, booting in docking station
> > results in undocked s2ram failing.
> > 
> > Problem seems to be that hda (cdrom in dock) is not deregistered
> > during undock, and that hda driver loops spitting error messages at
> > 'too-fast-to-read' rate when suspend with missing hda is attempted.
> 
> What driver do you mean exactly?  Old-IDE I would guess.

piix. hda, so I guess it is old-ide:

piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
pci 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
piix 0000:00:1f.1: IDE port disabled
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1810-0x1817
Probing IDE interface ide0...
hda: UJDA765 DVD/CDRW, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter for probing
all legacy ISA IDE ports
ide-gd driver 1.18
ide-cd driver 5.00
ide-cd: hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20

If I try to access cdrom after undocking, I get:

hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted
hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted
hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hda: drive not ready for command
hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted
ide-cd: hda: weird block size 0
ide-cd: hda: default to 2kb block size
hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted
hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted
hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted
hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted
hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted
hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted
hda: status error: status=0x20 { DeviceFault }
ide: failed opcode was: unknown
hda: Strange, packet command initiated yet DRQ isn't asserted

...something similar scrolls when it hangs during s2ram, but it is too
fast to read.

> Does this also happen with a PATA/libata driver?

Will try...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
