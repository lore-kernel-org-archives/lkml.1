Return-Path: <linux-kernel-owner+w=401wt.eu-S934970AbYBUQtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934970AbYBUQtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934796AbYBUQtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:49:24 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:48639 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934762AbYBUQtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:49:19 -0500
X-Authority-Analysis: v=1.0 c=1 a=bojhYoMd2USPMMK5XVEeMQ==:17
 a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8 a=xTmUNfhOct53F0HthOsA:9
 a=7Z6ucVVE7jmGFmYRfTYA:7 a=RAcOttNhkANl4PxEcTOlcVcd8vAA:4 a=MSl-tDqOz04A:10
 a=KUJAPYlYduUA:10
From: kelk1@comcast.net (Quel Qun)
To: "Dave Young" <hidave.darkstar@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, "Jiri Kosina" <jkosina@suse.cz>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
Date: Thu, 21 Feb 2008 16:49:13 +0000
Message-Id: <022120081649.19368.47BDAB89000C038700004BA82207300793CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 -------------- Original message ----------------------
From: "Dave Young" <hidave.darkstar@gmail.com>
> On Wed, Feb 20, 2008 at 4:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 20 Feb 2008, Thomas Gleixner wrote:
> >  > On Tue, 19 Feb 2008, Marcel Holtmann wrote:
> >
> > > > I don't really have any idea. Nothing has been changed in this area for a
> >  > > couple of years. The command TX timeout is the timeout that indicates a
> >  > > missing answer to a command sent down to the Bluetooth chip.
> >  > >
> >  > > However this involves some atomic and tasklet stuff. Did we have some 
> changes
> >  > > that I missed and might now render this usage as broken.
> >  >
> >  > Not that I'm aware off, but this might as well be some old use after
> >  > free bug which got exposed by some unrelated change. The good news is
> >  > that it is reproducible. I'll hack up some nasty debug patch which
> >  > lets us - hopefully - decode where the timer was armed.
> >
> >  Quel, before I do that, is there any chance that you retest with the
> >  latest mainline git version ?
> >
> >  
> http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc2-git4.bz2
> 
> And please test with this patch as well:
> 
> http://lkml.org/lkml/2008/2/20/121
> 
Same kind of result unfortunately with this last patch on top of git4:

hci_cmd_task: hci0 command tx timeout
BUG: unable to handle kernel paging request at 6b6b6b6b
IP: [<c012d22f>] get_next_timer_interrupt+0xf6/0x1fc
*pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: hidp rfcomm l2cap nfsd exportfs nfs lockd nfs_acl sunrpc autofs4 af_packet binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat fuse snd_pcm_oss snd_mixer_oss snd_intel8x0 hci_usb snd_ac97_codec ac97_bus snd_pcm snd_timer i2c_i801 bluetooth parport_pc sr_mod snd parport i2c_core soundcore rtc_cmos pcspkr iTCO_wdt snd_page_alloc iTCO_vendor_support thermal processor button dcdbas evdev tg3 sg ide_disk piix ide_core ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper Not tainted (2.6.25-rc2-git4kk1 #1)
EIP: 0060:[<c012d22f>] EFLAGS: 00010002 CPU: 0
EIP is at get_next_timer_interrupt+0xf6/0x1fc
EAX: 6b6b6b6b EBX: 3fffa098 ECX: c0430714 EDX: 6b6b6b6b
ESI: 00000021 EDI: c043060c EBP: c03aff58 ESP: c03aff20
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c03ae000 task=c03803a0 task.ti=c03ae000)
Stack: ffffa100 ffffa098 c042fe00 00000000 00000001 00000021 00ffffa1 c043060c 
       c043080c c0430a0c c0430c0c c18090c0 299c0e00 ffffa098 c03aff9c c013fa28 
       29ab5040 c03803a0 c0380510 c180c200 299c44e8 00000040 299c0e00 00000040 
Call Trace:
 [<c013fa28>] ? tick_nohz_stop_sched_tick+0x130/0x337
 [<c013fd2b>] ? tick_nohz_restart_sched_tick+0xfc/0x139
 [<c0103918>] ? default_idle+0x0/0x7f
 [<c0103789>] ? cpu_idle+0x34/0x100
 [<c02e2d39>] ? rest_init+0x49/0x50
 =======================
Code: 8d e0 8b 45 e0 83 e0 3f 89 45 dc 89 c6 8b 04 f7 8b 10 0f 18 02 90 8d 0c f7 39 c8 0f 84 82 00 00 00 8b 40 08 39 d8 0f 48 d8 89 d0 <8b> 12 0f 18 02 90 39 c1 75 ec c7 45 d4 01 00 00 00 8b 7d dc 85 
EIP: [<c012d22f>] get_next_timer_interrupt+0xf6/0x1fc SS:ESP 0068:c03aff20
---[ end trace bb6b2d4df944b938 ]---
Kernel panic - not syncing: Attempted to kill the idle task!

# addr2line -e vmlinux c012d22f
/usr/src/linux-2.6.25-rc2kk1/kernel/timer.c:721

721:			list_for_each_entry(nte, varp->vec + slot, entry) {
722:				found = 1;
723:				if (time_before(nte->expires, expires))
724:					expires = nte->expires;
725:			}

--
Eric
