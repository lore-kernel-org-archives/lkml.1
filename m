Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZCZDro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZCZDro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZCZDrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:47:33 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:42299 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbZCZDrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:47:31 -0400
Subject: Re: [Announce] 2.6.29-rc8-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: nando@ccrma.Stanford.EDU, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1238006725.3143.0.camel@localhost.localdomain>
References: <1235619922.31774.17.camel@localhost.localdomain>
	 <1236984825.10748.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
	 <1237661053.3196.10.camel@localhost.localdomain>
	 <20090321184904.GA19352@elte.hu>
	 <1237662372.3574.2.camel@localhost.localdomain>
	 <1237663624.3200.3.camel@localhost.localdomain>
	 <1237687635.3424.1.camel@localhost.localdomain>
	 <20090322130937.GA22848@elte.hu>
	 <1237758228.18021.8.camel@localhost.localdomain>
	 <20090323080724.GA13569@elte.hu>
	 <1237864404.3441.8.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903240907390.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903240912360.29264@localhost.localdomain>
	 <1237953290.3203.3.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903250824060.29264@localhost.localdomain>
	 <1238006725.3143.0.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 20:48:07 -0700
Message-Id: <1238039287.3345.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 11:45 -0700, Fernando Lopez-Lezcano wrote:
> On Wed, 2009-03-25 at 08:27 +0100, Thomas Gleixner wrote:
> > On Wed, 25 Mar 2009, Fernando Lopez-Lezcano wrote:
> > > > > 
> > > > > That'd be very helpful.
> > > 
> > > Snapshot attached... (on my t61 laptop)
> > 
> > The crash happens in alternatives_smp_switch(). Can you check whether
> > adding "noreplace-smp" to the kernel command line helps ? I boot your
> > config on my own T61. Hopefully I can reproduce.
> 
> Booting with noreplace-smp fixes the problem in my case, I can shutdown
> with no problems. 

The problem is still there in 2.6.29-rt1...

Booting it I got this, but not all the time (I'm writing from the T61
having booted successfully...):

