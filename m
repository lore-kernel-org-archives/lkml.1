Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbYD0AGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbYD0AGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYD0AFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:05:50 -0400
Received: from smtp.enter.net ([216.193.128.24]:2394 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbYD0AFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:05:50 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Warning in Genapic code on x86-64
Date: Sat, 26 Apr 2008 20:05:46 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804262005.46989.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the first 2.6.25 kernel I could boot on my system (2.6.25-rc8) I've had 
this warning. I thought I'd seen a patch go in that fixed it, but apparently 
not.

System is a Dell laptop - one of the "new" ones that ships with Linux, with 
Linux reinstalled (since they ship 32bit and I'd prefer to use the full power 
of the processor).

i915 chipset, Core2 Duo processor - warning repeats, apparently almost exactly 
the same, on both cores. I'll update to latest git and will test any patches 
to fix this.

[    0.167254] ------------[ cut here ]------------
[    0.167402] WARNING: at arch/x86/kernel/genapic_64.c:86 
read_apic_id+0x85/0x90()
[    0.167603] Modules linked in:
[    0.167808] Pid: 1, comm: swapper Not tainted 2.6.25 #2
[    0.167952]
[    0.167954] Call Trace:
[    0.168210]  [<ffffffff80240d7f>] warn_on_slowpath+0x5f/0x80
[    0.168367]  [<ffffffff8021370c>] ? native_sched_clock+0x6c/0xa0
[    0.168521]  [<ffffffff80235b71>] ? task_rq_lock+0x61/0xb0
[    0.168674]  [<ffffffff802643c3>] ? get_lock_stats+0x23/0x70
[    0.168824]  [<ffffffff8026441e>] ? put_lock_stats+0xe/0x30
[    0.168979]  [<ffffffff802644a6>] ? lock_release_holdtime+0x66/0x80
[    0.169137]  [<ffffffff804b8386>] ? _spin_unlock_irqrestore+0x66/0x80
[    0.169298]  [<ffffffff80672140>] ? early_idt_handler+0x0/0x73
[    0.170014]  [<ffffffff80266f85>] ? trace_hardirqs_on+0xe5/0x170
[    0.170171]  [<ffffffff804b836a>] ? _spin_unlock_irqrestore+0x4a/0x80
[    0.170327]  [<ffffffff80225425>] read_apic_id+0x85/0x90
[    0.170480]  [<ffffffff80680085>] verify_local_APIC+0xc5/0x190
[    0.170636]  [<ffffffff80672140>] ? early_idt_handler+0x0/0x73
[    0.170789]  [<ffffffff8067eeb9>] native_smp_prepare_cpus+0x1a9/0x390
[    0.170944]  [<ffffffff8067294a>] kernel_init+0x5a/0x350
[    0.171096]  [<ffffffff804b83dd>] ? _spin_unlock_irq+0x3d/0x70
[    0.171249]  [<ffffffff804b76f3>] ? trace_hardirqs_on_thunk+0x35/0x3a
[    0.171404]  [<ffffffff80266f85>] ? trace_hardirqs_on+0xe5/0x170
[    0.171558]  [<ffffffff80672140>] ? early_idt_handler+0x0/0x73
[    0.171714]  [<ffffffff8020d898>] child_rip+0xa/0x12
[    0.171861]  [<ffffffff8020cdfc>] ? restore_args+0x0/0x30
[    0.172012]  [<ffffffff806728f0>] ? kernel_init+0x0/0x350
[    0.172160]  [<ffffffff8020d88e>] ? child_rip+0x0/0x12
[    0.172304]
[    0.172534] ---[ end trace ca143223eefdc828 ]---


...On a related note, I'm also, now, getting the following when booting a 
kernel based on a git pulled in last night (b69d3987f4...cdd0cc204b79e)

[   58.960104] sysdev: class cpu: driver (ffffffff80627740) has already been 
registered to a class, something is wrong, but will forge on!
[   58.960120] ------------[ cut here ]------------
[   58.960125] WARNING: at drivers/base/sys.c:183 
sysdev_driver_register+0x4f/0x150()
[   58.960130] Modules linked in: acpi_cpufreq(+) cpufreq_ondemand 
cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats 
freq_table container sbs sbshc dm_crypt d
m_mod sbp2 parport_pc lp parport ipv6 snd_hda_intel snd_hwdep snd_pcm_oss 
snd_pcm snd_page_alloc snd_mixer_oss arc4 snd_seq_dummy ecb crypto_blkcipher 
joydev snd_seq_oss snd_seq_m
idi snd_rawmidi iwl3945 snd_seq_midi_event snd_seq serio_raw sdhci snd_timer 
snd_seq_device pcspkr psmouse mac80211 mmc_core ricoh_mmc snd led_class video 
cfg80211 iTCO_wdt iTCO_v
endor_support battery ac wmi button soundcore intel_agp shpchp pci_hotplug 
dcdbas evdev ext3 jbd mbcache sg sr_mod cdrom pata_acpi sd_mod ata_generic 
ohci1394 ieee1394 ahci ata_pi
ix libata scsi_mod dock tg3 ehci_hcd uhci_hcd usbcore thermal processor fan 
fuse
[   58.960273] Pid: 5555, comm: modprobe Not tainted 2.6.25 #2
[   58.960277]
[   58.960278] Call Trace:
[   58.960294]  [<ffffffff80240d7f>] warn_on_slowpath+0x5f/0x80
[   58.960308]  [<ffffffff80241f97>] ? printk+0x67/0x70
[   58.960325]  [<ffffffff802643c3>] ? get_lock_stats+0x23/0x70
[   58.960334]  [<ffffffff8026441e>] ? put_lock_stats+0xe/0x30
[   58.960343]  [<ffffffff802644a6>] ? lock_release_holdtime+0x66/0x80
[   58.960357]  [<ffffffff804b8386>] ? _spin_unlock_irqrestore+0x66/0x80
[   58.960369]  [<ffffffff803f5c8f>] sysdev_driver_register+0x4f/0x150
[   58.960382]  [<ffffffff80411259>] cpufreq_register_driver+0xb9/0x1c0
[   58.960398]  [<ffffffffa006b06e>] :acpi_cpufreq:acpi_cpufreq_init+0x6e/0x8f
[   58.960407]  [<ffffffff80272902>] sys_init_module+0xb2/0x1d0
[   58.960419]  [<ffffffff8020c6da>] system_call_after_swapgs+0x8a/0x8f
[   58.960432]
[   58.960436] ---[ end trace ca143223eefdc828 ]---

If needed I'll make the full dmesg&config available.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
