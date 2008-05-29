Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYE2QPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYE2QPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbYE2QPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:15:38 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:58419 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429AbYE2QPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:15:37 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops during hibernation - two times the same one
Date: Thu, 29 May 2008 18:15:26 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, pavel@ucw.cz
References: <200805282323.20679.linux@rainbow-software.org> <20080528152919.a5f264cd.akpm@linux-foundation.org> <200805290827.12722.linux@rainbow-software.org>
In-Reply-To: <200805290827.12722.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291815.28469.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2008 08:27:11 Ondrej Zary wrote:
> On Thursday 29 May 2008, Andrew Morton wrote:
> > On Thu, 29 May 2008 00:09:36 +0200
> >
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > On Wednesday, 28 of May 2008, Ondrej Zary wrote:
> > > > Hello,
> > > > I'm using hibernation on my desktop machine every day instead of
> > > > power off. It mostly works but sometimes aborts with "no space left
> > > > on device" error. Closing some programs and trying again usually
> > > > fixes it - but recently, I got two oopses instead. I'm sending them
> > > > because they're the same, only some details are different. Does
> > > > anyone know what might be wrong?
> > >
> > > Thanks for the report, but I have no idea of what could go wrong.
> > >
> > > Rafael
> > >
> > > > ------------[ cut here ]------------
> > > > Kernel BUG at c015610b [verbose debug info unavailable]
> >
> > Looks like this is
> >
> > 	BUG_ON(inode->i_state == I_CLEAR);
> >
> > Please do enable CONFIG_DEBUG_BUGVERBOSE.  Turning off this stuff
> > doesn't gain much.
> >
> > > > invalid opcode: 0000 [#1]
> > > > Modules linked in: snd_sb16 ppdev snd_opl3_synth snd_seq_midi_emul
> > > > snd_opl3_lib snd_hwdep snd_sb16_dsp snd_sb_common snd_mpu401_uart
> > > > snd_rawmidi 3c509 de2104x sr_mod cdrom [last unloaded: snd_sb16]
> > > >
> > > > Pid: 8634, comm: bash Not tainted (2.6.25.3-pentium #3)
> > > > EIP: 0060:[<c015610b>] EFLAGS: 00210246 CPU: 0
> > > > EIP is at iput+0x19/0x61
> > > > EAX: c02db808 EBX: cf402c08 ECX: 0001ec9e EDX: 00000000
> > > > ESI: cf402ba0 EDI: cf987c00 EBP: 00000000 ESP: c9a4deb4
> > > >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > > > Process bash (pid: 8634, ti=c9a4c000 task=c3975000 task.ti=c9a4c000)
> > > > Stack: 00000000 c0163eb5 cf402bac ffffffe4 c142b000 c0329881 cf80b6a0
> > > > c012e212 00000001 c38de7ac 00200286 00001000 00000000 00000001
> > > > 00000000 00000000 c142b000 00000000 00000000 0001ec82 0001ec82
> > > > 00200246 0001ec82 fffffa5d Call Trace:
> > > >  [<c0163eb5>] __blkdev_put+0xc2/0xda
> > > >  [<c012e212>] swsusp_write+0x307/0x311
> > > >  [<c012c81b>] hibernate+0xb4/0x131
> > > >  [<c012b9ad>] state_store+0x41/0xa3
> > > >  [<c012b96c>] state_store+0x0/0xa3
> > > >  [<c01babcb>] kobj_attr_store+0x18/0x1c
> > > >  [<c0173dd0>] sysfs_write_file+0xab/0xd8
> > > >  [<c0173d25>] sysfs_write_file+0x0/0xd8
> > > >  [<c0148a58>] vfs_write+0x7f/0xec
> > > >  [<c0148e9c>] sys_write+0x3c/0x63
> > > >  [<c01039d2>] syscall_call+0x7/0xb
> > > >  [<c02d0000>] i8042_probe+0x4c4/0x4db
> > > >  =======================
> > > > Code: 08 01 00 00 77 ff ff ff eb e5 e8 90 ad 17 00 31 c0 c3 53 85 c0
> > > > 89 c3 74 58 8b 80 8c 00 00 00 83 bb 08 01 00 00 40 8b 40 20 75 04
> > > > <0f> 0b eb fe 85 c0 74 0b 8b 50 10 85 d2 74 04 89 d8 ff d2 8d 43
> > > > EIP: [<c015610b>] iput+0x19/0x61 SS:ESP 0068:c9a4deb4
> >
> > Beats me.  Somehow the swap device's blockdev inode got I_CLEAR set
> > while swsusp_write() was playing with it.  Or during.
> >
> > I guess we could add I_CLEAR checks on resume_bdev into
> > kernel/power/swap.c in various places.
> >
> > Had there been any swapoffs before or during this suspend?
>
> Yes, you're right. I almost forgot that. I have two swaps - one 256MB swap
> partition (the machine has 256MB RAM) and one 128MB swap file. The silly
> thing is that the partition fills up first while the swapfile remains empty
> (ok, it's possible to change the priority - but haven't tried that yet). So
> when the hibernation failed, I tried to free the swap partition using
> swapoff and swapon. Sometimes, it crashes during the swapoff - like
> yesterday (will post later).

OK, here's the other crash. I was wrong, it was during swapon, not swapoff. 
I'll try to reproduce both of them.

PM: Not enough free swap
Restarting tasks ... done.
ata2.01: configured for PIO2
BUG: unable to handle kernel NULL pointer dereference at 00000030
IP: [<c0163812>] bd_claim+0x14/0x3e
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: usbhid snd_opl3_lib snd_hwdep snd_sb16_dsp snd_sb_common 
snd_mpu401_uart snd_rawmidi 3c509 ppdev sr_mod cdrom de2104x [last unloaded: 
snd_sb16]

Pid: 10517, comm: swapon Not tainted (2.6.25.3-pentium #3)
EIP: 0060:[<c0153812>] EFLAGS: 00210207 CPU: 0
EIP is at bd_claim+0x14/0x3e
EAX: 00000000 EBX: cf402ca0 ECX: cf402ba0 EDX: c0142178
ESI: 00000000 EDI: 00000000 EBP: c03daaac ESP: c7095f48
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process swapon (pid: 10517, ti=c7094000 task=c201a550 task.ti=c7094000)
Stack: c0142308 c013b28c 00000000 000000cf 00000000 c70e7000 cf402ba0 cd825340
       cf435b40 0000095c c71cab7c 00000001 cf402c08 b7e57180 c201a550 00000004
       c010c2d4 00000000 cf435b74 c7095fb8 cf435b40 00000000 1c9b5d63 0860d648
Call Trace:
 [<c0142308>] sys_swapon+0x190/0x7be
 [<c013b28c>] handle_mm_fault+0x202/0x438
 [<c010c2d4>] do_page_fault+0x205/0x559
 [<c01039d2>] syscall_call+0x7/0xb
 =======================
Code: 03 48 28 8d 42 a8 8b 50 58 8d 74 26 00 3d 34 67 37 c0 75 e3 89 c8 c3 89 
c1 8b 40 30 39 d0 74 19 85 c0 75 2b 8b 41 40 39 c8 74 0e <8b> 40 30 3d fe 37 
16 c0 74 04 85 c0 75 16 8b 41 40 ff 40 34 c7
EIP: [<c0163812>] bd_claim+0x15/0x3e SS:ESP 0068:c7095f48
---[ end trace 24e66613592015ef ]---



-- 
Ondrej Zary
