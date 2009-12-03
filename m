Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbZLCWpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbZLCWpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZLCWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:45:09 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53170 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZLCWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:45:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=IN73QQfEkZtoi9qebNaRKbYMsGmSrChPGM2ZwdiQrI935OIvQypvsKs6gV+IAdOEFN
         GqUnZFkhEwB29BhnjsDiZV1FPBJM7ECL5imMW0Fn4ipBtSVeFaI67oQPnKiPjU/PdP/V
         e5jzViWg+QemQtZ8Dwiat+Fv5VQbA0xb7w6rE=
MIME-Version: 1.0
Date: Thu, 3 Dec 2009 14:45:13 -0800
Message-ID: <dd18b0c30912031445m11bded01tb500e4953d3b3fa3@mail.gmail.com>
Subject: BUG: unable to handle kernel paging request at ffff8800000b8000
From: Justin Mattock <justinmattock@gmail.com>
To: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking into a wireless kmalloc BUG,
I ran into this(below)
basically to reproduce I use
s2ram two or three times in a row, and then
use echo mem > /sys/power/state happens on the second time.

Now if I choose to not use s2ram and only echo mem
the machine reports nothing on the second try, and just
automatically reboots.


heres the first catch of this:



<1>[  426.143717] BUG: unable to handle kernel paging request at
ffff8800000b8000
<1>[  426.143722] IP: [<ffffffff8123b098>] vgacon_switch+0x64/0x100
<4>[  426.143730] PGD 1002063 PUD 1006063 PMD 100067 PTE e7bea200e7bea2
<0>[  426.143735] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
<0>[  426.143738] last sysfs file: /sys/devices/platform/applesmc.768/light
<4>[  426.143741] CPU 0
<4>[  426.143743] Modules linked in: radeon ttm drm_kms_helper drm
i2c_algo_bit ipt_LOG iptable_nat nf_nat xt_state nf_conntrack_ftp
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables
x_tables snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep
firewire_ohci ath9k firewire_core snd_pcm ohci1394 i2c_i801 evdev ath
sky2 joydev thermal snd_page_alloc ac video battery button raw1394
ieee1394 uhci_hcd ehci_hcd coretemp acpi_cpufreq processor appletouch
applesmc
<6>[  426.143775] Pid: 3151, comm: X Not tainted
2.6.32-rc8-00261-g29fa55a #4 MacBookPro2,2
<6>[  426.143777] RIP: 0010:[<ffffffff8123b098>]  [<ffffffff8123b098>]
vgacon_switch+0x64/0x100
<6>[  426.143781] RSP: 0018:ffff88002bf55c98  EFLAGS: 00010202
<6>[  426.143783] RAX: ffffffff81488919 RBX: ffff880037ced400 RCX:
0000000000000fa0
<6>[  426.143785] RDX: 0000000000000010 RSI: ffff880022942000 RDI:
ffff8800000b8000
<6>[  426.143787] RBP: ffff88002bf55ca8 R08: 0000000000000019 R09:
0000000000000280
<6>[  426.143790] R10: ffff8800000b8000 R11: 0000000000000010 R12:
0000000000000000
<6>[  426.143792] R13: 0000000000000001 R14: ffff880024f53c00 R15:
ffff880020ef3000
<6>[  426.143795] FS:  00007f3f9ae437a0(0000)
GS:ffff880003600000(0000) knlGS:0000000000000000
<6>[  426.143797] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<6>[  426.143799] CR2: ffff8800000b8000 CR3: 000000003b788000 CR4:
00000000000006f0
<6>[  426.143801] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
<6>[  426.143803] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
<4>[  426.143806] Process X (pid: 3151, threadinfo ffff88002bf54000,
task ffff88002ba76360)
<0>[  426.143808] Stack:
<4>[  426.143809]  ffff880024f53c00 ffff880037ced400 ffff88002bf55cd8
ffffffff8129e59b
<4>[  426.143812] <0> ffff880037ced400 0000000000000001
0000000000000001 ffff880024f53c00
<4>[  426.143815] <0> ffff88002bf55cf8 ffffffff8129ef57
ffff880037ced400 0000000000000006
<0>[  426.143819] Call Trace:
<4>[  426.143823]  [<ffffffff8129e59b>] redraw_screen+0x102/0x1b6
<4>[  426.143827]  [<ffffffff8129ef57>] do_unblank_screen+0xff/0x145
<4>[  426.143831]  [<ffffffff8129632d>] complete_change_console+0x55/0xc8
<4>[  426.143834]  [<ffffffff812976c5>] vt_ioctl+0x12a7/0x1952
<4>[  426.143838]  [<ffffffff811daa1e>] ? avc_has_perm+0x5c/0x6e
<4>[  426.143843]  [<ffffffff810bc785>] ? __call_rcu+0x127/0x133
<4>[  426.143846]  [<ffffffff8128e90d>] tty_ioctl+0x7ee/0x856
<4>[  426.143850]  [<ffffffff81097620>] ? trace_hardirqs_off_caller+0x16/0xa9
<4>[  426.143855]  [<ffffffff81128261>] vfs_ioctl+0x22/0x87
<4>[  426.143858]  [<ffffffff811287ca>] do_vfs_ioctl+0x488/0x4ce
<4>[  426.143861]  [<ffffffff81128866>] sys_ioctl+0x56/0x79
<4>[  426.143865]  [<ffffffff8102e05b>] system_call_fastpath+0x16/0x1b
<0>[  426.143867] Code: 01 83 3d 2b 5b 0b 01 00 75 72 8b 4f 48 4c 8b
57 18 39 0d e4 6d 4d 00 48 8b 77 40 0f 46 0d d9 6d 4d 00 4c 89 d7 89
c9 41 c1 e1 03 <f3> a4 44 39 0d 8f 5a 0b 01 75 0d 44 0f af c2 44 39 05
86 5a 0b
<1>[  426.143893] RIP  [<ffffffff8123b098>] vgacon_switch+0x64/0x100
<4>[  426.143896]  RSP <ffff88002bf55c98>
<0>[  426.143897] CR2: ffff8800000b8000
<4>[  426.143900] ---[ end trace c919a05e0cc13f51 ]---
Bus reset !




