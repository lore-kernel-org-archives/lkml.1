Return-Path: <linux-kernel-owner+w=401wt.eu-S1762807AbYBMTR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807AbYBMTR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYBMTRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:17:21 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:23023 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYBMTRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kA6sURmUkarlp4QXFmwBcEoWn9c4n9ACiumI4amJMaZtZAFG5qE+ft11V2wucbAkfZq2hUhnThMi57gqB6zalW/Em6aFGUMlwkdRoaM52Kby1C+ftuophRs5S6gMGT/M0OR0s8P0ahyKhSXY3mAkpClIsYr+3QfYQd2l4Mska4Y=
Message-ID: <64bb37e0802131117i20aa09besac5d9b6ec5b085f0@mail.gmail.com>
Date: Wed, 13 Feb 2008 20:17:18 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc1
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <20080211141504.4fef4e74.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
	 <64bb37e0802111346q13ddc3fy60edfce0daff3bf@mail.gmail.com>
	 <20080211141504.4fef4e74.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 11, 2008 11:15 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 11 Feb 2008 22:46:18 +0100
> "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > On Feb 11, 2008 1:44 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > So give it all a good testing.
> >
> > My mm-mystery-crash has now sneaked into mainline:
>
> hm, I don't remember that.

Last report: http://marc.info/?l=linux-kernel&m=120129854023202

> > [ 1463.829078] BUG: unable to handle kernel NULL pointer dereference
> > at 0000000000000378
> > [ 1463.832141] IP: [<ffffffff8047af18>] ether1394_dg_complete+0x28/0xa0
> > [ 1463.834616] PGD 7955e067 PUD 7955d067 PMD 0
> > [ 1463.836148] Oops: 0000 [1] SMP
> > [ 1463.836148] CPU 0
> > [ 1463.836148] Modules linked in: radeon drm w83792d ipv6 tuner
> > tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761
> > tvaudio msp3400 bttv videodev v4l1_compat ir_common compat_ioctl32
> > v4l2_common videobuf_dma_sg videobuf_core btcx_risc usbhid tveeprom sg
> > i2c_nforce2 hid pata_amd
> > [ 1463.836148] Pid: 519, comm: khpsbpkt Not tainted 2.6.25-rc1 #1
> > [ 1463.836148] RIP: 0010:[<ffffffff8047af18>]  [<ffffffff8047af18>]
> > ether1394_dg_complete+0x28/0xa0
> > [ 1463.836148] RSP: 0000:ffff81007eeb1e80  EFLAGS: 00010282
> > [ 1463.836148] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
> > [ 1463.836148] RDX: ffff81004bc62d80 RSI: 0000000000000000 RDI: ffff810051873e40
> > [ 1463.836148] RBP: ffff81007eeb1eb0 R08: 0000000000000000 R09: 0000000000000001
> > [ 1463.836148] R10: 0000000000000001 R11: 0000000000000001 R12: ffff810051873e40
> > [ 1463.836148] R13: ffff81007e1f7200 R14: 0000000000000001 R15: ffff810051873e40
> > [ 1463.836148] FS:  00007f727d6d4700(0000) GS:ffffffff807e8000(0000)
> > knlGS:0000000000000000
> > [ 1463.836148] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > [ 1463.836148] CR2: 0000000000000378 CR3: 0000000079559000 CR4: 00000000000006e0
> > [ 1463.836148] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [ 1463.836148] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [ 1463.836148] Process khpsbpkt (pid: 519, threadinfo
> > ffff81007eeb0000, task ffff81007ee9e000)
> > [ 1463.836148] Stack:  ffff81007eeb1e90 ffff81004bc62b40
> > ffff810051873e40 0000000000000000
> > [ 1463.836148]  0000000000000001 0000000000000000 ffff81007eeb1ee0
> > ffffffff8047b233
> > [ 1463.836148]  ffff81007eeb1ec8 ffff81007eeb1ef0 ffffffff8046c280
> > ffff81007ff6df10
> > [ 1463.836148] Call Trace:
> > [ 1463.836148]  [<ffffffff8047b233>] ether1394_complete_cb+0xb3/0xd0
> > [ 1463.836148]  [<ffffffff8046c280>] ? hpsbpkt_thread+0x0/0x140
> > [ 1463.836148]  [<ffffffff8046c33b>] hpsbpkt_thread+0xbb/0x140
> > [ 1463.836148]  [<ffffffff8024aead>] kthread+0x4d/0x80
> > [ 1463.836148]  [<ffffffff8020c578>] child_rip+0xa/0x12
> > [ 1463.836148]  [<ffffffff8020bc8f>] ? restore_args+0x0/0x31
> > [ 1463.836148]  [<ffffffff8024ae60>] ? kthread+0x0/0x80
> > [ 1463.836148]  [<ffffffff8020c56e>] ? child_rip+0x0/0x12
> > [ 1463.836148]
> > [ 1463.836148]
> > [ 1463.836148] Code: 00 00 00 55 48 89 e5 48 83 ec 30 48 89 5d d8 4c
> > 89 75 f0 89 f3 4c 89 7d f8 4c 89 65 e0 49 89 ff 4c 89 6d e8 4c 8b 2f
> > 49 8b 45 20 <4c> 8b a0 78 03 00 00 4d 8d b4 24 d0 00 00 00 4c 89 f7 e8
> > 41 f0
> > [ 1463.836148] RIP  [<ffffffff8047af18>] ether1394_dg_complete+0x28/0xa0
> > [ 1463.836148]  RSP <ffff81007eeb1e80>
> > [ 1463.836148] CR2: 0000000000000378
> > [ 1463.836208] ohci1394: fw-host0: Waking dma ctx=0 ... processing is
> > probably too slow
> > [ 1463.839250] BUG: unable to handle kernel NULL pointer dereference
> > at 0000000000000000
> > [ 1463.841549] IP: [<ffffffff80296d1d>] kmem_cache_alloc_node+0x6d/0xa0
> > [ 1463.842925] PGD 7955e067 PUD 7955d067 PMD 0
> > [ 1463.846148] Oops: 0000 [2] SMP
> > [ 1463.846148] CPU 0
> > [ 1463.846148] Modules linked in: radeon drm w83792d ipv6 tuner
> > tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761
> > tvaudio msp3400 bttv videodev v4l1_compat ir_common compat_ioctl32
> > v4l2_common videobuf_dma_sg videobuf_core btcx_risc usbhid tveeprom sg
> > i2c_nforce2 hid pata_amd
> > [ 1463.846148] Pid: 519, comm: khpsbpkt Tainted: G      D  2.6.25-rc1 #1
> > [ 1463.846148] RIP: 0010:[<ffffffff80296d1d>]  [<ffffffff80296d1d>]
> > kmem_cache_alloc_node+0x6d/0xa0
> > [ 1463.846148] RSP: 0000:ffffffff80871ae0  EFLAGS: 00010046
> > [ 1463.846148] RAX: 0000000000000000 RBX: ffff810001006820 RCX: ffffffff8052c549
> > [ 1463.846148] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff807fbec0
> > [ 1463.846148] RBP: ffffffff80871b00 R08: 00000000000005e0 R09: 000000000000ffc1
> > [ 1463.846148] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000ffffffff
> > [ 1463.846148] R13: 0000000000000020 R14: 0000000000000020 R15: ffffffff807fbec0
> > -> here the output from the serial console stopped.
[snip]
> But this is a crash inside the 1394 code.  So if you're getting a crash
> with plain-old-ethernet then it is a different crash.  It'd be good if we
> could see the oops trace for that one too please.

