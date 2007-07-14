Return-Path: <linux-kernel-owner+w=401wt.eu-S1765526AbXGNVkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765526AbXGNVkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 17:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763475AbXGNVkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 17:40:46 -0400
Received: from smtpa2.netcabo.pt ([212.113.174.17]:52521 "EHLO
	exch01smtp01.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762798AbXGNVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 17:40:44 -0400
Message-ID: <46994278.6020000@rncbc.org>
Date: Sat, 14 Jul 2007 22:39:04 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: 2.6.22.1-rt3 lockups
References: <1184325752.12353.312.camel@chaos>
In-Reply-To: <1184325752.12353.312.camel@chaos>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2007 21:40:41.0726 (UTC) FILETIME=[A051D9E0:01C7C65F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Current 2.6.22.1-rt3 is locking-up on any of my x86 SMP machines, in
very rare and non-deterministic occasions and normal desktop workloads,
but seems to be more probable when high disk I/O is underway.

At least, I was able to capture some crash traces, via serial console,
with nmi_watchdog=1.

...
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: appletalk ax25 ipx p8023 snd_rtctimer snd_seq_dummy
snd_pcm_oss snd_mixer_oss snd_seq_midi snd_seq_midi_event w83627hf
hwmon_vid snd_seq button hwmon battery ac eeprom loop dm_mod ohci1394
ieee1394 wacom usbhid hid ff_memless snd_ice1712 snd_ice17xx_ak4xxx
snd_ak4xxx_adda snd_cs8427 snd_i2c firewire_ohci snd_mpu401_uart sk98lin
firewire_core ide_cd nvidia(P) snd_cs46xx gameport snd_rawmidi
snd_seq_device cdrom crc_itu_t snd_intel8x0 snd_ac97_codec ehci_hcd
uhci_hcd ac97_bus snd_pcm intel_agp snd_timer i2c_i801 agpgart snd
i2c_core soundcore snd_page_alloc shpchp iTCO_wdt rtc_cmos usbcore
pci_hotplug rtc_core rtc_lib ext3 mbcache jbd edd fan piix thermal
processor ide_disk ide_core
CPU:    1
EIP:    0060:[<00000000>]    Tainted: P       VLI
EFLAGS: 00210007   (2.6.22.1-rt3.0 #1)
EIP is at _stext+0x3feff000/0x20
eax: c1812a80   ebx: c03bb540   ecx: 00000001   edx: c038e3c0
esi: c038e3c0   edi: 00000001   ebp: c5099d6c   esp: c5099d50
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068  preempt:00000003
Process cc1plus (pid: 20669, ti=c5099000 task=deca8070 task.ti=c5099000)
Stack: c011a8fc 3302bd39 000009cb c1812a80 c1812a80 3302bd39 000009cb
c5099d90
       c011b45f 3302bd39 000009cb 00000001 c038e3c0 00000001 00000000
c038e3c0
       c5099df4 c011e04d c5099dfc c011ddeb 00000000 0000001f c1812a80
0000001f
Call Trace:
 [<c010622a>] show_trace_log_lvl+0x1a/0x30
 [<c01062f6>] show_stack_log_lvl+0xb6/0xe0
 [<c0106521>] show_registers+0x201/0x330
 [<c0106768>] die+0x118/0x260
 [<c03041e3>] do_page_fault+0x193/0x600
 [<c03028fa>] error_code+0x72/0x78
 [<c011b45f>] activate_task+0x4f/0xb0
 [<c011e04d>] try_to_wake_up+0x2bd/0x420
 [<c011e229>] wake_up_process_mutex+0x19/0x20
 [<c014257c>] wakeup_next_waiter+0xec/0x1a0
 [<c03016ec>] rt_spin_lock_slowunlock+0x4c/0x70
 [<c0301fa6>] rt_spin_unlock+0x26/0x30
 [<c015b394>] put_zone_pcp+0x14/0x20
 [<c015c215>] get_page_from_freelist+0x145/0x380
 [<c015c4a4>] __alloc_pages+0x54/0x2d0
 [<c016526d>] __handle_mm_fault+0x7dd/0x9a0
 [<c0304348>] do_page_fault+0x2f8/0x600
 [<c03028fa>] error_code+0x72/0x78
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] _stext+0x3feff000/0x20 SS:ESP 0068:c5099d50
__sched_text_start+0x91e/0xbd0
 [<c030086e>] schedule+0x2e/0x110
 [<c030184e>] rt_spin_lock_slowlock+0x8e/0x170
 [<c0301fd0>] __rt_spin_lock+0x20/0x30
 [<c0301fe8>] rt_spin_lock+0x8/0x10
 [<c015b53b>] get_zone_pcp+0x2b/0x50
 [<c015be97>] free_hot_cold_page+0xc7/0x190
 [<c015bfba>] free_hot_page+0xa/0x10
 [<c015bfe7>] __free_pages+0x27/0x30
 [<c015c016>] free_pages+0x26/0x30
 [<c01765e5>] quicklist_trim+0xc5/0x110
 [<c011875e>] check_pgt_cache+0x1e/0x20
 [<c01033b9>] cpu_idle+0x49/0xb0
 [<c02ff88d>] rest_init+0x6d/0x70
 [<c03c1e01>] start_kernel+0x301/0x3b0
 [<00000000>] _stext+0x3feff000/0x20
 =======================
NMI watchdog detected lockup on CPU#1 (5000/5000)

...
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: appletalk ax25 ipx p8023 snd_rtctimer snd_seq_dummy
snd_pcm_oss snd_mixer_oss snd_seq_midi snd_seq_midi_event snd_seq
w83627hf hwmon_vid button battery hwmon eeprom ac loop dm_mod ohci1394
ieee1394 wacom usbhid snd_ice1712 hid snd_ice17xx_ak4xxx snd_cs46xx
snd_ak4xxx_adda ff_memless snd_cs8427 gameport sk98lin firewire_ohci
snd_i2c snd_mpu401_uart nvidia(P) snd_rawmidi firewire_core
snd_seq_device crc_itu_t snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm
snd_timer ide_cd snd iTCO_wdt soundcore shpchp cdrom snd_page_alloc
pci_hotplug i2c_i801 i2c_core ehci_hcd uhci_hcd usbcore rtc_cmos
rtc_core rtc_lib intel_agp agpgart ext3 mbcache jbd edd fan piix thermal
processor ide_disk ide_core
CPU:    1
EIP:    0060:[<00000000>]    Tainted: P       VLI
EFLAGS: 00010003   (2.6.22.1-rt3.0 #1)
EIP is at _stext+0x3feff000/0x20
eax: c181ca80   ebx: c03bb540   ecx: 00000001   edx: dfca0c30
esi: dfca0c30   edi: 00000001   ebp: d2025b54   esp: d2025b38
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068  preempt:00000003
Process rsync (pid: 18436, ti=d2025000 task=ca152730 task.ti=d2025000)
Stack: c011a8fc 00387b36 000008de c181ca80 c181ca80 00387b36 000008de
d2025b78
       c011b45f 00387b36 000008de 00000001 dfca0c30 00000001 00000001
dfca0c30
       d2025bdc c011e04d d2025be4 c011ddeb 00000000 0000001f c181ca80
0000001f
Call Trace:
 [<c010622a>] show_trace_log_lvl+0x1a/0x30
 [<c01062f6>] show_stack_log_lvl+0xb6/0xe0
 [<c0106521>] show_registers+0x201/0x330
 [<c0106768>] die+0x118/0x260
 [<c03041e3>] do_page_fault+0x193/0x600
 [<c03028fa>] error_code+0x72/0x78
 [<c011b45f>] activate_task+0x4f/0xb0
 [<c011e04d>] try_to_wake_up+0x2bd/0x420
 [<c011e229>] wake_up_process_mutex+0x19/0x20
 [<c014257c>] wakeup_next_waiter+0xec/0x1a0
 [<c03016ec>] rt_spin_lock_slowunlock+0x4c/0x70
 [<c0301fa6>] rt_spin_unlock+0x26/0x30
 [<c015b394>] put_zone_pcp+0x14/0x20
 [<c015c215>] get_page_from_freelist+0x145/0x380
 [<c015c4a4>] __alloc_pages+0x54/0x2d0
 [<c0174e79>] cache_alloc_refill+0x2b9/0x510
 [<c0174bae>] kmem_cache_alloc+0x7e/0x90
 [<f95817a2>] ext3_alloc_inode+0x12/0x50 [ext3]
 [<c018c609>] alloc_inode+0x19/0x190
 [<c018c7ce>] iget_locked+0x4e/0x140
 [<f9581470>] ext3_lookup+0x80/0xe0 [ext3]
 [<c017ffd8>] do_lookup+0x138/0x180
 [<c018219d>] __link_path_walk+0x81d/0xe10
 [<c01827d6>] link_path_walk+0x46/0xd0
 [<c0182879>] path_walk+0x19/0x20
 [<c0182a2b>] do_path_lookup+0x7b/0x220
 [<c0183458>] __user_walk_fd+0x38/0x50
 [<c017be2e>] vfs_lstat_fd+0x1e/0x50
 [<c017bea1>] vfs_lstat+0x11/0x20
 [<c017bec4>] sys_lstat64+0x14/0x30
 [<c01051d2>] sysenter_past_esp+0x5f/0x85
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] _stext+0x3feff000/0x20 SS:ESP 0068:d2025b38
NMI watchdog detected lockup on CPU#1 (5000/5000)

Pid: 18436, comm:                rsync
EIP: 0060:[<c03022b6>] CPU: 1
EIP is at __spin_lock+0x16/0x20
 EFLAGS: 00000082    Tainted: P        (2.6.22.1-rt3.0 #1)
EAX: c181ca80 EBX: c181ca80 ECX: dfc2c1b0 EDX: d2025000
ESI: c0403a80 EDI: dfc2c1b0 EBP: d202598c DS: 007b ES: 007b FS: 00d8
CR0: 8005003b CR2: ffffffd5 CR3: 1027e000 CR4: 000006d0
 [<c010622a>] show_trace_log_lvl+0x1a/0x30
 [<c0106e12>] show_trace+0x12/0x20
 [<c0103af3>] show_regs+0x183/0x190
 [<c0303420>] nmi_watchdog_tick+0x1f0/0x290
 [<c0302e57>] do_nmi+0x77/0x260
 [<c03029a3>] nmi_stack_correct+0x26/0x2b
 [<c011bb77>] task_rq_lock+0x37/0x70
 [<c011e00a>] try_to_wake_up+0x27a/0x420
 [<c011e1c8>] default_wake_function+0x18/0x20
 [<c013689b>] autoremove_wake_function+0x1b/0x50
 [<c011a6a9>] __wake_up_common+0x39/0x60
 [<c01204a3>] __wake_up+0x33/0x60
 [<c012374b>] wake_up_klogd+0x3b/0x40
 [<c01ee247>] bust_spinlocks+0x27/0x30
 [<c01067bc>] die+0x16c/0x260
 [<c03041e3>] do_page_fault+0x193/0x600
 [<c03028fa>] error_code+0x72/0x78
 [<c011b45f>] activate_task+0x4f/0xb0
 [<c011e04d>] try_to_wake_up+0x2bd/0x420
 [<c011e229>] wake_up_process_mutex+0x19/0x20
 [<c014257c>] wakeup_next_waiter+0xec/0x1a0
 [<c03016ec>] rt_spin_lock_slowunlock+0x4c/0x70
 [<c0301fa6>] rt_spin_unlock+0x26/0x30
 [<c015b394>] put_zone_pcp+0x14/0x20
 [<c015c215>] get_page_from_freelist+0x145/0x380
 [<c015c4a4>] __alloc_pages+0x54/0x2d0
 [<c0174e79>] cache_alloc_refill+0x2b9/0x510
 [<c0174bae>] kmem_cache_alloc+0x7e/0x90
 [<f95817a2>] ext3_alloc_inode+0x12/0x50 [ext3]
 [<c018c609>] alloc_inode+0x19/0x190
 [<c018c7ce>] iget_locked+0x4e/0x140
 [<f9581470>] ext3_lookup+0x80/0xe0 [ext3]
 [<c017ffd8>] do_lookup+0x138/0x180
 [<c018219d>] __link_path_walk+0x81d/0xe10
 [<c01827d6>] link_path_walk+0x46/0xd0
 [<c0182879>] path_walk+0x19/0x20
 [<c0182a2b>] do_path_lookup+0x7b/0x220
 [<c0183458>] __user_walk_fd+0x38/0x50
 [<c017be2e>] vfs_lstat_fd+0x1e/0x50
 [<c017bea1>] vfs_lstat+0x11/0x20
 [<c017bec4>] sys_lstat64+0x14/0x30
 [<c01051d2>] sysenter_past_esp+0x5f/0x85
 =======================
NMI watchdog detected lockup on CPU#0 (0/5000)

...
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: appletalk ax25 ipx p8023 snd_rtctimer snd_seq_dummy
snd_pcm_oss snd_mixer_oss snd_seq_midi snd_seq_midi_event snd_seq button
battery ac w83627hf hwmon_vid hwmon eeprom loop dm_mod wacom usbhid hid
ff_memless nvidia(P) snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_cs46xx sk98lin snd_i2c gameport snd_mpu401_uart
snd_rawmidi snd_seq_device ohci1394 ieee1394 snd_intel8x0 snd_ac97_codec
ac97_bus snd_pcm firewire_ohci firewire_core snd_timer crc_itu_t ide_cd
cdrom shpchp intel_agp snd i2c_i801 iTCO_wdt agpgart pci_hotplug
i2c_core soundcore ehci_hcd snd_page_alloc uhci_hcd usbcore rtc_cmos
rtc_core rtc_lib ext3 mbcache jbd edd fan piix thermal processor
ide_disk ide_core
CPU:    0
EIP:    0060:[<00000000>]    Tainted: P       VLI
EFLAGS: 00213003   (2.6.22.1-rt3.0 #1)
EIP is at _stext+0x3feff000/0x20
eax: c1812a80   ebx: c03bb540   ecx: 00000001   edx: c038e3c0
esi: c038e3c0   edi: 00000001   ebp: f4fb0d6c   esp: f4fb0d50
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068  preempt:00000003
Process Xorg (pid: 4145, ti=f4fb0000 task=dfd8c6b0 task.ti=f4fb0000)
Stack: c011a8fc f00c393c 00000b0a c1812a80 c1812a80 f00c393c 00000b0a
f4fb0d90
       c011b45f f00c393c 00000b0a 00000001 c038e3c0 00000000 00000000
c038e3c0
       f4fb0df4 c011e04d 00000000 c180d000 00000000 0000001f c1812a80
f4fb0e20
Call Trace:
 [<c010622a>] show_trace_log_lvl+0x1a/0x30
 [<c01062f6>] show_stack_log_lvl+0xb6/0xe0
 [<c0106521>] show_registers+0x201/0x330
 [<c0106768>] die+0x118/0x260
 [<c03041e3>] do_page_fault+0x193/0x600
 [<c03028fa>] error_code+0x72/0x78
 [<c011b45f>] activate_task+0x4f/0xb0
 [<c011e04d>] try_to_wake_up+0x2bd/0x420
 [<c011e229>] wake_up_process_mutex+0x19/0x20
 [<c014257c>] wakeup_next_waiter+0xec/0x1a0
 [<c03016ec>] rt_spin_lock_slowunlock+0x4c/0x70
 [<c0301fa6>] rt_spin_unlock+0x26/0x30
 [<c015b394>] put_zone_pcp+0x14/0x20
 [<c015c215>] get_page_from_freelist+0x145/0x380
 [<c015c51f>] __alloc_pages+0xcf/0x2d0
 [<c016526d>] __handle_mm_fault+0x7dd/0x9a0
 [<c0304348>] do_page_fault+0x2f8/0x600
 [<c03028fa>] error_code+0x72/0x78
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] _stext+0x3feff000/0x20 SS:ESP 0068:f4fb0d50
NMI watchdog detected lockup on CPU#1 (5000/5000)

Pid: 2779, comm:                klogd
EIP: 0060:[<c03022b9>] CPU: 1
EIP is at __spin_lock+0x19/0x20
 EFLAGS: 00000082    Tainted: P        (2.6.22.1-rt3.0 #1)
EAX: c1812a80 EBX: c1812a80 ECX: 00000001 EDX: f4d11000
ESI: c0403a80 EDI: dff1c1b0 EBP: f4d11d1c DS: 007b ES: 007b FS: 00d8
CR0: 8005003b CR2: b7faa000 CR3: 1fe08000 CR4: 000006d0
 [<c010622a>] show_trace_log_lvl+0x1a/0x30
 [<c0106e12>] show_trace+0x12/0x20
 [<c0103af3>] show_regs+0x183/0x190
 [<c0303420>] nmi_watchdog_tick+0x1f0/0x290
 [<c0302e57>] do_nmi+0x77/0x260
 [<c03029a3>] nmi_stack_correct+0x26/0x2b
 [<c011bb77>] task_rq_lock+0x37/0x70
 [<c011ddb7>] try_to_wake_up+0x27/0x420
 [<c011e1c8>] default_wake_function+0x18/0x20
 [<c011a6a9>] __wake_up_common+0x39/0x60
 [<c012050b>] __wake_up_sync+0x3b/0x50
 [<c02939b9>] sock_def_readable+0x79/0x80
 [<c02fafc0>] unix_dgram_sendmsg+0x450/0x500
 [<c028eff4>] sock_aio_write+0x114/0x130
 [<c0178160>] do_sync_write+0xd0/0x110
 [<c0178a5d>] vfs_write+0x14d/0x160
 [<c017907d>] sys_write+0x3d/0x70
 [<c01051d2>] sysenter_past_esp+0x5f/0x85
 =======================
NMI watchdog detected lockup on CPU#0 (0/5000)

...

Here are the complete console captures:

  http://www.rncbc.org/datahub/console-2.6.22.1-rt3.0-1.log
  http://www.rncbc.org/datahub/console-2.6.22.1-rt3.0-2.log
  http://www.rncbc.org/datahub/console-2.6.22.1-rt3.0-3.log

.config evidence:

  http://www.rncbc.org/datahub/config-2.6.22.1-rt3.0

Cheers.
--
rncbc aka Rui Nuno Capela
