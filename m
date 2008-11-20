Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYKTIL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYKTIL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYKTILr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:11:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:55768 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYKTILo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=f4O3UdrJxOAFQuM3lqi7ZQAgv/VuX5wQYoK7dBvU0SLQEJWcnR71gYVFCKcoT8jznf
         SOz/RRPsH26+lJ4IotElXmhQAcbjI6SqoWeEMXJvR01gABXEFwjnpf/9Nl+ONKfZEvOj
         MI2yxj+wjQ6ol+AVoTuONBAC2jyZDBr1DHgss=
Subject: processors core stuck in full throttle after waking up from s2ram
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 00:11:39 -0800
Message-Id: <1227168699.4276.24.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(before getting into this I need to see if somebody else with a macbook
pro(ATI with radeon drivers) is experiencing the same issue?)
I'm not sure I this is caused by the kernel or the program s2ram.
when I cat watch /proc/cpuinfo I see: (after waking up from suspend.)

Every 2.0s: cat /proc/cpuinfo
Wed Nov 19 23:49:13 2008

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping        : 6
cpu MHz         : 2167.000  
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx
 est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips        : 4322.49
clflush size    : 64
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping        : 6
cpu MHz         : 1000.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx
 est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips        : 4322.60
clflush size    : 64
power management:


the processor is full throttle on one of the cores.

if I issue the command:
powersave -e powersave
powersave -l

to trip the powersave module and then unlplug the A/C to trip ondemand
it seems to help, but for some reason the system its just roaring(fans)
not calming down as normally.
below is dmesg of suspend(there seems to be some kind of circular
locking dependency as well.) At the time there is a large number of
avc's cluttering dmesg, so I just cut the suspend part.(let me know if
you need all of dmesg).



