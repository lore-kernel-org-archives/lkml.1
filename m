Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbXKNESa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbXKNESa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761251AbXKNESN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:18:13 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:30788 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758840AbXKNESK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:18:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=eBHagI8rPG/7fpj2OU0ecxIShCL0J0hplaZFQG+96Q9ug8APHiS+Pu8O9fvHytJDlP4W5WhBgMKyyUg36XY92rsvID/vI4RHCkjiIJGWJ/sBz27vvJwaQYX5Hcehiin/L+P1mie2XyYlq+35cuX+19NJgGE5fNOPEva4rd4MSAU=
Message-ID: <473A76FA.4050701@googlemail.com>
Date: Wed, 14 Nov 2007 05:18:02 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mark Gross <mgross@linux.intel.com>
Subject: Re: 2.6.24-rc2-mm1
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <473A678C.2020507@googlemail.com>
In-Reply-To: <473A678C.2020507@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
> 
> I got it to boot but .. 

> 
> ...
> [   45.030261] input: Power Button (CM) as /devices/virtual/input/input4
> [   45.031331] BUG: sleeping function called from invalid context at kernel/rwsem.c:47
> [   45.031560] in_atomic():0, irqs_disabled():1
> [   45.031569] 1 lock held by modprobe/2105:
> [   45.031574]  #0:  (pm_qos_lock){....}, at: [<c0139b1c>] pm_qos_add_notifier+0x14/0x3c
> [   45.031606] irq event stamp: 4036
> [   45.031612] hardirqs last  enabled at (4035): [<c0140cc3>] debug_check_no_locks_freed+0xf9/0x105
> [   45.031632] hardirqs last disabled at (4036): [<c0333bf5>] _spin_lock_irqsave+0x10/0x55
> [   45.031653] softirqs last  enabled at (3710): [<c0128e96>] __do_softirq+0xe9/0xf1
> [   45.031670] softirqs last disabled at (3703): [<c0128ed8>] do_softirq+0x3a/0x52
> [   45.031685]  [<c0104e01>] show_trace_log_lvl+0x12/0x25
> [   45.031702]  [<c010562d>] show_trace+0xd/0x10
> [   45.031717]  [<c0105704>] dump_stack+0x16/0x18
> [   45.031728]  [<c011db69>] __might_sleep+0xc2/0xc9
> [   45.031740]  [<c0139093>] down_write+0x17/0x6f
> [   45.031754]  [<c013991e>] blocking_notifier_chain_register+0x26/0x3f
> [   45.031766]  [<c0139b2f>] pm_qos_add_notifier+0x27/0x3c
> [   45.031778]  [<e885bc77>] acpi_processor_power_init+0x4d/0x164 [processor]
> [   45.031802]  [<e885a5b3>] acpi_processor_start+0x503/0x556 [processor]
> [   45.031820]  [<c022125c>] acpi_start_single_object+0x20/0x3d
> [   45.031837]  [<c0222392>] acpi_device_probe+0x78/0x88
> [   45.031850]  [<c0244700>] driver_probe_device+0xb2/0x12d
> [   45.031866]  [<c02448a2>] __driver_attach+0x76/0xaf
> [   45.031878]  [<c0243cb0>] bus_for_each_dev+0x3e/0x60
> [   45.031889]  [<c0244588>] driver_attach+0x14/0x16
> [   45.031899]  [<c0243f9a>] bus_add_driver+0x7a/0x180
> [   45.031909]  [<c0244a9d>] driver_register+0x57/0x5c
> [   45.031918]  [<c022267e>] acpi_bus_register_driver+0x3a/0x3c
> [   45.031929]  [<e882f073>] acpi_processor_init+0x73/0xc5 [processor]
> [   45.031943]  [<c0148ec5>] sys_init_module+0x14e3/0x15ae
> [   45.031958]  [<c0103d86>] sysenter_past_esp+0x5f/0xa5
> [   45.031969]  =======================
> [   45.032213] ACPI: Invalid PBLK length [0]
> [   45.032465] ACPI: Invalid PBLK length [0]
> [   45.032656] ACPI: Invalid PBLK length [0]                                                                                               
> 
> ...
> 
> ...
> [  102.331554] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
> [  102.331575] in_atomic():0, irqs_disabled():1
> [  102.331583] 1 lock held by artsd/4385:
> [  102.331589]  #0:  (pm_qos_lock){....}, at: [<c0139d4a>] pm_qos_add_requirement+0x5a/0x98
> [  102.331619] irq event stamp: 19022
> [  102.331624] hardirqs last  enabled at (19021): [<c0333d1a>] _spin_unlock_irqrestore+0x36/0x3c
> [  102.331641] hardirqs last disabled at (19022): [<c0333bf5>] _spin_lock_irqsave+0x10/0x55
> [  102.331655] softirqs last  enabled at (18846): [<c0128e96>] __do_softirq+0xe9/0xf1
> [  102.331672] softirqs last disabled at (18839): [<c0128ed8>] do_softirq+0x3a/0x52
> [  102.331688]  [<c0104e01>] show_trace_log_lvl+0x12/0x25
> [  102.331704]  [<c010562d>] show_trace+0xd/0x10
> [  102.331715]  [<c0105704>] dump_stack+0x16/0x18
> [  102.331727]  [<c011db69>] __might_sleep+0xc2/0xc9
> [  102.331739]  [<c0138fe7>] down_read+0x16/0x6a
> [  102.331750]  [<c0139872>] __blocking_notifier_call_chain+0x24/0x4c
> [  102.331761]  [<c01398a6>] blocking_notifier_call_chain+0xc/0xe
> [  102.331773]  [<c0139b82>] update_target+0x3e/0x43
> [  102.331784]  [<c0139d66>] pm_qos_add_requirement+0x76/0x98
> [  102.331795]  [<c02bd8a0>] snd_pcm_hw_params_user+0x2b1/0x302
> [  102.331811]  [<c02bdad9>] snd_pcm_common_ioctl1+0x17a/0xda3
> [  102.331825]  [<c02bee6b>] snd_pcm_playback_ioctl1+0x3ab/0x3c2
> [  102.331840]  [<c02bef06>] snd_pcm_playback_ioctl+0x27/0x35
> [  102.331853]  [<c01795ce>] vfs_ioctl+0x22/0x67
> [  102.331867]  [<c017986d>] do_vfs_ioctl+0x25a/0x268
> [  102.331878]  [<c01798a7>] sys_ioctl+0x2c/0x45
> [  102.331889]  [<c0103d86>] sysenter_past_esp+0x5f/0xa5
> [  102.331901]  =======================
> [  102.331911] WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
> [  102.331920]  [<c0104e01>] show_trace_log_lvl+0x12/0x25
> [  102.331932]  [<c010562d>] show_trace+0xd/0x10
> [  102.331944]  [<c0105704>] dump_stack+0x16/0x18
> [  102.331955]  [<c0112f35>] native_smp_call_function_mask+0x39/0x11d
> [  102.331970]  [<c01142ef>] smp_call_function+0x18/0x1d
> [  102.331984]  [<e885b449>] acpi_processor_latency_notify+0x13/0x1a [processor]
> [  102.332011]  [<c01396e2>] notifier_call_chain+0x2b/0x4a
> [  102.332023]  [<c0139885>] __blocking_notifier_call_chain+0x37/0x4c
> [  102.332035]  [<c01398a6>] blocking_notifier_call_chain+0xc/0xe
> [  102.332047]  [<c0139b82>] update_target+0x3e/0x43
> [  102.332058]  [<c0139d66>] pm_qos_add_requirement+0x76/0x98
> [  102.332070]  [<c02bd8a0>] snd_pcm_hw_params_user+0x2b1/0x302
> [  102.332085]  [<c02bdad9>] snd_pcm_common_ioctl1+0x17a/0xda3
> [  102.332097]  [<c02bee6b>] snd_pcm_playback_ioctl1+0x3ab/0x3c2
> [  102.332111]  [<c02bef06>] snd_pcm_playback_ioctl+0x27/0x35
> [  102.332123]  [<c01795ce>] vfs_ioctl+0x22/0x67
> [  102.332134]  [<c017986d>] do_vfs_ioctl+0x25a/0x268
> [  102.332146]  [<c01798a7>] sys_ioctl+0x2c/0x45
> [  102.332156]  [<c0103d86>] sysenter_past_esp+0x5f/0xa5
> [  102.332167]  =======================
> [  102.357016] WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
> [  102.357034]  [<c0104e01>] show_trace_log_lvl+0x12/0x25
> [  102.357058]  [<c010562d>] show_trace+0xd/0x10
> [  102.357072]  [<c0105704>] dump_stack+0x16/0x18
> [  102.357083]  [<c0112f35>] native_smp_call_function_mask+0x39/0x11d
> [  102.357100]  [<c01142ef>] smp_call_function+0x18/0x1d
> [  102.357113]  [<e885b449>] acpi_processor_latency_notify+0x13/0x1a [processor]
> [  102.357141]  [<c01396e2>] notifier_call_chain+0x2b/0x4a
> [  102.357155]  [<c0139885>] __blocking_notifier_call_chain+0x37/0x4c
> [  102.357166]  [<c01398a6>] blocking_notifier_call_chain+0xc/0xe
> [  102.357178]  [<c0139b82>] update_target+0x3e/0x43
> [  102.357190]  [<c0139bec>] pm_qos_remove_requirement+0x65/0x87
> [  102.357200]  [<c02bd865>] snd_pcm_hw_params_user+0x276/0x302
> [  102.357215]  [<c02bdad9>] snd_pcm_common_ioctl1+0x17a/0xda3
> [  102.357227]  [<c02bee6b>] snd_pcm_playback_ioctl1+0x3ab/0x3c2
> [  102.357239]  [<c02bef06>] snd_pcm_playback_ioctl+0x27/0x35
> [  102.357251]  [<c01795ce>] vfs_ioctl+0x22/0x67
> [  102.357264]  [<c017986d>] do_vfs_ioctl+0x25a/0x268
> [  102.357276]  [<c01798a7>] sys_ioctl+0x2c/0x45
> [  102.357286]  [<c0103d86>] sysenter_past_esp+0x5f/0xa5
> [  102.357296]  =======================
> [  102.357325] WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
> [  102.357332]  [<c0104e01>] show_trace_log_lvl+0x12/0x25
> [  102.357345]  [<c010562d>] show_trace+0xd/0x10
> [  102.357356]  [<c0105704>] dump_stack+0x16/0x18
> [  102.357367]  [<c0112f35>] native_smp_call_function_mask+0x39/0x11d
> [  102.357378]  [<c01142ef>] smp_call_function+0x18/0x1d
> [  102.357391]  [<e885b449>] acpi_processor_latency_notify+0x13/0x1a [processor]
> [  102.357409]  [<c01396e2>] notifier_call_chain+0x2b/0x4a
> [  102.357421]  [<c0139885>] __blocking_notifier_call_chain+0x37/0x4c
> [  102.357433]  [<c01398a6>] blocking_notifier_call_chain+0xc/0xe
> [  102.357443]  [<c0139b82>] update_target+0x3e/0x43
> [  102.357454]  [<c0139d66>] pm_qos_add_requirement+0x76/0x98
> [  102.357465]  [<c02bd8a0>] snd_pcm_hw_params_user+0x2b1/0x302
> [  102.357477]  [<c02bdad9>] snd_pcm_common_ioctl1+0x17a/0xda3
> [  102.357488]  [<c02bee6b>] snd_pcm_playback_ioctl1+0x3ab/0x3c2
> [  102.357500]  [<c02bef06>] snd_pcm_playback_ioctl+0x27/0x35
> [  102.357511]  [<c01795ce>] vfs_ioctl+0x22/0x67
> [  102.357521]  [<c017986d>] do_vfs_ioctl+0x25a/0x268
> [  102.357532]  [<c01798a7>] sys_ioctl+0x2c/0x45
> [  102.357542]  [<c0103d86>] sysenter_past_esp+0x5f/0xa5
> [  102.357552]  =======================
> [  102.366346] WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
> [  102.366358]  [<c0104e01>] show_trace_log_lvl+0x12/0x25
> [  102.366380]  [<c010562d>] show_trace+0xd/0x10
> [  102.366393]  [<c0105704>] dump_stack+0x16/0x18
> [  102.366404]  [<c0112f35>] native_smp_call_function_mask+0x39/0x11d
> [  102.366420]  [<c01142ef>] smp_call_function+0x18/0x1d
> [  102.366434]  [<e885b449>] acpi_processor_latency_notify+0x13/0x1a [processor]
> [  102.366460]  [<c01396e2>] notifier_call_chain+0x2b/0x4a
> [  102.366473]  [<c0139885>] __blocking_notifier_call_chain+0x37/0x4c
> [  102.366486]  [<c01398a6>] blocking_notifier_call_chain+0xc/0xe
> [  102.366498]  [<c0139b82>] update_target+0x3e/0x43
> [  102.366509]  [<c0139bec>] pm_qos_remove_requirement+0x65/0x87
> [  102.366521]  [<c02bd865>] snd_pcm_hw_params_user+0x276/0x302
> [  102.366537]  [<c02bdad9>] snd_pcm_common_ioctl1+0x17a/0xda3
> [  102.366550]  [<c02bee6b>] snd_pcm_playback_ioctl1+0x3ab/0x3c2
> [  102.366563]  [<c02bef06>] snd_pcm_playback_ioctl+0x27/0x35
> [  102.366574]  [<c01795ce>] vfs_ioctl+0x22/0x67
> [  102.366588]  [<c017986d>] do_vfs_ioctl+0x25a/0x268
> [  102.366600]  [<c01798a7>] sys_ioctl+0x2c/0x45
> [  102.366611]  [<c0103d86>] sysenter_past_esp+0x5f/0xa5
> [  102.366622]  =======================
> [  102.366690] WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
> [  102.366698]  [<c0104e01>] show_trace_log_lvl+0x12/0x25
> [  102.366711]  [<c010562d>] show_trace+0xd/0x10
> [  102.366722]  [<c0105704>] dump_stack+0x16/0x18
> [  102.366733]  [<c0112f35>] native_smp_call_function_mask+0x39/0x11d
> [  102.366747]  [<c01142ef>] smp_call_function+0x18/0x1d
> [  102.366759]  [<e885b449>] acpi_processor_latency_notify+0x13/0x1a [processor]
> [  102.366778]  [<c01396e2>] notifier_call_chain+0x2b/0x4a
> [  102.366792]  [<c0139885>] __blocking_notifier_call_chain+0x37/0x4c
> [  102.366805]  [<c01398a6>] blocking_notifier_call_chain+0xc/0xe
> [  102.366817]  [<c0139b82>] update_target+0x3e/0x43
> [  102.366829]  [<c0139d66>] pm_qos_add_requirement+0x76/0x98
> [  102.366840]  [<c02bd8a0>] snd_pcm_hw_params_user+0x2b1/0x302
> [  102.366853]  [<c02bdad9>] snd_pcm_common_ioctl1+0x17a/0xda3
> [  102.366865]  [<c02bee6b>] snd_pcm_playback_ioctl1+0x3ab/0x3c2
> [  102.366879]  [<c02bef06>] snd_pcm_playback_ioctl+0x27/0x35
> [  102.366892]  [<c01795ce>] vfs_ioctl+0x22/0x67
> [  102.366902]  [<c017986d>] do_vfs_ioctl+0x25a/0x268
> [  102.366913]  [<c01798a7>] sys_ioctl+0x2c/0x45
> [  102.366922]  [<c0103d86>] sysenter_past_esp+0x5f/0xa5
> [  102.366932]  =======================
> [  108.552031] printk: 31 messages suppressed.


All this BUG / WARNINGS are caused by *-qos* patches. Reverting this 3 patches makes the BUGs go away :

latencyc-use-qos-infrastructure.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch


Gabriel





