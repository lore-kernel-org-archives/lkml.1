Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbYB0VqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbYB0VqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbYB0VqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:46:06 -0500
Received: from mail-08.jhb.wbs.co.za ([196.2.97.5]:44130 "EHLO
	mail-08.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbYB0VqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:46:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAACNpxUfEAmHGlWdsb2JhbACQaAEBAQEHChEYnRM
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Robert Fitzsimons <robfitz@273k.net>
Subject: Re: [PATCH] bttv: Re-enabling radio support requires the use of struct bttv_fh.
Date: Wed, 27 Feb 2008 23:45:43 +0200
User-Agent: KMail/1.9.9
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <200802171036.19619.bonganilinux@mweb.co.za> <20080227014238.GA2685@localhost> <20080227014729.GC2685@localhost>
In-Reply-To: <20080227014729.GC2685@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802272345.43209.bonganilinux@mweb.co.za>
X-Original-Subject: Re: [PATCH] bttv: Re-enabling radio support requires the use of struct bttv_fh.
X-Scan-Signature: 4841a2d5810e6eb55b5c74f7e3e92d55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008 03:47:29 Robert Fitzsimons wrote:
> A number of the radio tuner ioctl functions are shared with the TV
> tuner, these functions require a struct bttv_fh data structure to be
> allocated and initialized.
>
> Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> 
> Mauro, the radio_open function may want to do more initialisation then
> the amount I copied from bttv_open.

Thanx Robert

I have applied both your patches and my radio works, but my TV doesn't work 
anymore (no picture or sound). But when I exit the radio program I get this 
oops:


BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff8030cd72>] kref_get+0xc/0x29
PGD 72230067 PUD 6dbd1067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
binfmt_misc loop nls_cp437 vfat fat nls_iso8859_1 ntfs thermal processor fan 
container button pcspkr snd_pcm_oss snd_mixer_oss snd_emu10k1 tuner tea5767 
tda8290 tuner_xc2028 tda9887 tuner_simple snd_rawmidi mt20xx snd_ac97_codec 
tea5761 bttv ac97_bus snd_pcm ir_common snd_seq_device firewire_ohci 
compat_ioctl32 snd_timer firewire_core videodev snd_page_alloc v4l1_compat 
uhci_hcd snd_util_mem ehci_hcd crc_itu_t v4l2_common snd_hwdep 
videobuf_dma_sg ohci1394 usbcore sr_mod ide_cd_mod snd videobuf_core ieee1394 
emu10k1_gp tg3 cdrom btcx_risc sg i2c_viapro gameport tveeprom evdev 
soundcore
Pid: 4319, comm: radio Not tainted 2.6.25-rc3-dirty #42
RIP: 0010:[<ffffffff8030cd72>]  [<ffffffff8030cd72>] kref_get+0xc/0x29
RSP: 0018:ffff810065211db8  EFLAGS: 00010296
RAX: ffff81006d815880 RBX: 0000000000000010 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff810065211e28 RDI: 0000000000000010
RBP: ffff810065211dc8 R08: 0000000000000000 R09: 0000001000000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffff810065211e28
R13: 0000000000000000 R14: 0000000000000000 R15: fffffffffffffff8
FS:  00007fe0f915f6f0(0000) GS:ffff81007fb89dc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 0000000063e8f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process radio (pid: 4319, threadinfo ffff810065210000, task ffff810068e534e0)
Stack:  ffff810065211ea8 0000000000000000 ffff810065211e08 ffffffff8044b362
 ffff810063dc0440 ffff810065211e28 0000000000000000 ffffffff803c0b75
 ffff810065211e78 ffff81007fb55580 ffff810065211e18 ffffffff8037be03
Call Trace:
 [<ffffffff8044b362>] klist_next+0x5d/0x8a
 [<ffffffff803c0b75>] ? i2c_cmd+0x0/0x3b
 [<ffffffff8037be03>] next_device+0x9/0x19
 [<ffffffff8037be4a>] device_for_each_child+0x37/0x5c
 [<ffffffff803bf371>] i2c_clients_command+0x23/0x25
 [<ffffffff88149b2a>] :bttv:bttv_call_i2c_clients+0x16/0x18
 [<ffffffff88142bf3>] :bttv:radio_release+0x23/0x27
 [<ffffffff802862dd>] __fput+0xac/0x16c
 [<ffffffff80286547>] fput+0x14/0x16
 [<ffffffff802838e7>] filp_close+0x66/0x71
 [<ffffffff80284d1c>] sys_close+0x8e/0xd1
 [<ffffffff8020b34b>] system_call_after_swapgs+0x7b/0x80


Code: ff f0 ff 0b 0f 94 c0 31 d2 84 c0 74 0b 48 89 df 41 ff d4 ba 01 00 00 00 
5b 41 5c c9 89 d0 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 <83> 3f 00 75 11 be 
2b 00 00 00 48 c7 c7 46 b9 53 80 e8 d7 33 f2
RIP  [<ffffffff8030cd72>] kref_get+0xc/0x29
 RSP <ffff810065211db8>
CR2: 0000000000000010
---[ end trace 7ada9aa1e484b38f ]---

