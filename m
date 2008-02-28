Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYB1KLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYB1KLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYB1KL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:11:26 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:51470 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYB1KLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BsXUawbSVtoOUc2BDIq6cAAAmEQ8T616UF+b6bCeYPtBFK8jklPH5qiYgwSV7QA7/vD/hoWI49UO9R9KQpXnjp5qXtRCocB8f18AMjEcwLfqei63K6x0z1BkGxmypQGu3TeUhP0q+qP1PtoZMGAjgKTnAnlFrySpJYBAF6TcTtU=
Message-ID: <c4e36d110802280211w79b88622qc8e5a3770277fdbd@mail.gmail.com>
Date: Thu, 28 Feb 2008 11:11:22 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: KVM and mce64 suspend trace
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

While doing suspend/resume with running qemu I've got this trace log -
unsure whether this is a problem or not - using git tree 64bit
2.6.25-rc3, CPU C2D


[36676.515618] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[36676.518674] ACPI: PCI interrupt for device 0000:00:19.0 disabled
[36676.529738] Disabling non-boot CPUs ...
[36676.533064] kvm: disabling virtualization on CPU1
[36676.533217] ------------[ cut here ]------------
[36676.533355] WARNING: at arch/x86/kernel/smp_64.c:424
smp_call_function_single+0xf8/0x110()
[36676.533539] Modules linked in: cpufreq_userspace loop tun i915 drm
ipt_MASQUERADE iptable_nat nf_nat nf_c
onntrack_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge llc nfsd lockd nfs_acl
auth_rpcgss exportfs
autofs4 sunrpc binfmt_misc dm_mirror dm_multipath dm_mod uinput
kvm_intel kvm snd_hda_intel snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_dev
ice snd_pcm_oss snd_mixer_oss snd_pcm mmc_block arc4 ecb
crypto_blkcipher cryptomgr sr_mod snd_timer crypto_algapi sdhci
i2c_i801 cdrom snd ps
mouse rtc_cmos rtc_core serio_raw iwl3945 mac80211 cfg80211 soundcore
iTCO_wdt iTCO_vendor_support e1000e snd_page_alloc ac intel_agp
thinkpad
_acpi hwmon backlight rtc_lib i2c_core mmc_core evdev nvram button
uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: battery]
[36676.536073] Pid: 20359, comm: kstopmachine Not tainted 2.6.25-rc3 #85
[36676.536073]
[36676.536073] Call Trace:
[36676.536073]  [<ffffffff8103e54f>] warn_on_slowpath+0x5f/0x90
[36676.536073]  [<ffffffff8103f4c1>] ? vprintk+0x351/0x4c0
[36676.536073]  [<ffffffff8103a449>] ? hrtick_set+0x39/0x130
[36676.536073]  [<ffffffff8824eaa5>] ? :kvm:decache_vcpus_on_cpu+0x65/0xe0
[36676.536073]  [<ffffffff81020dd8>] smp_call_function_single+0xf8/0x110
[36676.536073]  [<ffffffff8826cbae>] :kvm_intel:vmx_vcpu_decache+0x2e/0x40
[36676.536073]  [<ffffffff8824eae5>] :kvm:decache_vcpus_on_cpu+0xa5/0xe0
[36676.536073]  [<ffffffff88249a6d>] :kvm:hardware_disable+0x2d/0x40
[36676.536073]  [<ffffffff88249b0f>] :kvm:kvm_cpu_hotplug+0x8f/0xe0
[36676.536073]  [<ffffffff812f578f>] notifier_call_chain+0x3f/0x80
[36676.536073]  [<ffffffff8105b071>] raw_notifier_call_chain+0x11/0x20
[36676.536073]  [<ffffffff8106d29b>] take_cpu_down+0x1b/0x40
[36676.536073]  [<ffffffff8107c978>] do_stop+0x148/0x250
[36676.536073]  [<ffffffff8107c830>] ? do_stop+0x0/0x250
[36676.536073]  [<ffffffff8107c830>] ? do_stop+0x0/0x250
[36676.536073]  [<ffffffff81056229>] kthread+0x49/0x90
[36676.536073]  [<ffffffff8100d8d8>] child_rip+0xa/0x12
[36676.536073]  [<ffffffff8100ce3c>] ? restore_args+0x0/0x30
[36676.536073]  [<ffffffff810561e0>] ? kthread+0x0/0x90
[36676.536073]  [<ffffffff8100d8ce>] ? child_rip+0x0/0x12
[36676.536073]
[36676.536073] ---[ end trace e691d2c23a034bc8 ]---
[36256.372221] CPU 1 is now offline
[36256.372221] CPU 1 is now offline
[36256.372366] lockdep: fixing up alternatives.
[36256.372504] SMP alternatives: switching to UP code
[36256.374626] BUG: using smp_processor_id() in preemptible [00000000]
code: pm-suspend/20198
[36256.374824] caller is rcu_offline_cpu+0x205/0x2a0
[36256.374966] Pid: 20198, comm: pm-suspend Not tainted 2.6.25-rc3 #85
[36256.375112]
[36256.375113] Call Trace:
[36256.375388]  [<ffffffff811807cc>] debug_smp_processor_id+0xcc/0xd0
[36256.375548]  [<ffffffff8108b205>] rcu_offline_cpu+0x205/0x2a0
[36256.375709]  [<ffffffff812ecb58>] rcu_cpu_notify+0x38/0x40
[36256.375851]  [<ffffffff812f578f>] notifier_call_chain+0x3f/0x80
[36256.376005]  [<ffffffff8105b071>] raw_notifier_call_chain+0x11/0x20
[36256.376158]  [<ffffffff8106d467>] _cpu_down+0x1a7/0x290
[36256.376309]  [<ffffffff8106d621>] disable_nonboot_cpus+0x71/0x110
[36256.376464]  [<ffffffff810730d5>] suspend_devices_and_enter+0xe5/0x1a0
[36256.376615]  [<ffffffff81073306>] enter_state+0x146/0x1d0
[36256.376759]  [<ffffffff8107344a>] state_store+0xba/0x100
[36256.376909]  [<ffffffff811757f7>] kobj_attr_store+0x17/0x20
[36256.377057]  [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
[36256.377214]  [<ffffffff810bb82b>] vfs_write+0xcb/0x170
[36256.377364]  [<ffffffff810bb9c0>] sys_write+0x50/0x90
[36256.377515]  [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
[36256.377675]
[36256.379799] CPU1 is down
[36256.380025] ------------[ cut here ]------------
[36256.380163] WARNING: at arch/x86/kernel/smp_64.c:424
smp_call_function_single+0xf8/0x110()
[36256.380351] Modules linked in: cpufreq_userspace loop tun i915 drm
ipt_MASQUERADE iptable_nat nf_nat nf_c
onntrack_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge llc nfsd lockd nfs_acl
auth_rpcgss exportfs
autofs4 sunrpc binfmt_misc dm_mirror dm_multipath dm_mod uinput
kvm_intel kvm snd_hda_intel snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_dev
ice snd_pcm_oss snd_mixer_oss snd_pcm mmc_block arc4 ecb
crypto_blkcipher cryptomgr sr_mod snd_timer crypto_algapi sdhci
i2c_i801 cdrom snd ps
mouse rtc_cmos rtc_core serio_raw iwl3945 mac80211 cfg80211 soundcore
iTCO_wdt iTCO_vendor_support e1000e snd_page_alloc ac intel_agp
thinkpad
_acpi hwmon backlight rtc_lib i2c_core mmc_core evdev nvram button
uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: battery]
[36256.382196] Pid: 20198, comm: pm-suspend Not tainted 2.6.25-rc3 #85
[36256.382196]
[36256.382196] Call Trace:
[36256.382196]  [<ffffffff8103e54f>] warn_on_slowpath+0x5f/0x90
[36256.382196]  [<ffffffff812f191a>] ? _spin_unlock_irqrestore+0x4a/0x90
[36256.382196]  [<ffffffff8103ecef>] ? release_console_sem+0x22f/0x250
[36256.382196]  [<ffffffff8103f4c1>] ? vprintk+0x351/0x4c0
[36256.382196]  [<ffffffff8824eaa5>] ? :kvm:decache_vcpus_on_cpu+0x65/0xe0
[36256.382196]  [<ffffffff81020dd8>] smp_call_function_single+0xf8/0x110
[36256.382196]  [<ffffffff8826cbae>] :kvm_intel:vmx_vcpu_decache+0x2e/0x40
[36256.382196]  [<ffffffff8824eae5>] :kvm:decache_vcpus_on_cpu+0xa5/0xe0
[36256.382196]  [<ffffffff88249a6d>] :kvm:hardware_disable+0x2d/0x40
[36256.382196]  [<ffffffff88249b6b>] :kvm:kvm_suspend+0xb/0x10
[36256.382196]  [<ffffffff811ff071>] sysdev_suspend+0xd1/0x230
[36256.382196]  [<ffffffff81205518>] device_power_down+0xc8/0x130
[36256.382196]  [<ffffffff8107311e>] suspend_devices_and_enter+0x12e/0x1a0
[36256.382196]  [<ffffffff81073306>] enter_state+0x146/0x1d0
[36256.382196]  [<ffffffff8107344a>] state_store+0xba/0x100
[36256.382196]  [<ffffffff811757f7>] kobj_attr_store+0x17/0x20
[36256.382196]  [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
[36256.382196]  [<ffffffff810bb82b>] vfs_write+0xcb/0x170
[36256.382196]  [<ffffffff810bb9c0>] sys_write+0x50/0x90
[36256.382196]  [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
[36256.382196]
[36256.382196] ---[ end trace e691d2c23a034bc8 ]---
[36256.382284] Extended CMOS year: 2000
[36256.383689]  hwsleep-0322 [00] enter_sleep_state     : Entering
sleep state [S3]
[36256.384011] BUG: using smp_processor_id() in preemptible [00000000]
code: pm-suspend/20198
[36256.384094] caller is do_machine_check+0x99/0x510
[36256.384155] Pid: 20198, comm: pm-suspend Not tainted 2.6.25-rc3 #85
[36256.384218]
[36256.384219] Call Trace:
[36256.384351]  [<ffffffff811807cc>] debug_smp_processor_id+0xcc/0xd0
[36256.384417]  [<ffffffff81019149>] do_machine_check+0x99/0x510
[36256.384492]  [<ffffffff8101966d>] mce_init+0x5d/0x130
[36256.384556]  [<ffffffff8101974b>] mce_resume+0xb/0x10
gnome-power-manager: computer wakeup
[36256.384620]  [<ffffffff811feed0>] __sysdev_resume+0x20/0x60
[36256.384684]  [<ffffffff811fef68>] sysdev_resume+0x58/0x90
[36256.384752]  [<ffffffff81205b19>] device_power_up+0x9/0x10
[36256.384815]  [<ffffffff81073137>] suspend_devices_and_enter+0x147/0x1a0
[36256.384881]  [<ffffffff81073306>] enter_state+0x146/0x1d0
[36256.384944]  [<ffffffff8107344a>] state_store+0xba/0x100
[36256.385009]  [<ffffffff811757f7>] kobj_attr_store+0x17/0x20
[36256.385075]  [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
[36256.385140]  [<ffffffff810bb82b>] vfs_write+0xcb/0x170
[36256.385205]  [<ffffffff810bb9c0>] sys_write+0x50/0x90
[36256.385271]  [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
[36256.385337]
[36256.385471] Extended CMOS year: 2000
[36256.385529] BUG: using smp_processor_id() in preemptible [00000000]
code: pm-suspend/20198
[36256.385541] caller is retrigger_next_event+0x1c/0xf0
[36256.385604] Pid: 20198, comm: pm-suspend Not tainted 2.6.25-rc3 #85
[36256.385670]
[36256.385671] Call Trace:
[36256.385786]  [<ffffffff811807cc>] debug_smp_processor_id+0xcc/0xd0
[36256.385853]  [<ffffffff810599fc>] retrigger_next_event+0x1c/0xf0
[36256.385919]  [<ffffffff812f1990>] ? _spin_unlock+0x30/0x60
[36256.385983]  [<ffffffff8105a30e>] hres_timers_resume+0x1e/0x50
[36256.386048]  [<ffffffff8105cb76>] timekeeping_resume+0x176/0x1c0
[36256.386115]  [<ffffffff811feed0>] __sysdev_resume+0x20/0x60
[36256.386182]  [<ffffffff811fef68>] sysdev_resume+0x58/0x90
[36256.386246]  [<ffffffff81205b19>] device_power_up+0x9/0x10
[36256.386310]  [<ffffffff81073137>] suspend_devices_and_enter+0x147/0x1a0
[36256.386375]  [<ffffffff81073306>] enter_state+0x146/0x1d0
[36256.386440]  [<ffffffff8107344a>] state_store+0xba/0x100
[36256.386500]  [<ffffffff811757f7>] kobj_attr_store+0x17/0x20
[36256.386565]  [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
[36256.386630]  [<ffffffff810bb82b>] vfs_write+0xcb/0x170
[36256.386694]  [<ffffffff810bb9c0>] sys_write+0x50/0x90
[36256.386761]  [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
[36256.386832]
[36256.387488] BUG: using smp_processor_id() in preemptible [00000000]
code: pm-suspend/20198
[36256.387565] caller is retrigger_next_event+0x84/0xf0
[36256.387625] Pid: 20198, comm: pm-suspend Not tainted 2.6.25-rc3 #85
[36256.387688]
[36256.387688] Call Trace:
[36256.387805]  [<ffffffff811807cc>] debug_smp_processor_id+0xcc/0xd0
[36256.387869]  [<ffffffff81059a64>] retrigger_next_event+0x84/0xf0
[36256.387936]  [<ffffffff8105a30e>] hres_timers_resume+0x1e/0x50
[36256.388001]  [<ffffffff8105cb76>] timekeeping_resume+0x176/0x1c0
[36256.388066]  [<ffffffff811feed0>] __sysdev_resume+0x20/0x60
[36256.388128]  [<ffffffff811fef68>] sysdev_resume+0x58/0x90
[36256.388192]  [<ffffffff81205b19>] device_power_up+0x9/0x10
[36256.388256]  [<ffffffff81073137>] suspend_devices_and_enter+0x147/0x1a0
[36256.388323]  [<ffffffff81073306>] enter_state+0x146/0x1d0
[36256.388388]  [<ffffffff8107344a>] state_store+0xba/0x100
[36256.388451]  [<ffffffff811757f7>] kobj_attr_store+0x17/0x20
[36256.388516]  [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
[36256.388583]  [<ffffffff810bb82b>] vfs_write+0xcb/0x170
[36256.388646]  [<ffffffff810bb9c0>] sys_write+0x50/0x90
[36256.388714]  [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
[36256.388871]
[36256.389005] Enabling non-boot CPUs ...
[36256.389560] lockdep: fixing up alternatives.
[36256.389623] SMP alternatives: switching to SMP code
[36256.390351] Booting processor 1/2 APIC 0x1
[36676.538568] Initializing CPU#1


Zdenek
