Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbXKMXbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbXKMXbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbXKMXbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:31:42 -0500
Received: from mail.dbd-breitband.de ([217.188.211.21]:2229 "EHLO
	dbd-mpx01.dbd-breitband.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755505AbXKMXbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:31:41 -0500
X-Greylist: delayed 1461 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 18:31:40 EST
From: Marc Donner <donner@dbd-breitband.de>
Organization: DBD DeutscheBreitbandDienste
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at mm/prio_tree.c:125
Date: Wed, 14 Nov 2007 01:04:54 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711140004.55369.donner@dbd-breitband.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi 

i got this kernel bug on our production system, which is running since last 
saturday.

anybody an idea??

Marc

uname -a
Linux files 2.6.18-5-686-bigmem #1 SMP Thu Aug 30 03:25:44 UTC 2007 i686
GNU/Linux

Nov 13 16:55:24 files kernel: ------------[ cut here ]------------
Nov 13 16:55:24 files kernel: kernel BUG at mm/prio_tree.c:125!
Nov 13 16:55:24 files kernel: invalid opcode: 0000 [#1]
Nov 13 16:55:24 files kernel: SMP
Nov 13 16:55:24 files kernel: Modules linked in: button ac battery ipv6
dm_snapshot dm_mirror dm_mod loop snd_via82xx gameport snd_ac97_codec
snd_ac97_bus sn
d_pcm snd_timer snd_page_alloc snd_mpu401_uart evdev snd_rawmidi
snd_seq_device snd serio_raw via82cxxx_audio uart401 sound soundcore
i2c_viapro ac97_codec p
smouse i2c_core rtc pcspkr via_agp agpgart shpchp pci_hotplug raid10 raid456
xor multipath linear ide_generic via_rhine mii ehci_hcd uhci_hcd usbcore
ide_dis
k thermal fan freq_table processor raid1 raid0 md_mod ahci sata_nv sata_sil
sata_via libata via82cxxx ide_core 3w_9xxx 3w_xxxx scsi_mod xfs ext3 jbd
ext2 mbc
ache reiserfs
Nov 13 16:55:24 files kernel: CPU:    0
Nov 13 16:55:24 files kernel: EIP:    0060:[<c0147ad5>]    Not tainted VLI
Nov 13 16:55:24 files kernel: EFLAGS: 00210217   (2.6.18-5-686-bigmem #1)
Nov 13 16:55:24 files kernel: EIP is at vma_prio_tree_remove+0x46/0xcd
Nov 13 16:55:24 files kernel: eax: ee09238c   ebx: f2806b58   ecx: ee09238c
edx: f2806b70
Nov 13 16:55:24 files kernel: esi: c85c0f40   edi: f3970524   ebp: b69f4000
esp: d8e95f1c
Nov 13 16:55:24 files kernel: ds: 007b   es: 007b   ss: 0068
Nov 13 16:55:24 files kernel: Process apache (pid: 31369, ti=d8e94000
task=f7cffaa0 task.ti=d8e94000)
Nov 13 16:55:24 files kernel: Stack: f2806b70 f2806b58 c85c0f40 ee09238c
b69f4000 c014cce1 c17e5ee0 ee09238c
Nov 13 16:55:24 files kernel:        f37a238c c014bec2 b69f4000 d8e95f6c
c17e5ee0 f3cd4740 ee092b1c f37a243c
Nov 13 16:55:24 files kernel:        c014c9f7 b6d87000 ee09238c 000000d7
c17e5ee0 f3cd4740 ee0925f4 ee09238c
Nov 13 16:55:24 files kernel: Call Trace:
Nov 13 16:55:24 files kernel:  [<c014cce1>] unlink_file_vma+0x25/0x2e
Nov 13 16:55:24 files kernel:  [<c014bec2>] free_pgtables+0x26/0x78
Nov 13 16:55:24 files kernel:  [<c014c9f7>] unmap_region+0xbb/0xf3
Nov 13 16:55:24 files kernel:  [<c014d2d7>] do_munmap+0x148/0x19b
Nov 13 16:55:24 files kernel:  [<c014d35d>] sys_munmap+0x33/0x41
Nov 13 16:55:24 files kernel:  [<c0102c0d>] sysenter_past_esp+0x56/0x79
Nov 13 16:55:24 files kernel: Code: 16 8b 50 28 8b 43 04 89 42 04 89 10 89
5b 04 89 59 28 e9 92 00 00 00 8b 04 24 89 da 59 5b 5e 5f 5d e9 a4 04 07 00
39 47 3
4 74 08 <0f> 0b 7d 00 5e a2 29 c0 83 79 30 00 74 38 8b 77 28 8d 57 28 8d
Nov 13 16:55:24 files kernel: EIP: [<c0147ad5>]
vma_prio_tree_remove+0x46/0xcd SS:ESP 0068:d8e95f1c

Nov 13 16:55:37 files postfix/master[3582]: warning: process
/usr/lib/postfix/smtpd pid 1044 killed by signal 11
Nov 13 16:55:37 files postfix/master[3582]: warning: /usr/lib/postfix/smtpd:
bad command startup -- throttling
