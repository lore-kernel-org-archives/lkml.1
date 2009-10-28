Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZJ1KnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZJ1KnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 06:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbZJ1KnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 06:43:09 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:56819 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZJ1KnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 06:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nXY+loeHtbZ+BAHj+3hvxTFy7/ipR6t4/eH3uu67QjMpiVg8FORHhTFDQ/OKUZuY5Q
         2FDkhMKD1o3/kY8UmArAAlgqlIDxGiSEfFTRSGmXr2rph5JJA8+Xr/C8K22PfskwP0wF
         1M8/TfTia/pexlHoxrx32Sj/zhdSw21dhKOOA=
Date: Wed, 28 Oct 2009 18:42:12 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH][RFC] input: remove bios I8042_CTR_XLATE check to make
	keyboard usable
Message-ID: <20091028104211.GA2207@darkstar.vlan7>
References: <20091027053404.GA2241@darkstar.vlan7> <20091028054309.GA2368@core.coreip.homeip.net> <20091028100318.GA4861@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028100318.GA4861@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 11:03:18AM +0100, Vojtech Pavlik wrote:
> On Tue, Oct 27, 2009 at 10:43:10PM -0700, Dmitry Torokhov wrote:
> > Hi Dave,
> > 
> > On Tue, Oct 27, 2009 at 01:34:04PM +0800, Dave Young wrote:
> > > 
> > > Pressing somekey at early booting phase cause keyboard to be not usable
> > > (The hardware is DELL latitude e5400):
> 
> Does early booting mean while the BIOS is coming up? Does the keyboard
> work in GRUB then? Or is it during the early init of the Linux kernel?

Keyboard work under lilo.
For the early booting I means the early init of the linux kernel

>  
> > > atkbd.c: Unknown key pressed (raw set 2, code 0xd3 on isa0060/serio0).
> > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > > atkbd.c: Unknown key pressed (raw set 2, code 0x1d3 on isa0060/serio0).
> > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > > 
> > > i8042.c set i8042_direct to true when the controller init. But the result
> > > is keyboard not usable, The only option is press the power button to shutdown. 
> > > 
> > > So here remove the bios check to fix it.
> 
> My question would be: Why this happens? Could it be that the probe is
> confused by the keypress and reads the CTR incorrectly? Or is it just
> that the keyboard controller is in fact in translating mode, yet the CTR
> indicates otherwise?
> 
> A i8042.debug=1 log of the bad init would be good.