Mar 25 20:09:04 localhost kernel: BUG: unable to handle kernel paging
request at f5891000
Mar 25 20:09:04 localhost kernel: IP: [<f5891000>] 0xf5891000
Mar 25 20:09:04 localhost kernel: *pdpt = 0000000000945001 *pde =
80000000358001e3 
Mar 25 20:09:04 localhost kernel: Oops: 0011 [#1] PREEMPT SMP 
Mar 25 20:09:04 localhost kernel: last sysfs
file: /sys/devices/pci0000:00/0000:00:19.0/irq
Mar 25 20:09:04 localhost kernel: Modules linked in: l2cap sunrpc
ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6
cpufreq_ondemand acpi_cpufreq dm_multipath uinput snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy arc4 snd_seq_oss
snd_seq_midi_event ecb snd_seq snd_seq_device thinkpad_acpi iwl3945
snd_pcm_oss snd_mixer_oss snd_pcm rfkill sdhci_pci hwmon btusb snd_timer
mac80211 ohci1394 i2c_i801 snd sdhci ricoh_mmc mmc_core yenta_socket
i2c_core iTCO_wdt rsrc_nonstatic pcspkr video soundcore lib80211 e1000e
snd_page_alloc cfg80211 bluetooth iTCO_vendor_support joydev output
ata_generic pata_acpi [last unloaded: microcode]
Mar 25 20:09:04 localhost kernel:
Mar 25 20:09:04 localhost kernel: Pid: 9, comm: sirq-tasklet/0 Not
tainted (2.6.29-1.rt1.1.fc10.ccrma.i686.rtPAE #1) 6463CTO
Mar 25 20:09:04 localhost kernel: EIP: 0060:[<f5891000>] EFLAGS:
00010246 CPU: 0
Mar 25 20:09:04 localhost kernel: EIP is at 0xf5891000
Mar 25 20:09:04 localhost kernel: EAX: f73c0f20 EBX: 00000000 ECX:
000000ff EDX: f73c18b4
Mar 25 20:09:04 localhost kernel: ESI: f73c0f20 EDI: 000000ff EBP:
f7073f84 ESP: f7073f20
Mar 25 20:09:04 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000
SS: 0068 preempt:00000001
Mar 25 20:09:04 localhost kernel: Process sirq-tasklet/0 (pid: 9,
ti=f7073000 task=f7088e40 task.ti=f7073000)
Mar 25 20:09:04 localhost kernel: Stack:
Mar 25 20:09:04 localhost kernel: f8357bde f73c1494 00000000 00010000
00000008 00000005 00000000 00000000
Mar 25 20:09:04 localhost kernel: 00000002 f45c0004 f73c18b4 f73c35cc
f73c35d8 345c0004 00000000 f73c37f4
Mar 25 20:09:04 localhost kernel: f73c4f70 f73c1880 fffffffd 80000008
34940004 00000006 f73c5020 f73c5024
Mar 25 20:09:04 localhost kernel: Call Trace:
Mar 25 20:09:04 localhost kernel: [<f8357bde>] ? iwl3945_irq_tasklet
+0x421/0x80f [iwl3945]
Mar 25 20:09:04 localhost kernel: [<c043d707>] ? __tasklet_action
+0x81/0xe4
Mar 25 20:09:04 localhost kernel: [<c043d7ea>] ? tasklet_action
+0x3e/0x42
Mar 25 20:09:04 localhost kernel: [<c043d4e6>] ? ksoftirqd+0x130/0x216
Mar 25 20:09:04 localhost kernel: [<c043d3b6>] ? ksoftirqd+0x0/0x216
Mar 25 20:09:04 localhost kernel: [<c044a18d>] ? kthread+0x3b/0x61
Mar 25 20:09:04 localhost kernel: [<c044a152>] ? kthread+0x0/0x61
Mar 25 20:09:04 localhost kernel: [<c0409267>] ? kernel_thread_helper
+0x7/0x10
Mar 25 20:09:04 localhost kernel: Code: 00 00 00 00 00 00 00 00 00 00 00
fc 00 00 00 24 04 0a b8 73 00 00 00 46 02 00 00 dc e6 c9 bf 7b 00 00 00
00 00 00 00 00 00 00 00 <00> 00 00 00 6c 09 14 00 01 00 00 00 00 00 00
00 06 00 00 00 0f 
Mar 25 20:09:04 localhost kernel: EIP: [<f5891000>] 0xf5891000 SS:ESP
0068:f7073f20
Mar 25 20:09:04 localhost kernel: CR2: 00000000f5891000
Mar 25 20:09:04 localhost kernel: ---[ end trace bf9fc42e701e26d1 ]---

-- Fernando

And before that this one, looks even weirder...
I think this was a warm boot from
kernel-PAE-2.6.27.19-170.2.35.fc10.i686

Mar 25 20:02:23 localhost kernel: iwl3945 0000:03:00.0: PCI INT A -> GSI
17 (level, low) -> IRQ 17
Mar 25 20:02:25 localhost kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000008.
Mar 25 20:02:25 localhost kernel: ------------[ cut here ]------------
Mar 25 20:02:25 localhost kernel: kernel BUG at
drivers/net/wireless/iwlwifi/iwl3945-base.c:3352!
Mar 25 20:02:25 localhost kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Mar 25 20:02:25 localhost kernel: last sysfs
file: /sys/devices/pci0000:00/0000:00:19.0/irq
Mar 25 20:02:25 localhost kernel: Modules linked in: sunrpc ip6t_REJECT
nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand
acpi_cpufreq dm_multipath uinput snd_hda_codec_analog snd_hda_intel
snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event
arc4 snd_seq snd_seq_device ecb sdhci_pci snd_pcm_oss snd_mixer_oss
snd_pcm sdhci thinkpad_acpi hwmon iwl3945 rfkill mac80211 ohci1394
i2c_i801 btusb snd_timer ricoh_mmc mmc_core snd yenta_socket i2c_core
video rsrc_nonstatic pcspkr soundcore lib80211 bluetooth iTCO_wdt e1000e
snd_page_alloc cfg80211 joydev iTCO_vendor_support output ata_generic
pata_acpi [last unloaded: microcode]
Mar 25 20:02:25 localhost kernel:
Mar 25 20:02:25 localhost kernel: Pid: 23, comm: sirq-tasklet/1 Not
tainted (2.6.29-1.rt1.1.fc10.ccrma.i686.rtPAE #1) 6463CTO
Mar 25 20:02:25 localhost kernel: EIP: 0060:[<f832bc52>] EFLAGS:
00010297 CPU: 1
Mar 25 20:02:25 localhost kernel: EIP is at iwl3945_irq_tasklet
+0x495/0x80f [iwl3945]
Mar 25 20:02:25 localhost kernel: EAX: 00000000 EBX: 00000000 ECX:
f44ab380 EDX: f73a0000
Mar 25 20:02:25 localhost kernel: ESI: f73a8f20 EDI: 00000000 EBP:
f70abf84 ESP: f70abf24
Mar 25 20:02:25 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000
SS: 0068 preempt:00000001
Mar 25 20:02:25 localhost kernel: Process sirq-tasklet/1 (pid: 23,
ti=f70ab000 task=f70bf000 task.ti=f70ab000)
Mar 25 20:02:25 localhost kernel: Stack:
Mar 25 20:02:25 localhost kernel: f73a9494 02000000 00010000 00000008
00000005 00000001 00000000 00000003
Mar 25 20:02:25 localhost kernel: f44bb004 f73a98b4 f73ab5cc f73ab5d8
344bb004 00000000 f73ab7f4 f73acf70
Mar 25 20:02:25 localhost kernel: f73a9880 00000000 82000008 349ad004
00000006 f73ad020 f73ad024 000f4240
Mar 25 20:02:25 localhost kernel: Call Trace:
Mar 25 20:02:25 localhost kernel: [<c043d707>] ? __tasklet_action
+0x81/0xe4
Mar 25 20:02:25 localhost kernel: [<c043d7ea>] ? tasklet_action
+0x3e/0x42
Mar 25 20:02:25 localhost kernel: [<c043d4e6>] ? ksoftirqd+0x130/0x216
Mar 25 20:02:25 localhost kernel: [<c043d3b6>] ? ksoftirqd+0x0/0x216
Mar 25 20:02:25 localhost kernel: [<c044a18d>] ? kthread+0x3b/0x61
Mar 25 20:02:25 localhost kernel: [<c044a152>] ? kthread+0x0/0x61
Mar 25 20:02:25 localhost kernel: [<c0409267>] ? kernel_thread_helper
+0x7/0x10
Mar 25 20:02:25 localhost kernel: Code: 0f 84 44 01 00 00 8b 45 c4 8b 48
08 85 c9 0f 84 2b 01 00 00 8b 81 ac 00 00 00 66 8b 50 06 0f b6 c6 25 bf
00 00 00 83 f8 04 74 04 <0f> 0b eb fe 88 55 e7 80 e6 40 8b 86 e8 27 00
00 75 04 48 22 45 
Mar 25 20:02:25 localhost kernel: EIP: [<f832bc52>] iwl3945_irq_tasklet
+0x495/0x80f [iwl3945] SS:ESP 0068:f70abf24
Mar 25 20:02:25 localhost kernel: ---[ end trace 173bbf32758a5321 ]---


