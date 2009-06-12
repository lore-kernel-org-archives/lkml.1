Return-Path: <linux-kernel-owner+w=401wt.eu-S934176AbZFLWOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbZFLWOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbZFLWNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:13:55 -0400
Received: from [212.98.175.89] ([212.98.175.89]:47670 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751520AbZFLWNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:13:54 -0400
Date: Sat, 13 Jun 2009 01:15:09 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: BUG: scheduling while atomic: pptpgw
Message-ID: <20090612221509.GA3888@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan.

As I can see you've patched tty recently.
---
commit c9b3976e3fec266be25c5001a70aa0a890b6c476
Author: Alan Cox <alan@redhat.com>
Date:   Fri Jan 2 13:44:56 2009 +0000

    tty: Fix PPP hang under load
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

I have some problems in tty + ppp.
Part of syslog (the rest is in attach):

[ 8506.042498] BUG: scheduling while atomic: pptpgw/3167/0x00000400
[ 8506.042504] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse sbp2 loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore pcspkr i2c_i801 rng_core snd_page_alloc psmouse asus_laptop
serio_raw evdev led_class usbhid hid sg sd_mod sr_mod cdrom ata_generic pata_acpi ata_piix ide_pci_generic ohci1394 ieee1394 r8169 mii uhci_hcd ehci_hcd usbcore
[ 8506.042563] 
[ 8506.042568] Pid: 3167, comm: pptpgw Tainted: G        W  (2.6.30-nv-git3 #7) F3JC                
[ 8506.042572] EIP: 0060:[<c13e4386>] EFLAGS: 00200246 CPU: 0
[ 8506.042580] EIP is at _spin_unlock_irqrestore+0x16/0x30
[ 8506.042583] EAX: c1660040 EBX: 00200246 ECX: 00000000 EDX: 00200246
[ 8506.042586] ESI: f66b97e0 EDI: 00000001 EBP: f22ebe5c ESP: f22ebe58
[ 8506.042590]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 8506.042593] CR0: 8005003b CR2: b753c000 CR3: 36a91000 CR4: 000006d0
[ 8506.042596] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 8506.042599] DR6: ffff0ff0 DR7: 00000400
[ 8506.042601] Call Trace:
[ 8506.042609]  [<c12b92cb>] tty_ldisc_deref+0x5b/0x90
[ 8506.042615]  [<c12b2699>] tty_wakeup+0x79/0x90
[ 8506.042620]  [<c12baa23>] pty_unthrottle+0x23/0x50
[ 8506.042624]  [<c12b75f0>] tty_unthrottle+0x40/0x70
[ 8506.042628]  [<c12b571f>] n_tty_read+0x47f/0x720
[ 8506.042636]  [<c103a020>] ? default_wake_function+0x0/0x40
[ 8506.042640]  [<c12b0a28>] tty_read+0x98/0xe0
[ 8506.042644]  [<c12b52a0>] ? n_tty_read+0x0/0x720
[ 8506.042651]  [<c10e5dfb>] vfs_read+0xbb/0x1c0
[ 8506.042655]  [<c12b0990>] ? tty_read+0x0/0xe0
[ 8506.042659]  [<c10e6008>] sys_read+0x58/0xa0
[ 8506.042665]  [<c100320b>] sysenter_do_call+0x12/0x22


	Sergey

p.s.
Reported :http://bugzilla.kernel.org/show_bug.cgi?id=13522
