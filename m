Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbZC3JCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbZC3JCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbZC3JCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:02:35 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2390 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbZC3JCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:02:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: ivtv-devel@ivtvdriver.org
Subject: Re: [ivtv-devel] 2.6.29: ivtv-vbi.c: divide-by-zero in compress_sliced_buf()
Date: Mon, 30 Mar 2009 11:00:31 +0200
User-Agent: KMail/1.9.9
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>,
       v4l-dvb-maintainer@linuxtv.org, g.liakhovetski@gmx.de,
       video4linux-list@redhat.com
References: <49D03596.8030802@rtr.ca>
In-Reply-To: <49D03596.8030802@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903301100.31611.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009 04:59:34 Mark Lord wrote:
> The changes to line_size in 2.6.29 now cause
> attempts to record from my PVR250 cards (MythTV)
> to die with a divide by zero error in ivtv-vbi.c.
>
> The value of "line_size" in compress_sliced_buf() is zero.

Weird. That should never be zero. Can you mail me the ivtv initialization 
log from dmesg? I need the bit between 'ivtv: Start initialization' 
and 'ivtv: End initialization'.

Regards,

	Hans

>
> divide error: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/block/sr0/removable
> CPU 0
> Modules linked in: nfsd nfs lockd nfs_acl auth_rpcgss sunrpc ir_kbd_i2c
> ir_common battery sbs sbshc container ac usbhid tuner msp3400 saa7115 fan
> ivtv serio_raw nvidia(P) sky2 cx2341x firewire_ohci ehci_hcd thermal sg
> uhci_hcd intel_agp button processor xc5000 au8522 tea5767 tda9887 tda8290
> tea5761 snd_usb_audio snd_usb_lib snd_hwdep au0828 usbcore tveeprom
> dvb_core snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss
> snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
> snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore
> snd_page_alloc firewire_sbp2 firewire_core crc_itu_t fuse Pid: 18548,
> comm: mythbackend Tainted: P       A   2.6.29 #1 OEM RIP:
> 0010:[<ffffffffa09cabc4>]  [<ffffffffa09cabc4>]
> compress_sliced_buf+0x5c/0x14a [ivtv] RSP: 0018:ffff88004e3b1c58  EFLAGS:
> 00010246
> RAX: 0000000000000000 RBX: ffff88007c1b8300 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007b5a0000
> RBP: ffff88007c1b8000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffffa09c0818 R12: ffff88007b5a0000
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88007b5a0000
> FS:  000000004f219950(0063) GS:ffffffff80683040(0000)
> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fd267365000 CR3: 0000000078dea000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mythbackend (pid: 18548, threadinfo ffff88004e3b0000, task
> ffff880056895580) Stack:
>  0000000000000000 ffff88007d199440 ffff88007e0e4e40 0000000000000202
>  ffff880001013100 0000000000000000 ffff880001013118 ffffffff80219939
>  0000000000000002 0000000000000300 ffff88007c1b8000 ffff88007b5a0000
> Call Trace:
>  [<ffffffff80219939>] ? native_flush_tlb_others+0xaa/0xb5
>  [<ffffffffa09cb4a3>] ? ivtv_process_vbi_data+0x10f/0x51c [ivtv]
>  [<ffffffff8026de33>] ? __do_fault+0x399/0x3e1
>  [<ffffffff80223434>] ? ptep_set_access_flags+0x1a/0x1e
>  [<ffffffff8026e6bd>] ? do_wp_page+0x5d8/0x64d
>  [<ffffffffa09c0502>] ? ivtv_start_capture+0x54/0x217 [ivtv]
>  [<ffffffffa09c0d8f>] ? ivtv_v4l2_read+0x577/0xac4 [ivtv]
>  [<ffffffff80247d42>] ? getnstimeofday+0x56/0xb0
>  [<ffffffff80244ad7>] ? ktime_get_ts+0x21/0x49
>  [<ffffffff80241f34>] ? autoremove_wake_function+0x0/0x2e
>  [<ffffffff802853e3>] ? vfs_read+0xaa/0x133
>  [<ffffffff80285528>] ? sys_read+0x45/0x6e
>  [<ffffffff8020b49b>] ? system_call_fastpath+0x16/0x1b
> Code: 0f 80 7b 02 00 75 09 8a 54 24 1f 38 53 03 74 09 ff c0 48 ff c3 39
> c8 72 dd 29 c1 89 c8 44 39 f1 0f 82 e1 00 00 00 31 d2 45 31 ed <41> f7 f6
> 45 31 e4 89 44 24 18 31 ed e9 c0 00 00 00 89 e8 48 8d RIP 
> [<ffffffffa09cabc4>] compress_sliced_buf+0x5c/0x14a [ivtv]
>  RSP <ffff88004e3b1c58>
> ---[ end trace a154c5e5843294d8 ]---
>
> _______________________________________________
> ivtv-devel mailing list
> ivtv-devel@ivtvdriver.org
> http://ivtvdriver.org/mailman/listinfo/ivtv-devel



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