[ 2118.923832] PM: Syncing filesystems ... done.
[ 2118.943711] Freezing user space processes ... (elapsed 0.02 seconds)
done.
[ 2118.968122] Freezing remaining freezable tasks ... (elapsed 0.00
seconds) done.
[ 2118.968262] Suspending console(s) (use no_console_suspend to debug)
[ 2118.971931] btusb_intr_complete: hci0 urb f4067d10 failed to resubmit
(2)
[ 2118.972923] btusb_bulk_complete: hci0 urb f3f970b0 failed to resubmit
(2)
[ 2118.972944] btusb_bulk_complete: hci0 urb f3f97580 failed to resubmit
(2)
[ 2119.240293] 
[ 2119.240296] =======================================================
[ 2119.240299] [ INFO: possible circular locking dependency detected ]
[ 2119.240304] 2.6.28-rc5-00118-geef8eed #2
[ 2119.240307] -------------------------------------------------------
[ 2119.240310] s2ram/4147 is trying to acquire lock:
[ 2119.240313]  (&usbhid->setup){--..}, at: [<c0319075>] hid_suspend
+0x21/0x6a
[ 2119.240325] 
[ 2119.240327] but task is already holding lock:
[ 2119.240329]  (&dev->pm_mutex/1){--..}, at: [<c02ed6ff>]
usb_external_suspend_device+0x25/0x45
[ 2119.240341] 
[ 2119.240342] which lock already depends on the new lock.
[ 2119.240344] 
[ 2119.240346] 
[ 2119.240347] the existing dependency chain (in reverse order) is:
[ 2119.240350] 
[ 2119.240352] -> #2 (&dev->pm_mutex/1){--..}:
[ 2119.240358]        [<c0147796>] __lock_acquire+0xf8d/0x1272
[ 2119.240366]        [<c0147aeb>] lock_acquire+0x70/0x97
[ 2119.240371]        [<c03cf62a>] mutex_lock_nested+0xd2/0x26d
[ 2119.240379]        [<c02ed067>] usb_autopm_do_interface+0x30/0xbd
[ 2119.240385]        [<c02ed10d>] usb_autopm_get_interface+0xd/0xf
[ 2119.240391]        [<c0319fb8>] usbhid_open+0x27/0x53
[ 2119.240396]        [<c0313b12>] hidinput_open+0x12/0x14
[ 2119.240403]        [<c02fcd39>] input_open_device+0x58/0x84
[ 2119.240409]        [<c0295a67>] kbd_connect+0x6e/0x8a
[ 2119.240416]        [<c02fc623>] input_attach_handler+0x33/0x66
[ 2119.240423]        [<c02fd805>] input_register_device+0x143/0x189
[ 2119.240428]        [<c03161f4>] hidinput_connect+0x2619/0x2647
[ 2119.240434]        [<c03130af>] hid_connect+0x7a/0x221
[ 2119.240440]        [<c0316b51>] apple_probe+0xbe/0x11b
[ 2119.240446]        [<c03132d0>] hid_device_probe+0x7a/0xe7
[ 2119.240451]        [<c02a1e4a>] driver_probe_device+0xa0/0x13c
[ 2119.240458]        [<c02a1f5f>] __device_attach+0x8/0xa
[ 2119.240463]        [<c02a15fa>] bus_for_each_drv+0x3f/0x69
[ 2119.240468]        [<c02a1fd0>] device_attach+0x50/0x64
[ 2119.240473]        [<c02a1445>] bus_attach_device+0x24/0x4e
[ 2119.240478]        [<c02a0549>] device_add+0x3eb/0x51e
[ 2119.240484]        [<c0313019>] hid_add_device+0x12c/0x148
[ 2119.240490]        [<c03197c2>] hid_probe+0x263/0x2a7
[ 2119.240495]        [<c02ed20c>] usb_probe_interface+0xf0/0x123
[ 2119.240501]        [<c02a1e4a>] driver_probe_device+0xa0/0x13c
[ 2119.240506]        [<c02a1f5f>] __device_attach+0x8/0xa
[ 2119.240511]        [<c02a15fa>] bus_for_each_drv+0x3f/0x69
[ 2119.240516]        [<c02a1fd0>] device_attach+0x50/0x64
[ 2119.240521]        [<c02a1445>] bus_attach_device+0x24/0x4e
[ 2119.240527]        [<c02a0549>] device_add+0x3eb/0x51e
[ 2119.240532]        [<c02ec532>] usb_set_configuration+0x402/0x44b
[ 2119.240538]        [<c02f28e7>] generic_probe+0x44/0x7d
[ 2119.240544]        [<c02ec70e>] usb_probe_device+0x32/0x38
[ 2119.240550]        [<c02a1e4a>] driver_probe_device+0xa0/0x13c
[ 2119.240555]        [<c02a1f5f>] __device_attach+0x8/0xa
[ 2119.240560]        [<c02a15fa>] bus_for_each_drv+0x3f/0x69
[ 2119.240565]        [<c02a1fd0>] device_attach+0x50/0x64
[ 2119.240570]        [<c02a1445>] bus_attach_device+0x24/0x4e
[ 2119.240575]        [<c02a0549>] device_add+0x3eb/0x51e
[ 2119.240580]        [<c02e74f5>] usb_new_device+0x4d/0x8e
[ 2119.240586]        [<c02e8747>] hub_thread+0x96e/0xe01
[ 2119.240591]        [<c0138cd5>] kthread+0x3b/0x61
[ 2119.240598]        [<c01040cb>] kernel_thread_helper+0x7/0x10
[ 2119.240605]        [<ffffffff>] 0xffffffff
[ 2119.240622] 
[ 2119.240623] -> #1 (&dev->mutex){--..}:
[ 2119.240627]        [<c0147796>] __lock_acquire+0xf8d/0x1272
[ 2119.240633]        [<c0147aeb>] lock_acquire+0x70/0x97
[ 2119.240638]        [<c03cf62a>] mutex_lock_nested+0xd2/0x26d
[ 2119.240645]        [<c02fd0b7>] input_unregister_device+0x1a/0x16b
[ 2119.240650]        [<c0313b5d>] hidinput_disconnect+0x35/0x49
[ 2119.240656]        [<c031989d>] usbhid_stop+0x34/0x131
[ 2119.240661]        [<c0312504>] hid_device_remove+0x2c/0x3b
[ 2119.240667]        [<c02a1bef>] __device_release_driver+0x78/0x96
[ 2119.240673]        [<c02a1cc2>] device_release_driver+0x1b/0x26
[ 2119.240678]        [<c02a1407>] bus_remove_device+0x90/0xaa
[ 2119.240683]        [<c02a00ac>] device_del+0xe1/0x133
[ 2119.240689]        [<c03126d4>] hid_destroy_device+0x1a/0x2f
[ 2119.240694]        [<c03190f6>] hid_disconnect+0x2a/0x34
[ 2119.240699]        [<c02ed4bd>] usb_unbind_interface+0x51/0xa1
[ 2119.240705]        [<c02a1bef>] __device_release_driver+0x78/0x96
[ 2119.240710]        [<c02a1cc2>] device_release_driver+0x1b/0x26
[ 2119.240716]        [<c02a1407>] bus_remove_device+0x90/0xaa
[ 2119.240721]        [<c02a00ac>] device_del+0xe1/0x133
[ 2119.240726]        [<c02eb203>] usb_disable_device+0x63/0xc1
[ 2119.240732]        [<c02e75ac>] usb_disconnect+0x76/0x112
[ 2119.240737]        [<c02e8328>] hub_thread+0x54f/0xe01
[ 2119.240742]        [<c0138cd5>] kthread+0x3b/0x61
[ 2119.240748]        [<c01040cb>] kernel_thread_helper+0x7/0x10
[ 2119.240754]        [<ffffffff>] 0xffffffff
[ 2119.240773] 
[ 2119.240774] -> #0 (&usbhid->setup){--..}:
[ 2119.240779]        [<c0147520>] __lock_acquire+0xd17/0x1272
[ 2119.240785]        [<c0147aeb>] lock_acquire+0x70/0x97
[ 2119.240790]        [<c03cf62a>] mutex_lock_nested+0xd2/0x26d
[ 2119.240796]        [<c0319075>] hid_suspend+0x21/0x6a
[ 2119.240801]        [<c02ecec7>] usb_suspend_both+0xbf/0x22f
[ 2119.240807]        [<c02ed70f>] usb_external_suspend_device+0x35/0x45
[ 2119.240813]        [<c02ed750>] usb_suspend+0x31/0x37
[ 2119.240819]        [<c02e5200>] usb_dev_suspend+0xd/0xf
[ 2119.240824]        [<c02a43ee>] pm_op+0x45/0xbf
[ 2119.240830]        [<c02a48f8>] device_suspend+0x274/0x3a9
[ 2119.240835]        [<c0150fdf>] suspend_devices_and_enter+0x38/0x123
[ 2119.240842]        [<c0151208>] enter_state+0xf4/0x146
[ 2119.240847]        [<c01512e9>] state_store+0x8f/0xa2
[ 2119.240851]        [<c022d7b1>] kobj_attr_store+0x1a/0x22
[ 2119.240859]        [<c01bc6dd>] sysfs_write_file+0xb9/0xe4
[ 2119.240866]        [<c01865ca>] vfs_write+0x8a/0x104
[ 2119.240873]        [<c01866dd>] sys_write+0x3b/0x60
[ 2119.240878]        [<c01031eb>] sysenter_do_call+0x12/0x3f
[ 2119.240884]        [<ffffffff>] 0xffffffff
[ 2119.240896] 
[ 2119.240898] other info that might help us debug this:
[ 2119.240900] 
[ 2119.240903] 3 locks held by s2ram/4147:
[ 2119.240905]  #0:  (&buffer->mutex){--..}, at: [<c01bc649>]
sysfs_write_file+0x25/0xe4
[ 2119.240915]  #1:  (pm_mutex){--..}, at: [<c0151251>] enter_state
+0x13d/0x146
[ 2119.240923]  #2:  (&dev->pm_mutex/1){--..}, at: [<c02ed6ff>]
usb_external_suspend_device+0x25/0x45
[ 2119.240933] 
[ 2119.240934] stack backtrace:
[ 2119.240938] Pid: 4147, comm: s2ram Not tainted
2.6.28-rc5-00118-geef8eed #2
[ 2119.240942] Call Trace:
[ 2119.240947]  [<c03ce35f>] ? printk+0xf/0x18
[ 2119.240953]  [<c01464fa>] print_circular_bug_tail+0x9a/0xa5
[ 2119.240959]  [<c0147520>] __lock_acquire+0xd17/0x1272
[ 2119.240965]  [<c0147a62>] ? __lock_acquire+0x1259/0x1272
[ 2119.240971]  [<c0147aeb>] lock_acquire+0x70/0x97
[ 2119.240977]  [<c0319075>] ? hid_suspend+0x21/0x6a
[ 2119.240983]  [<c03cf62a>] mutex_lock_nested+0xd2/0x26d
[ 2119.240988]  [<c0319075>] ? hid_suspend+0x21/0x6a
[ 2119.240992]  [<c0319075>] ? hid_suspend+0x21/0x6a
[ 2119.240998]  [<c03cf7a9>] ? mutex_lock_nested+0x251/0x26d
[ 2119.241004]  [<c0319075>] hid_suspend+0x21/0x6a
[ 2119.241009]  [<c02ecec7>] usb_suspend_both+0xbf/0x22f
[ 2119.241016]  [<c02ed70f>] usb_external_suspend_device+0x35/0x45
[ 2119.241021]  [<c02ed750>] usb_suspend+0x31/0x37
[ 2119.241026]  [<c02e5200>] usb_dev_suspend+0xd/0xf
[ 2119.241032]  [<c02a43ee>] pm_op+0x45/0xbf
[ 2119.241038]  [<c02a48f8>] device_suspend+0x274/0x3a9
[ 2119.241044]  [<c0150fdf>] suspend_devices_and_enter+0x38/0x123
[ 2119.241049]  [<c0151208>] enter_state+0xf4/0x146
[ 2119.241054]  [<c01512e9>] state_store+0x8f/0xa2
[ 2119.241059]  [<c015125a>] ? state_store+0x0/0xa2
[ 2119.241065]  [<c022d7b1>] kobj_attr_store+0x1a/0x22
[ 2119.241071]  [<c01bc6dd>] sysfs_write_file+0xb9/0xe4
[ 2119.241077]  [<c01bc624>] ? sysfs_write_file+0x0/0xe4
[ 2119.241083]  [<c01865ca>] vfs_write+0x8a/0x104
[ 2119.241089]  [<c01866dd>] sys_write+0x3b/0x60
[ 2119.241094]  [<c01031eb>] sysenter_do_call+0x12/0x3f
[ 2119.300233] sd 2:0:1:0: [sda] Synchronizing SCSI cache
[ 2119.300567] sd 2:0:1:0: [sda] Stopping disk
[ 2119.500111] Clocksource tsc unstable (delta = -208687214 ns)
[ 2120.270299] ath9k 0000:03:00.0: PCI INT A disabled
[ 2120.290699] ata_piix 0000:00:1f.2: PCI INT B disabled
[ 2120.310295] ata_piix 0000:00:1f.1: PCI INT A disabled
[ 2120.310909] ata_piix 0000:00:1f.1: power state changed by ACPI to D3
[ 2120.311154] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[ 2120.330194] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[ 2120.330262] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 2120.330329] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 2120.330396] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 2120.330702] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 2120.353416] ACPI: Preparing to enter system sleep state S3
[ 2120.355350] Disabling non-boot CPUs ...
[ 2120.357824] kvm: disabling virtualization on CPU1
[ 2120.357849] CPU 1 is now offline
[ 2120.357853] lockdep: fixing up alternatives.
[ 2120.357856] SMP alternatives: switching to UP code
[ 2120.587059] CPU0 attaching NULL sched-domain.
[ 2120.587063] CPU1 attaching NULL sched-domain.
[ 2120.589384] CPU0 attaching NULL sched-domain.
[ 2120.589718] CPU1 is down
[ 2120.589812] Extended CMOS year: 2000
[ 2120.589812] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[ 2120.589812] Intel machine check architecture supported.
[ 2120.589812] Intel machine check reporting enabled on CPU#0.
[ 2120.589812] Back to C!
[ 2120.589812] Extended CMOS year: 2000
[ 2120.589812] Enabling non-boot CPUs ...
[ 2120.590311] lockdep: fixing up alternatives.
[ 2120.590313] SMP alternatives: switching to SMP code
[ 2120.720409] Booting processor 1 APIC 0x1 ip 0x6000
[ 2120.586767] Initializing CPU#1
[ 2120.586767] Calibrating delay using timer specific routine.. 4322.60
BogoMIPS (lpj=21613038)
[ 2120.586767] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 2120.586767] CPU: L2 cache: 4096K
[ 2120.586767] CPU: Physical Processor ID: 0
[ 2120.586767] CPU: Processor Core ID: 1
[ 2120.586767] Intel machine check architecture supported.
[ 2120.586767] Intel machine check reporting enabled on CPU#1.
[ 2120.586767] x86 PAT enabled: cpu 1, old 0x7040600070406, new
0x7010600070106
[ 2120.881750] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping 06
[ 2120.881771] kvm: enabling virtualization on CPU1
[ 2120.881819] CPU0 attaching NULL sched-domain.
[ 2120.882515] Switched to high resolution mode on CPU 1
[ 2120.884233] CPU0 attaching sched-domain:
[ 2120.884237]  domain 0: span 0-1 level MC
[ 2120.884238]   groups: 0 1
[ 2120.884244] CPU1 attaching sched-domain:
[ 2120.884246]  domain 0: span 0-1 level MC
[ 2120.884248]   groups: 1 0
[ 2120.892526] CPU1 is up
[ 2120.892528] ACPI: Waking up from system sleep state S3
[ 2121.093468] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[ 2121.258250] pci 0000:00:01.0: restoring config space at offset 0xf
(was 0x80100, writing 0x8010b)
[ 2121.258268] pci 0000:00:01.0: restoring config space at offset 0xa
(was 0xf, writing 0x0)
[ 2121.258277] pci 0000:00:01.0: restoring config space at offset 0x9
(was 0x1fff1, writing 0x47f14001)
[ 2121.258286] pci 0000:00:01.0: restoring config space at offset 0x8
(was 0xfff0, writing 0x50305030)
[ 2121.258294] pci 0000:00:01.0: restoring config space at offset 0x7
(was 0xf0, writing 0x3030)
[ 2121.258303] pci 0000:00:01.0: restoring config space at offset 0x6
(was 0x0, writing 0x10100)
[ 2121.258315] pci 0000:00:01.0: restoring config space at offset 0x3
(was 0x10000, writing 0x10040)
[ 2121.258325] pci 0000:00:01.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100007)
[ 2121.258366] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[ 2121.258374] pci 0000:00:01.0: setting latency timer to 64
[ 2121.258392] pci 0000:00:07.0: restoring config space at offset 0xf
(was 0x100, writing 0x10b)
[ 2121.258419] pci 0000:00:07.0: restoring config space at offset 0x4
(was 0x0, writing 0x50404000)
[ 2121.258431] pci 0000:00:07.0: restoring config space at offset 0x1
(was 0xb00000, writing 0xb00002)
[ 2121.270161] HDA Intel 0000:00:1b.0: restoring config space at offset
0xf (was 0x100, writing 0x10a)
[ 2121.270199] HDA Intel 0000:00:1b.0: restoring config space at offset
0x4 (was 0x4, writing 0x50400004)
[ 2121.270210] HDA Intel 0000:00:1b.0: restoring config space at offset
0x3 (was 0x0, writing 0x40)
[ 2121.270222] HDA Intel 0000:00:1b.0: restoring config space at offset
0x1 (was 0x100000, writing 0x100002)
[ 2121.270261] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low)
-> IRQ 22
[ 2121.270274] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 2121.270365] pci 0000:00:1c.0: restoring config space at offset 0x9
(was 0x10001, writing 0x50515051)
[ 2121.270376] pci 0000:00:1c.0: restoring config space at offset 0x8
(was 0x0, writing 0x50205020)
[ 2121.270386] pci 0000:00:1c.0: restoring config space at offset 0x7
(was 0x20000000, writing 0x2020)
[ 2121.270404] pci 0000:00:1c.0: restoring config space at offset 0x3
(was 0x810000, writing 0x810040)
[ 2121.270417] pci 0000:00:1c.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100007)
[ 2121.270465] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ
17
[ 2121.270474] pci 0000:00:1c.0: setting latency timer to 64
[ 2121.270522] pci 0000:00:1c.1: restoring config space at offset 0x9
(was 0x10001, writing 0x1fff1)
[ 2121.270532] pci 0000:00:1c.1: restoring config space at offset 0x8
(was 0x0, writing 0x50105010)
[ 2121.270542] pci 0000:00:1c.1: restoring config space at offset 0x7
(was 0x20000000, writing 0x200000f0)
[ 2121.270560] pci 0000:00:1c.1: restoring config space at offset 0x3
(was 0x810000, writing 0x810040)
[ 2121.270573] pci 0000:00:1c.1: restoring config space at offset 0x1
(was 0x100000, writing 0x100007)
[ 2121.270621] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ
16
[ 2121.270630] pci 0000:00:1c.1: setting latency timer to 64
[ 2121.270677] pci 0000:00:1c.2: restoring config space at offset 0x9
(was 0x10001, writing 0x4bf14801)
[ 2121.270687] pci 0000:00:1c.2: restoring config space at offset 0x8
(was 0x0, writing 0x50004c10)
[ 2121.270697] pci 0000:00:1c.2: restoring config space at offset 0x7
(was 0x20000000, writing 0x1010)
[ 2121.270715] pci 0000:00:1c.2: restoring config space at offset 0x3
(was 0x810000, writing 0x810040)
[ 2121.270728] pci 0000:00:1c.2: restoring config space at offset 0x1
(was 0x100000, writing 0x100007)
[ 2121.270776] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ
18
[ 2121.270785] pci 0000:00:1c.2: setting latency timer to 64
[ 2121.270801] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[ 2121.270813] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 2121.270894] usb usb2: root hub lost power or was reset
[ 2121.270942] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[ 2121.270954] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 2121.271035] usb usb3: root hub lost power or was reset
[ 2121.271062] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[ 2121.271074] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 2121.271154] usb usb4: root hub lost power or was reset
[ 2121.271196] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low)
-> IRQ 16
[ 2121.271208] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[ 2121.271288] usb usb5: root hub lost power or was reset
[ 2121.290118] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[ 2121.290131] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 2121.290250] pci 0000:00:1e.0: restoring config space at offset 0x9
(was 0x10001, writing 0x1fff1)
[ 2121.290260] pci 0000:00:1e.0: restoring config space at offset 0x8
(was 0x0, writing 0x4c004c00)
[ 2121.290270] pci 0000:00:1e.0: restoring config space at offset 0x7
(was 0x22800000, writing 0x228000f0)
[ 2121.290294] pci 0000:00:1e.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100007)
[ 2121.290645] pci 0000:00:1e.0: power state changed by ACPI to D0
[ 2121.290658] pci 0000:00:1e.0: setting latency timer to 64
[ 2121.290939] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[ 2121.290950] ata_piix 0000:00:1f.1: restoring config space at offset
0xf (was 0x100, writing 0x10b)
[ 2121.290995] ata_piix 0000:00:1f.1: restoring config space at offset
0x1 (was 0x2800001, writing 0x2800005)
[ 2121.291198] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[ 2121.291207] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low)
-> IRQ 18
[ 2121.291217] ata_piix 0000:00:1f.1: setting latency timer to 64
[ 2121.310139] ata_piix 0000:00:1f.2: restoring config space at offset
0xf (was 0x200, writing 0x20b)
[ 2121.310185] ata_piix 0000:00:1f.2: restoring config space at offset
0x1 (was 0x2b00003, writing 0x2b00007)
[ 2121.310215] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[ 2121.310225] ata_piix 0000:00:1f.2: setting latency timer to 64
[ 2121.310330] pci 0000:01:00.0: restoring config space at offset 0xf
(was 0x1ff, writing 0x10b)
[ 2121.310344] pci 0000:01:00.0: restoring config space at offset 0xc
(was 0x0, writing 0xfffe0000)
[ 2121.310363] pci 0000:01:00.0: restoring config space at offset 0x6
(was 0x0, writing 0x50300000)
[ 2121.310372] pci 0000:01:00.0: restoring config space at offset 0x5
(was 0x1, writing 0x3001)
[ 2121.310381] pci 0000:01:00.0: restoring config space at offset 0x4
(was 0x8, writing 0x40000008)
[ 2121.310390] pci 0000:01:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x40)
[ 2121.310401] pci 0000:01:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100007)
[ 2121.310436] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[ 2121.310444] pci 0000:01:00.0: setting latency timer to 64
[ 2121.310502] pci 0000:02:00.0: restoring config space at offset 0xf
(was 0x100, writing 0x10b)
[ 2121.310520] pci 0000:02:00.0: restoring config space at offset 0xc
(was 0x0, writing 0xfffe0000)
[ 2121.310548] pci 0000:02:00.0: restoring config space at offset 0x6
(was 0x1, writing 0x2001)
[ 2121.310563] pci 0000:02:00.0: restoring config space at offset 0x4
(was 0x4, writing 0x50200004)
[ 2121.310574] pci 0000:02:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x40)
[ 2121.310589] pci 0000:02:00.0: restoring config space at offset 0x1
(was 0x40100000, writing 0x100007)
[ 2121.330126] ath9k 0000:03:00.0: enabling device (0000 -> 0002)
[ 2121.330137] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[ 2121.330182] ath9k 0000:03:00.0: restoring config space at offset 0xf
(was 0x1ff, writing 0x10a)
[ 2121.330227] ath9k 0000:03:00.0: restoring config space at offset 0x4
(was 0x4, writing 0x50100004)
[ 2121.330238] ath9k 0000:03:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x40)
[ 2121.330253] ath9k 0000:03:00.0: restoring config space at offset 0x1
(was 0x100002, writing 0x100007)
[ 2121.350119] firewire_ohci 0000:0c:03.0: restoring config space at
offset 0x5 (was 0x0, writing 0x4c000000)
[ 2121.350131] firewire_ohci 0000:0c:03.0: restoring config space at
offset 0x4 (was 0x0, writing 0x4c004000)
[ 2121.350143] firewire_ohci 0000:0c:03.0: restoring config space at
offset 0x3 (was 0x0, writing 0xf810)
[ 2121.350157] firewire_ohci 0000:0c:03.0: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100016)
[ 2121.462238] sd 2:0:1:0: [sda] Starting disk
[ 2121.482175] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[ 2121.482180] ata1.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
[ 2121.520740] ata1.00: configured for UDMA/66
[ 2122.050467] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
[ 2122.050472] ata3.01: ACPI cmd ef/03:45:00:00:00:b0 filtered out
[ 2122.150810] ata3.01: configured for UDMA/100
[ 2122.171864] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors:
(120 GB/111 GiB)
[ 2122.171951] sd 2:0:1:0: [sda] Write Protect is off
[ 2122.171955] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[ 2122.172084] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 2123.240101] usb 2-2: reset full speed USB device using uhci_hcd and
address 2
[ 2123.413167] appletouch: Geyser mode initialized.
[ 2123.530105] usb 4-2: reset full speed USB device using uhci_hcd and
address 2
[ 2123.692049] applesmc: device has already been initialized (0xe0,
0x00).
[ 2123.810092] usb 5-1: reset full speed USB device using uhci_hcd and
address 3
[ 2123.880198] pm_op(): usb_dev_resume+0x0/0xa returns -19
[ 2123.880205] PM: Device 5-1 failed to resume: error -19
[ 2123.886192] Restarting tasks ... <7>wlan0: No ProbeResp from current
AP 00:1e:2a:00:67:f0 - assume out of range
[ 2124.009616] done.
[ 2124.250144] usb 5-1: USB disconnect, address 3
[ 2124.530045] usb 5-1: new full speed USB device using uhci_hcd and
address 4
[ 2124.725251] usb 5-1: configuration #1 chosen from 1 choice
[ 2124.760665] input: HID 05ac:1000 as /class/input/input13
[ 2125.400137] generic-usb 0003:05AC:1000.0007: input: USB HID v1.11
Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
[ 2125.450778] [drm] Loading R500 Microcode
[ 2125.450831] [drm] Num pipes: 1
[ 2125.547660] input: HID 05ac:1000 as /class/input/input14
[ 2125.630162] generic-usb 0003:05AC:1000.0008: input: USB HID v1.11
Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
[ 2126.870505] wlan0: authenticate with AP 00:1e:2a:00:67:f0
[ 2126.872071] wlan0: authenticated
[ 2126.872074] wlan0: associate with AP 00:1e:2a:00:67:f0
[ 2126.875435] wlan0: RX ReassocResp from 00:1e:2a:00:67:f0 (capab=0x431
status=0 aid=33)
[ 2126.875438] wlan0: associated

I first need to find out if others have the same issue,
if not then I need to figure out what library I'm missing,
or something on the line, that might be causing this.

regards;


-- 
Justin P. Mattock <justinmattock@gmail.com>

