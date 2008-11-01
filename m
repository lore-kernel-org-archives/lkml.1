Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbYKAQMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbYKAQMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYKAQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:12:11 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3322 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYKAQMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:12:08 -0400
Date: Sat, 1 Nov 2008 17:12:01 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26] OOPS in elv_next_request
Message-ID: <20081101161201.GQ11214@vanheusden.com>
References: <20081027090426.GN8318@vanheusden.com> <a8e1da0810272211s4b145bboef26801c3af0d652@mail.gmail.com> <20081030142550.GB11214@vanheusden.com> <a8e1da0810301822k3402e753m482d98f4530419a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0810301822k3402e753m482d98f4530419a0@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Wed Oct 29 12:57:18 CET 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > While running my http://vanheusden.com/pyk/ script (which randomly
> >> > inserts and removes modules) I triggered the folllowing oops in a 2.6.26
> >> > kernel on a Celeron 400 (Mendocino):
> >> >
> >> > [ 4768.664021] Floppy drive(s): fd0 is 1.44M
> > ...
> >> > [ 4768.720058] ---[ end trace 6a50caff78c47574 ]---
> >> > [ 4769.658313] Floppy drive(s): fd0 is 1.44M
> >> > [ 4789.656060] no cont in shutdown!
> >>
> >> Hi, could you try the attached test patch?  sorry for using attachment
> >> as there's some problem for my mail client to reply.
> >
> > As your patch is based on 2.6.27 I compiled the 2.6.27 kernel with it. But
> > something odd is going on: when 2.6.27 boots, right after the initrd loading
> > the screen-resolution gets changed or so, so that most text is no longer
> > visible. Also the system seems to halt. Unfortunately too early for
> > netconsole to emit the errors.
> 
> Yes, the patch is based on 2.6.27, but it can be applied to 2.6.26
> without problem.
> Could you try it with 2.6.26 again?

Here are the results:

[ 7041.704567] Floppy drive(s): fd0 is 1.44M
[ 7041.722756] FDC 0 is a post-1991 82077
[ 7041.757944] BUG: unable to handle kernel NULL pointer dereference at 00000010
[ 7041.758250] IP: [<c01d352c>] elv_next_request+0x17f/0x190
[ 7041.758563] *pde = 00000000
[ 7041.758728] Oops: 0000 [#1] SMP
[ 7041.758996] Modules linked in: floppy(-) loop video output thermal ata_generic libata scsi_mod snd_mpu401_uart snd_rawmidi snd_pcm shpchp button parport ide_cd_mod cdrom fan uhci_hcd gameport snd_opl3_lib snd_hwdep pci_hotplug i2c_core snd_page_alloc dock snd_timer snd_seq_device netconsole configfs ipv6 snd soundcore via_agp agpgart evdev ext3 jbd mbcache ide_disk via82cxxx ide_pci_generic ide_core 8139too usbcore 8139cp mii pr
ocessor thermal_sys [last unloaded: battery]
[ 7041.760087]
[ 7041.760087] Pid: 6, comm: events/0 Not tainted (2.6.26-floppy-kerneldebug #1)
[ 7041.760087] EIP: 0060:[<c01d352c>] EFLAGS: 00010046 CPU: 0
[ 7041.760087] EIP is at elv_next_request+0x17f/0x190
[ 7041.760087] EAX: c888e49c EBX: c940a820 ECX: 00000000 EDX: 00000000
[ 7041.760087] ESI: c888e49c EDI: ca9487ca EBP: c940a824 ESP: c943ff34
[ 7041.760087]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 7041.760087] Process events/0 (pid: 6, ti=c943e000 task=c942a460 task.ti=c943e000)
[ 7041.760087] Stack: 00000000 c940a820 ca94f5a4 ca9487ca c940a824 ca948813 c02bd3af 00d8f000
[ 7041.760087]        c8150100 c03b7364 c03b9e20 c03b9e20 c942a460 c942a5ec c1148e20 00000000
[ 7041.760087]        878a643e 00000667 c940a820 c942a5ec ca94705d 00000286 c940a820 ca94f5a4
[ 7041.760087] Call Trace:
[ 7041.760087]  [<ca9487ca>] redo_fd_request+0x0/0xdc0 [floppy]
[ 7041.760087]  [<ca948813>] redo_fd_request+0x49/0xdc0 [floppy]
[ 7041.760087]  [<c02bd3af>] schedule+0x6f5/0x737
[ 7041.760087]  [<ca94705d>] reset_interrupt+0x0/0x6c [floppy]
[ 7041.760087]  [<ca9487ca>] redo_fd_request+0x0/0xdc0 [floppy]
[ 7041.760087]  [<c012f74d>] run_workqueue+0x74/0xef
[ 7041.760087]  [<c012f87f>] worker_thread+0xb7/0xc3
[ 7041.760087]  [<c013236a>] autoremove_wake_function+0x0/0x2d
[ 7041.760087]  [<c012f7c8>] worker_thread+0x0/0xc3
[ 7041.760087]  [<c0132104>] kthread+0x38/0x5d
[ 7041.760087]  [<c01320cc>] kthread+0x0/0x5d
[ 7041.760087]  [<c01045a7>] kernel_thread_helper+0x7/0x10
[ 7041.760087]  =======================
[ 7041.760087] Code: 04 24 89 e2 89 f0 e8 35 33 00 00 85 c0 74 0d 8b 1c 24 85 db 0f 85 a0 fe ff ff eb 18 8b 06 39 f0 75 dd 8b 46 0c 31 d2 8b 08 89 f0 <ff> 51 10 85 c0 75 ea 31 db 5a 89 d8 5b 5e 5f 5d c3 55 89 cd 57
[ 7041.760087] EIP: [<c01d352c>] elv_next_request+0x17f/0x190 SS:ESP 0068:c943ff34
[ 7041.760087] ---[ end trace d4b702ab996006dc ]---


> BTW, for 2.6.27, did you set vga=normal or other things?

None.
I also explicitly tried to set it but that didn't help


Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
