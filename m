Return-Path: <linux-kernel-owner+w=401wt.eu-S965807AbXBTAt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965807AbXBTAt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965810AbXBTAt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:49:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56230 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965807AbXBTAtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:49:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm2
Date: Tue, 20 Feb 2007 01:43:47 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702190025.49273.rjw@sisk.pl> <20070218160026.2988d59f.akpm@linux-foundation.org>
In-Reply-To: <20070218160026.2988d59f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702200143.48195.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 February 2007 01:00, Andrew Morton wrote:
> On Mon, 19 Feb 2007 00:25:48 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > netconsole is good.
> > 
> > I know. :-)
> > 
> > In the meantime, I've got something worse on another x86_64 box:
> > 
> > Asus Laptop ACPI Extras version 0.30
> >   L5D model detected, supported
> > audit(1171831698.918:2): audit_pid=4281 old=0 by auid=4294967295
> > general protection fault: 0000 [2] PREEMPT
> > last sysfs file: /class/net/eth2/carrier
> > CPU 0
> > Modules linked in: af_packet ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device asus_acpi backlight button battery ac dm_mod pcmr
> > Pid: 178, comm: pdflush Not tainted 2.6.20-mm2 #1
> > RIP: 0010:[<ffffffff8034bce4>]  [<ffffffff8034bce4>] __make_request+0x134/0x370
> > RSP: 0000:ffff81005ed659a0  EFLAGS: 00010297
> > RAX: 00000000ffffffff RBX: 6b6b6b6b6b6b6b6b RCX: 000000000203396a
> > RDX: 0000000100000000 RSI: ffff810037b4dbb0 RDI: ffff81004683d8c0
> > RBP: ffff81005ed659f0 R08: ffff81004683d070 R09: ffff81003d333cc0
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff810037b4dbb0
> > R13: ffff81005daba3f0 R14: ffff810037daca90 R15: ffff81005daba3d0
> > FS:  00002ad4a29e6d00(0000) GS:ffffffff805db000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 00002b6a345aa000 CR3: 0000000056585000 CR4: 00000000000006e0
> > Process pdflush (pid: 178, threadinfo ffff81005ed64000, task ffff810037b060c0)
> > Stack:  ffff810002852540 0000000000000001 ffff810037b4dbb0 ffffffff8026be21
> >  ffff81005ed65a40 0000000000000008 ffff810037b4dbb0 0000000000000800
> >  0000000000000008 ffff8100021d94e0 ffff81005ed65a40 ffffffff80348e7c
> > Call Trace:
> >  [<ffffffff8026be21>] mempool_alloc_slab+0x11/0x20
> >  [<ffffffff80348e7c>] generic_make_request+0x1ec/0x230
> 
> yeah. everyone except me is hitting that.

An interesting variant:

------------[ cut here ]------------
kernel BUG at block/ll_rw_blk.c:2782!
invalid opcode: 0000 [1] PREEMPT
last sysfs file: /class/net/eth2/carrier
CPU 0
Modules linked in: af_packet ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device asus_acpi backlight button battery ac dm_mod usbhid pcmcir
Pid: 5060, comm: preload Not tainted 2.6.20-mm2 #4
RIP: 0010:[<ffffffff80349b7a>]  [<ffffffff80349b7a>] bio_attempt_back_merge+0x2a/0xa0
RSP: 0018:ffff810045819a58  EFLAGS: 00010202
RAX: 0000000100000080 RBX: ffff810046946eb0 RCX: 0000000002b26b42
RDX: 0000000100000000 RSI: ffff810046946eb0 RDI: ffff810037d74a90
RBP: ffff810045819a68 R08: ffff810046946eb0 R09: 0000000000000400
R10: 0000000000000000 R11: 0000000000000000 R12: ffff810046fcc330
R13: ffff81004a218770 R14: ffff810037d74a90 R15: ffff81004a218750
FS:  00002acb9c6076f0(0000) GS:ffffffff805db000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002aaaaaaac000 CR3: 0000000045855000 CR4: 00000000000006e0
Process preload (pid: 5060, threadinfo ffff810045818000, task ffff81004a12e140)
Stack:  ffff810046946eb0 ffff810046fcc330 ffff810045819ac8 ffffffff8034b730
 0000000000000000 0000000000000000 ffff810046fcc330 0000000000000002
 ffff810046946eb0 0000000000000008 ffff810046fcc330 0000000000000800
Call Trace:
 [<ffffffff8034b730>] __make_request+0x100/0x370
 [<ffffffff803488fc>] generic_make_request+0x1ec/0x230
 [<ffffffff802b9a7b>] bio_alloc_bioset+0xeb/0x120
 [<ffffffff8034b266>] submit_bio+0xf6/0x110
 [<ffffffff802b9b10>] bio_alloc+0x10/0x20
 [<ffffffff802bd3f2>] mpage_bio_submit+0x22/0x30
 [<ffffffff802bdfe5>] do_mpage_readpage+0x505/0x590
 [<ffffffff80482cd6>] _write_unlock_irq+0x36/0x60
 [<ffffffff80268bfb>] add_to_page_cache+0xbb/0xf0
 [<ffffffff8026d950>] get_page_from_freelist+0x120/0x430
 [<ffffffff802be2be>] mpage_readpages+0xbe/0x160
 [<ffffffff8030fa20>] ext3_get_block+0x0/0x110
 [<ffffffff8030fa20>] ext3_get_block+0x0/0x110
 [<ffffffff804833b0>] _spin_unlock+0x30/0x50
 [<ffffffff8026da50>] get_page_from_freelist+0x220/0x430
 [<ffffffff8030eb8a>] ext3_readpages+0x1a/0x20
 [<ffffffff8027072f>] __do_page_cache_readahead+0x20f/0x330
 [<ffffffff80294d68>] cp_new_stat+0xf8/0x120
 [<ffffffff80270c7d>] force_page_cache_readahead+0x6d/0xb0
 [<ffffffff8026c533>] sys_fadvise64_64+0x143/0x1e0
 [<ffffffff8026c5d9>] sys_fadvise64+0x9/0x10
 [<ffffffff80209a0e>] system_call+0x7e/0x83


Code: 0f 0b 0f 1f 40 00 eb fe 4c 89 e2 e8 f6 df ff ff 31 d2 85 c0
RIP  [<ffffffff80349b7a>] bio_attempt_back_merge+0x2a/0xa0
 RSP <ffff810045819a58>
