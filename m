Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYGFMep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYGFMep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 08:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYGFMeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 08:34:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33692 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYGFMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 08:34:36 -0400
Date: Sun, 6 Jul 2008 14:35:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Re: 2.6.26-rc6: pcmcia stopped working
Message-ID: <20080706123530.GA1862@elf.ucw.cz>
References: <20080622224022.GA2066@elf.ucw.cz> <20080625220946.GA1587@elf.ucw.cz> <20080625221529.GA1600@elf.ucw.cz> <200807051448.40466.bzolnier@gmail.com> <20080705224631.GA32546@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080705224631.GA32546@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-07-06 00:46:31, Pavel Machek wrote:
> Hi!
> 
> > > > > Hmm, hitting sysrq-w produces no blocked task until I eject pcmcia
> > > > > card. Backtrace there is:
> > > > > 
> > > > > Greg, I believe some traces lead to sysfs, can you help here?
> > > > 
> > > > ide_unregister() does not complete :-(.
> > > > 
> > > >         device_unregister(&hwif->gendev);
> > > > +       printk("ide_unregister: waiting for rel_comp\n");
> > > >         wait_for_completion(&hwif->gendev_rel_comp);
> > > > 
> > > > ...that wait_for_completion never returns.
> > 
> > [...]
> > 
> > Thanks for narrowing it down to wait_for_completion() call,
> > it was an useful hint.

Patched version seems to work here, thanks.

Tested-by: Pavel Machek <pavel@suse.cz>

There's still some funny stuff going on: Trying to free nonexistent
resource <> seems to indicate a code problem somewhere, and "hdc:
set_geometry_intr: error" is slightly scary, but the flash card seems
to work ok.
								Pavel

PM: Resume from disk failed.
Probing IDE interface ide1...
hdc: SunDisk SDP3B-20, CFA DISK drive
hdd: SunDisk SDP3B-20, CFA DISK drive
ide-probe: ignoring undecoded slave
ide1 at 0x9100-0x9107,0x910e on irq 16
hdc: max request size: 128KiB
hdc: 40960 sectors (20 MB) w/1KiB Cache, CHS=640/2/32
 hdc:hdc: set_geometry_intr: status=0x51 { DriveReady SeekComplete
Error }
hdc: set_geometry_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
 hdc1 hdc3
ide-cs: hdc: Vpp = 0.0
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
...
Failure of coda_cnode_make for root: error -4
pccard: card ejected from slot 0
Trying to free nonexistent resource <000000000000910e-000000000000910e>
Trying to free nonexistent resource <0000000000009100-0000000000009107>
pccard: PCMCIA card inserted into slot 0
pcmcia: registering new device pcmcia0.0
Probing IDE interface ide1...
hdc: SunDisk SDP3B-20, CFA DISK drive
hdd: SunDisk SDP3B-20, CFA DISK drive
ide-probe: ignoring undecoded slave
ide1 at 0x9100-0x9107,0x910e on irq 16
hdc: max request size: 128KiB
hdc: 40960 sectors (20 MB) w/1KiB Cache, CHS=640/2/32
 hdc:hdc: set_geometry_intr: status=0x51 { DriveReady SeekComplete Error }
hdc: set_geometry_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
 hdc1 hdc3
ide-cs: hdc: Vpp = 0.0
Clocksource tsc unstable (delta = -63722496 ns)





-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
