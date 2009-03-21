Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZCUSnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZCUSnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 14:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZCUSng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 14:43:36 -0400
Received: from smtp4.Stanford.EDU ([171.67.219.84]:37810 "EHLO
	smtp4.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZCUSne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 14:43:34 -0400
Subject: Re: [Announce] 2.6.29-rc8-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Fernando Pablo Lopez-Lezcano <nando@ccrma.Stanford.EDU>
In-Reply-To: <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
References: <1235437021.4462.25.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>
	 <1235513895.3816.11.camel@localhost.localdomain>
	 <1235595160.9252.49.camel@localhost.localdomain>
	 <1235619922.31774.17.camel@localhost.localdomain>
	 <1236984825.10748.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 11:44:13 -0700
Message-Id: <1237661053.3196.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 08:46 +0100, Thomas Gleixner wrote:
> On Fri, 13 Mar 2009, Fernando Lopez-Lezcano wrote:
> > After a quick test some BUG's on boot (on a quad core intel machine),
> > I'm just attaching the whole dmesg output as that might provide more
> > clues...
> > 
> > In short, two types, one BUG and another WARNING:
> > 
> > BUG: sleeping function called from invalid context at
> > kernel/rtmutex.c:683
> > WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x3e/0xa8()
> 
> Yep. I got another report already. Looking into it.
>  
> > Thanks again for all the hard work!
> > (and looking forward to the next rt patch!)
> 
> Thansk for testing !

More testing and an Oops that prevents booting... maybe unrelated to rt?
(this is with 2.6.29-rc8 plus additional patches from Fedora's koji
build 61 for fc10). First time my laptop does not boot with the new
kernels on a long time. 

See below. 
-- Fernando


Mar 21 10:47:43 localhost kernel: kernel tried to execute NX-protected
page - exploit attempt? (uid: 0)
Mar 21 10:47:43 localhost kernel: BUG: unable to handle kernel paging
request at f6400800
Mar 21 10:47:43 localhost kernel: IP: [<f6400800>] 0xf6400800
Mar 21 10:47:43 localhost kernel: *pdpt = 0000000000922001 *pde =
000000003087f063 *pte = 8000000036400163 
Mar 21 10:47:43 localhost kernel: Oops: 0011 [#1] PREEMPT SMP 
Mar 21 10:47:43 localhost kernel: last sysfs
file: /sys/devices/pci0000:00/0000:00:19.0/irq
Mar 21 10:47:43 localhost kernel: Modules linked in: sunrpc ip6t_REJECT
nf_conntrack_ipv6 ip6table_filter ip6_tables cpufreq_ondemand
acpi_cpufreq dm_multipath i915 drm i2c_algo_bit ipv6
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep thinkpad_acpi
hwmon arc4 snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq joydev
ecb sdhci_pci snd_seq_device yenta_socket ricoh_mmc i2c_i801 sdhci
i2c_core pcspkr snd_pcm_oss snd_mixer_oss snd_pcm mmc_core
rsrc_nonstatic iwl3945 ohci1394 snd_timer iTCO_wdt iTCO_vendor_support
snd video output soundcore rfkill btusb snd_page_alloc mac80211 lib80211
e1000e bluetooth cfg80211 ata_generic pata_acpi uhci_hcd ohci_hcd
ehci_hcd [last unloaded: microcode]
Mar 21 10:47:43 localhost kernel:
Mar 21 10:47:43 localhost kernel: Pid: 9, comm: sirq-tasklet/0 Not
tainted (2.6.29-0.2.rt2.1.rc8.fc9.ccrma.i686.rtPAE #1) 6463CTO
Mar 21 10:47:43 localhost kernel: EIP: 0060:[<f6400800>] EFLAGS:
00010246 CPU: 0
Mar 21 10:47:43 localhost kernel: EIP is at 0xf6400800
Mar 21 10:47:43 localhost kernel: EAX: f3858f20 EBX: 00000000 ECX:
000000ff EDX: f38598b4
Mar 21 10:47:43 localhost kernel: ESI: f3858f20 EDI: 000000ff EBP:
f7073f84 ESP: f7073f20
Mar 21 10:47:43 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000
SS: 0068 preempt:00000001
Mar 21 10:47:43 localhost kernel: Process sirq-tasklet/0 (pid: 9,
ti=f7073000 task=f7088e30 task.ti=f7073000)
Mar 21 10:47:43 localhost kernel: Stack:
Mar 21 10:47:43 localhost kernel: f82adb93 f3859494 00000000 00010000
00000008 00ccd272 00000000 00000000
Mar 21 10:47:43 localhost kernel: 00000002 ea427004 f38598b4 f385b5cc
f385b5d8 2a427004 00000000 f385b7f4
Mar 21 10:47:43 localhost kernel: f385cf70 f3859880 f41a3a40 80000008
2a9ae004 00000006 f385d020 f385d024
Mar 21 10:47:43 localhost kernel: Call Trace:
Mar 21 10:47:43 localhost kernel: [<f82adb93>] ? iwl3945_irq_tasklet
+0x421/0x80f [iwl3945]
Mar 21 10:47:43 localhost kernel: [<c043d0e2>] ? __tasklet_action
+0x81/0xe4
Mar 21 10:47:43 localhost kernel: [<c043d1c5>] ? tasklet_action
+0x3e/0x42
Mar 21 10:47:43 localhost kernel: [<c043ceb7>] ? ksoftirqd+0x131/0x221
Mar 21 10:47:43 localhost kernel: [<c043cd86>] ? ksoftirqd+0x0/0x221
Mar 21 10:47:43 localhost kernel: [<c0449949>] ? kthread+0x3b/0x61
Mar 21 10:47:43 localhost kernel: [<c044990e>] ? kthread+0x0/0x61
Mar 21 10:47:43 localhost kernel: [<c0409207>] ? kernel_thread_helper
+0x7/0x10
Mar 21 10:47:43 localhost kernel: Code: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 <00> 00 00 00 6c 09 14 00 01 00 00 00 00 00 00
00 06 00 00 00 0f 
Mar 21 10:47:43 localhost kernel: EIP: [<f6400800>] 0xf6400800 SS:ESP
0068:f7073f20
Mar 21 10:47:43 localhost kernel: CR2: 00000000f6400800
Mar 21 10:47:43 localhost kernel: ---[ end trace 8e8838dc83c2350d ]---



