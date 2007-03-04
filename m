Return-Path: <linux-kernel-owner+w=401wt.eu-S1751486AbXCDIg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbXCDIg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 03:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXCDIg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 03:36:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:33975 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751486AbXCDIg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 03:36:57 -0500
X-Provags-ID: V01U2FsdGVkX18qxwwtvTMqUwSt3YdhTHCYw0HakPbLXlOZsEC7vR
	0AhNrL/Gyhi4Af
From: Frank Hartmann <soundart@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Subject: Re: PROBLEM: 2.6.19.1 Oops while doing Disk IO + playing sound, 2.6.20 too ->  STATUS git-bisect 
In-Reply-To: <20070216092909.GA1711@duck.suse.cz> (Jan Kara's message of "Fri,
	16 Feb 2007 10:29:09 +0100")
References: <877ivr6t0k.fsf@fantasio.hh.de>
	<20070207091841.GE24590@atrey.karlin.mff.cuni.cz>
	<87wt2thhux.fsf@fantasio.hh.de> <20070208093930.GB10973@duck.suse.cz>
	<87bqk06bhi.fsf_-_@fantasio.hh.de> <20070214143249.GE23203@duck.suse.cz>
	<87r6ssl3g4.fsf@fantasio.hh.de> <20070215094053.GA28205@duck.suse.cz>
	<87mz3f9gab.fsf@fantasio.hh.de> <20070216092909.GA1711@duck.suse.cz>
Date: Sun, 04 Mar 2007 09:37:04 +0100
Message-ID: <877itxmmkv.fsf_-_@fantasio.hh.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

the last 10 days I have been bisecting my problem. Currenly I am here
and I have 10 commits to go:

fantasio:~/tmp/linux-2.6$ git-bisect log
git-bisect start
# bad: [fa285a3d7924a0e3782926e51f16865c5129a2f7] Linux 2.6.20
git-bisect bad fa285a3d7924a0e3782926e51f16865c5129a2f7
# bad: [fa285a3d7924a0e3782926e51f16865c5129a2f7] Linux 2.6.20
git-bisect bad fa285a3d7924a0e3782926e51f16865c5129a2f7
# good: [8ba130df4b67fa40878ccf80d54615132d24bc68] Linux v2.6.17
git-bisect good 8ba130df4b67fa40878ccf80d54615132d24bc68
# good: [8ba130df4b67fa40878ccf80d54615132d24bc68] Linux v2.6.17
git-bisect good 8ba130df4b67fa40878ccf80d54615132d24bc68
# good: [ebdea46fecae40c4d7effcd33f40918a37a1df4b] Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm
git-bisect good ebdea46fecae40c4d7effcd33f40918a37a1df4b
# good: [8c6270f957f0eaa343e4a609159c4b85038468d6] 8390 fixes - m68k oddballs
git-bisect good 8c6270f957f0eaa343e4a609159c4b85038468d6
# good: [de1ba09b214056365d9082982905b255caafb7a2] fault injection: documentation and scripts
git-bisect good de1ba09b214056365d9082982905b255caafb7a2
# bad: [fadfc8e930dcaf502b49a0a0170ba8ebe9a34c49] gss_spkm3: fix error handling in module init
git-bisect bad fadfc8e930dcaf502b49a0a0170ba8ebe9a34c49
# good: [1cf24bdbbbd2eb5439796dc399ab1649d150ed1d] [IA64] - Reduce overhead of FP exception logging messages
git-bisect good 1cf24bdbbbd2eb5439796dc399ab1649d150ed1d
# good: [ed8ed9ac06604513edd6be6b1c81b6270296b7fc] [POWERPC] cell: update cell_defconfig
git-bisect good ed8ed9ac06604513edd6be6b1c81b6270296b7fc
# bad: [ee2fae03d68e702866a8661fbee7ff2f2f3754d7] Merge branch 'drm-patches' of master.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6
git-bisect bad ee2fae03d68e702866a8661fbee7ff2f2f3754d7
# bad: [f238085415c56618e042252894f2fcc971add645] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git-bisect bad f238085415c56618e042252894f2fcc971add645
# good: [b06824cecafdacf2b12de583d4b41fd9c583c8c4] [DocBook]: Fix two typos in generic IRQ docs.
git-bisect good b06824cecafdacf2b12de583d4b41fd9c583c8c4
# good: [a159aaa328a02b0189774c58ae7d917b25d26852] [AX.25]: Fix unchecked rose_add_loopback_node uses
git-bisect good a159aaa328a02b0189774c58ae7d917b25d26852
# good: [749494bad9ca170e404b8dcebe8422df0d79b3ac] [TG3]: Update version and reldate.
git-bisect good 749494bad9ca170e404b8dcebe8422df0d79b3ac


My problem is that I need a reality check now. Jan indicated that my
report might be contradicting already, so it could be I missed a bad
kernel somewhere. Triggering the error problem seems for the bad
kernels fairly easy, but I do not know how good a bug can hide!

I said earlier in this thread. that I had 'similar' Oops in 2.6.19.1
2.6.19.2 and 2.6.20 in addition to the ones marked as bad in above
log. (I cannot find 2.6.19.x in git revisions history.)


On the other hand I have only 10 commits now and someone with
knowledge could judge and review the suspects. 

I would welcome hints too where I should restart in case the situation
makes no sense at all.



>From my vague understanding of things I would think:



commit a240d9f1d8e6421cb970632b93e71b2f66c2cd70
Author: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date:   Mon Dec 18 01:53:58 2006 -0800

    [CONNECTOR]: Replace delayed work with usual work queue.
    
    Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d8172d822fb02d5c4f7508e41f9267428dd3d891
Author: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date:   Sun Dec 17 17:09:41 2006 -0800

    [CONNECTOR]: Fix compilation breakage introduced recently.
    
    Linus has changed work queue structure and has not tested it with
    connector compiled in, his changes break the build.
    
    Attached patch fixes compilation error.
    
    Patch is against commit 99f5e9718185f07458ae70c2282c2153a2256c91.
    
    Thanks to Toralf F<C3><B6>rster for pointing this out.
    
    Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d1998ef38a13c4e74c69df55ccd38b0440c429b2
Author: Ben Collins <ben.collins@ubuntu.com>
Date:   Wed Dec 13 22:10:05 2006 -0500

    [PATCH] ib_verbs: Use explicit if-else statements to avoid errors with do-while macros
    
    At least on PPC, the "op ? op : dma" construct causes a compile failure
    because the dma_* is a do{}while(0) macro.
    
    This turns all of them into proper if/else to avoid this problem.
    
    Signed-off-by: Ben Collins <bcollins@ubuntu.com>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>



Are the ones left. The other commits declare they do something with
networking or usb.

Is it possible, that one of the commit above causes Oopses like the stuff below?


regards
  Frank



Feb 25 17:07:29 fantasio kernel:  printing eip:
Feb 25 17:07:29 fantasio kernel: e0c03b16
Feb 25 17:07:29 fantasio kernel: *pde = 00000000
Feb 25 17:07:29 fantasio kernel: Oops: 0000 [#1]
Feb 25 17:07:29 fantasio kernel: Modules linked in: cbc blkcipher visor usbserial binfmt_misc bnep rfcomm l2cap nfs nfsd exportfs lockd sunrpc ip_tables bridge llc cryptoloop loop sha256 aes it
87 hwmon_vid i2c_isa i2c_core md5 ipv6 af_packet radeon drm dm_crypt dm_mod snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart analog
 prism54 snd_rawmidi rtc 8250_pnp 8250 snd serial_core gameport firmware_class evdev soundcore via_agp agpgart sd_mod ext3 jbd mbcache raid1 raid0 multipath linear md_mod ide_cd cdrom ide_disk 
usbhid usb_storage via82cxxx ide_core ehci_hcd via_rhine mii uhci_hcd usbcore sym53c8xx scsi_transport_spi scsi_mod unix
Feb 25 17:07:29 fantasio kernel: CPU:    0
Feb 25 17:07:29 fantasio kernel: EIP:    0060:[pg0+545897238/1070162944]    Not tainted VLI
Feb 25 17:07:29 fantasio kernel: EFLAGS: 00010202   (2.6.20-rc1-fadfc8e930dcaf502b49a0a0170ba8ebe9a34c49 #4)
Feb 25 17:07:29 fantasio kernel: EIP is at walk_page_buffers+0x1e/0x87 [ext3]
Feb 25 17:07:29 fantasio kernel: eax: cbdf7601   ebx: 00002000   ecx: 00000029   edx: cbdf6601
Feb 25 17:07:29 fantasio kernel: esi: 00002000   edi: cbdf66ec   ebp: 00000000   esp: df63bdc0
Feb 25 17:07:29 fantasio kernel: ds: 007b   es: 007b   ss: 0068
Feb 25 17:07:29 fantasio kernel: Process pdflush (pid: 135, ti=df63a000 task=df653070 task.ti=df63a000)
Feb 25 17:07:29 fantasio kernel: Stack: 00000029 00001000 00000000 df26f734 c1224620 cbdf66ec df26f734 df26f734 
Feb 25 17:07:29 fantasio kernel:        e0c0429b 00001000 00000000 e0c041b1 df63be3c 0000000e df63bf58 0000000b 
Feb 25 17:07:29 fantasio kernel:        c1224620 0000000e df63bf58 c01338d4 00000000 0000000e 00000000 00000001 
Feb 25 17:07:29 fantasio kernel: Call Trace:
Feb 25 17:07:30 fantasio kernel:  [pg0+545899163/1070162944] ext3_ordered_writepage+0xcc/0x158 [ext3]
Feb 25 17:07:30 fantasio kernel:  [pg0+545898929/1070162944] bget_one+0x0/0x6 [ext3]
Feb 25 17:07:30 fantasio kernel:  [generic_writepages+380/690] generic_writepages+0x17c/0x2b2
Feb 25 17:07:30 fantasio kernel:  [pg0+545898959/1070162944] ext3_ordered_writepage+0x0/0x158 [ext3]
Feb 25 17:07:30 fantasio kernel:  [do_writepages+41/48] do_writepages+0x29/0x30
Feb 25 17:07:30 fantasio kernel:  [__sync_single_inode+81/406] __sync_single_inode+0x51/0x196
Feb 25 17:07:30 fantasio kernel:  [__writeback_single_inode+291/299] __writeback_single_inode+0x123/0x12b
Feb 25 17:07:30 fantasio kernel:  [handle_edge_irq+185/215] handle_edge_irq+0xb9/0xd7
Feb 25 17:07:30 fantasio kernel:  [process_timeout+0/5] process_timeout+0x0/0x5
Feb 25 17:07:30 fantasio kernel:  [common_interrupt+35/40] common_interrupt+0x23/0x28
Feb 25 17:07:30 fantasio kernel:  [congestion_wait+107/117] congestion_wait+0x6b/0x75
Feb 25 17:07:30 fantasio kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Feb 25 17:07:30 fantasio kernel:  [sync_sb_inodes+361/511] sync_sb_inodes+0x169/0x1ff
Feb 25 17:07:30 fantasio kernel:  [writeback_inodes+67/100] writeback_inodes+0x43/0x64
Feb 25 17:07:30 fantasio kernel:  [pdflush+0/40] pdflush+0x0/0x28
Feb 25 17:07:30 fantasio kernel:  [background_writeout+88/137] background_writeout+0x58/0x89
Feb 25 17:07:30 fantasio kernel:  [pdflush+0/40] pdflush+0x0/0x28
Feb 25 17:07:30 fantasio kernel:  [__pdflush+179/309] __pdflush+0xb3/0x135
Feb 25 17:07:30 fantasio kernel:  [pdflush+36/40] pdflush+0x24/0x28
Feb 25 17:07:30 fantasio kernel:  [background_writeout+0/137] background_writeout+0x0/0x89
Feb 25 17:07:30 fantasio kernel:  [pdflush+0/40] pdflush+0x0/0x28
Feb 25 17:07:30 fantasio kernel:  [kthread+114/151] kthread+0x72/0x97
Feb 25 17:07:30 fantasio kernel:  [kthread+0/151] kthread+0x0/0x97
Feb 25 17:07:30 fantasio kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Feb 25 17:07:30 fantasio kernel:  =======================
Feb 25 17:07:30 fantasio kernel: Code: 06 fb ff ff ff 83 c4 0c 89 c8 5b 5e c3 55 31 ed 57 89 d7 56 31 f6 53 83 ec 10 89 4c 24 08 89 44 24 0c 89 d1 8b 42 10 89 44 24 04 <8b> 41 04 89 04 24 8b 44
 24 04 8d 1c 06 3b 5c 24 08 0f 96 c2 3b 

----------------------------------------------------------------------
or
----------------------------------------------------------------------

Feb 28 01:17:37 fantasio kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000029
Feb 28 01:17:37 fantasio kernel:  printing eip:
Feb 28 01:17:37 fantasio kernel: e0c7674e
Feb 28 01:17:37 fantasio kernel: *pde = 00000000
Feb 28 01:17:37 fantasio kernel: Oops: 0000 [#1]
Feb 28 01:17:37 fantasio kernel: Modules linked in: iptable_filter cbc blkcipher binfmt_misc bnep rfcomm l2cap nfs nfsd exportfs lockd sunrpc ip_tables bridge llc cryptoloop loop sha256 aes it8
7 hwmon_vid i2c_isa i2c_core md5 ipv6 af_packet radeon drm dm_crypt dm_mod snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss analog via_agp prism54 gameport 8250_pnp 8250 serial_cor
e agpgart firmware_class snd_pcm snd_timer snd_page_alloc snd_mpu401_uart rtc snd_rawmidi snd soundcore sd_mod evdev ext3 jbd mbcache raid1 raid0 multipath linear md_mod ide_cd cdrom ide_disk u
sbhid usb_storage via82cxxx ide_core via_rhine mii ehci_hcd uhci_hcd usbcore sym53c8xx scsi_transport_spi scsi_mod unix
Feb 28 01:17:37 fantasio kernel: CPU:    0
Feb 28 01:17:37 fantasio kernel: EIP:    0060:[pg0+546367310/1070162944]    Not tainted VLI
Feb 28 01:17:37 fantasio kernel: EFLAGS: 00010213   (2.6.20-rc1-ee2fae03d68e702866a8661fbee7ff2f2f3754d7 #2)
Feb 28 01:17:37 fantasio kernel: EIP is at journal_grab_journal_head+0x2/0x14 [jbd]
Feb 28 01:17:37 fantasio kernel: eax: 00000029   ebx: 00000029   ecx: 00000029   edx: 00000000
Feb 28 01:17:37 fantasio kernel: esi: 00000000   edi: c10b6140   ebp: c70fd6ec   esp: c14bbdc8
Feb 28 01:17:37 fantasio kernel: ds: 007b   es: 007b   ss: 0068
Feb 28 01:17:37 fantasio kernel: Process kswapd0 (pid: 136, ti=c14ba000 task=df637a70 task.ti=c14ba000)
Feb 28 01:17:37 fantasio kernel: Stack: e0c72534 c1128f60 c13de7e0 c1312460 c1321e20 d4ed81dc 00000000 df822c60 
Feb 28 01:17:37 fantasio kernel:        e0bf357f 000000d0 d4ed81dc c14bbe8c c0131325 c10b6140 c14bbf3c c01358da 
Feb 28 01:17:37 fantasio kernel:        00000001 00000001 00000011 00000000 c14bbf3c c14bbe1c c14bbe1c 00000003 
Feb 28 01:17:37 fantasio kernel: Call Trace:
Feb 28 01:17:37 fantasio kernel:  [pg0+546350388/1070162944] journal_try_to_free_buffers+0x62/0x9f [jbd]
Feb 28 01:17:37 fantasio kernel:  [pg0+545830271/1070162944] ext3_releasepage+0x0/0x72 [ext3]
Feb 28 01:17:37 fantasio kernel:  [try_to_release_page+48/67] try_to_release_page+0x30/0x43
Feb 28 01:17:37 fantasio kernel:  [shrink_page_list+597/803] shrink_page_list+0x255/0x323
Feb 28 01:17:37 fantasio kernel:  [shrink_inactive_list+126/421] shrink_inactive_list+0x7e/0x1a5
Feb 28 01:17:37 fantasio kernel:  [shrink_zone+182/215] shrink_zone+0xb6/0xd7
Feb 28 01:17:37 fantasio kernel:  [balance_pgdat+496/817] balance_pgdat+0x1f0/0x331
Feb 28 01:17:37 fantasio kernel:  [kswapd+217/219] kswapd+0xd9/0xdb
Feb 28 01:17:37 fantasio kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Feb 28 01:17:37 fantasio kernel:  [__wake_up_common+53/79] __wake_up_common+0x35/0x4f
Feb 28 01:17:37 fantasio kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Feb 28 01:17:37 fantasio kernel:  [kswapd+0/219] kswapd+0x0/0xdb
Feb 28 01:17:37 fantasio kernel:  [kthread+114/151] kthread+0x72/0x97
Feb 28 01:17:37 fantasio kernel:  [kthread+0/151] kthread+0x0/0x97
Feb 28 01:17:37 fantasio kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Feb 28 01:17:37 fantasio kernel:  =======================
Feb 28 01:17:37 fantasio kernel: Code: 8f 89 d7 31 d2 0f ba 2b 0e 89 7b 20 89 1f ff 43 30 ff 47 04 85 d2 74 07 89 d0 e8 5b ff ff ff 8b 43 20 83 c4 18 5b 5e 5f c3 89 c1 <8b> 00 31 d2 f6 c4 40 74
 06 8b 51 20 ff 42 04 89 d0 c3 56 53 89 
Feb 28 01:17:37 fantasio kernel: EIP: [pg0+546367310/1070162944] journal_grab_journal_head+0x2/0x14 [jbd] SS:ESP 0068:c14bbdc8


----------------------------------------------------------------------
or
----------------------------------------------------------------------


Mar  1 00:15:40 fantasio kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000029
Mar  1 00:15:40 fantasio kernel:  printing eip:
Mar  1 00:15:40 fantasio kernel: e0bd074e
Mar  1 00:15:40 fantasio kernel: *pde = 00000000
Mar  1 00:15:40 fantasio kernel: Oops: 0000 [#1]
Mar  1 00:15:40 fantasio kernel: Modules linked in: cbc blkcipher binfmt_misc bnep rfcomm l2cap nfs nfsd exportfs lockd sunrpc ip_tables bridge llc cryptoloop loop sha256 aes it87 hwmon_vid i2c
_isa i2c_core md5 ipv6 af_packet radeon drm dm_crypt dm_mod snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart analog snd_rawmidi gam
eport via_agp prism54 snd agpgart firmware_class soundcore 8250_pnp 8250 serial_core evdev rtc sd_mod ext3 jbd mbcache raid1 raid0 multipath linear md_mod ide_cd cdrom ide_disk usbhid usb_stora
ge via_rhine mii via82cxxx ehci_hcd uhci_hcd ide_core usbcore sym53c8xx scsi_transport_spi scsi_mod unix
Mar  1 00:15:40 fantasio kernel: CPU:    0
Mar  1 00:15:40 fantasio kernel: EIP:    0060:[pg0+545687374/1070162944]    Not tainted VLI
Mar  1 00:15:40 fantasio kernel: EFLAGS: 00010213   (2.6.20-rc1-f238085415c56618e042252894f2fcc971add645 #3)
Mar  1 00:15:40 fantasio kernel: EIP is at journal_grab_journal_head+0x2/0x14 [jbd]
Mar  1 00:15:40 fantasio kernel: eax: 00000029   ebx: 00000029   ecx: 00000029   edx: 00000000
Mar  1 00:15:40 fantasio kernel: esi: 00000000   edi: c10eae80   ebp: c4b676ec   esp: c14bbdc8
Mar  1 00:15:40 fantasio kernel: ds: 007b   es: 007b   ss: 0068
Mar  1 00:15:40 fantasio kernel: Process kswapd0 (pid: 136, ti=c14ba000 task=df637a70 task.ti=c14ba000)
Mar  1 00:15:40 fantasio kernel: Stack: e0bcc534 c10cd940 c110f480 c11ecc00 c10b9be0 c10bec60 00000000 df065c60 
Mar  1 00:15:40 fantasio kernel:        e0bfd57f 000000d0 cf3e383c c14bbe8c c0131325 c10eae80 c14bbf3c c01358da 
Mar  1 00:15:40 fantasio kernel:        00000001 00000001 0000001c 00000000 c14bbf3c c14bbe1c c14bbe1c 00000000 
Mar  1 00:15:40 fantasio kernel: Call Trace:
Mar  1 00:15:40 fantasio kernel:  [pg0+545670452/1070162944] journal_try_to_free_buffers+0x62/0x9f [jbd]
Mar  1 00:15:40 fantasio kernel:  [pg0+545871231/1070162944] ext3_releasepage+0x0/0x72 [ext3]
Mar  1 00:15:40 fantasio kernel:  [try_to_release_page+48/67] try_to_release_page+0x30/0x43
Mar  1 00:15:40 fantasio kernel:  [shrink_page_list+597/803] shrink_page_list+0x255/0x323
Mar  1 00:15:40 fantasio kernel:  [shrink_inactive_list+126/421] shrink_inactive_list+0x7e/0x1a5
Mar  1 00:15:40 fantasio kernel:  [shrink_zone+182/215] shrink_zone+0xb6/0xd7
Mar  1 00:15:40 fantasio kernel:  [balance_pgdat+496/817] balance_pgdat+0x1f0/0x331
Mar  1 00:15:40 fantasio kernel:  [kswapd+217/219] kswapd+0xd9/0xdb
Mar  1 00:15:40 fantasio kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Mar  1 00:15:40 fantasio kernel:  [__wake_up_common+53/79] __wake_up_common+0x35/0x4f
Mar  1 00:15:40 fantasio kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Mar  1 00:15:40 fantasio kernel:  [kswapd+0/219] kswapd+0x0/0xdb
Mar  1 00:15:40 fantasio kernel:  [kthread+114/151] kthread+0x72/0x97
Mar  1 00:15:40 fantasio kernel:  [kthread+0/151] kthread+0x0/0x97
Mar  1 00:15:40 fantasio kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Mar  1 00:15:40 fantasio kernel:  =======================
Mar  1 00:15:40 fantasio kernel: Code: 8f 89 d7 31 d2 0f ba 2b 0e 89 7b 20 89 1f ff 43 30 ff 47 04 85 d2 74 07 89 d0 e8 5b ff ff ff 8b 43 20 83 c4 18 5b 5e 5f c3 89 c1 <8b> 00 31 d2 f6 c4 40 74
 06 8b 51 20 ff 42 04 89 d0 c3 56 53 89 
Mar  1 00:15:40 fantasio kernel: EIP: [pg0+545687374/1070162944] journal_grab_journal_head+0x2/0x14 [jbd] SS:ESP 0068:c14bbdc8

----------------------------------------------------------------------
or
----------------------------------------------------------------------

Feb 19 16:09:34 fantasio kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000029
Feb 19 16:09:34 fantasio kernel:  printing eip:
Feb 19 16:09:34 fantasio kernel: e0c40766
Feb 19 16:09:34 fantasio kernel: *pde = 00000000
Feb 19 16:09:34 fantasio kernel: Oops: 0000 [#1]
Feb 19 16:09:34 fantasio kernel: Modules linked in: nls_iso8859_1 nls_cp437 vfat fat cbc blkcipher binfmt_misc bnep rfcomm l2cap nfs nfsd exportfs lockd sunrpc ip_tables bridge llc cryptoloop l
oop sha256 aes it87 hwmon_vid i2c_isa i2c_core md5 ipv6 af_packet radeon drm dm_crypt dm_mod snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_m
pu401_uart snd_rawmidi analog 8250_pnp 8250 serial_core snd prism54 via_agp soundcore gameport agpgart firmware_class sd_mod evdev rtc ext3 jbd mbcache raid1 raid0 multipath linear md_mod ide_c
d cdrom ide_disk usbhid usb_storage via_rhine mii ehci_hcd via82cxxx ide_core uhci_hcd usbcore sym53c8xx scsi_transport_spi scsi_mod unix
Feb 19 16:09:34 fantasio kernel: CPU:    0
Feb 19 16:09:34 fantasio kernel: EIP:    0060:[pg0+546137958/1070154752]    Not tainted VLI
Feb 19 16:09:34 fantasio kernel: EFLAGS: 00010213   (2.6.20 #1)
Feb 19 16:09:34 fantasio kernel: EIP is at journal_grab_journal_head+0x2/0x14 [jbd]
Feb 19 16:09:34 fantasio kernel: eax: 00000029   ebx: 00000029   ecx: 00000029   edx: 00000000
Feb 19 16:09:34 fantasio kernel: esi: 00000000   edi: c11939e0   ebp: cf0af6ec   esp: c14f3dc8
Feb 19 16:09:34 fantasio kernel: ds: 007b   es: 007b   ss: 0068
Feb 19 16:09:34 fantasio kernel: Process kswapd0 (pid: 135, ti=c14f2000 task=dfc04550 task.ti=c14f2000)
Feb 19 16:09:34 fantasio kernel: Stack: e0c3c534 c1044660 c1087600 c1390200 c10616a0 dd70e54c 00000000 de818c60 
Feb 19 16:09:34 fantasio kernel:        e0c6d57f 000000d0 dd70e54c c14f3e8c c0130fc1 c11939e0 c14f3f3c c013550a 
Feb 19 16:09:34 fantasio kernel:        00000001 00000001 00000018 00000000 c14f3f3c c14f3e1c c14f3e1c 0000000a 
Feb 19 16:09:34 fantasio kernel: Call Trace:
Feb 19 16:09:34 fantasio kernel:  [pg0+546121012/1070154752] journal_try_to_free_buffers+0x62/0x9f [jbd]
Feb 19 16:09:34 fantasio kernel:  [pg0+546321791/1070154752] ext3_releasepage+0x0/0x72 [ext3]
Feb 19 16:09:34 fantasio kernel:  [try_to_release_page+48/67] try_to_release_page+0x30/0x43
Feb 19 16:09:34 fantasio kernel:  [shrink_page_list+597/803] shrink_page_list+0x255/0x323
Feb 19 16:09:34 fantasio kernel:  [shrink_inactive_list+126/439] shrink_inactive_list+0x7e/0x1b7
Feb 19 16:09:34 fantasio kernel:  [shrink_zone+182/215] shrink_zone+0xb6/0xd7
Feb 19 16:09:34 fantasio kernel:  [balance_pgdat+496/817] balance_pgdat+0x1f0/0x331
Feb 19 16:09:34 fantasio kernel:  [kswapd+217/219] kswapd+0xd9/0xdb
Feb 19 16:09:34 fantasio kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Feb 19 16:09:34 fantasio kernel:  [__wake_up_common+53/79] __wake_up_common+0x35/0x4f
Feb 19 16:09:34 fantasio kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Feb 19 16:09:34 fantasio kernel:  [kswapd+0/219] kswapd+0x0/0xdb
Feb 19 16:09:35 fantasio kernel:  [kthread+114/151] kthread+0x72/0x97
Feb 19 16:09:35 fantasio kernel:  [kthread+0/151] kthread+0x0/0x97
Feb 19 16:09:35 fantasio kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Feb 19 16:09:35 fantasio kernel:  =======================

----------------------------------------------------------------------
or
----------------------------------------------------------------------



Feb 25 10:16:24 fantasio kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 0000002d
Feb 25 10:16:24 fantasio kernel:  printing eip:
Feb 25 10:16:24 fantasio kernel: e0c55b16
Feb 25 10:16:24 fantasio kernel: *pde = 00000000
Feb 25 10:16:24 fantasio kernel: Oops: 0000 [#1]
Feb 25 10:16:24 fantasio kernel: Modules linked in: isofs cbc blkcipher binfmt_misc bnep rfcomm l2cap nfs nfsd exportfs lockd sunrpc ip_tables bridge llc cryptoloop loop sha256 aes it87 hwmon_v
id i2c_isa i2c_core md5 ipv6 af_packet radeon drm dm_crypt dm_mod snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd 
prism54 analog soundcore firmware_class 8250_pnp 8250 serial_core via_agp agpgart evdev gameport rtc sd_mod ext3 jbd mbcache raid1 raid0 multipath linear md_mod ide_cd cdrom ide_disk usbhid usb
_storage via82cxxx ide_core via_rhine mii ehci_hcd uhci_hcd usbcore sym53c8xx scsi_transport_spi scsi_mod unix
Feb 25 10:16:24 fantasio kernel: CPU:    0
Feb 25 10:16:24 fantasio kernel: EIP:    0060:[pg0+546224918/1070154752]    Not tainted VLI
Feb 25 10:16:24 fantasio kernel: EFLAGS: 00010202   (2.6.20 #1)
Feb 25 10:16:24 fantasio kernel: EIP is at walk_page_buffers+0x1e/0x87 [ext3]
Feb 25 10:16:24 fantasio kernel: eax: ccbab601   ebx: 00002000   ecx: 00000029   edx: ccbab601
Feb 25 10:16:24 fantasio kernel: esi: 00002000   edi: ccbab6ec   ebp: 00000000   esp: c14f5dbc
Feb 25 10:16:24 fantasio kernel: ds: 007b   es: 007b   ss: 0068
Feb 25 10:16:24 fantasio kernel: Process pdflush (pid: 134, ti=c14f4000 task=dfc04a70 task.ti=c14f4000)
Feb 25 10:16:24 fantasio kernel: Stack: 00000029 00001000 00000000 df25e720 c12255a0 ccbab6ec df25e720 df25e720 
Feb 25 10:16:24 fantasio kernel:        e0c5629b 00001000 00000000 e0c561b1 c14f5e38 0000000e c14f5f58 00000000 
Feb 25 10:16:24 fantasio kernel:        c12255a0 0000000e c14f5f58 c0133584 00000000 0000000e 00000000 00000001 
Feb 25 10:16:24 fantasio kernel: Call Trace:
Feb 25 10:16:24 fantasio kernel:  [pg0+546226843/1070154752] ext3_ordered_writepage+0xcc/0x158 [ext3]
Feb 25 10:16:24 fantasio kernel:  [pg0+546226609/1070154752] bget_one+0x0/0x6 [ext3]
Feb 25 10:16:24 fantasio kernel:  [generic_writepages+380/690] generic_writepages+0x17c/0x2b2
Feb 25 10:16:24 fantasio kernel:  [pg0+546226639/1070154752] ext3_ordered_writepage+0x0/0x158 [ext3]
Feb 25 10:16:24 fantasio kernel:  [do_writepages+41/48] do_writepages+0x29/0x30
Feb 25 10:16:24 fantasio kernel:  [__sync_single_inode+81/406] __sync_single_inode+0x51/0x196
Feb 25 10:16:24 fantasio kernel:  [__writeback_single_inode+312/320] __writeback_single_inode+0x138/0x140
Feb 25 10:16:24 fantasio kernel:  [schedule_timeout+121/141] schedule_timeout+0x79/0x8d
Feb 25 10:16:24 fantasio kernel:  [process_timeout+0/5] process_timeout+0x0/0x5
Feb 25 10:16:24 fantasio kernel:  [congestion_wait+107/117] congestion_wait+0x6b/0x75
Feb 25 10:16:24 fantasio kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Feb 25 10:16:24 fantasio kernel:  [sync_sb_inodes+361/511] sync_sb_inodes+0x169/0x1ff
Feb 25 10:16:24 fantasio kernel:  [writeback_inodes+67/100] writeback_inodes+0x43/0x64
Feb 25 10:16:24 fantasio kernel:  [pdflush+0/40] pdflush+0x0/0x28
Feb 25 10:16:24 fantasio kernel:  [background_writeout+88/137] background_writeout+0x58/0x89
Feb 25 10:16:24 fantasio kernel:  [pdflush+0/40] pdflush+0x0/0x28
Feb 25 10:16:24 fantasio kernel:  [__pdflush+179/309] __pdflush+0xb3/0x135
Feb 25 10:16:24 fantasio kernel:  [pdflush+36/40] pdflush+0x24/0x28
Feb 25 10:16:24 fantasio kernel:  [background_writeout+0/137] background_writeout+0x0/0x89
Feb 25 10:16:24 fantasio kernel:  [pdflush+0/40] pdflush+0x0/0x28
Feb 25 10:16:24 fantasio kernel:  [kthread+114/151] kthread+0x72/0x97
Feb 25 10:16:24 fantasio kernel:  [kthread+0/151] kthread+0x0/0x97
Feb 25 10:16:24 fantasio kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Feb 25 10:16:24 fantasio kernel:  =======================
Feb 25 10:16:24 fantasio kernel: Code: 06 fb ff ff ff 83 c4 0c 89 c8 5b 5e c3 55 31 ed 57 89 d7 56 31 f6 53 83 ec 10 89 4c 24 08 89 44 24 0c 89 d1 8b 42 10 89 44 24 04 <8b> 41 04 89 04 24 8b 44
 24 04 8d 1c 06 3b 5c 24 08 0f 96 c2 3b 
Feb 25 10:16:24 fantasio kernel: EIP: [pg0+546224918/1070154752] walk_page_buffers+0x1e/0x87 [ext3] SS:ESP 0068:c14f5dbc