Here it is (retrieve from syslog):

Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: RSDP 000fbce0 00024 (v02 DELL  )
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: XSDT 3d391e00 00064 (v01 DELL    M09     27D9041D ASL  00000061)
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: FACP 3d391c9c 000F4 (v04 DELL    M09     27D9041D ASL  00000061)
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: DSDT 3d392400 06857 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: FACS 3d3a0c00 00040
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: HPET 3d391f00 00038 (v01 DELL    M09     00000001 ASL  00000061)
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: DMAR 3d3a0400 000F8 (v01 DELL    M09     27D9041D ASL  00000061)
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: APIC 3d392000 00068 (v01 DELL    M09     27D9041D ASL  00000047)
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: ASF! 3d391c00 00076 (v32 DELL    M09     27D9041D ASL  00000061)
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: MCFG 3d391fc0 0003E (v16 DELL    M09     27D9041D ASL  00000061)
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: TCPA 3d392300 00032 (v01                 00000000 ASL  00000000)
Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: SSDT 3d3902e7 0066C (v01  PmRef    CpuPm 00003000 INTL 20050624)
Oct 28 18:31:40 darkstar kernel: [    0.000000] Zone PFN ranges:
Oct 28 18:31:40 darkstar kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Oct 28 18:31:40 darkstar kernel: [    0.000000]   Normal   0x00001000 -> 0x000377fe
Oct 28 18:31:40 darkstar kernel: [    0.000000]   HighMem  0x000377fe -> 0x0003d38d
Oct 28 18:31:40 darkstar kernel: [    0.000000] Movable zone start PFN for each node
Oct 28 18:31:40 darkstar kernel: [    0.000000] early_node_map[2] active PFN ranges
Oct 28 18:31:40 darkstar kernel: [    0.000000]     0: 0x00000000 -> 0x0000009f
Oct 28 18:31:40 darkstar kernel: [    0.000000]     0: 0x00000100 -> 0x0003d38d
Oct 28 18:31:40 darkstar kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 248708
Oct 28 18:31:40 darkstar kernel: [    0.000000] Console: colour dummy device 80x25
Oct 28 18:31:40 darkstar kernel: [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCK_DEPTH:          48
Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
Oct 28 18:31:40 darkstar kernel: [    0.000000] ... CLASSHASH_SIZE:          4096
Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
Oct 28 18:31:40 darkstar kernel: [    0.000000] ... CHAINHASH_SIZE:          16384
Oct 28 18:31:40 darkstar kernel: [    0.000000]  memory used by lock dependency info: 3567 kB
Oct 28 18:31:40 darkstar kernel: [    0.000000]  per task-struct memory footprint: 1152 bytes
Oct 28 18:31:40 darkstar kernel: [    0.000000] Fast TSC calibration using PIT
Oct 28 18:31:40 darkstar kernel: [    0.000000] Detected 1995.305 MHz processor.
Oct 28 18:31:40 darkstar kernel: [    0.003477] Mount-cache hash table entries: 512
Oct 28 18:31:40 darkstar kernel: [    0.073332] lockdep: fixing up alternatives.
Oct 28 18:31:40 darkstar kernel: [    0.167889] khelper used greatest stack depth: 6736 bytes left
Oct 28 18:31:40 darkstar kernel: [    0.167906] Time: 18:31:22  Date: 10/28/09
Oct 28 18:31:40 darkstar kernel: [    0.183926] bio: create slab <bio-0> at 0
Oct 28 18:31:40 darkstar kernel: [    0.233917] ACPI: SSDT 3d3a0c80 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
Oct 28 18:31:40 darkstar kernel: [    0.699300] highmem bounce pool size: 64 pages
Oct 28 18:31:40 darkstar kernel: [    0.707157] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Oct 28 18:31:40 darkstar kernel: [    0.713658] ALI M7101 PMU not found.
Oct 28 18:31:40 darkstar kernel: [    0.727193] Console: switching to colour frame buffer device 128x48
Oct 28 18:31:40 darkstar kernel: [    0.745940] ACPI: SSDT 3d390953 002C3 (v01  PmRef   BspIst 00003000 INTL 20050624)
Oct 28 18:31:40 darkstar kernel: [    0.747451] ACPI: SSDT 3d390ded 005C6 (v01  PmRef   BspCst 00003001 INTL 20050624)
Oct 28 18:31:40 darkstar kernel: [    0.750953] ACPI: SSDT 3d390c16 001D7 (v01  PmRef    ApIst 00003000 INTL 20050624)
Oct 28 18:31:40 darkstar kernel: [    0.752370] ACPI: SSDT 3d3913b3 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
Oct 28 18:31:40 darkstar kernel: [    0.808726] i8k: unable to get SMM BIOS version
Oct 28 18:31:40 darkstar kernel: [    0.831297] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Oct 28 18:31:40 darkstar kernel: [    0.836900] Hangcheck: Using get_cycles().
Oct 28 18:31:40 darkstar kernel: [    0.858621] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
Oct 28 18:31:40 darkstar kernel: [    0.888873] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to expected String at index 9 (20090903/nsrepair-132)
Oct 28 18:31:40 darkstar kernel: [    0.894759] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to expected String at index 10 (20090903/nsrepair-132)
Oct 28 18:31:40 darkstar kernel: [    0.900646] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to expected String at index 11 (20090903/nsrepair-132)
Oct 28 18:31:40 darkstar kernel: [    0.906408] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to expected String at index 12 (20090903/nsrepair-132)
Oct 28 18:31:40 darkstar kernel: [    1.006024] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-B
Oct 28 18:31:40 darkstar kernel: [    1.022192] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-C
Oct 28 18:31:40 darkstar kernel: [    1.033201] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-D
Oct 28 18:31:40 darkstar kernel: [    1.652138] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
Oct 28 18:31:40 darkstar kernel: [    1.657946] Console: switching to colour dummy device 80x25
Oct 28 18:31:40 darkstar kernel: [    1.940032] async/0 used greatest stack depth: 6204 bytes left
Oct 28 18:31:40 darkstar kernel: [    2.033774] Console: switching to colour frame buffer device 160x50
Oct 28 18:31:40 darkstar kernel: [    2.114389] ACPI Warning for \_SB_.PCI0.VID2._DOD: Return Package has no elements (empty) (20090903/nspredef-433)
Oct 28 18:31:40 darkstar kernel: [    2.657074] i8042.c: Warning: Keylock active.
Oct 28 18:31:40 darkstar kernel: [    2.666119] Driver 'rtc_cmos' needs updating - please use bus_type methods
Oct 28 18:31:40 darkstar kernel: [    3.796606] Netfilter messages via NETLINK v0.30.
Oct 28 18:31:40 darkstar kernel: [    3.796700] nf_conntrack version 0.5.0 (15347 buckets, 61388 max)
Oct 28 18:31:40 darkstar kernel: [    3.797524] ctnetlink v0.93: registering with nfnetlink.
Oct 28 18:31:40 darkstar kernel: [    4.196617]  sda1 sda2 sda3 sda4 <
Oct 28 18:31:40 darkstar kernel: [    4.234941] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Oct 28 18:31:40 darkstar kernel: [    4.415478]  sda5
Oct 28 18:31:40 darkstar kernel: [    4.662008]  sda6 sda7
Oct 28 18:31:40 darkstar kernel: [    4.696955]  sda8 >
Oct 28 18:31:40 darkstar kernel: [    4.696839] atkbd.c: Unknown key pressed (raw set 2, code 0x125 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    4.696839] atkbd.c: Use 'setkeycodes 25 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    4.783405] registered taskstats version 1
Oct 28 18:31:40 darkstar kernel: [    4.811084]   Magic number: 13:516:545
Oct 28 18:31:40 darkstar kernel: [    4.832325] atkbd.c: Unknown key pressed (raw set 2, code 0x124 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    4.832327] atkbd.c: Use 'setkeycodes 24 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.081883] atkbd.c: Unknown key pressed (raw set 2, code 0x126 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.085138] atkbd.c: Use 'setkeycodes 26 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.125712] atkbd.c: Unknown key pressed (raw set 2, code 0x125 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.128995] atkbd.c: Use 'setkeycodes 25 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.266914] async/1 used greatest stack depth: 5944 bytes left
Oct 28 18:31:40 darkstar kernel: [    5.288891] atkbd.c: Unknown key pressed (raw set 2, code 0x124 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.292146] atkbd.c: Use 'setkeycodes 24 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.390758] atkbd.c: Unknown key pressed (raw set 2, code 0x125 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.410290] atkbd.c: Use 'setkeycodes 25 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.410290] atkbd.c: Unknown key pressed (raw set 2, code 0x121 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.410290] atkbd.c: Use 'setkeycodes 21 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.544134] atkbd.c: Unknown key pressed (raw set 2, code 0x124 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.545078] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
Oct 28 18:31:40 darkstar kernel: [    5.547392] atkbd.c: Use 'setkeycodes 24 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.659418] atkbd.c: Unknown key pressed (raw set 2, code 0x126 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.680843] atkbd.c: Use 'setkeycodes 26 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.719052] atkbd.c: Unknown key pressed (raw set 2, code 0x125 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.719055] atkbd.c: Use 'setkeycodes 25 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.798708] atkbd.c: Unknown key pressed (raw set 2, code 0x121 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.802006] atkbd.c: Use 'setkeycodes 21 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    5.858461] atkbd.c: Unknown key pressed (raw set 2, code 0x124 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    5.861732] atkbd.c: Use 'setkeycodes 24 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    6.047765] atkbd.c: Unknown key pressed (raw set 2, code 0x120 on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Unknown key pressed (raw set 2, code 0x11e on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Use 'setkeycodes 1e <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Unknown key pressed (raw set 2, code 0x11f on isa0060/serio0).
Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Use 'setkeycodes 1f <keycode>' to make it known.
Oct 28 18:31:40 darkstar kernel: [    8.220557] cdrom_id used greatest stack depth: 5856 bytes left
Oct 28 18:31:40 darkstar kernel: [   17.219715] REISERFS warning (device sda5):  reiserfs_fill_super: CONFIG_REISERFS_CHECK is set ON
Oct 28 18:31:40 darkstar kernel: [   17.230511] REISERFS warning (device sda5):  reiserfs_fill_super: - it is slow mode for debugging.
Oct 28 18:31:40 darkstar kernel: [   17.374339] mount used greatest stack depth: 5796 bytes left
Oct 28 18:31:46 darkstar kernel: [   24.237922] update-mime-dat used greatest stack depth: 5772 bytes left
Oct 28 18:31:47 darkstar kernel: [   25.233169] atkbd.c: Unknown key pressed (raw set 2, code 0x20 on isa0060/serio0).
Oct 28 18:31:47 darkstar kernel: [   25.233176] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
Oct 28 18:31:47 darkstar kernel: [   25.358673] atkbd.c: Unknown key pressed (raw set 2, code 0x120 on isa0060/serio0).
Oct 28 18:31:47 darkstar kernel: [   25.358681] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
Oct 28 18:31:47 darkstar kernel: [   25.563353] atkbd.c: Unknown key pressed (raw set 2, code 0x20 on isa0060/serio0).
Oct 28 18:31:47 darkstar kernel: [   25.563360] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
Oct 28 18:31:47 darkstar kernel: [   25.687429] atkbd.c: Unknown key pressed (raw set 2, code 0x120 on isa0060/serio0).
Oct 28 18:31:47 darkstar kernel: [   25.687437] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
Oct 28 18:31:48 darkstar kernel: [   25.841800] atkbd.c: Unknown key pressed (raw set 2, code 0x20 on isa0060/serio0).
Oct 28 18:31:48 darkstar kernel: [   25.841808] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
Oct 28 18:31:48 darkstar kernel: [   25.956515] atkbd.c: Unknown key pressed (raw set 2, code 0x120 on isa0060/serio0).
Oct 28 18:31:48 darkstar kernel: [   25.956522] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.

