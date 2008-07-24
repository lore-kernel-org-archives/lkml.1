Return-Path: <linux-kernel-owner+w=401wt.eu-S1751990AbYGXBxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbYGXBxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 21:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYGXBwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 21:52:53 -0400
Received: from cg-p00-ob.rzone.de ([81.169.146.192]:43974 "EHLO
	cg-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbYGXBww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 21:52:52 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 21:52:52 EDT
X-RZG-CLASS-ID: cg00
Date: Thu, 24 Jul 2008 03:46:13 +0200 (MEST)
Message-Id: <200807240146.m6O1kDRS027098@post.webmailer.de>
To: linux-kernel@vger.kernel.org
From: c4p7n1@capitanio.org
Subject: [BUGs] in the flood v2.6.26..20b7997e8ab
Cc: c4p7n1@capitanio.org
X-Priority: 3
X-Abuse: 383041 / 79.220.252.223
X-RZG-MBID: 1GeNaoUet6Qfjg==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI the curent linus' git tree (20b7997e8abdf) is not running well here:

[   65.904324] ------------[ cut here ]------------
[   65.904344] WARNING: at net/core/dev.c:1344 __netif_schedule+0x56/0x70()
[   65.904350] Modules linked in: af_packet i915 drm rfcomm l2cap bluetooth sbs sbshc acpi_cpufreq cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative iptable_filter ip_tables x_tables ebtable_broute bridge stp llc ebtable_nat ebtable_filter ebtables coretemp hwmon fuse arc4 ecb usbhid hid rtl8187 mac80211 uvcvideo compat_ioctl32 videodev eeprom_93cx6 v4l1_compat cfg80211 joydev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi video backlight output snd_seq_midi_event evdev snd_seq psmouse snd_timer snd_seq_device r8169 snd soundcore uhci_hcd ehci_hcd usbcore iTCO_wdt iTCO_vendor_support
[   65.904499] Pid: 1357, comm: rtl8187 Not tainted 2.6.26c4p7n-06214-gee05e2b #1
[   65.904509]  [<c0126d5f>] warn_on_slowpath+0x5f/0x90
[   65.904538]  [<f8934a70>] urb_destroy+0x0/0x20 [usbcore]
[   65.904585]  [<f89353c1>] usb_start_wait_urb+0x71/0xc0 [usbcore]
[   65.904628]  [<f893563b>] usb_control_msg+0xdb/0x100 [usbcore]
[   65.904665]  [<c011dbce>] __wake_up+0x3e/0x60
[   65.904673]  [<c0136f7b>] insert_work+0x4b/0x70
[   65.904681]  [<c0137317>] __queue_work+0x27/0x40
[   65.904688]  [<c03671b6>] __netif_schedule+0x56/0x70
[   65.904698]  [<f8bff244>] ieee80211_scan_completed+0x204/0x2a0 [mac80211]
[   65.904736]  [<f8c02940>] ieee80211_sta_scan_work+0x0/0x1d0 [mac80211]
[   65.904770]  [<c0136e2a>] run_workqueue+0x7a/0x120
[   65.904778]  [<c01376c0>] worker_thread+0x0/0xe0
[   65.904785]  [<c0137740>] worker_thread+0x80/0xe0
[   65.904791]  [<c013a340>] autoremove_wake_function+0x0/0x40
[   65.904800]  [<c01376c0>] worker_thread+0x0/0xe0
[   65.904807]  [<c013a032>] kthread+0x42/0x70
[   65.904813]  [<c0139ff0>] kthread+0x0/0x70
[   65.904820]  [<c0104963>] kernel_thread_helper+0x7/0x14
[   65.904829]  =======================
[   65.904834] ---[ end trace 45931c11df3cd2dc ]---


[  103.456557] BUG: unable to handle kernel NULL pointer dereference at 00000002
[  103.456566] IP: [<c0122293>] sched_power_savings_store+0x13/0x70
[  103.456575] *pde = 00000000 
[  103.456580] Oops: 0000 [#1] PREEMPT SMP 
[  103.456585] Modules linked in: af_packet i915 drm rfcomm l2cap bluetooth sbs sbshc acpi_cpufreq cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative iptable_filter ip_tables x_tables ebtable_broute bridge stp llc ebtable_nat ebtable_filter ebtables coretemp hwmon fuse arc4 ecb usbhid hid rtl8187 mac80211 uvcvideo compat_ioctl32 videodev eeprom_93cx6 v4l1_compat cfg80211 joydev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi video backlight output snd_seq_midi_event evdev snd_seq psmouse snd_timer snd_seq_device r8169 snd soundcore uhci_hcd ehci_hcd usbcore iTCO_wdt iTCO_vendor_support
[  103.456635] 
[  103.456638] Pid: 3719, comm: sched-powersave Tainted: G        W (2.6.26c4p7n-06214-gee05e2b #1)
[  103.456641] EIP: 0060:[<c0122293>] EFLAGS: 00010296 CPU: 1
[  103.456645] EIP is at sched_power_savings_store+0x13/0x70
[  103.456647] EAX: 00000002 EBX: 00000000 ECX: ffffffea EDX: c04dfd18
[  103.456649] ESI: c04dfd18 EDI: eb421000 EBP: 00000002 ESP: eb449f3c
[  103.456651]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  103.456654] Process sched-powersave (pid: 3719, ti=eb448000 task=ec3a32c0 task.ti=eb448000)
[  103.456656] Stack: c0122300 c04e0024 c02f0849 c04dfd18 f7c0a6f0 c04e0024 c01cd6c0 00000002 
[  103.456662]        095e1408 ec3b63c0 ec1b1fd4 c04dfd18 ec3b63c0 095e1408 00000002 c01cd600 
[  103.456668]        c018adab eb449fa0 ec3b63c0 ec3b63c0 fffffff7 095e1408 eb448000 c018b2e1 
[  103.456674] Call Trace:
[  103.456677]  [<c0122300>] sched_mc_power_savings_store+0x0/0x10
[  103.456682]  [<c02f0849>] sysdev_class_store+0x29/0x40
[  103.456687]  [<c01cd6c0>] sysfs_write_file+0xc0/0x110
[  103.456694]  [<c01cd600>] sysfs_write_file+0x0/0x110
[  103.456698]  [<c018adab>] vfs_write+0x9b/0x120
[  103.456703]  [<c018b2e1>] sys_write+0x41/0x70
[  103.456707]  [<c0103d25>] sysenter_past_esp+0x6a/0x91
[  103.456711]  [<c03e0000>] cond_resched_softirq+0x20/0x50
[  103.456717]  =======================
[  103.456718] Code: ff 89 c3 b8 c8 13 4d c0 e8 fb e1 2b 00 e8 d6 67 00 00 89 d8 5b c3 66 90 83 ec 08 89 1c 24 89 cb b9 ea ff ff ff 89 74 24 04 89 d6 <0f> b6 10 8d 42 d0 3c 01 76 13 8b 1c 24 89 c8 8b 74 24 04 83 c4 
[  103.456749] EIP: [<c0122293>] sched_power_savings_store+0x13/0x70 SS:ESP 0068:eb449f3c
[  103.456756] ---[ end trace 45931c11df3cd2dc ]---

executing a powertop 1.9 gives always:

[ 2039.880148] BUG: unable to handle kernel paging request at c0120cd0
[ 2039.880154] IP: [<c0283a58>] number+0x1f8/0x330
[ 2039.880161] *pde = 005c7067 *pte = 00120161
[ 2039.880166] Oops: 0003 [#2] PREEMPT SMP 
[ 2039.880170] Modules linked in: af_packet i915 drm rfcomm l2cap bluetooth sbs sbshc acpi_cpufreq cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative iptable_filter ip_tables x_tables ebtable_broute bridge stp llc ebtable_nat ebtable_filter ebtables coretemp hwmon fuse arc4 ecb usbhid hid rtl8187 mac80211 uvcvideo compat_ioctl32 videodev eeprom_93cx6 v4l1_compat cfg80211 joydev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi video backlight output snd_seq_midi_event evdev snd_seq psmouse snd_timer snd_seq_device r8169 snd soundcore uhci_hcd ehci_hcd usbcore iTCO_wdt iTCO_vendor_support
[ 2039.880215] 
[ 2039.880218] Pid: 4181, comm: powertop Tainted: G      D W (2.6.26c4p7n-06214-gee05e2b #1)
[ 2039.880221] EIP: 0060:[<c0283a58>] EFLAGS: 00010202 CPU: 0
[ 2039.880223] EIP is at number+0x1f8/0x330
[ 2039.880225] EAX: 00000030 EBX: 00000000 ECX: ea26bdab EDX: c0120cd0
[ 2039.880227] ESI: c0120cd0 EDI: ffffffff EBP: 00000001 ESP: ea26bd88
[ 2039.880230]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 2039.880232] Process powertop (pid: 4181, ti=ea26a000 task=ea077660 task.ti=ea26a000)
[ 2039.880234] Stack: fffffffc ea26bdaa 00001f77 00000000 f7f6f500 fffffffd fffffffc 00000001 
[ 2039.880240]        f730a790 00000246 00000246 ebd91c00 c019c3dc f7808300 4c0c797e ebd91c08 
[ 2039.880246]        ea26be54 ea26be40 00000000 00000016 ea202018 ea26be40 00000000 ebd91c00 
[ 2039.880251] Call Trace:
[ 2039.880254]  [<c019c3dc>] __d_lookup+0xac/0x120
[ 2039.880259]  [<c0120cd0>] sched_mc_power_savings_show+0x0/0x20
[ 2039.880265]  [<c02844b1>] vsnprintf+0x2d1/0x5a0
[ 2039.880268]  [<c0120cd0>] sched_mc_power_savings_show+0x0/0x20
[ 2039.880271]  [<c01a1218>] mntput_no_expire+0x18/0x110
[ 2039.880275]  [<c019ba94>] dput+0x14/0xd0
[ 2039.880278]  [<c01942b1>] path_walk+0x51/0x90
[ 2039.880281]  [<c01ce84c>] sysfs_put_active_two+0xc/0x20
[ 2039.880286]  [<c01cd550>] sysfs_open_file+0x110/0x1c0
[ 2039.880290]  [<c0194527>] do_path_lookup+0x77/0x1d0
[ 2039.880293]  [<c016b1e6>] get_page_from_freelist+0x2c6/0x4d0
[ 2039.880298]  [<c016b617>] __alloc_pages_internal+0xa7/0x410
[ 2039.880301]  [<c02847a0>] sprintf+0x20/0x30
[ 2039.880304]  [<c0120cec>] sched_mc_power_savings_show+0x1c/0x20
[ 2039.880307]  [<c0120cd0>] sched_mc_power_savings_show+0x0/0x20
[ 2039.880310]  [<c02f0811>] sysdev_class_show+0x21/0x30
[ 2039.880315]  [<c01cd793>] sysfs_read_file+0x83/0x120
[ 2039.880318]  [<c0269dbc>] security_file_permission+0xc/0x10
[ 2039.880322]  [<c01cd710>] sysfs_read_file+0x0/0x120
[ 2039.880326]  [<c018aec9>] vfs_read+0x99/0x120
[ 2039.880330]  [<c018b271>] sys_read+0x41/0x70
[ 2039.880333]  [<c0103d25>] sysenter_past_esp+0x6a/0x91
[ 2039.880336]  [<c03e0000>] cond_resched_softirq+0x20/0x50
[ 2039.880341]  =======================
[ 2039.880343] Code: 06 30 83 e8 01 83 c6 01 39 c5 7e ef 89 eb 83 eb 01 78 2a 8d 54 24 22 89 d1 89 54 24 04 01 e9 89 f2 66 90 39 d7 76 06 0f b6 41 ff <88> 02 83 c2 01 83 e9 01 3b 4c 24 04 75 ea 8d 74 1e 01 8b 4c 24 
[ 2039.880374] EIP: [<c0283a58>] number+0x1f8/0x330 SS:ESP 0068:ea26bd88
[ 2039.880378] ---[ end trace 45931c11df3cd2dc ]---


config http://capitanio.org/kernel/config-git20b7997e8abdf 
(may include some nonsense, going thru the menuconfig is a ...)

make 2> http://capitanio.org/kernel/log-git20b7997e8abdf 
many warnings like:

arch/x86/mm/pgtable.c: In function 'pgd_mop_up_pmds':
arch/x86/mm/pgtable.c:194: warning: unused variable 'pmd'
WARNING: arch/x86/kernel/built-in.o(.text+0x50e): Section mismatch in reference from the function cpu_exit_clear() to the function .cpuinit.text:cpu_uninit()
The function cpu_exit_clear() references
the function __cpuinit cpu_uninit().
This is often because cpu_exit_clear lacks a __cpuinit
annotation or the annotation of cpu_uninit is wrong.
...

http://capitanio.org/kernel/toshiba-l300-lspci
http://capitanio.org/kernel/dmesg-git20b7997e8abdf


