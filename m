Return-Path: <linux-kernel-owner+w=401wt.eu-S1161049AbXBGJSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049AbXBGJSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXBGJSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:18:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44505 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030604AbXBGJSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:18:42 -0500
Date: Wed, 7 Feb 2007 10:18:41 +0100
From: Jan Kara <jack@suse.cz>
To: Frank Hartmann <soundart@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.19.1 Oops while doing Disk IO + playing sound
Message-ID: <20070207091841.GE24590@atrey.karlin.mff.cuni.cz>
References: <877ivr6t0k.fsf@fantasio.hh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ivr6t0k.fsf@fantasio.hh.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Has this bug got fixed? Are you still able to reproduce the problem with 2.6.20?

> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000029
>  printing eip:
> e0c25de0
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT 
> Modules linked in: cbc blkcipher binfmt_misc rfcomm l2cap nfs nfsd exportfs lock
> d sunrpc ip_nat_irc ip_nat_ftp ip_conntrack_irc ip_conntrack_ftp xt_state ipt_RE
> JECT ipt_LOG iptable_mangle iptable_filter iptable_nat ip_nat ip_tables ip_connt
> rack cryptoloop loop sha256 aes it87 hwmon_vid i2c_isa i2c_core md5 ipv6 af_pack
> et radeon drm sd_mod dm_crypt dm_mod snd_via82xx snd_ac97_codec snd_ac97_bus snd
> _pcm_oss snd_mixer_oss analog gameport snd_pcm snd_timer snd_page_alloc snd_mpu4
> 01_uart snd_rawmidi usb_storage 8250_pnp 8250 serial_core rtc snd soundcore pris
> m54 usbhid via_agp agpgart firmware_class evdev ext3 jbd mbcache raid1 raid0 mul
> tipath linear md_mod ide_cd cdrom ide_disk ehci_hcd uhci_hcd usbcore via_rhine m
> ii via82cxxx ide_core sym53c8xx scsi_transport_spi scsi_mod unix
> CPU:    0
> EIP:    0060:[<e0c25de0>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.19.1 #1)
> EIP is at journal_grab_journal_head+0xd/0x36 [jbd]
> eax: dfd54000   ebx: 00000029   ecx: 000000d0   edx: 00000029
> esi: c12ae6e0   edi: 00000000   ebp: c09576ec   esp: dfd55dfc
> ds: 007b   es: 007b   ss: 0068
> Process kswapd0 (pid: 132, ti=dfd54000 task=dff98590 task.ti=dfd54000)
> Stack: 00000029 e0c215ca 00000246 c09579c4 c28b44b8 c11717a0 00000001 e0c5559a 
>        000000d0 00000001 c02c2d00 c0134758 c12ae6e0 c28b430c c0139da9 dfd55f1c 
>        00000014 dfd55f80 00000020 00000000 00000000 00000020 0000000b 00000001 
> Call Trace:
>  [<e0c215ca>] journal_try_to_free_buffers+0x5e/0x13d [jbd]
>  [<e0c5559a>] ext3_releasepage+0x0/0x72 [ext3]
>  [<c0134758>] try_to_release_page+0x34/0x46
>  [<c0139da9>] shrink_inactive_list+0x468/0x6f4
>  [<c0138b2a>] __pagevec_release+0x15/0x1d
>  [<c01397f7>] shrink_active_list+0x386/0x38e
>  [<c013a0e9>] shrink_zone+0xb4/0xd5
>  [<c013a570>] kswapd+0x288/0x38f
>  [<c0125eea>] autoremove_wake_function+0x0/0x35
>  [<c013a2e8>] kswapd+0x0/0x38f
>  [<c0125e31>] kthread+0xad/0xd8
>  [<c0125d84>] kthread+0x0/0xd8
>  [<c010379f>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: 04 00 74 03 83 0a 04 89 e0 25 00 e0 ff ff ff 48 14 8b 40 08 a8 08 74 05 e9
>  c9 ab 64 df c3 53 89 c2 89 e0 25 00 e0 ff ff ff 40 14 <8b> 02 31 db f6 c4 40 74
>  06 8b 5a 20 ff 43 04 89 e0 25 00 e0 ff 
> EIP: [<e0c25de0>] journal_grab_journal_head+0xd/0x36 [jbd] SS:ESP 0068:dfd55dfc
>  <6>note: kswapd0[132] exited with preempt_count 1
> 
> ##
> ## sound + backup from ide to USB
> ##
> 
> Jan  7 20:03:52 fantasio kernel: Oops: 0000 [#1]
> Jan  7 20:03:52 fantasio kernel: PREEMPT 
> Jan  7 20:03:52 fantasio kernel: Modules linked in: cbc blkcipher sd_mod visor usbserial binfmt_misc rfcomm l2cap nfs nfsd exportfs lockd sunrpc ip_nat_irc ip_nat_ftp ip_conntrack_irc ip_conntrack_ftp xt_state 
> ipt_REJECT ipt_LOG iptable_mangle iptable_filter iptable_nat ip_nat ip_tables ip_conntrack cryptoloop loop sha256 aes it87 hwmon_vid i2c_isa i2c_core md5 ipv6 af_packet usb_storage radeon drm dm_crypt dm_mod sn
> d_via82xx snd_ac97_codec snd_ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi analog gameport 8250_pnp 8250 serial_core rtc snd prism54 via_agp soundcore agpgart f
> irmware_class evdev ext3 jbd mbcache raid1 raid0 multipath linear md_mod ide_cd cdrom ide_disk usbhid via_rhine mii via82cxxx ide_core ehci_hcd uhci_hcd usbcore sym53c8xx scsi_transport_spi scsi_mod unix
> Jan  7 20:03:52 fantasio kernel: CPU:    0
> Jan  7 20:03:52 fantasio kernel: EIP:    0060:[pg0+546304086/1070171136]    Not tainted VLI
> Jan  7 20:03:52 fantasio kernel: EFLAGS: 00010206   (2.6.19.1 #1)
> Jan  7 20:03:52 fantasio kernel: EIP is at walk_page_buffers+0x1c/0x7e [ext3]
> Jan  7 20:03:52 fantasio kernel: eax: 00004000   ebx: 00004023   ecx: 00000000   edx: 00001001
> Jan  7 20:03:52 fantasio kernel: esi: 00003000   edi: c54976ec   ebp: 00001000   esp: d13b7e24
> Jan  7 20:03:52 fantasio kernel: ds: 007b   es: 007b   ss: 0068
> Jan  7 20:03:52 fantasio kernel: Process pdflush (pid: 12292, ti=d13b6000 task=d42a0550 task.ti=d13b6000)
> Jan  7 20:03:52 fantasio kernel: Stack: 00000000 df1783d8 00004023 c125d100 df1783d8 c54976ec df1783d8 e0c67bf8 
> Jan  7 20:03:52 fantasio kernel:        00001000 00000000 e0c650b8 00000000 c125d100 d13b7f70 c125d100 00000007 
> Jan  7 20:03:52 fantasio kernel:        00000000 d13b7f70 c01373fc 00000000 0000000e c9181664 0000000e c15cd1ac 
> Jan  7 20:03:52 fantasio kernel: Call Trace:
> Jan  7 20:03:52 fantasio kernel:  [pg0+546315256/1070171136] ext3_ordered_writepage+0xd7/0x194 [ext3]
> Jan  7 20:03:52 fantasio kernel:  [pg0+546304184/1070171136] bget_one+0x0/0x6 [ext3]
> Jan  7 20:03:52 fantasio kernel:  [generic_writepages+375/682] generic_writepages+0x177/0x2aa
> Jan  7 20:03:52 fantasio kernel:  [pg0+546315041/1070171136] ext3_ordered_writepage+0x0/0x194 [ext3]
> Jan  7 20:03:52 fantasio kernel:  [do_writepages+41/48] do_writepages+0x29/0x30
> Jan  7 20:03:52 fantasio kernel:  [__writeback_single_inode+414/811] __writeback_single_inode+0x19e/0x32b
> Jan  7 20:03:52 fantasio kernel:  [schedule_timeout+140/160] schedule_timeout+0x8c/0xa0
> Jan  7 20:03:52 fantasio kernel:  [process_timeout+0/5] process_timeout+0x0/0x5
> Jan  7 20:03:52 fantasio kernel:  [sync_sb_inodes+348/529] sync_sb_inodes+0x15c/0x211
> Jan  7 20:03:52 fantasio kernel:  [writeback_inodes+103/206] writeback_inodes+0x67/0xce
> Jan  7 20:03:52 fantasio kernel:  [background_writeout+99/142] background_writeout+0x63/0x8e
> Jan  7 20:03:52 fantasio kernel:  [pdflush+0/431] pdflush+0x0/0x1af
> Jan  7 20:03:52 fantasio kernel:  [pdflush+267/431] pdflush+0x10b/0x1af
> Jan  7 20:03:52 fantasio kernel:  [background_writeout+0/142] background_writeout+0x0/0x8e
> Jan  7 20:03:52 fantasio kernel:  [kthread+173/216] kthread+0xad/0xd8
> Jan  7 20:03:52 fantasio kernel:  [kthread+0/216] kthread+0x0/0xd8
> Jan  7 20:03:52 fantasio kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
> Jan  7 20:03:52 fantasio kernel:  =======================
> Jan  7 20:03:52 fantasio kernel: Code: 41 04 3b 02 74 f0 31 c0 39 d9 5b 0f 97 c0 c3 55 57 89 d7 56 31 f6 53 89 d3 83 ec 0c 89 44 24 04 89 0c 24 8b 6a 10 01 ee 3b 34 24 <8b> 43 04 89 f2 89 44 24 08 0f 96 c0 29 e
> a 3b 54 24 20 0f 93 c2 
> Jan  7 20:03:52 fantasio kernel: EIP: [pg0+546304086/1070171136] walk_page_buffers+0x1c/0x7e [ext3] SS:ESP 0068:d13b7e24
> 
										Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
