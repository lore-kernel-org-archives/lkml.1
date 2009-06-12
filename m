Return-Path: <linux-kernel-owner+w=401wt.eu-S934437AbZFLWRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbZFLWRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbZFLWRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:17:12 -0400
Received: from [212.98.175.89] ([212.98.175.89]:33684 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759659AbZFLWRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:17:08 -0400
Date: Sat, 13 Jun 2009 01:18:19 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: BUG: scheduling while atomic: pptpgw (with attachment)
Message-ID: <20090612221819.GB3888@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Alan.

Sorry, forgot about attachment.

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

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=syslog_bug

[ 8506.042498] BUG: scheduling while atomic: pptpgw/3167/0x00000400
[ 8506.042504] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse sbp2 loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore pcspkr i2c_i801 rng_core snd_page_alloc psmouse asus_laptop serio_raw evdev led_class usbhid hid sg sd_mod sr_mod cdrom ata_generic pata_acpi ata_piix ide_pci_generic ohci1394 ieee1394 r8169 mii uhci_hcd ehci_hcd usbcore
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
[ 8885.673899] make invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8885.673912] make cpuset=/ mems_allowed=0
[ 8885.673921] Pid: 10957, comm: make Tainted: G        W  2.6.30-nv-git3 #7
[ 8885.673927] Call Trace:
[ 8885.673944]  [<c10b6384>] T.392+0xc4/0x250
[ 8885.673954]  [<c10b61b5>] ? badness+0x135/0x240
[ 8885.673965]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8885.673975]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8885.673985]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8885.673996]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8885.674007]  [<c103daea>] copy_process+0xca/0x1090
[ 8885.674017]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8885.674027]  [<c100b958>] sys_vfork+0x38/0x50
[ 8885.674036]  [<c10032d8>] syscall_call+0x7/0xb
[ 8885.674042] Mem-Info:
[ 8885.674047] DMA per-cpu:
[ 8885.674053] CPU    0: hi:    0, btch:   1 usd:   0
[ 8885.674059] CPU    1: hi:    0, btch:   1 usd:   0
[ 8885.674064] Normal per-cpu:
[ 8885.674070] CPU    0: hi:  186, btch:  31 usd:   0
[ 8885.674076] CPU    1: hi:  186, btch:  31 usd:   0
[ 8885.674081] HighMem per-cpu:
[ 8885.674087] CPU    0: hi:   42, btch:   7 usd:   0
[ 8885.674093] CPU    1: hi:   42, btch:   7 usd:   0
[ 8885.674102] Active_anon:7322 active_file:8880 inactive_anon:9533
[ 8885.674105]  inactive_file:6083 unevictable:0 dirty:5 writeback:0 unstable:0
[ 8885.674109]  free:73824 slab:102205 mapped:8845 pagetables:561 bounce:0
[ 8885.674120] DMA free:3520kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:12kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8885.674129] lowmem_reserve[]: 0 865 999 999
[ 8885.674145] Normal free:269068kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:56kB active_file:7112kB inactive_file:7076kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8885.674154] lowmem_reserve[]: 0 0 1076 1076
[ 8885.674170] HighMem free:22708kB min:132kB low:276kB high:420kB active_anon:29256kB inactive_anon:38064kB active_file:28408kB inactive_file:17256kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8885.674178] lowmem_reserve[]: 0 0 0 0
[ 8885.674189] DMA: 6*4kB 395*8kB 21*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3520kB
[ 8885.674216] Normal: 66712*4kB 55*8kB 0*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 269112kB
[ 8885.674243] HighMem: 1126*4kB 1333*8kB 278*16kB 50*32kB 18*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 22752kB
[ 8885.674271] 15997 total pagecache pages
[ 8885.674276] 777 pages in swap cache
[ 8885.674282] Swap cache stats: add 13528, delete 12751, find 702/875
[ 8885.674287] Free swap  = 826996kB
[ 8885.674291] Total swap = 875500kB
[ 8885.679660] 262040 pages RAM
[ 8885.679665] 34730 pages HighMem
[ 8885.679670] 3930 pages reserved
[ 8885.679674] 53968 pages shared
[ 8885.679678] 134773 pages non-shared
[ 8885.679686] Out of memory: kill process 3212 (kopete) score 17744 or a child
[ 8885.679726] Killed process 3212 (kopete)
[ 8886.099540] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8886.099552] sh cpuset=/ mems_allowed=0
[ 8886.099561] Pid: 11238, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8886.099567] Call Trace:
[ 8886.099585]  [<c10b6384>] T.392+0xc4/0x250
[ 8886.099595]  [<c10b61b5>] ? badness+0x135/0x240
[ 8886.099605]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8886.099615]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8886.099625]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8886.099635]  [<c10b2c92>] ? find_lock_page+0x32/0x80
[ 8886.099645]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8886.099657]  [<c103daea>] copy_process+0xca/0x1090
[ 8886.099667]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8886.099677]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8886.099685]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8886.099691] Mem-Info:
[ 8886.099695] DMA per-cpu:
[ 8886.099702] CPU    0: hi:    0, btch:   1 usd:   0
[ 8886.099708] CPU    1: hi:    0, btch:   1 usd:   0
[ 8886.099712] Normal per-cpu:
[ 8886.099718] CPU    0: hi:  186, btch:  31 usd:   0
[ 8886.099724] CPU    1: hi:  186, btch:  31 usd:   0
[ 8886.099729] HighMem per-cpu:
[ 8886.099734] CPU    0: hi:   42, btch:   7 usd:   0
[ 8886.099740] CPU    1: hi:   42, btch:   7 usd:   0
[ 8886.099750] Active_anon:7236 active_file:8390 inactive_anon:9242
[ 8886.099753]  inactive_file:5579 unevictable:0 dirty:6 writeback:0 unstable:0
[ 8886.099756]  free:75175 slab:102250 mapped:8347 pagetables:545 bounce:0
[ 8886.099767] DMA free:3520kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:12kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8886.099775] lowmem_reserve[]: 0 865 999 999
[ 8886.099791] Normal free:268984kB min:3728kB low:4660kB high:5592kB active_anon:88kB inactive_anon:0kB active_file:7320kB inactive_file:6820kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8886.099800] lowmem_reserve[]: 0 0 1076 1076
[ 8886.099815] HighMem free:28196kB min:132kB low:276kB high:420kB active_anon:28856kB inactive_anon:36956kB active_file:26240kB inactive_file:15496kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8886.099824] lowmem_reserve[]: 0 0 0 0
[ 8886.099834] DMA: 6*4kB 395*8kB 21*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3520kB
[ 8886.099861] Normal: 66682*4kB 62*8kB 0*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 269048kB
[ 8886.099888] HighMem: 1653*4kB 1396*8kB 324*16kB 74*32kB 27*64kB 7*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28212kB
[ 8886.099916] 14790 total pagecache pages
[ 8886.099921] 585 pages in swap cache
[ 8886.099927] Swap cache stats: add 13573, delete 12988, find 706/885
[ 8886.099932] Free swap  = 831532kB
[ 8886.099937] Total swap = 875500kB
[ 8886.105259] 262040 pages RAM
[ 8886.105265] 34730 pages HighMem
[ 8886.105270] 3930 pages reserved
[ 8886.105274] 50974 pages shared
[ 8886.105278] 134068 pages non-shared
[ 8886.105286] Out of memory: kill process 3020 (kdesktop) score 11317 or a child
[ 8886.105327] Killed process 31277 (kdesktop_lock)
[ 8888.355567] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8888.355579] sh cpuset=/ mems_allowed=0
[ 8888.355588] Pid: 31659, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8888.355594] Call Trace:
[ 8888.355612]  [<c10b6384>] T.392+0xc4/0x250
[ 8888.355621]  [<c10b61b5>] ? badness+0x135/0x240
[ 8888.355632]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8888.355642]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8888.355652]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8888.355663]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8888.355675]  [<c103daea>] copy_process+0xca/0x1090
[ 8888.355685]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8888.355695]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8888.355704]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 8888.355713]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8888.355721]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8888.355727] Mem-Info:
[ 8888.355732] DMA per-cpu:
[ 8888.355739] CPU    0: hi:    0, btch:   1 usd:   0
[ 8888.355745] CPU    1: hi:    0, btch:   1 usd:   0
[ 8888.355749] Normal per-cpu:
[ 8888.355755] CPU    0: hi:  186, btch:  31 usd:   0
[ 8888.355761] CPU    1: hi:  186, btch:  31 usd:   0
[ 8888.355766] HighMem per-cpu:
[ 8888.355772] CPU    0: hi:   42, btch:   7 usd:   0
[ 8888.355777] CPU    1: hi:   42, btch:   7 usd:   0
[ 8888.355809] Active_anon:6543 active_file:8305 inactive_anon:9708
[ 8888.355812]  inactive_file:5588 unevictable:0 dirty:8 writeback:3 unstable:0
[ 8888.355816]  free:75386 slab:102324 mapped:7870 pagetables:530 bounce:0
[ 8888.355827] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8888.355835] lowmem_reserve[]: 0 865 999 999
[ 8888.355886] Normal free:268632kB min:3728kB low:4660kB high:5592kB active_anon:56kB inactive_anon:0kB active_file:7068kB inactive_file:7068kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8888.355894] lowmem_reserve[]: 0 0 1076 1076
[ 8888.355910] HighMem free:29404kB min:132kB low:276kB high:420kB active_anon:26116kB inactive_anon:38832kB active_file:26152kB inactive_file:15284kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8888.355919] lowmem_reserve[]: 0 0 0 0
[ 8888.355929] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8888.355957] Normal: 66698*4kB 14*8kB 0*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268728kB
[ 8888.355984] HighMem: 1544*4kB 1476*8kB 352*16kB 81*32kB 30*64kB 8*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 29408kB
[ 8888.356011] 15032 total pagecache pages
[ 8888.356016] 908 pages in swap cache
[ 8888.356022] Swap cache stats: add 14045, delete 13137, find 786/1026
[ 8888.356027] Free swap  = 832160kB
[ 8888.356032] Total swap = 875500kB
[ 8888.361346] 262040 pages RAM
[ 8888.361353] 34730 pages HighMem
[ 8888.361357] 3930 pages reserved
[ 8888.361361] 47933 pages shared
[ 8888.361365] 134297 pages non-shared
[ 8888.361374] Out of memory: kill process 3022 (kicker) score 8870 or a child
[ 8888.361413] Killed process 3022 (kicker)
[ 8891.400532] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8891.400544] sh cpuset=/ mems_allowed=0
[ 8891.400554] Pid: 31659, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8891.400560] Call Trace:
[ 8891.400577]  [<c10b6384>] T.392+0xc4/0x250
[ 8891.400587]  [<c10b61b5>] ? badness+0x135/0x240
[ 8891.400597]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8891.400607]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8891.400617]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8891.400629]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8891.400640]  [<c103daea>] copy_process+0xca/0x1090
[ 8891.400650]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8891.400660]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8891.400669]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 8891.400678]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8891.400686]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8891.400692] Mem-Info:
[ 8891.400697] DMA per-cpu:
[ 8891.400704] CPU    0: hi:    0, btch:   1 usd:   0
[ 8891.400710] CPU    1: hi:    0, btch:   1 usd:   0
[ 8891.400715] Normal per-cpu:
[ 8891.400721] CPU    0: hi:  186, btch:  31 usd:   0
[ 8891.400727] CPU    1: hi:  186, btch:  31 usd:   0
[ 8891.400732] HighMem per-cpu:
[ 8891.400737] CPU    0: hi:   42, btch:   7 usd:   0
[ 8891.400743] CPU    1: hi:   42, btch:   7 usd:   0
[ 8891.400753] Active_anon:6182 active_file:8005 inactive_anon:9899
[ 8891.400756]  inactive_file:5657 unevictable:0 dirty:6 writeback:0 unstable:0
[ 8891.400760]  free:75731 slab:102392 mapped:7438 pagetables:520 bounce:0
[ 8891.400771] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8891.400779] lowmem_reserve[]: 0 865 999 999
[ 8891.400795] Normal free:268432kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:24kB active_file:7320kB inactive_file:6852kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8891.400804] lowmem_reserve[]: 0 0 1076 1076
[ 8891.400820] HighMem free:30984kB min:132kB low:276kB high:420kB active_anon:24696kB inactive_anon:39572kB active_file:24700kB inactive_file:15776kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8891.400828] lowmem_reserve[]: 0 0 0 0
[ 8891.400838] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8891.400866] Normal: 66662*4kB 3*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268480kB
[ 8891.400893] HighMem: 977*4kB 1568*8kB 423*16kB 109*32kB 39*64kB 10*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 30996kB
[ 8891.400922] 15195 total pagecache pages
[ 8891.400927] 1291 pages in swap cache
[ 8891.400933] Swap cache stats: add 14614, delete 13323, find 956/1269
[ 8891.400938] Free swap  = 833120kB
[ 8891.400943] Total swap = 875500kB
[ 8891.406419] 262040 pages RAM
[ 8891.406426] 34730 pages HighMem
[ 8891.406430] 3930 pages reserved
[ 8891.406435] 45001 pages shared
[ 8891.406439] 134262 pages non-shared
[ 8891.406447] Out of memory: kill process 3009 (kded) score 8769 or a child
[ 8891.406486] Killed process 3009 (kded)
[ 8892.137138] openbox invoked oom-killer: gfp_mask=0x4d0, order=2, oomkilladj=0
[ 8892.137150] openbox cpuset=/ mems_allowed=0
[ 8892.137160] Pid: 3017, comm: openbox Tainted: G        W  2.6.30-nv-git3 #7
[ 8892.137166] Call Trace:
[ 8892.137183]  [<c10b6384>] T.392+0xc4/0x250
[ 8892.137193]  [<c10b61b5>] ? badness+0x135/0x240
[ 8892.137204]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8892.137214]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8892.137224]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8892.137236]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 8892.137246]  [<c10e07e7>] __kmalloc+0x147/0x170
[ 8892.137258]  [<c134c131>] __alloc_skb+0x51/0x120
[ 8892.137267]  [<c1346c26>] sock_alloc_send_pskb+0x176/0x290
[ 8892.137278]  [<c122dca1>] ? copy_from_user+0x41/0x150
[ 8892.137287]  [<c1346d64>] sock_alloc_send_skb+0x24/0x40
[ 8892.137298]  [<c13c6d42>] unix_stream_sendmsg+0x2c2/0x360
[ 8892.137307]  [<c134af34>] ? __kfree_skb+0x64/0xd0
[ 8892.137317]  [<c1342883>] sock_aio_write+0x133/0x150
[ 8892.137328]  [<c10e4bc0>] do_sync_readv_writev+0xe0/0x130
[ 8892.137337]  [<c1342750>] ? sock_aio_write+0x0/0x150
[ 8892.137348]  [<c105a7e0>] ? autoremove_wake_function+0x0/0x60
[ 8892.137358]  [<c10e4eff>] ? rw_verify_area+0x6f/0xf0
[ 8892.137367]  [<c10e49f8>] ? rw_copy_check_uvector+0x98/0x120
[ 8892.137376]  [<c10e54a3>] do_readv_writev+0xb3/0x1e0
[ 8892.137384]  [<c1342750>] ? sock_aio_write+0x0/0x150
[ 8892.137394]  [<c10cc81e>] ? handle_mm_fault+0x38e/0x5e0
[ 8892.137404]  [<c10e5632>] vfs_writev+0x62/0x80
[ 8892.137412]  [<c10e5788>] sys_writev+0x58/0xd0
[ 8892.137422]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8892.137428] Mem-Info:
[ 8892.137433] DMA per-cpu:
[ 8892.137439] CPU    0: hi:    0, btch:   1 usd:   0
[ 8892.137512] CPU    1: hi:    0, btch:   1 usd:   0
[ 8892.137517] Normal per-cpu:
[ 8892.137523] CPU    0: hi:  186, btch:  31 usd:   0
[ 8892.137530] CPU    1: hi:  186, btch:  31 usd:   0
[ 8892.137534] HighMem per-cpu:
[ 8892.137540] CPU    0: hi:   42, btch:   7 usd:   0
[ 8892.137546] CPU    1: hi:   42, btch:   7 usd:   0
[ 8892.137556] Active_anon:5969 active_file:7992 inactive_anon:9640
[ 8892.137559]  inactive_file:5868 unevictable:0 dirty:5 writeback:6 unstable:0
[ 8892.137562]  free:76032 slab:102364 mapped:7024 pagetables:503 bounce:0
[ 8892.137573] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8892.137581] lowmem_reserve[]: 0 865 999 999
[ 8892.137598] Normal free:268612kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:24kB active_file:7128kB inactive_file:7012kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8892.137606] lowmem_reserve[]: 0 0 1076 1076
[ 8892.137622] HighMem free:32008kB min:132kB low:276kB high:420kB active_anon:23844kB inactive_anon:38536kB active_file:24840kB inactive_file:16460kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8892.137631] lowmem_reserve[]: 0 0 0 0
[ 8892.137641] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8892.137668] Normal: 66678*4kB 20*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268680kB
[ 8892.137696] HighMem: 964*4kB 1596*8kB 435*16kB 119*32kB 41*64kB 12*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 32064kB
[ 8892.137724] 15313 total pagecache pages
[ 8892.137729] 1221 pages in swap cache
[ 8892.137735] Swap cache stats: add 14651, delete 13430, find 988/1306
[ 8892.137740] Free swap  = 834044kB
[ 8892.137745] Total swap = 875500kB
[ 8892.143102] 262040 pages RAM
[ 8892.143109] 34730 pages HighMem
[ 8892.143114] 3930 pages reserved
[ 8892.143118] 42000 pages shared
[ 8892.143122] 134406 pages non-shared
[ 8892.143131] Out of memory: kill process 3044 (kmix) score 7798 or a child
[ 8892.143170] Killed process 3044 (kmix)
[ 8892.391306] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8892.391318] sh cpuset=/ mems_allowed=0
[ 8892.391327] Pid: 31659, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8892.391334] Call Trace:
[ 8892.391352]  [<c10b6384>] T.392+0xc4/0x250
[ 8892.391362]  [<c10b61b5>] ? badness+0x135/0x240
[ 8892.391372]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8892.391382]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8892.391392]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8892.391404]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 8892.391414]  [<c10e091f>] kmem_cache_alloc+0x10f/0x120
[ 8892.391426]  [<c103dad1>] copy_process+0xb1/0x1090
[ 8892.391436]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8892.391446]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8892.391455]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 8892.391464]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8892.391472]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8892.391478] Mem-Info:
[ 8892.391483] DMA per-cpu:
[ 8892.391490] CPU    0: hi:    0, btch:   1 usd:   0
[ 8892.391496] CPU    1: hi:    0, btch:   1 usd:   0
[ 8892.391500] Normal per-cpu:
[ 8892.391506] CPU    0: hi:  186, btch:  31 usd:   0
[ 8892.391512] CPU    1: hi:  186, btch:  31 usd:   0
[ 8892.391517] HighMem per-cpu:
[ 8892.391523] CPU    0: hi:   42, btch:   7 usd:   0
[ 8892.391529] CPU    1: hi:   42, btch:   7 usd:   0
[ 8892.391538] Active_anon:5449 active_file:8009 inactive_anon:9666
[ 8892.391541]  inactive_file:5858 unevictable:0 dirty:5 writeback:6 unstable:0
[ 8892.391545]  free:76500 slab:102364 mapped:6907 pagetables:478 bounce:0
[ 8892.391556] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8892.391564] lowmem_reserve[]: 0 865 999 999
[ 8892.391581] Normal free:268612kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:24kB active_file:7144kB inactive_file:6972kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8892.391589] lowmem_reserve[]: 0 0 1076 1076
[ 8892.391605] HighMem free:33880kB min:132kB low:276kB high:420kB active_anon:21764kB inactive_anon:38640kB active_file:24892kB inactive_file:16460kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8892.391613] lowmem_reserve[]: 0 0 0 0
[ 8892.391623] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8892.391651] Normal: 66680*4kB 24*8kB 1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268688kB
[ 8892.391679] HighMem: 1034*4kB 1637*8kB 460*16kB 128*32kB 46*64kB 14*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 33936kB
[ 8892.391707] 15339 total pagecache pages
[ 8892.391712] 1222 pages in swap cache
[ 8892.391719] Swap cache stats: add 14684, delete 13462, find 1015/1337
[ 8892.391724] Free swap  = 834168kB
[ 8892.391729] Total swap = 875500kB
[ 8892.397449] 262040 pages RAM
[ 8892.397457] 34730 pages HighMem
[ 8892.397461] 3930 pages reserved
[ 8892.397466] 39751 pages shared
[ 8892.397470] 134041 pages non-shared
[ 8892.397478] Out of memory: kill process 3048 (kpowersave) score 7778 or a child
[ 8892.397517] Killed process 3048 (kpowersave)
[ 8894.126349] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8894.126361] sh cpuset=/ mems_allowed=0
[ 8894.126370] Pid: 31659, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8894.126376] Call Trace:
[ 8894.126395]  [<c10b6384>] T.392+0xc4/0x250
[ 8894.126404]  [<c10b61b5>] ? badness+0x135/0x240
[ 8894.126415]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8894.126424]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8894.126434]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8894.126447]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 8894.126457]  [<c10e091f>] kmem_cache_alloc+0x10f/0x120
[ 8894.126468]  [<c103dad1>] copy_process+0xb1/0x1090
[ 8894.126478]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8894.126488]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8894.126497]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 8894.126506]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8894.126514]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8894.126520] Mem-Info:
[ 8894.126525] DMA per-cpu:
[ 8894.126532] CPU    0: hi:    0, btch:   1 usd:   0
[ 8894.126538] CPU    1: hi:    0, btch:   1 usd:   0
[ 8894.126542] Normal per-cpu:
[ 8894.126548] CPU    0: hi:  186, btch:  31 usd:   0
[ 8894.126555] CPU    1: hi:  186, btch:  31 usd:   0
[ 8894.126559] HighMem per-cpu:
[ 8894.126565] CPU    0: hi:   42, btch:   7 usd:   0
[ 8894.126571] CPU    1: hi:   42, btch:   7 usd:   0
[ 8894.126581] Active_anon:4617 active_file:7463 inactive_anon:10012
[ 8894.126584]  inactive_file:5967 unevictable:0 dirty:5 writeback:5 unstable:0
[ 8894.126588]  free:77437 slab:102423 mapped:6350 pagetables:473 bounce:0
[ 8894.126599] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8894.126607] lowmem_reserve[]: 0 865 999 999
[ 8894.126624] Normal free:268540kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:16kB active_file:6920kB inactive_file:7208kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8894.126632] lowmem_reserve[]: 0 0 1076 1076
[ 8894.126648] HighMem free:37700kB min:132kB low:276kB high:420kB active_anon:18436kB inactive_anon:40032kB active_file:22932kB inactive_file:16660kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8894.126657] lowmem_reserve[]: 0 0 0 0
[ 8894.126667] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8894.126695] Normal: 66673*4kB 15*8kB 1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268588kB
[ 8894.126722] HighMem: 831*4kB 1721*8kB 521*16kB 148*32kB 60*64kB 21*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 37716kB
[ 8894.126751] 15157 total pagecache pages
[ 8894.126756] 1497 pages in swap cache
[ 8894.126762] Swap cache stats: add 15037, delete 13540, find 1158/1526
[ 8894.126768] Free swap  = 834512kB
[ 8894.126772] Total swap = 875500kB
[ 8894.132241] 262040 pages RAM
[ 8894.132249] 34730 pages HighMem
[ 8894.132253] 3930 pages reserved
[ 8894.132258] 35413 pages shared
[ 8894.132262] 133562 pages non-shared
[ 8894.132271] Out of memory: kill process 3020 (kdesktop) score 7770 or a child
[ 8894.132309] Killed process 3020 (kdesktop)
[ 8894.483692] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8894.483703] sh cpuset=/ mems_allowed=0
[ 8894.483712] Pid: 31659, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8894.483719] Call Trace:
[ 8894.483737]  [<c10b6384>] T.392+0xc4/0x250
[ 8894.483747]  [<c10b61b5>] ? badness+0x135/0x240
[ 8894.483757]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8894.483766]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8894.483776]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8894.483788]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 8894.483799]  [<c10e091f>] kmem_cache_alloc+0x10f/0x120
[ 8894.483810]  [<c103dad1>] copy_process+0xb1/0x1090
[ 8894.483820]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8894.483831]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8894.483840]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 8894.483849]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8894.483857]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8894.483863] Mem-Info:
[ 8894.483868] DMA per-cpu:
[ 8894.483874] CPU    0: hi:    0, btch:   1 usd:   0
[ 8894.483881] CPU    1: hi:    0, btch:   1 usd:   0
[ 8894.483885] Normal per-cpu:
[ 8894.483891] CPU    0: hi:  186, btch:  31 usd:   0
[ 8894.483898] CPU    1: hi:  186, btch:  31 usd:   0
[ 8894.483902] HighMem per-cpu:
[ 8894.483908] CPU    0: hi:   42, btch:   7 usd:   0
[ 8894.483914] CPU    1: hi:   42, btch:   7 usd:   0
[ 8894.483924] Active_anon:4617 active_file:7472 inactive_anon:9778
[ 8894.483927]  inactive_file:5957 unevictable:0 dirty:5 writeback:5 unstable:0
[ 8894.483930]  free:77680 slab:102423 mapped:6038 pagetables:448 bounce:0
[ 8894.483941] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8894.483949] lowmem_reserve[]: 0 865 999 999
[ 8894.483966] Normal free:268540kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:16kB active_file:6904kB inactive_file:7220kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8894.483975] lowmem_reserve[]: 0 0 1076 1076
[ 8894.483990] HighMem free:38672kB min:132kB low:276kB high:420kB active_anon:18436kB inactive_anon:39096kB active_file:22984kB inactive_file:16608kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8894.483999] lowmem_reserve[]: 0 0 0 0
[ 8894.484009] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8894.484037] Normal: 66667*4kB 19*8kB 1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268596kB
[ 8894.484064] HighMem: 769*4kB 1744*8kB 540*16kB 157*32kB 65*64kB 22*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 38692kB
[ 8894.484092] 15209 total pagecache pages
[ 8894.484097] 1545 pages in swap cache
[ 8894.484104] Swap cache stats: add 15176, delete 13631, find 1238/1624
[ 8894.484109] Free swap  = 834876kB
[ 8894.484113] Total swap = 875500kB
[ 8894.489599] 262040 pages RAM
[ 8894.489607] 34730 pages HighMem
[ 8894.489611] 3930 pages reserved
[ 8894.489616] 33090 pages shared
[ 8894.489620] 133615 pages non-shared
[ 8894.489629] Out of memory: kill process 3033 (kxkb) score 7416 or a child
[ 8894.489668] Killed process 3033 (kxkb)
[ 8894.884173] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8894.884268] sh cpuset=/ mems_allowed=0
[ 8894.884278] Pid: 31659, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8894.884284] Call Trace:
[ 8894.884302]  [<c10b6384>] T.392+0xc4/0x250
[ 8894.884312]  [<c10b61b5>] ? badness+0x135/0x240
[ 8894.884322]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8894.884332]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8894.884342]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8894.884354]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 8894.884365]  [<c10e091f>] kmem_cache_alloc+0x10f/0x120
[ 8894.884376]  [<c103dad1>] copy_process+0xb1/0x1090
[ 8894.884386]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8894.884396]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8894.884405]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 8894.884414]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8894.884423]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8894.884429] Mem-Info:
[ 8894.884434] DMA per-cpu:
[ 8894.884440] CPU    0: hi:    0, btch:   1 usd:   0
[ 8894.884446] CPU    1: hi:    0, btch:   1 usd:   0
[ 8894.884451] Normal per-cpu:
[ 8894.884457] CPU    0: hi:  186, btch:  31 usd:   0
[ 8894.884463] CPU    1: hi:  186, btch:  31 usd:   0
[ 8894.884468] HighMem per-cpu:
[ 8894.884474] CPU    0: hi:   42, btch:   7 usd:   0
[ 8894.884480] CPU    1: hi:   42, btch:   7 usd:   0
[ 8894.884490] Active_anon:4266 active_file:7206 inactive_anon:9895
[ 8894.884493]  inactive_file:5874 unevictable:0 dirty:5 writeback:5 unstable:0
[ 8894.884496]  free:78247 slab:102423 mapped:5999 pagetables:448 bounce:0
[ 8894.884507] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8894.884515] lowmem_reserve[]: 0 865 999 999
[ 8894.884532] Normal free:268540kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:16kB active_file:6984kB inactive_file:7148kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8894.884540] lowmem_reserve[]: 0 0 1076 1076
[ 8894.884556] HighMem free:40940kB min:132kB low:276kB high:420kB active_anon:17032kB inactive_anon:39564kB active_file:21840kB inactive_file:16348kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8894.884565] lowmem_reserve[]: 0 0 0 0
[ 8894.884575] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8894.884603] Normal: 66676*4kB 17*8kB 1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268616kB
[ 8894.884631] HighMem: 880*4kB 1795*8kB 575*16kB 172*32kB 69*64kB 23*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 40968kB
[ 8894.884659] 14962 total pagecache pages
[ 8894.884663] 1647 pages in swap cache
[ 8894.884701] Swap cache stats: add 15296, delete 13649, find 1253/1654
[ 8894.884707] Free swap  = 834948kB
[ 8894.884712] Total swap = 875500kB
[ 8894.890066] 262040 pages RAM
[ 8894.890073] 34730 pages HighMem
[ 8894.890078] 3930 pages reserved
[ 8894.890082] 31119 pages shared
[ 8894.890087] 133063 pages non-shared
[ 8894.890095] Out of memory: kill process 3046 (klipper) score 7380 or a child
[ 8894.890134] Killed process 3046 (klipper)
[ 8895.119862] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8895.119874] sh cpuset=/ mems_allowed=0
[ 8895.119883] Pid: 31659, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8895.119889] Call Trace:
[ 8895.119907]  [<c10b6384>] T.392+0xc4/0x250
[ 8895.119917]  [<c10b61b5>] ? badness+0x135/0x240
[ 8895.119927]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8895.119937]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8895.119980]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8895.119992]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8895.120003]  [<c103daea>] copy_process+0xca/0x1090
[ 8895.120013]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8895.120024]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8895.120032]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 8895.120042]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8895.120050]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8895.120057] Mem-Info:
[ 8895.120061] DMA per-cpu:
[ 8895.120067] CPU    0: hi:    0, btch:   1 usd:   0
[ 8895.120074] CPU    1: hi:    0, btch:   1 usd:   0
[ 8895.120079] Normal per-cpu:
[ 8895.120085] CPU    0: hi:  186, btch:  31 usd:   0
[ 8895.120091] CPU    1: hi:  186, btch:  31 usd:   0
[ 8895.120095] HighMem per-cpu:
[ 8895.120101] CPU    0: hi:   42, btch:   7 usd:   0
[ 8895.120107] CPU    1: hi:   42, btch:   7 usd:   0
[ 8895.120116] Active_anon:4005 active_file:7182 inactive_anon:9893
[ 8895.120119]  inactive_file:5920 unevictable:0 dirty:5 writeback:17 unstable:0
[ 8895.120123]  free:78483 slab:102437 mapped:5679 pagetables:425 bounce:0
[ 8895.120134] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8895.120142] lowmem_reserve[]: 0 865 999 999
[ 8895.120159] Normal free:268524kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:16kB active_file:6864kB inactive_file:7284kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8895.120167] lowmem_reserve[]: 0 0 1076 1076
[ 8895.120183] HighMem free:41900kB min:132kB low:276kB high:420kB active_anon:15988kB inactive_anon:39556kB active_file:21864kB inactive_file:16396kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8895.120192] lowmem_reserve[]: 0 0 0 0
[ 8895.120202] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8895.120229] Normal: 66675*4kB 11*8kB 3*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268596kB
[ 8895.120256] HighMem: 894*4kB 1810*8kB 588*16kB 182*32kB 73*64kB 23*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 41928kB
[ 8895.120283] 14966 total pagecache pages
[ 8895.120288] 1637 pages in swap cache
[ 8895.120295] Swap cache stats: add 15310, delete 13673, find 1281/1684
[ 8895.120300] Free swap  = 835292kB
[ 8895.120304] Total swap = 875500kB
[ 8895.125626] 262040 pages RAM
[ 8895.125633] 34730 pages HighMem
[ 8895.125637] 3930 pages reserved
[ 8895.125641] 29138 pages shared
[ 8895.125645] 133111 pages non-shared
[ 8895.125654] Out of memory: kill process 3007 (klauncher) score 6720 or a child
[ 8895.125693] Killed process 3007 (klauncher)
[ 8900.165263] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8900.165275] sh cpuset=/ mems_allowed=0
[ 8900.165284] Pid: 11285, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8900.165290] Call Trace:
[ 8900.165308]  [<c10b6384>] T.392+0xc4/0x250
[ 8900.165317]  [<c10b61b5>] ? badness+0x135/0x240
[ 8900.165328]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8900.165338]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8900.165348]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8900.165357]  [<c10b2c92>] ? find_lock_page+0x32/0x80
[ 8900.165368]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8900.165379]  [<c103daea>] copy_process+0xca/0x1090
[ 8900.165389]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8900.165399]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8900.165408]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8900.165414] Mem-Info:
[ 8900.165418] DMA per-cpu:
[ 8900.165425] CPU    0: hi:    0, btch:   1 usd:   0
[ 8900.165431] CPU    1: hi:    0, btch:   1 usd:   0
[ 8900.165435] Normal per-cpu:
[ 8900.165441] CPU    0: hi:  186, btch:  31 usd:   0
[ 8900.165447] CPU    1: hi:  186, btch:  31 usd:   0
[ 8900.165452] HighMem per-cpu:
[ 8900.165458] CPU    0: hi:   42, btch:   7 usd:   0
[ 8900.165463] CPU    1: hi:   42, btch:   7 usd:   0
[ 8900.165473] Active_anon:4305 active_file:7128 inactive_anon:10116
[ 8900.165476]  inactive_file:5994 unevictable:0 dirty:5 writeback:0 unstable:0
[ 8900.165480]  free:77909 slab:102463 mapped:5675 pagetables:429 bounce:0
[ 8900.165491] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8900.165499] lowmem_reserve[]: 0 865 999 999
[ 8900.165515] Normal free:268424kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:8kB active_file:7028kB inactive_file:7052kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8900.165524] lowmem_reserve[]: 0 0 1076 1076
[ 8900.165540] HighMem free:39704kB min:132kB low:276kB high:420kB active_anon:17188kB inactive_anon:40456kB active_file:21484kB inactive_file:16924kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8900.165548] lowmem_reserve[]: 0 0 0 0
[ 8900.165559] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8900.165585] Normal: 66653*4kB 10*8kB 1*16kB 2*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268500kB
[ 8900.165612] HighMem: 215*4kB 1832*8kB 604*16kB 183*32kB 74*64kB 23*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 39740kB
[ 8900.165640] 15197 total pagecache pages
[ 8900.165644] 1830 pages in swap cache
[ 8900.165650] Swap cache stats: add 15619, delete 13789, find 1505/1948
[ 8900.165656] Free swap  = 835748kB
[ 8900.165660] Total swap = 875500kB
[ 8900.170991] 262040 pages RAM
[ 8900.170998] 34730 pages HighMem
[ 8900.171002] 3930 pages reserved
[ 8900.171006] 29687 pages shared
[ 8900.171011] 133506 pages non-shared
[ 8900.171019] Out of memory: kill process 3041 (kaccess) score 6708 or a child
[ 8900.171057] Killed process 3041 (kaccess)
[ 8903.220954] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8903.221054] sh cpuset=/ mems_allowed=0
[ 8903.221063] Pid: 31659, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8903.221070] Call Trace:
[ 8903.221087]  [<c10b6384>] T.392+0xc4/0x250
[ 8903.221097]  [<c10b61b5>] ? badness+0x135/0x240
[ 8903.221107]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8903.221117]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8903.221127]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8903.221139]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 8903.221149]  [<c10b9535>] ? __alloc_pages_internal+0xd5/0x4d0
[ 8903.221159]  [<c10e091f>] kmem_cache_alloc+0x10f/0x120
[ 8903.221167]  [<c10bcbdb>] ? lru_cache_add_lru+0x2b/0x60
[ 8903.221179]  [<c103dad1>] copy_process+0xb1/0x1090
[ 8903.221189]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8903.221199]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8903.221208]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 8903.221217]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8903.221226]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8903.221231] Mem-Info:
[ 8903.221237] DMA per-cpu:
[ 8903.221243] CPU    0: hi:    0, btch:   1 usd:   0
[ 8903.221249] CPU    1: hi:    0, btch:   1 usd:   0
[ 8903.221254] Normal per-cpu:
[ 8903.221260] CPU    0: hi:  186, btch:  31 usd:   0
[ 8903.221266] CPU    1: hi:  186, btch:  31 usd:   0
[ 8903.221271] HighMem per-cpu:
[ 8903.221277] CPU    0: hi:   42, btch:   7 usd:   0
[ 8903.221283] CPU    1: hi:   42, btch:   7 usd:   0
[ 8903.221293] Active_anon:4124 active_file:7168 inactive_anon:10128
[ 8903.221296]  inactive_file:5881 unevictable:0 dirty:5 writeback:0 unstable:0
[ 8903.221299]  free:78109 slab:102508 mapped:5571 pagetables:418 bounce:0
[ 8903.221310] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8903.221318] lowmem_reserve[]: 0 865 999 999
[ 8903.221335] Normal free:268248kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:8kB active_file:7348kB inactive_file:6760kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8903.221343] lowmem_reserve[]: 0 0 1076 1076
[ 8903.221359] HighMem free:40680kB min:132kB low:276kB high:420kB active_anon:16464kB inactive_anon:40504kB active_file:21324kB inactive_file:16764kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8903.221368] lowmem_reserve[]: 0 0 0 0
[ 8903.221378] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8903.221406] Normal: 66624*4kB 5*8kB 1*16kB 2*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268344kB
[ 8903.221433] HighMem: 341*4kB 1843*8kB 625*16kB 185*32kB 74*64kB 23*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 40732kB
[ 8903.221462] 15120 total pagecache pages
[ 8903.221467] 1829 pages in swap cache
[ 8903.221473] Swap cache stats: add 15632, delete 13803, find 1516/1962
[ 8903.221478] Free swap  = 835796kB
[ 8903.221483] Total swap = 875500kB
[ 8903.226907] 262040 pages RAM
[ 8903.226914] 34730 pages HighMem
[ 8903.226918] 3930 pages reserved
[ 8903.226923] 27906 pages shared
[ 8903.226927] 133431 pages non-shared
[ 8903.226936] Out of memory: kill process 3016 (ksmserver) score 6702 or a child
[ 8903.226974] Killed process 3016 (ksmserver)
[ 8903.336453] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8903.336465] sh cpuset=/ mems_allowed=0
[ 8903.336474] Pid: 11285, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8903.336480] Call Trace:
[ 8903.336498]  [<c10b6384>] T.392+0xc4/0x250
[ 8903.336508]  [<c10b61b5>] ? badness+0x135/0x240
[ 8903.336518]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8903.336528]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8903.336538]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8903.336548]  [<c10b2c92>] ? find_lock_page+0x32/0x80
[ 8903.336558]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8903.336570]  [<c103daea>] copy_process+0xca/0x1090
[ 8903.336580]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8903.336590]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8903.336598]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8903.336604] Mem-Info:
[ 8903.336609] DMA per-cpu:
[ 8903.336615] CPU    0: hi:    0, btch:   1 usd:   0
[ 8903.336621] CPU    1: hi:    0, btch:   1 usd:   0
[ 8903.336626] Normal per-cpu:
[ 8903.336632] CPU    0: hi:  186, btch:  31 usd:   0
[ 8903.336638] CPU    1: hi:  186, btch:  31 usd:   0
[ 8903.336642] HighMem per-cpu:
[ 8903.336648] CPU    0: hi:   42, btch:   7 usd:   0
[ 8903.336654] CPU    1: hi:   42, btch:   7 usd:   0
[ 8903.336664] Active_anon:4098 active_file:7111 inactive_anon:9972
[ 8903.336667]  inactive_file:5940 unevictable:0 dirty:5 writeback:0 unstable:0
[ 8903.336671]  free:78306 slab:102508 mapped:5337 pagetables:418 bounce:0
[ 8903.336682] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8903.336690] lowmem_reserve[]: 0 865 999 999
[ 8903.336707] Normal free:268316kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:8kB active_file:7120kB inactive_file:6996kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8903.336715] lowmem_reserve[]: 0 0 1076 1076
[ 8903.336731] HighMem free:41400kB min:132kB low:276kB high:420kB active_anon:16360kB inactive_anon:39880kB active_file:21324kB inactive_file:16764kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8903.336739] lowmem_reserve[]: 0 0 0 0
[ 8903.336750] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8903.336777] Normal: 66626*4kB 8*8kB 1*16kB 2*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268376kB
[ 8903.336804] HighMem: 408*4kB 1846*8kB 631*16kB 187*32kB 74*64kB 23*128kB 5*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 41440kB
[ 8903.336832] 15120 total pagecache pages
[ 8903.336837] 1829 pages in swap cache
[ 8903.336844] Swap cache stats: add 15632, delete 13803, find 1516/1962
[ 8903.336849] Free swap  = 835796kB
[ 8903.336853] Total swap = 875500kB
[ 8903.342156] 262040 pages RAM
[ 8903.342162] 34730 pages HighMem
[ 8903.342166] 3930 pages reserved
[ 8903.342171] 26146 pages shared
[ 8903.342175] 133483 pages non-shared
[ 8903.342183] Out of memory: kill process 11284 (klauncher) score 6551 or a child
[ 8903.342222] Killed process 11284 (klauncher)
[ 8903.433958] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8903.433969] sh cpuset=/ mems_allowed=0
[ 8903.433978] Pid: 11285, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8903.433984] Call Trace:
[ 8903.434002]  [<c10b6384>] T.392+0xc4/0x250
[ 8903.434012]  [<c10b61b5>] ? badness+0x135/0x240
[ 8903.434022]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8903.434032]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8903.434042]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8903.434052]  [<c10b2c92>] ? find_lock_page+0x32/0x80
[ 8903.434062]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8903.434074]  [<c103daea>] copy_process+0xca/0x1090
[ 8903.434084]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8903.434094]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8903.434102]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8903.434108] Mem-Info:
[ 8903.434113] DMA per-cpu:
[ 8903.434120] CPU    0: hi:    0, btch:   1 usd:   0
[ 8903.434126] CPU    1: hi:    0, btch:   1 usd:   0
[ 8903.434131] Normal per-cpu:
[ 8903.434137] CPU    0: hi:  186, btch:  31 usd:   0
[ 8903.434143] CPU    1: hi:  186, btch:  31 usd:   0
[ 8903.434147] HighMem per-cpu:
[ 8903.434153] CPU    0: hi:   42, btch:   7 usd:   0
[ 8903.434159] CPU    1: hi:   42, btch:   7 usd:   0
[ 8903.434168] Active_anon:4033 active_file:7091 inactive_anon:9972
[ 8903.434172]  inactive_file:5958 unevictable:0 dirty:5 writeback:0 unstable:0
[ 8903.434175]  free:78369 slab:102508 mapped:4856 pagetables:393 bounce:0
[ 8903.434186] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8903.434194] lowmem_reserve[]: 0 865 999 999
[ 8903.434211] Normal free:268316kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:8kB active_file:6988kB inactive_file:7120kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8903.434219] lowmem_reserve[]: 0 0 1076 1076
[ 8903.434235] HighMem free:41652kB min:132kB low:276kB high:420kB active_anon:16100kB inactive_anon:39880kB active_file:21376kB inactive_file:16712kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8903.434244] lowmem_reserve[]: 0 0 0 0
[ 8903.434254] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8903.434281] Normal: 66622*4kB 12*8kB 1*16kB 2*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268392kB
[ 8903.434309] HighMem: 466*4kB 1846*8kB 632*16kB 187*32kB 74*64kB 23*128kB 5*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 41688kB
[ 8903.434337] 15120 total pagecache pages
[ 8903.434342] 1829 pages in swap cache
[ 8903.434348] Swap cache stats: add 15632, delete 13803, find 1516/1962
[ 8903.434354] Free swap  = 835796kB
[ 8903.434358] Total swap = 875500kB
[ 8903.439679] 262040 pages RAM
[ 8903.439685] 34730 pages HighMem
[ 8903.439689] 3930 pages reserved
[ 8903.439694] 24879 pages shared
[ 8903.439698] 133983 pages non-shared
[ 8903.439706] Out of memory: kill process 3017 (openbox) score 6500 or a child
[ 8903.439744] Killed process 3017 (openbox)
[ 8904.215182] sh invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8904.215194] sh cpuset=/ mems_allowed=0
[ 8904.215203] Pid: 31659, comm: sh Tainted: G        W  2.6.30-nv-git3 #7
[ 8904.215209] Call Trace:
[ 8904.215227]  [<c10b6384>] T.392+0xc4/0x250
[ 8904.215237]  [<c10b61b5>] ? badness+0x135/0x240
[ 8904.215247]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8904.215257]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8904.215267]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8904.215279]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 8904.215289]  [<c10e091f>] kmem_cache_alloc+0x10f/0x120
[ 8904.215300]  [<c103dad1>] copy_process+0xb1/0x1090
[ 8904.215310]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8904.215321]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8904.215330]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 8904.215339]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8904.215347]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8904.215353] Mem-Info:
[ 8904.215358] DMA per-cpu:
[ 8904.215365] CPU    0: hi:    0, btch:   1 usd:   0
[ 8904.215371] CPU    1: hi:    0, btch:   1 usd:   0
[ 8904.215375] Normal per-cpu:
[ 8904.215381] CPU    0: hi:  186, btch:  31 usd:   0
[ 8904.215388] CPU    1: hi:  186, btch:  31 usd:   0
[ 8904.215392] HighMem per-cpu:
[ 8904.215398] CPU    0: hi:   42, btch:   7 usd:   0
[ 8904.215404] CPU    1: hi:   42, btch:   7 usd:   0
[ 8904.215414] Active_anon:4052 active_file:6800 inactive_anon:6221
[ 8904.215417]  inactive_file:5854 unevictable:0 dirty:5 writeback:4 unstable:0
[ 8904.215420]  free:82509 slab:102500 mapped:4769 pagetables:400 bounce:0
[ 8904.215431] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8904.215439] lowmem_reserve[]: 0 865 999 999
[ 8904.215456] Normal free:268360kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:8kB active_file:6924kB inactive_file:7176kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8904.215464] lowmem_reserve[]: 0 0 1076 1076
[ 8904.215480] HighMem free:58168kB min:132kB low:276kB high:420kB active_anon:16176kB inactive_anon:24876kB active_file:20276kB inactive_file:16240kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8904.215489] lowmem_reserve[]: 0 0 0 0
[ 8904.215499] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8904.215526] Normal: 66627*4kB 18*8kB 0*16kB 2*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268444kB
[ 8904.215554] HighMem: 636*4kB 1896*8kB 674*16kB 207*32kB 89*64kB 30*128kB 9*256kB 4*512kB 5*1024kB 2*2048kB 0*4096kB = 58224kB
[ 8904.215582] 14696 total pagecache pages
[ 8904.215587] 1809 pages in swap cache
[ 8904.215593] Swap cache stats: add 15648, delete 13839, find 1523/1971
[ 8904.215599] Free swap  = 836144kB
[ 8904.215603] Total swap = 875500kB
[ 8904.220931] 262040 pages RAM
[ 8904.220938] 34730 pages HighMem
[ 8904.220943] 3930 pages reserved
[ 8904.220947] 24912 pages shared
[ 8904.220952] 129797 pages non-shared
[ 8904.220960] Out of memory: kill process 11290 (klauncher) score 6552 or a child
[ 8904.220998] Killed process 11290 (klauncher)
[ 8907.819016] startkde invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8907.819028] startkde cpuset=/ mems_allowed=0
[ 8907.819038] Pid: 2880, comm: startkde Tainted: G        W  2.6.30-nv-git3 #7
[ 8907.819044] Call Trace:
[ 8907.819062]  [<c10b6384>] T.392+0xc4/0x250
[ 8907.819072]  [<c10b61b5>] ? badness+0x135/0x240
[ 8907.819083]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8907.819092]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8907.819103]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8907.819113]  [<c10ee81e>] ? path_put+0x2e/0x50
[ 8907.819158]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8907.819169]  [<c103daea>] copy_process+0xca/0x1090
[ 8907.819180]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8907.819190]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8907.819200]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8907.819208]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8907.819214] Mem-Info:
[ 8907.819219] DMA per-cpu:
[ 8907.819225] CPU    0: hi:    0, btch:   1 usd:   0
[ 8907.819231] CPU    1: hi:    0, btch:   1 usd:   0
[ 8907.819236] Normal per-cpu:
[ 8907.819242] CPU    0: hi:  186, btch:  31 usd:   0
[ 8907.819248] CPU    1: hi:  186, btch:  31 usd:   0
[ 8907.819253] HighMem per-cpu:
[ 8907.819259] CPU    0: hi:   42, btch:   7 usd:   0
[ 8907.819265] CPU    1: hi:   42, btch:   7 usd:   0
[ 8907.819275] Active_anon:3861 active_file:6826 inactive_anon:6009
[ 8907.819278]  inactive_file:5888 unevictable:0 dirty:5 writeback:0 unstable:0
[ 8907.819281]  free:82799 slab:102563 mapped:4280 pagetables:363 bounce:0
[ 8907.819292] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8907.819300] lowmem_reserve[]: 0 865 999 999
[ 8907.819316] Normal free:268088kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:8kB active_file:7004kB inactive_file:7144kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8907.819325] lowmem_reserve[]: 0 0 1076 1076
[ 8907.819341] HighMem free:59600kB min:132kB low:276kB high:420kB active_anon:15412kB inactive_anon:24028kB active_file:20300kB inactive_file:16408kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8907.819349] lowmem_reserve[]: 0 0 0 0
[ 8907.819359] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8907.819387] Normal: 66578*4kB 3*8kB 0*16kB 2*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268128kB
[ 8907.819414] HighMem: 748*4kB 1921*8kB 703*16kB 211*32kB 92*64kB 30*128kB 9*256kB 4*512kB 5*1024kB 2*2048kB 0*4096kB = 59656kB
[ 8907.819441] 14766 total pagecache pages
[ 8907.819446] 1815 pages in swap cache
[ 8907.819452] Swap cache stats: add 15670, delete 13855, find 1540/1992
[ 8907.819458] Free swap  = 836208kB
[ 8907.819462] Total swap = 875500kB
[ 8907.824799] 262040 pages RAM
[ 8907.824805] 34730 pages HighMem
[ 8907.824810] 3930 pages reserved
[ 8907.824814] 22983 pages shared
[ 8907.824818] 130305 pages non-shared
[ 8907.824826] Out of memory: kill process 3005 (dcopserver) score 6389 or a child
[ 8907.824864] Killed process 3005 (dcopserver)
[ 8911.198541] make invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8911.198554] make cpuset=/ mems_allowed=0
[ 8911.198563] Pid: 11168, comm: make Tainted: G        W  2.6.30-nv-git3 #7
[ 8911.198569] Call Trace:
[ 8911.198587]  [<c10b6384>] T.392+0xc4/0x250
[ 8911.198597]  [<c10b61b5>] ? badness+0x135/0x240
[ 8911.198607]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8911.198617]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8911.198627]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8911.198639]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 8911.198648]  [<c10b2c92>] ? find_lock_page+0x32/0x80
[ 8911.198658]  [<c10e091f>] kmem_cache_alloc+0x10f/0x120
[ 8911.198667]  [<c10b2c3f>] ? unlock_page+0x4f/0x70
[ 8911.198678]  [<c103dad1>] copy_process+0xb1/0x1090
[ 8911.198688]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8911.198698]  [<c100b958>] sys_vfork+0x38/0x50
[ 8911.198707]  [<c10032d8>] syscall_call+0x7/0xb
[ 8911.198713] Mem-Info:
[ 8911.198717] DMA per-cpu:
[ 8911.198723] CPU    0: hi:    0, btch:   1 usd:   0
[ 8911.198730] CPU    1: hi:    0, btch:   1 usd:   0
[ 8911.198734] Normal per-cpu:
[ 8911.198740] CPU    0: hi:  186, btch:  31 usd:   0
[ 8911.198746] CPU    1: hi:  186, btch:  31 usd:   0
[ 8911.198751] HighMem per-cpu:
[ 8911.198757] CPU    0: hi:   42, btch:   7 usd:   0
[ 8911.198763] CPU    1: hi:   42, btch:   7 usd:   0
[ 8911.198773] Active_anon:3944 active_file:4507 inactive_anon:5717
[ 8911.198776]  inactive_file:4743 unevictable:0 dirty:5 writeback:1 unstable:0
[ 8911.198779]  free:86463 slab:102597 mapped:4018 pagetables:352 bounce:0
[ 8911.198790] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8911.198798] lowmem_reserve[]: 0 865 999 999
[ 8911.198814] Normal free:268080kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:8kB active_file:6816kB inactive_file:7284kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8911.198823] lowmem_reserve[]: 0 0 1076 1076
[ 8911.198838] HighMem free:74264kB min:132kB low:276kB high:420kB active_anon:15744kB inactive_anon:22860kB active_file:11212kB inactive_file:11688kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8911.198847] lowmem_reserve[]: 0 0 0 0
[ 8911.198857] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8911.198885] Normal: 66560*4kB 10*8kB 2*16kB 2*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268144kB
[ 8911.198914] HighMem: 1494*4kB 2117*8kB 852*16kB 305*32kB 121*64kB 36*128kB 11*256kB 3*512kB 3*1024kB 2*2048kB 1*4096kB = 74272kB
[ 8911.198942] 11315 total pagecache pages
[ 8911.198947] 1815 pages in swap cache
[ 8911.198954] Swap cache stats: add 15671, delete 13856, find 1541/1993
[ 8911.198959] Free swap  = 836208kB
[ 8911.198963] Total swap = 875500kB
[ 8911.204277] 262040 pages RAM
[ 8911.204284] 34730 pages HighMem
[ 8911.204289] 3930 pages reserved
[ 8911.204293] 22447 pages shared
[ 8911.204297] 126956 pages non-shared
[ 8911.204305] Out of memory: kill process 3686 (rxvt) score 3824 or a child
[ 8911.204343] Killed process 3687 (bash)
[ 8911.278788] make invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8911.278800] make cpuset=/ mems_allowed=0
[ 8911.278809] Pid: 11168, comm: make Tainted: G        W  2.6.30-nv-git3 #7
[ 8911.278815] Call Trace:
[ 8911.278832]  [<c10b6384>] T.392+0xc4/0x250
[ 8911.278842]  [<c10b61b5>] ? badness+0x135/0x240
[ 8911.278852]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8911.278861]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8911.278872]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8911.278884]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 8911.278893]  [<c10b2c92>] ? find_lock_page+0x32/0x80
[ 8911.278903]  [<c10e091f>] kmem_cache_alloc+0x10f/0x120
[ 8911.278912]  [<c10b2c3f>] ? unlock_page+0x4f/0x70
[ 8911.278923]  [<c103dad1>] copy_process+0xb1/0x1090
[ 8911.278933]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8911.278943]  [<c100b958>] sys_vfork+0x38/0x50
[ 8911.278951]  [<c10032d8>] syscall_call+0x7/0xb
[ 8911.278957] Mem-Info:
[ 8911.278962] DMA per-cpu:
[ 8911.278968] CPU    0: hi:    0, btch:   1 usd:   0
[ 8911.278975] CPU    1: hi:    0, btch:   1 usd:   0
[ 8911.278979] Normal per-cpu:
[ 8911.278986] CPU    0: hi:  186, btch:  31 usd:   0
[ 8911.278992] CPU    1: hi:  186, btch:  31 usd:   0
[ 8911.278996] HighMem per-cpu:
[ 8911.279002] CPU    0: hi:   42, btch:   7 usd:   0
[ 8911.279008] CPU    1: hi:   42, btch:   7 usd:   0
[ 8911.279018] Active_anon:3723 active_file:4537 inactive_anon:5665
[ 8911.279021]  inactive_file:4734 unevictable:0 dirty:5 writeback:1 unstable:0
[ 8911.279025]  free:86724 slab:102597 mapped:4018 pagetables:352 bounce:0
[ 8911.279036] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8911.279044] lowmem_reserve[]: 0 865 999 999
[ 8911.279060] Normal free:268080kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:8kB active_file:6936kB inactive_file:7248kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8911.279069] lowmem_reserve[]: 0 0 1076 1076
[ 8911.279084] HighMem free:75308kB min:132kB low:276kB high:420kB active_anon:14860kB inactive_anon:22652kB active_file:11212kB inactive_file:11688kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8911.279093] lowmem_reserve[]: 0 0 0 0
[ 8911.279103] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8911.279151] Normal: 66568*4kB 10*8kB 2*16kB 2*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268176kB
[ 8911.279179] HighMem: 1693*4kB 2108*8kB 858*16kB 303*32kB 124*64kB 37*128kB 11*256kB 3*512kB 3*1024kB 2*2048kB 1*4096kB = 75348kB
[ 8911.279208] 11276 total pagecache pages
[ 8911.279213] 1767 pages in swap cache
[ 8911.279219] Swap cache stats: add 15679, delete 13912, find 1542/1995
[ 8911.279225] Free swap  = 838624kB
[ 8911.279229] Total swap = 875500kB
[ 8911.284477] 262040 pages RAM
[ 8911.284483] 34730 pages HighMem
[ 8911.284487] 3930 pages reserved
[ 8911.284492] 21915 pages shared
[ 8911.284496] 126673 pages non-shared
[ 8911.284504] Out of memory: kill process 3768 (rxvt) score 3824 or a child
[ 8911.284540] Killed process 3769 (bash)
Jun 12 22:03:28  console-kit-daemon[2644]: WARNING: Unable to activate console: No such device or address 
[ 8915.780567] hal-acl-tool invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8915.780579] hal-acl-tool cpuset=/ mems_allowed=0
[ 8915.780589] Pid: 11324, comm: hal-acl-tool Tainted: G        W  2.6.30-nv-git3 #7
[ 8915.780595] Call Trace:
[ 8915.780613]  [<c10b6384>] T.392+0xc4/0x250
[ 8915.780623]  [<c10b61b5>] ? badness+0x135/0x240
[ 8915.780633]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8915.780643]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8915.780653]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8915.780664]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8915.780675]  [<c103daea>] copy_process+0xca/0x1090
[ 8915.780685]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8915.780696]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8915.780704]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8915.780710] Mem-Info:
[ 8915.780715] DMA per-cpu:
[ 8915.780721] CPU    0: hi:    0, btch:   1 usd:   0
[ 8915.780728] CPU    1: hi:    0, btch:   1 usd:   0
[ 8915.780732] Normal per-cpu:
[ 8915.780738] CPU    0: hi:  186, btch:  31 usd:   0
[ 8915.780745] CPU    1: hi:  186, btch:  31 usd:   0
[ 8915.780749] HighMem per-cpu:
[ 8915.780755] CPU    0: hi:   42, btch:   7 usd:   0
[ 8915.780761] CPU    1: hi:   42, btch:   7 usd:   0
[ 8915.780771] Active_anon:326 active_file:4741 inactive_anon:3647
[ 8915.780774]  inactive_file:5376 unevictable:0 dirty:29 writeback:1 unstable:0
[ 8915.780778]  free:91313 slab:102693 mapped:2606 pagetables:207 bounce:0
[ 8915.780789] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8915.780797] lowmem_reserve[]: 0 865 999 999
[ 8915.780814] Normal free:267428kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:4kB active_file:7348kB inactive_file:7416kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8915.780823] lowmem_reserve[]: 0 0 1076 1076
[ 8915.780839] HighMem free:94316kB min:132kB low:276kB high:420kB active_anon:1272kB inactive_anon:14584kB active_file:11616kB inactive_file:14088kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8915.780848] lowmem_reserve[]: 0 0 0 0
[ 8915.780858] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8915.780886] Normal: 66413*4kB 6*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 267508kB
[ 8915.780913] HighMem: 2298*4kB 1999*8kB 1004*16kB 430*32kB 189*64kB 61*128kB 18*256kB 5*512kB 2*1024kB 3*2048kB 1*4096kB = 94368kB
[ 8915.780940] 10999 total pagecache pages
[ 8915.780945] 822 pages in swap cache
[ 8915.780951] Swap cache stats: add 16523, delete 15701, find 1783/2375
[ 8915.780957] Free swap  = 861800kB
[ 8915.780961] Total swap = 875500kB
[ 8915.786244] 262040 pages RAM
[ 8915.786251] 34730 pages HighMem
[ 8915.786255] 3930 pages reserved
[ 8915.786259] 13034 pages shared
[ 8915.786263] 123637 pages non-shared
[ 8915.786271] Out of memory: kill process 3654 (bash) score 2792 or a child
[ 8915.786303] Killed process 3684 (elinks)
[ 8917.945955] hal-acl-tool invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 8917.945967] hal-acl-tool cpuset=/ mems_allowed=0
[ 8917.945978] Pid: 11324, comm: hal-acl-tool Tainted: G        W  2.6.30-nv-git3 #7
[ 8917.945984] Call Trace:
[ 8917.946002]  [<c10b6384>] T.392+0xc4/0x250
[ 8917.946012]  [<c10b61b5>] ? badness+0x135/0x240
[ 8917.946022]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 8917.946032]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 8917.946042]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 8917.946054]  [<c10b99a8>] __get_free_pages+0x28/0x60
[ 8917.946065]  [<c103daea>] copy_process+0xca/0x1090
[ 8917.946075]  [<c11f460e>] ? security_file_alloc+0x1e/0x40
[ 8917.946085]  [<c103eb34>] do_fork+0x84/0x3a0
[ 8917.946094]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 8917.946103]  [<c10ed7be>] ? sys_pipe2+0x5e/0x90
[ 8917.946112]  [<c10018cb>] sys_clone+0x3b/0x60
[ 8917.946120]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 8917.946127] Mem-Info:
[ 8917.946131] DMA per-cpu:
[ 8917.946138] CPU    0: hi:    0, btch:   1 usd:   0
[ 8917.946144] CPU    1: hi:    0, btch:   1 usd:   0
[ 8917.946148] Normal per-cpu:
[ 8917.946154] CPU    0: hi:  186, btch:  31 usd:   0
[ 8917.946160] CPU    1: hi:  186, btch:  31 usd:   0
[ 8917.946165] HighMem per-cpu:
[ 8917.946171] CPU    0: hi:   42, btch:   7 usd:   0
[ 8917.946177] CPU    1: hi:   42, btch:   7 usd:   0
[ 8917.946186] Active_anon:281 active_file:3938 inactive_anon:3219
[ 8917.946189]  inactive_file:4949 unevictable:0 dirty:5 writeback:0 unstable:0
[ 8917.946193]  free:92980 slab:102718 mapped:2315 pagetables:203 bounce:0
[ 8917.946204] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 8917.946212] lowmem_reserve[]: 0 865 999 999
[ 8917.946229] Normal free:267920kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:0kB active_file:7036kB inactive_file:7104kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 8917.946237] lowmem_reserve[]: 0 0 1076 1076
[ 8917.946253] HighMem free:100492kB min:132kB low:276kB high:420kB active_anon:1092kB inactive_anon:12876kB active_file:8716kB inactive_file:12692kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 8917.946262] lowmem_reserve[]: 0 0 0 0
[ 8917.946273] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 8917.946301] Normal: 66515*4kB 18*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268012kB
[ 8917.946328] HighMem: 2366*4kB 1880*8kB 983*16kB 490*32kB 225*64kB 78*128kB 21*256kB 5*512kB 2*1024kB 3*2048kB 1*4096kB = 100520kB
[ 8917.946356] 9412 total pagecache pages
[ 8917.946361] 445 pages in swap cache
[ 8917.946367] Swap cache stats: add 16555, delete 16110, find 1791/2393
[ 8917.946373] Free swap  = 867956kB
[ 8917.946377] Total swap = 875500kB
[ 8917.951539] 262040 pages RAM
[ 8917.951546] 34730 pages HighMem
[ 8917.951550] 3930 pages reserved
[ 8917.951554] 12141 pages shared
[ 8917.951558] 122509 pages non-shared
[ 8917.951567] Out of memory: kill process 2641 (hald) score 2055 or a child
[ 8917.951597] Killed process 2707 (hald-runner)
Jun 12 22:05:02  /USR/SBIN/CRON[11358]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
Jun 12 22:05:29  kdm: :0[11336]: Hung in XOpenDisplay(:0), aborting
Jun 12 22:05:29  kdm: :0[11336]: Cannot connect to :0, giving up
Jun 12 22:05:29  kdm[2835]: Display :0 cannot be opened
Jun 12 22:06:10  shutdown[11361]: shutting down for system reboot
Jun 12 22:06:10  init: Switching to runlevel: 6
[ 9078.715238] K01kdm invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
[ 9078.715249] K01kdm cpuset=/ mems_allowed=0
[ 9078.715259] Pid: 11367, comm: K01kdm Tainted: G        W  2.6.30-nv-git3 #7
[ 9078.715265] Call Trace:
[ 9078.715283]  [<c10b6384>] T.392+0xc4/0x250
[ 9078.715293]  [<c10b61b5>] ? badness+0x135/0x240
[ 9078.715303]  [<c10b665a>] __out_of_memory+0x14a/0x170
[ 9078.715313]  [<c10b66d9>] out_of_memory+0x59/0xb0
[ 9078.715323]  [<c10b98dd>] __alloc_pages_internal+0x47d/0x4d0
[ 9078.715335]  [<c10e04b5>] cache_alloc_refill+0x2f5/0x4e0
[ 9078.715345]  [<c10b9535>] ? __alloc_pages_internal+0xd5/0x4d0
[ 9078.715356]  [<c10e091f>] kmem_cache_alloc+0x10f/0x120
[ 9078.715367]  [<c103dad1>] copy_process+0xb1/0x1090
[ 9078.715377]  [<c103eb34>] do_fork+0x84/0x3a0
[ 9078.715387]  [<c122ddf1>] ? copy_to_user+0x41/0x150
[ 9078.715396]  [<c104d25d>] ? sigprocmask+0x6d/0x110
[ 9078.715405]  [<c10018cb>] sys_clone+0x3b/0x60
[ 9078.715413]  [<c100320b>] sysenter_do_call+0x12/0x22
[ 9078.715419] Mem-Info:
[ 9078.715424] DMA per-cpu:
[ 9078.715430] CPU    0: hi:    0, btch:   1 usd:   0
[ 9078.715436] CPU    1: hi:    0, btch:   1 usd:   0
[ 9078.715441] Normal per-cpu:
[ 9078.715447] CPU    0: hi:  186, btch:  31 usd:   0
[ 9078.715453] CPU    1: hi:  186, btch:  31 usd:   0
[ 9078.715458] HighMem per-cpu:
[ 9078.715463] CPU    0: hi:   42, btch:   7 usd:   0
[ 9078.715469] CPU    1: hi:   42, btch:   7 usd:   0
[ 9078.715479] Active_anon:453 active_file:3543 inactive_anon:2764
[ 9078.715482]  inactive_file:4323 unevictable:0 dirty:9 writeback:0 unstable:0
[ 9078.715486]  free:94476 slab:102512 mapped:1786 pagetables:173 bounce:0
[ 9078.715497] DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[ 9078.715505] lowmem_reserve[]: 0 865 999 999
[ 9078.715521] Normal free:268480kB min:3728kB low:4660kB high:5592kB active_anon:32kB inactive_anon:0kB active_file:7012kB inactive_file:7420kB unevictable:0kB present:885944kB pages_scanned:0 all_unreclaimable? no
[ 9078.715530] lowmem_reserve[]: 0 0 1076 1076
[ 9078.715546] HighMem free:105916kB min:132kB low:276kB high:420kB active_anon:1780kB inactive_anon:11056kB active_file:7160kB inactive_file:9872kB unevictable:0kB present:137832kB pages_scanned:0 all_unreclaimable? no
[ 9078.715554] lowmem_reserve[]: 0 0 0 0
[ 9078.715564] DMA: 3*4kB 399*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3508kB
[ 9078.715592] Normal: 66660*4kB 12*8kB 1*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 268576kB
[ 9078.715619] HighMem: 1790*4kB 1592*8kB 966*16kB 528*32kB 247*64kB 116*128kB 28*256kB 5*512kB 1*1024kB 2*2048kB 2*4096kB = 105944kB
[ 9078.715648] 8385 total pagecache pages
[ 9078.715653] 440 pages in swap cache
[ 9078.715659] Swap cache stats: add 16556, delete 16116, find 1792/2395
[ 9078.715665] Free swap  = 867980kB
[ 9078.715670] Total swap = 875500kB
[ 9078.720869] 262040 pages RAM
[ 9078.720876] 34730 pages HighMem
[ 9078.720880] 3930 pages reserved
[ 9078.720885] 10163 pages shared
[ 9078.720889] 121721 pages non-shared
[ 9078.720897] Out of memory: kill process 2835 (kdm) score 1381 or a child
[ 9078.720927] Killed process 2838 (Xorg)
[ 9105.449449] SysRq : Keyboard mode set to system default
Jun 12 22:06:39  exiting on signal 15
Jun 12 22:09:04  syslogd 1.5.0#5: restart.
--6c2NcOVqGQ03X4Wi--
