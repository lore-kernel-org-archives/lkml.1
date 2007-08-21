Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbXHUKJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbXHUKJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbXHUKJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:09:28 -0400
Received: from 193-189-87-45.ip.kis.lt ([193.189.87.45]:60717 "EHLO
	barclay.wilibox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754176AbXHUKJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:09:27 -0400
Subject: Kernel Oops in ext3 (kernel tainted, fglrx
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 21 Aug 2007 13:09:22 +0300
Message-Id: <1187690962.5742.4.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello lkml,

A moment ago I've got this beauty below. Kernel is tainted due to
fglrx.ko feel free to ignore. 

ATI drivers 8.40.4 and for some reason iwl3945(F). What does it mean (F)
- forced insmod ? :\ iwl3945 driver is from git repository. I am running
2.6.23-rc3, 2GB of RAM, dual Core, HP nx9420 laptop. 

What does it mean 'PGD 73414067 PUD 0' ? Page table directory corrupted ?


Aug 21 12:44:00 zv kernel: PGD 73414067 PUD 0 
Aug 21 12:44:00 zv kernel: CPU 1 
Aug 21 12:44:00 zv kernel: Modules linked in: nfs cpufreq_ondemand fglrx(P) rfcomm l2cap nfsd exportfs lockd nfs_acl auth_rpcgss 
sunrpc ppdev lp autofs4 ipv6 deflate zlib_deflate twofish twofish_common camellia serpent blowfish des cbc aes xcbc sha256 sha1 
crypto_null af_key dm_crypt dm_snapshot dm_mirror dm_mod firewire_sbp2 loop coretemp cpufreq_conservative cpufreq_stats acpi_cpufreq 
freq_table arc4 ecb blkcipher pcmcia joydev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm pl2303 snd_timer iwl3945(F) snd sdhci 
firmware_class yenta_socket soundcore mac80211 rsrc_nonstatic tifm_7xx1 hci_usb parport_pc mmc_core usbserial tifm_core psmouse 
bluetooth cfg80211 pcspkr snd_page_alloc parport pcmcia_core iTCO_wdt intel_agp serio_raw video output battery container ac button 
tsdev evdev ext3 jbd mbcache sg sr_mod cdrom generic piix ide_core usbhid hid sd_mod ata_piix firewire_ohci ata_generic ahci 
firewire_core libata scsi_mod crc_itu_t tg3 ehci_hcd uhci_hcd thermal processor fan
Aug 21 12:44:00 zv kernel: Pid: 5475, comm: evolution Tainted: PF       2.6.23-rc3 #1
Aug 21 12:44:00 zv kernel: RIP: 0010:[<ffffffff8814cfc5>]  [<ffffffff8814cfc5>] :ext3:ext3_try_to_allocate_with_rsv+0x3df/0x4e3
Aug 21 12:44:00 zv kernel: RSP: 0018:ffff810034fe9758  EFLAGS: 00010286
Aug 21 12:44:00 zv kernel: RAX: 00000000ffffffff RBX: 00000000ffffffff RCX: 0000000000000000
Aug 21 12:44:00 zv kernel: RDX: ffff810034fe9878 RSI: ffffffff8815de90 RDI: ffff81006ce87380
Aug 21 12:44:00 zv kernel: RBP: ffff81004c26cbc0 R08: ffff810034fe97b8 R09: 0000000000000011
Aug 21 12:44:00 zv kernel: R10: ffff81006ce87000 R11: ffff81006cd60268 R12: 0000000000000007
Aug 21 12:44:00 zv kernel: R13: ffff81007b413cc0 R14: ffff81007cd45000 R15: ffff81004c26cbc0
Aug 21 12:44:00 zv kernel: FS:  0000000041802950(0063) GS:ffff8100011c8c40(0000) knlGS:0000000000000000
Aug 21 12:44:00 zv kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 21 12:44:00 zv kernel: CR2: 00000000ffffffff CR3: 000000007c130000 CR4: 00000000000006e0
Aug 21 12:44:00 zv kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 21 12:44:00 zv kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 21 12:44:00 zv kernel: Process evolution (pid: 5475, threadinfo ffff810034fe8000, task ffff810037e65040)
Aug 21 12:44:00 zv kernel: Stack:  ffff81004c26cbe0 00001bef7c7f4cc0 ffff81006cd60268 00000066802a2954
Aug 21 12:44:00 zv kernel:  ffff81001d9273d8 0000000000330000 0000000000337fff 0000000000000066
Aug 21 12:44:00 zv kernel:  ffff81004c26cbe0 0000000000000066 ffff81004c26cbc0 ffffffff802a3ece
Aug 21 12:44:00 zv kernel: Call Trace:
Aug 21 12:44:00 zv kernel:  [<ffffffff802a3ece>] __bread+0x6/0x76
Aug 21 12:44:00 zv kernel:  [<ffffffff8814d2b7>] :ext3:ext3_new_blocks+0x1ee/0x65e
Aug 21 12:44:00 zv kernel:  [<ffffffff881503ba>] :ext3:ext3_get_blocks_handle+0x405/0x8e4
Aug 21 12:44:00 zv kernel:  [<ffffffff8813abb6>] :jbd:do_get_write_access+0x47b/0x4ad
Aug 21 12:44:00 zv kernel:  [<ffffffff8813a2a2>] :jbd:__journal_file_buffer+0x125/0x21c
Aug 21 12:44:00 zv kernel:  [<ffffffff88150b85>] :ext3:ext3_get_block+0xc2/0xe4
Aug 21 12:44:00 zv kernel:  [<ffffffff802a32fc>] __block_prepare_write+0x18a/0x441
Aug 21 12:44:00 zv kernel:  [<ffffffff88150ac3>] :ext3:ext3_get_block+0x0/0xe4
Aug 21 12:44:00 zv kernel:  [<ffffffff802a35cd>] block_prepare_write+0x1a/0x25
Aug 21 12:44:00 zv kernel:  [<ffffffff88151ef5>] :ext3:ext3_prepare_write+0xb2/0x17b
Aug 21 12:44:00 zv kernel:  [<ffffffff80261142>] generic_file_buffered_write+0x288/0x61a
Aug 21 12:44:00 zv kernel:  [<ffffffff80239490>] current_fs_time+0x1e/0x24
Aug 21 12:44:00 zv kernel:  [<ffffffff8038bada>] sock_common_recvmsg+0x30/0x45
Aug 21 12:44:00 zv kernel:  [<ffffffff80261813>] __generic_file_aio_write_nolock+0x33f/0x3a9
Aug 21 12:44:00 zv kernel:  [<ffffffff80246f9a>] autoremove_wake_function+0x0/0x2e
Aug 21 12:44:00 zv kernel:  [<ffffffff802618de>] generic_file_aio_write+0x61/0xc1
Aug 21 12:44:00 zv kernel:  [<ffffffff8814e1b6>] :ext3:ext3_file_write+0x16/0x94
Aug 21 12:44:00 zv kernel:  [<ffffffff80283df8>] do_sync_write+0xc9/0x10c
Aug 21 12:44:00 zv kernel:  [<ffffffff80246f9a>] autoremove_wake_function+0x0/0x2e
Aug 21 12:44:00 zv kernel:  [<ffffffff802845bf>] vfs_write+0xce/0x157
Aug 21 12:44:00 zv kernel:  [<ffffffff80284b1d>] sys_write+0x45/0x6e
Aug 21 12:44:00 zv kernel:  [<ffffffff8020be6e>] system_call+0x7e/0x83
Aug 21 12:44:00 zv kernel: 
Aug 21 12:44:00 zv kernel: 
Aug 21 12:44:00 zv kernel: Code: 48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Aug 21 12:44:00 zv kernel:  RSP <ffff810034fe9758>
Aug 21 12:46:06 zv kernel: SysRq : Emergency Sync
Aug 21 12:46:07 zv kernel: Emergency Sync complete
Aug 21 12:46:07 zv kernel: SysRq : Emergency Sync
Aug 21 12:46:07 zv kernel: Emergency Sync complete
Aug 21 12:46:08 zv kernel: SysRq : Emergency Remount R/O


