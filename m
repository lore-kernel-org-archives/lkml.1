Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYFYLCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYFYLCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbYFYLBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:01:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56325 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbYFYLBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:01:40 -0400
Date: Wed, 25 Jun 2008 13:01:06 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org,
       bzolnier@gmail.com, linux-ide@vger.kernel.org
Subject: Re: [regression] Re: 2.6.26-rc6: pcmcia stopped working
Message-ID: <20080625110105.GA1551@elf.ucw.cz>
References: <20080622224022.GA2066@elf.ucw.cz> <20080623081309.GA10820@isilmar.linta.de> <20080623081811.GA1850@elf.ucw.cz> <20080623083046.GA12849@isilmar.linta.de> <20080625102347.GA2011@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625102347.GA2011@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-06-25 12:23:47, Pavel Machek wrote:
> On Mon 2008-06-23 10:30:46, Dominik Brodowski wrote:
> > On Mon, Jun 23, 2008 at 10:18:11AM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > After s2ram and resume, CF card in PCMCIA-to-CF slot is no longer
> > > > > detected.
> > > > 
> > > > might this be related to:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=10957 ? There didn't change
> > > > anything with regard to pcmcia between -rc3 and -rc6...
> > > 
> > > I'm pretty sure it worked in 2.6.25; I don't know if it worked in
> > > -rc3, or not.
> > > 
> > > I don't even see note about card insertion in dmesg, so I figured out
> > > it is probably pcmcia-core problem (or something deeper).
> > 
> > Well, even since 2.6.25 not much changed in PCMCIA-land, so...
> 
> Actually, it is worse. On thinkpad, PCMCIA card is only detected
> once. If I remove it and reinsert it, it will not be detected, and
> machine will not reboot.
> 
> Thinkpad X60.

Hmm, but with -rc8, I actually got some useful info:

kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
debug: unmapping init memory c099f000..c09ef000
Write protecting the kernel text: 5320k
Write protecting the kernel read-only data: 1916k
Failed to execute /tmp/swsusp-init.  Attempting defaults...
EXT3 FS on sda4, internal journal
Adding 987988k swap on /dev/sda1.  Priority:-1 extents:1 across:987988k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwclock.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
coda_read_super: Bad mount data
coda_read_super: device index: 0
coda_read_super: rootfid is (01234567.ffffffff.08051a38.00000000)
coda: Unexpected interruption.
Failure of coda_cnode_make for root: error -4
pccard: PCMCIA card inserted into slot 0
cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xd3fff 0xdc000-0xfffff
cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff 0xe4e70000-0xe523ffff 0xe5db0000-0xe617ffff 0xe6cf0000-0xe70bffff
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
Clocksource tsc unstable (delta = -68835537 ns)
pccard: card ejected from slot 0
INFO: task pccardd:1121 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pccardd       D f6dd1e1c     0  1121      2
       f6dd1e30 00000086 00000002 f6dd1e1c f6dd1e10 00000000 c2015e80 c2015e80 
       c09113e0 00000286 00000286 f72d13b8 f72d1618 c2015e80 f6dd0000 f6afedc0 
       ffff03a9 f6bcb458 00000000 c02bd187 00000000 f6dd1e4c 00000003 00000000 
Call Trace:
 [<c02bd187>] sysfs_addrm_finish+0x1a7/0x1e0
 [<c072edec>] schedule_timeout+0x7c/0xd0
 [<c02bd1e7>] remove_dir+0x27/0x40
 [<c0730b9a>] _spin_lock_irq+0x2a/0x40
 [<c072e240>] wait_for_common+0xc0/0x130
 [<c021f5c0>] default_wake_function+0x0/0x10
 [<c04d489f>] ide_unregister+0xcf/0x150
 [<c04e5671>] ide_release+0x21/0x40
 [<c04e56b9>] ide_detach+0x29/0x80
 [<c0520146>] pcmcia_device_remove+0x36/0xe0
 [<c0423116>] __device_release_driver+0x56/0x90
 [<c0423210>] device_release_driver+0x20/0x40
 [<c04225bb>] bus_remove_device+0x6b/0x90
 [<c04210cf>] device_del+0xcf/0x140
 [<c0421148>] device_unregister+0x8/0x10
 [<c051fb7c>] pcmcia_card_remove+0x6c/0x80
 [<c0520a34>] ds_event+0x64/0xb0
 [<c051c12f>] pccardd+0x16f/0x2a0
 [<c051b7fb>] send_event+0x4b/0x80
 [<c051ba6b>] socket_shutdown+0xb/0xd0
 [<c051bb4c>] socket_remove+0x1c/0x30
 [<c051c1fe>] pccardd+0x23e/0x2a0
 [<c021f5c0>] default_wake_function+0x0/0x10
 [<c051bfc0>] pccardd+0x0/0x2a0
 [<c023c3f2>] kthread+0x42/0x70
 [<c023c3b0>] kthread+0x0/0x70
 [<c02047ab>] kernel_thread_helper+0x7/0x1c
 [<c04216f2>] device_create_vargs+0x42/0xd0
 =======================
no locks held by pccardd/1121.
INFO: task pccardd:1121 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pccardd       D f6dd1e1c     0  1121      2
       f6dd1e30 00000086 00000002 f6dd1e1c f6dd1e10 00000000 c2015e80 c2015e80 
       c09113e0 00000286 00000286 f72d13b8 f72d1618 c2015e80 f6dd0000 f6afedc0 
       ffff03a9 f6bcb458 00000000 c02bd187 00000000 f6dd1e4c 00000003 00000000 
Call Trace:
 [<c02bd187>] sysfs_addrm_finish+0x1a7/0x1e0
 [<c072edec>] schedule_timeout+0x7c/0xd0
 [<c02bd1e7>] remove_dir+0x27/0x40
 [<c0730b9a>] _spin_lock_irq+0x2a/0x40
 [<c072e240>] wait_for_common+0xc0/0x130
 [<c021f5c0>] default_wake_function+0x0/0x10
 [<c04d489f>] ide_unregister+0xcf/0x150
 [<c04e5671>] ide_release+0x21/0x40
 [<c04e56b9>] ide_detach+0x29/0x80
 [<c0520146>] pcmcia_device_remove+0x36/0xe0
 [<c0423116>] __device_release_driver+0x56/0x90
 [<c0423210>] device_release_driver+0x20/0x40
 [<c04225bb>] bus_remove_device+0x6b/0x90
 [<c04210cf>] device_del+0xcf/0x140
 [<c0421148>] device_unregister+0x8/0x10
 [<c051fb7c>] pcmcia_card_remove+0x6c/0x80
 [<c0520a34>] ds_event+0x64/0xb0
 [<c051c12f>] pccardd+0x16f/0x2a0
 [<c051b7fb>] send_event+0x4b/0x80
 [<c051ba6b>] socket_shutdown+0xb/0xd0
 [<c051bb4c>] socket_remove+0x1c/0x30
 [<c051c1fe>] pccardd+0x23e/0x2a0
 [<c021f5c0>] default_wake_function+0x0/0x10
 [<c051bfc0>] pccardd+0x0/0x2a0
 [<c023c3f2>] kthread+0x42/0x70
 [<c023c3b0>] kthread+0x0/0x70
 [<c02047ab>] kernel_thread_helper+0x7/0x1c
 [<c04216f2>] device_create_vargs+0x42/0xd0
 =======================
no locks held by pccardd/1121.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