> 
> > I would be a little hesitant to force translation by default on all
> > architectures, although it may make sense on x86...
> 
> The old 2.4 kernel sources say that there are some IBM PowerPC portables
> that don't support translation at all. I wouldn't be surprised if there
> were more examples like that in the embedded space.
> 
> I'm not aware of any x86 machine that wouldn't support the translated
> mode.
> 
> > Vojtech, you wrote the thing, do you see any issues with forcing
> > translation? I think most of the x86 boxes work in translated mode and
> > the only time it is in raw is when BIOS screwed up initialization.
> > 
> > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > > ---
> > >  drivers/input/serio/i8042.c |    8 --------
> > >  1 file changed, 8 deletions(-)
> > > 
> > > --- linux-2.6.orig/drivers/input/serio/i8042.c	2009-10-13 08:57:07.000000000 +0800
> > > +++ linux-2.6/drivers/input/serio/i8042.c	2009-10-27 13:15:13.000000000 +0800
> > > @@ -869,14 +869,6 @@ static int i8042_controller_init(void)
> > >  	spin_unlock_irqrestore(&i8042_lock, flags);
> > >  
> > >  /*
> > > - * If the chip is configured into nontranslated mode by the BIOS, don't
> > > - * bother enabling translating and be happy.
> > > - */
> > > -
> > > -	if (~i8042_ctr & I8042_CTR_XLATE)
> > > -		i8042_direct = true;
> > > -
> > > -/*
> > >   * Set nontranslated mode for the kbd interface if requested by an option.
> > >   * After this the kbd interface becomes a simple serial in/out, like the aux
> > >   * interface is. We don't do this by default, since it can confuse notebook
> 
> -- 
> Vojtech Pavlik
> Director SuSE Labs