and the second catch of this(seems reproducible from here unlike the
wireless bug I'm looking at).


/* second go at this i.g. used s2ram 2/3 times then used echo mem >
/sys/power/state 2 times */


<1>[  160.534278] BUG: unable to handle kernel paging request at
ffff88000011b068
<1>[  160.534286] IP: [<ffffffff81048af4>] spurious_fault+0x129/0x1a0
<4>[  160.534296] PGD 1002063 PUD 1006063 PMD 100067 PTE c7bea600c7bea6
<0>[  160.534303] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
<0>[  160.534308] last sysfs file: /sys/devices/platform/applesmc.768/light
<4>[  160.534313] CPU 1
<4>[  160.534315] Modules linked in: radeon ttm drm_kms_helper drm
i2c_algo_bit ipt_LOG iptable_nat nf_nat xt_state nf_conntrack_ftp
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables
x_tables snd_hda_codec_idt snd_hda_intel firewire_ohci snd_hda_codec
firewire_core ath9k video snd_hwdep ohci1394 i2c_i801 battery ac evdev
joydev thermal sky2 snd_pcm ath button snd_page_alloc raw1394 ieee1394
uhci_hcd ehci_hcd coretemp acpi_cpufreq processor appletouch applesmc
<6>[  160.534372] Pid: 2786, comm: X Tainted: G   M
2.6.32-rc8-00261-g29fa55a #4 MacBookPro2,2
<6>[  160.534375] RIP: 0010:[<ffffffff81048af4>]  [<ffffffff81048af4>]
spurious_fault+0x129/0x1a0
<6>[  160.534381] RSP: 0000:ffff880003803978  EFLAGS: 00013002
<6>[  160.534384] RAX: ffff880000000000 RBX: ffff88000360df70 RCX:
ffffc00000000fff
<6>[  160.534386] RDX: ffff8800010060d8 RSI: 000000000011b068 RDI:
0000000000000000
<6>[  160.534389] RBP: ffff880003803978 R08: 000000000011b067 R09:
0000000000000001
<6>[  160.534392] R10: 0000000000000001 R11: ffffffff81063515 R12:
ffff8800038039d8
<6>[  160.534395] R13: 0000000000000000 R14: ffff8800039d8558 R15:
ffff88002beca7c0
<6>[  160.534398] FS:  00007f7bc3eb07a0(0000)
GS:ffff880003800000(0000) knlGS:0000000000000000
<6>[  160.534401] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<6>[  160.534404] CR2: ffff88000011b068 CR3: 000000002b87f000 CR4:
00000000000006e0
<6>[  160.534407] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
<6>[  160.534410] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
<4>[  160.534413] Process X (pid: 2786, threadinfo ffff8800247e0000,
task ffff88002beca7c0)
<0>[  160.534415] Stack:
<4>[  160.534417]  ffff8800038039c8 ffffffff81446420 ffff88002b9bb1e0
ffff88002b9bb180
<4>[  160.534423] <0> 0000000000000000 0000000000000001
0000000000000000 0000000000000800
<4>[  160.534429] <0> ffff8800039d8558 0000000000000800
ffff880003803af0 ffffffff814443af
<0>[  160.534436] Call Trace:
<0>[  160.534438]  <IRQ>
<4>[  160.534444]  [<ffffffff81446420>] do_page_fault+0x81/0x320
<4>[  160.534448]  [<ffffffff814443af>] page_fault+0x1f/0x30
<4>[  160.534453]  [<ffffffff81063515>] ? scheduler_tick+0x41/0x28f
<4>[  160.534459]  [<ffffffff810586e1>] ? tg_shares_up+0x167/0x292
<4>[  160.534463]  [<ffffffff81055c38>] ? walk_tg_tree+0x0/0xc6
<4>[  160.534468]  [<ffffffff8108b94b>] ? cpu_clock+0x2d/0x40
<4>[  160.534473]  [<ffffffff8104ea21>] ? tg_nop+0x0/0xd
<4>[  160.534477]  [<ffffffff8105857a>] ? tg_shares_up+0x0/0x292
<4>[  160.534480]  [<ffffffff81055cc6>] walk_tg_tree+0x8e/0xc6
<4>[  160.534484]  [<ffffffff81055c38>] ? walk_tg_tree+0x0/0xc6
<4>[  160.534489]  [<ffffffff810976c0>] ? trace_hardirqs_off+0xd/0xf
<4>[  160.534492]  [<ffffffff8108b94b>] ? cpu_clock+0x2d/0x40
<4>[  160.534496]  [<ffffffff81058227>] update_shares+0x57/0x5b
<4>[  160.534500]  [<ffffffff81058b71>] select_task_rq_fair+0x2de/0x995
<4>[  160.534504]  [<ffffffff81058933>] ? select_task_rq_fair+0xa0/0x995
<4>[  160.534508]  [<ffffffff81056fe9>] ? task_rq_lock+0x43/0x75
<4>[  160.534512]  [<ffffffff81056fe9>] ? task_rq_lock+0x43/0x75
<4>[  160.534516]  [<ffffffff81062177>] try_to_wake_up+0xd1/0x2e1
<4>[  160.534520]  [<ffffffff81056ece>] ? __wake_up+0x22/0x4d
<4>[  160.534524]  [<ffffffff81062399>] default_wake_function+0x12/0x14
<4>[  160.534529]  [<ffffffff810868d2>] autoremove_wake_function+0x16/0x39
<4>[  160.534533]  [<ffffffff8104f454>] __wake_up_common+0x4e/0x84
<4>[  160.534537]  [<ffffffff81056ece>] ? __wake_up+0x22/0x4d
<4>[  160.534541]  [<ffffffff81056ee5>] __wake_up+0x39/0x4d
<4>[  160.534545]  [<ffffffff81081eaf>] insert_work+0x98/0xa5
<4>[  160.534549]  [<ffffffff810824f6>] ? __queue_work+0x1c/0x41
<4>[  160.534553]  [<ffffffff81082509>] __queue_work+0x2f/0x41
<4>[  160.534557]  [<ffffffff8108255a>] delayed_work_timer_fn+0x3f/0x41
<4>[  160.534562]  [<ffffffff81075fe5>] run_timer_softirq+0x25c/0x320
<4>[  160.534566]  [<ffffffff81075f4d>] ? run_timer_softirq+0x1c4/0x320
<4>[  160.534571]  [<ffffffff8108945c>] ? __run_hrtimer+0x100/0x12f
<4>[  160.534575]  [<ffffffff8108251b>] ? delayed_work_timer_fn+0x0/0x41
<4>[  160.534580]  [<ffffffff8106e0df>] __do_softirq+0xf2/0x1c3
<4>[  160.534586]  [<ffffffff8102f21c>] call_softirq+0x1c/0x3e
<4>[  160.534590]  [<ffffffff81030911>] do_softirq+0x3d/0x88
<4>[  160.534594]  [<ffffffff8106dc4e>] irq_exit+0x4a/0x8c
<4>[  160.534598]  [<ffffffff81448402>] smp_apic_timer_interrupt+0x8e/0x9c
<4>[  160.534602]  [<ffffffff8102ebf3>] apic_timer_interrupt+0x13/0x20
<0>[  160.534605]  <EOI>
<0>[  160.534607] Code: ff ff 48 23 02 48 f7 d0 48 c1 e8 3f e9 88 00
00 00 4c 21 c1 48 c1 ee 09 81 e6 f8 0f 00 00 48 01 ce 48 b9 ff 0f 00
00 00 c0 ff ff <48> 23 0c 06 48 89 c8 f7 c1 01 01 00 00 74 56 48 89 fe
83 e6 02
<1>[  160.534663] RIP  [<ffffffff81048af4>] spurious_fault+0x129/0x1a0
<4>[  160.534668]  RSP <ffff880003803978>
<0>[  160.534670] CR2: ffff88000011b068
<4>[  160.534674] ---[ end trace 0be4c179ab42ceb7 ]---
<0>[  160.534677] Kernel panic - not syncing: Fatal exception in interrupt
<4>[  160.534680] Pid: 2786, comm: X Tainted: G   M  D
2.6.32-rc8-00261-g29fa55a #4
<4>[  160.534682] Call Trace:
<4>[  160.534684]  <IRQ>  [<ffffffff814406d6>] panic+0x7a/0x12b
<4>[  160.534691]  [<ffffffff81443a05>] ? _spin_unlock_irqrestore+0x38/0x46
<4>[  160.534695]  [<ffffffff81444fe2>] oops_end+0x86/0x93
<4>[  160.534699]  [<ffffffff810491c3>] no_context+0x1f3/0x202
<4>[  160.534703]  [<ffffffff81049357>] __bad_area_nosemaphore+0x185/0x1a8
<4>[  160.534707]  [<ffffffff81444593>] ? error_sti+0x5/0x6
<4>[  160.534712]  [<ffffffff8104938d>] bad_area_nosemaphore+0x13/0x15
<4>[  160.534716]  [<ffffffff8144654f>] do_page_fault+0x1b0/0x320
<4>[  160.534720]  [<ffffffff814443af>] page_fault+0x1f/0x30
<4>[  160.534723]  [<ffffffff81063515>] ? scheduler_tick+0x41/0x28f
<4>[  160.534727]  [<ffffffff81048af4>] ? spurious_fault+0x129/0x1a0
<4>[  160.534731]  [<ffffffff81446420>] do_page_fault+0x81/0x320
<4>[  160.534735]  [<ffffffff814443af>] page_fault+0x1f/0x30
<4>[  160.534739]  [<ffffffff81063515>] ? scheduler_tick+0x41/0x28f
<4>[  160.534743]  [<ffffffff810586e1>] ? tg_shares_up+0x167/0x292
<4>[  160.534747]  [<ffffffff81055c38>] ? walk_tg_tree+0x0/0xc6
<4>[  160.534751]  [<ffffffff8108b94b>] ? cpu_clock+0x2d/0x40
<4>[  160.534754]  [<ffffffff8104ea21>] ? tg_nop+0x0/0xd
<4>[  160.534758]  [<ffffffff8105857a>] ? tg_shares_up+0x0/0x292
<4>[  160.534762]  [<ffffffff81055cc6>] walk_tg_tree+0x8e/0xc6
<4>[  160.534765]  [<ffffffff81055c38>] ? walk_tg_tree+0x0/0xc6
<4>[  160.534769]  [<ffffffff810976c0>] ? trace_hardirqs_off+0xd/0xf
<4>[  160.534773]  [<ffffffff8108b94b>] ? cpu_clock+0x2d/0x40
<4>[  160.534777]  [<ffffffff81058227>] update_shares+0x57/0x5b
<4>[  160.534781]  [<ffffffff81058b71>] select_task_rq_fair+0x2de/0x995
<4>[  160.534785]  [<ffffffff81058933>] ? select_task_rq_fair+0xa0/0x995
<4>[  160.534789]  [<ffffffff81056fe9>] ? task_rq_lock+0x43/0x75
<4>[  160.534793]  [<ffffffff81056fe9>] ? task_rq_lock+0x43/0x75
<4>[  160.534797]  [<ffffffff81062177>] try_to_wake_up+0xd1/0x2e1
<4>[  160.534800]  [<ffffffff81056ece>] ? __wake_up+0x22/0x4d
<4>[  160.534804]  [<ffffffff81062399>] default_wake_function+0x12/0x14
<4>[  160.534808]  [<ffffffff810868d2>] autoremove_wake_function+0x16/0x39
<4>[  160.534812]  [<ffffffff8104f454>] __wake_up_common+0x4e/0x84
<4>[  160.534816]  [<ffffffff81056ece>] ? __wake_up+0x22/0x4d
<4>[  160.534820]  [<ffffffff81056ee5>] __wake_up+0x39/0x4d
<4>[  160.534824]  [<ffffffff81081eaf>] insert_work+0x98/0xa5
<4>[  160.534827]  [<ffffffff810824f6>] ? __queue_work+0x1c/0x41
<4>[  160.534831]  [<ffffffff81082509>] __queue_work+0x2f/0x41
<4>[  160.534835]  [<ffffffff8108255a>] delayed_work_timer_fn+0x3f/0x41
<4>[  160.534839]  [<ffffffff81075fe5>] run_timer_softirq+0x25c/0x320
<4>[  160.534843]  [<ffffffff81075f4d>] ? run_timer_softirq+0x1c4/0x320
<4>[  160.534847]  [<ffffffff8108945c>] ? __run_hrtimer+0x100/0x12f
<4>[  160.534851]  [<ffffffff8108251b>] ? delayed_work_timer_fn+0x0/0x41
<4>[  160.534856]  [<ffffffff8106e0df>] __do_softirq+0xf2/0x1c3
<4>[  160.534860]  [<ffffffff8102f21c>] call_softirq+0x1c/0x3e
<4>[  160.534864]  [<ffffffff81030911>] do_softirq+0x3d/0x88
<4>[  160.534868]  [<ffffffff8106dc4e>] irq_exit+0x4a/0x8c
<4>[  160.534872]  [<ffffffff81448402>] smp_apic_timer_interrupt+0x8e/0x9c
<4>[  160.534876]  [<ffffffff8102ebf3>] apic_timer_interrupt+0x13/0x20


If I use s2ram I can suspend numerous times without an issue.
(the message was retrieved using firescope)

-- 
Justin P. Mattock
