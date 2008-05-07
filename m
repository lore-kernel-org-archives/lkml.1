Return-Path: <linux-kernel-owner+w=401wt.eu-S1764410AbYEGSL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764410AbYEGSL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbYEGSLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:11:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:47526 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755032AbYEGSLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:11:15 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX18O9kJBVBwOoqHpdsObyXXbL9GmHMdvVK0iBcUNqG
	jZjmQtDCLkL1Rn
Subject: Re: [BUG]:WARNING: at arch/x86/kernel/rtc.c:122 in 2.6.26-rc1
From: Mirco Tischler <mt-ml@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1210183536.28099.10.camel@mtlp.tischlernetz>
References: <1210183536.28099.10.camel@mtlp.tischlernetz>
Content-Type: text/plain
Date: Wed, 07 May 2008 20:11:11 +0200
Message-Id: <1210183871.28099.12.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 2008-05-07 at 20:05 +0200, Mirco Tischler wrote:
> Hello
> I've triggered this warning in 2.6.26-rc1-git from 6th of may:
> ...
> [11677.490019] CPU1 is down
> [11677.490149] Extended CMOS year: 2000
> [11677.490149] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> 0x7010600070106
> [11677.490747] Back to C!
> [11677.490952] microcode: CPU0 updated from revision 0x92 to 0x92, date
> = 03132007 
> [11677.491065] ------------[ cut here ]------------
> [11677.491065] WARNING: at arch/x86/kernel/rtc.c:122 mach_get_cmos_time
> +0x9e/0x14e()
> [11677.491065] Modules linked in: i915 microcode cpufreq_userspace
> cpufreq_conservative cpufreq_powersave sbs sbshc wmi aes_x86_64 dm_crypt
> rtc_cmos rtc_core rtc_lib kvm_intel kvm coretemp hwmon sbp2
> snd_hda_intel snd_pcm snd_page_alloc snd_hwdep pata_acpi snd_seq
> firewire_ohci firewire_core tifm_7xx1 crc_itu_t snd_timer snd_seq_device
> tpm_infineon tpm tpm_bios psmouse tifm_core ide_pci_generic snd
> soundcore intel_agp ohci1394 ieee1394 ata_generic ehci_hcd uhci_hcd fan
> fuse usbcore [last unloaded: iwl4965]
> [11677.491065] Pid: 30643, comm: pm-suspend Not tainted
> 2.6.26-rc1-experimental #72
> [11677.491065] 
> [11677.491065] Call Trace:
> [11677.491065]  [<ffffffff80235361>] warn_on_slowpath+0x51/0x8c
> [11677.491065]  [<ffffffff8022bb5b>] try_to_wake_up+0x1d8/0x1e9
> [11677.491065]  [<ffffffff8021560b>] do_machine_check+0xa4/0x3d3
> [11677.491065]  [<ffffffff8022c076>] __wake_up+0x38/0x4e
> [11677.491065]  [<ffffffff80211cdb>] mach_get_cmos_time+0x9e/0x14e
> [11677.491065]  [<ffffffff80211da6>] read_persistent_clock+0x1b/0x35
> [11677.491065]  [<ffffffff8024c101>] timekeeping_resume+0xb/0x120
> [11677.491065]  [<ffffffff803be5a6>] __sysdev_resume+0x16/0x43
> [11677.491065]  [<ffffffff803be5f9>] sysdev_resume+0x26/0x61
> [11677.491065]  [<ffffffff803c296a>] device_power_up+0x9/0xf
> [11677.491065]  [<ffffffff80257e76>] suspend_devices_and_enter
> +0xbc/0x105
> [11677.491065]  [<ffffffff80257fef>] enter_state+0xe3/0x131
> [11677.491065]  [<ffffffff802580f1>] state_store+0xb4/0xd5
> [11677.491065]  [<ffffffff802e8b11>] sysfs_write_file+0xd0/0x107
> [11677.491065]  [<ffffffff802a2524>] vfs_write+0xad/0x136
> [11677.491065]  [<ffffffff802a2669>] sys_write+0x45/0x6e
> [11677.491065]  [<ffffffff8020bedb>] system_call_after_swapgs+0x7b/0x80
> [11677.491065] 
> [11677.491065] ---[ end trace cce3eb8653db51b7 ]---
> [11677.491065] Extended CMOS year: 2000
> [11677.491232] Enabling non-boot CPUs ...
> ...
> 
> I wasn't able to reproduce the warning yet, but because the commit
> message introducing the WARN_ON says:
> > [ tglx@linutronix.de: changed to WARN_ON - we want to know that!
> >       If no one reports it we can remove the complete if (RTC_ALWAYS_BCD)
> >       magic, which has RTC_ALWAYS_BCD defined to 1 since Linux 1.0 ... ]
> I'm reporting it anyway now.
> 
> Thanks
> 
> Mirco
Resend cause Andi's email has changed