2.6.24-rc3-mm2:
http://marc.info/?l=linux-kernel&m=119636996902805
-> crash in ether1394 and another one in sunrpc
http://marc.info/?l=linux-kernel&m=119671371413299
-> crash in tcp v4
http://marc.info/?l=linux-kernel&m=119888251227487
-> crash in sunrpc (first oops in mail)

2.6.24-rc6-mm1:
http://marc.info/?l=linux-kernel&m=119888251227487
-> crash net-core (skb_release_data) (second oops in mail)
http://marc.info/?l=linux-kernel&m=119898573229965
-> another one in net-core (skb_release_data)
http://marc.info/?l=linux-kernel&m=119910705115373
-> crash in sunrpc
http://marc.info/?l=linux-kernel&m=119921272203686
-> crash in tcp v4
http://marc.info/?l=linux-kernel&m=119933661810303
-> crash in sunrpc
http://marc.info/?l=linux-kernel&m=119946018207746
-> crash in firewire thread
http://marc.info/?l=linux-kernel&m=119958976409612
-> crash in sunrpc

2.6.24-rc8-mm1:
http://marc.info/?l=linux-kernel&m=119671371413299
-> unknown, but some list check triggered (kernel BUG at lib/list_debug.c:33!)

2.6.25-rc1:
http://marc.info/?l=linux-kernel&m=120276641105256&w=2
-> crash in ether1394

All looks network related, and my testcase did stress the network
somewhat because it was reading large files from a NFSv4 share.
But I agree with Stefan, that its not looking like a ether1394 bug.
The code did not change and looking at the code from these crashed in
my eyes it can't crash. The list is checked before calling into the
processing functions and the locking also looks right. It very much
looks like the list itself got corrupted somehow. And that the other
network system also suffer from a similar corruption.

But I have no clue where to look for the corruptor. I tried
slub_debug=FZP, but that also crashed (after several days of working)
without the slub debugging catching anything.
The corruptor also might be in the disk subsystem, as testcase also
stresses the disks.

My current best guess are the changes between rc2-mm1 and rc3-mm2 in
the git trees sched, scsi-misc or x86. Maybe git-xfs, but during all
the crashes my root xfs filesystem did lose some files because their
contents was still in writeback, but the directories or other
filesystem structures where not damaged once.

Torsten
