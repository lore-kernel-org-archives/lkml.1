Return-Path: <linux-kernel-owner+w=401wt.eu-S932854AbXBKOAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbXBKOAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 09:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932858AbXBKOAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 09:00:01 -0500
Received: from mail.gmx.net ([213.165.64.20]:53757 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932854AbXBKOAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 09:00:00 -0500
X-Provags-ID: V01U2FsdGVkX19k3NVLNpFk6A3or95NCe19EUCdLj42ALOiZBi2pS
	Hnww==
From: Frank Hartmann <soundart@gmx.net>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.19.1 Oops while doing Disk IO + playing sound, 2.6.20 too
In-Reply-To: <20070208093930.GB10973@duck.suse.cz> (Jan Kara's message of
	"Thu, 8 Feb 2007 10:39:30 +0100")
References: <877ivr6t0k.fsf@fantasio.hh.de>
	<20070207091841.GE24590@atrey.karlin.mff.cuni.cz>
	<87wt2thhux.fsf@fantasio.hh.de> <20070208093930.GB10973@duck.suse.cz>
Date: Sun, 11 Feb 2007 14:59:53 +0100
Message-ID: <87bqk06bhi.fsf_-_@fantasio.hh.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:
>   OK, thanks for the news. Please, write me when you try out 2.6.20. Just
> if it rings bell to someone on this list: It looks like the page had no
> buffers but PagePrivate was set. Strange.

Hi Jan,

below is what I got using 2.6.20. 

Is there any correlation to my previous reports? Should I focus
testing memory/disks/etc. further(and how?)? Or should I focus modifying kernel
parameters(and which)? 


Feb 11 14:30:47 fantasio kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 0000002d
Feb 11 14:30:47 fantasio kernel:  printing eip:
Feb 11 14:30:47 fantasio kernel: e0c55b16
Feb 11 14:30:47 fantasio kernel: *pde = 00000000
Feb 11 14:30:47 fantasio kernel: Oops: 0000 [#1]
Feb 11 14:30:48 fantasio kernel: Modules linked in: cbc blkcipher binfmt_misc bnep rfcomm l2cap nfs nfsd exportfs lockd sunrpc ip_tables bridge llc cryptoloop loop sha256 aes it87 hwmon_vid i2c_isa i2c_core md5 ipv6 af_packet radeon drm dm_crypt dm_mod snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc analog snd_mpu401_uart rtc gameport snd_rawmidi snd via_agp agpgart prism54 8250_pnp 8250 serial_core evdev soundcore firmware_class sd_mod ext3 jbd mbcache raid1 raid0 multipath linear md_mod ide_cd cdrom ide_disk usbhid usb_storage via82cxxx ide_core via_rhine mii ehci_hcd uhci_hcd usbcore sym53c8xx scsi_transport_spi scsi_mod unix
Feb 11 14:30:48 fantasio kernel: CPU:    0
Feb 11 14:30:48 fantasio kernel: EIP:    0060:[pg0+546224918/1070154752]    Not tainted VLI
Feb 11 14:30:48 fantasio kernel: EFLAGS: 00010202   (2.6.20 #1)
Feb 11 14:30:48 fantasio kernel: EIP is at walk_page_buffers+0x1e/0x87 [ext3]
Feb 11 14:30:48 fantasio kernel: eax: c38df601   ebx: 00002000   ecx: 00000029   edx: c38df601
Feb 11 14:30:48 fantasio kernel: esi: 00002000   edi: c38df6ec   ebp: 00000000   esp: c14f5dbc
Feb 11 14:30:48 fantasio kernel: ds: 007b   es: 007b   ss: 0068
Feb 11 14:30:48 fantasio kernel: Process pdflush (pid: 134, ti=c14f4000 task=dfc04a70 task.ti=c14f4000)
Feb 11 14:30:48 fantasio kernel: Stack: 00000029 00001000 00000000 dce96734 c104f700 c38df6ec dce96734 dce96734 
Feb 11 14:30:48 fantasio kernel:        e0c5629b 00001000 00000000 e0c561b1 c14f5e38 0000000e c14f5f58 0000000a 
Feb 11 14:30:48 fantasio kernel:        c104f700 0000000e c14f5f58 c0133584 00000000 0000000e 00000000 00000001 
Feb 11 14:30:48 fantasio kernel: Call Trace:
Feb 11 14:30:48 fantasio kernel:  [pg0+546226843/1070154752] ext3_ordered_writepage+0xcc/0x158 [ext3]
Feb 11 14:30:48 fantasio kernel:  [pg0+546226609/1070154752] bget_one+0x0/0x6 [ext3]
Feb 11 14:30:48 fantasio kernel:  [generic_writepages+380/690] generic_writepages+0x17c/0x2b2
Feb 11 14:30:48 fantasio kernel:  [pg0+546226639/1070154752] ext3_ordered_writepage+0x0/0x158 [ext3]
Feb 11 14:30:48 fantasio kernel:  [do_writepages+41/48] do_writepages+0x29/0x30
Feb 11 14:30:48 fantasio kernel:  [__sync_single_inode+81/406] __sync_single_inode+0x51/0x196
Feb 11 14:30:48 fantasio kernel:  [__writeback_single_inode+312/320] __writeback_single_inode+0x138/0x140
Feb 11 14:30:48 fantasio kernel:  [schedule_timeout+121/141] schedule_timeout+0x79/0x8d
Feb 11 14:30:48 fantasio kernel:  [process_timeout+0/5] process_timeout+0x0/0x5
Feb 11 14:30:48 fantasio kernel:  [apic_timer_interrupt+40/48] apic_timer_interrupt+0x28/0x30
Feb 11 14:30:48 fantasio kernel:  [congestion_wait+107/117] congestion_wait+0x6b/0x75
Feb 11 14:30:48 fantasio kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Feb 11 14:30:48 fantasio kernel:  [sync_sb_inodes+361/511] sync_sb_inodes+0x169/0x1ff
Feb 11 14:30:48 fantasio kernel:  [writeback_inodes+67/100] writeback_inodes+0x43/0x64
Feb 11 14:30:48 fantasio kernel:  [pdflush+0/40] pdflush+0x0/0x28
Feb 11 14:30:48 fantasio kernel:  [background_writeout+88/137] background_writeout+0x58/0x89
Feb 11 14:30:48 fantasio kernel:  [pdflush+0/40] pdflush+0x0/0x28
Feb 11 14:30:48 fantasio kernel:  [__pdflush+179/309] __pdflush+0xb3/0x135
Feb 11 14:30:48 fantasio kernel:  [pdflush+36/40] pdflush+0x24/0x28
Feb 11 14:30:48 fantasio kernel:  [background_writeout+0/137] background_writeout+0x0/0x89
Feb 11 14:30:48 fantasio kernel:  [pdflush+0/40] pdflush+0x0/0x28
Feb 11 14:30:48 fantasio kernel:  [kthread+114/151] kthread+0x72/0x97
Feb 11 14:30:48 fantasio kernel:  [kthread+0/151] kthread+0x0/0x97
Feb 11 14:30:48 fantasio kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Feb 11 14:30:48 fantasio kernel:  =======================
Feb 11 14:30:48 fantasio kernel: Code: 06 fb ff ff ff 83 c4 0c 89 c8 5b 5e c3 55 31 ed 57 89 d7 56 31 f6 53 83 ec 10 89 4c 24 08 89 44 24 0c 89 d1 8b 42 10 89 44 24 04 <8b> 41 04 89 04 24 8b 44 24 04 8d 1c 06 3b 5c 24 08 0f 96 c2 3b 
Feb 11 14:30:48 fantasio kernel: EIP: [pg0+546224918/1070154752] walk_page_buffers+0x1e/0x87 [ext3] SS:ESP 0068:c14f5dbc


regards
  Frank
