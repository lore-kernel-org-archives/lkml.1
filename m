Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZCJFmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZCJFmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZCJFmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:42:24 -0400
Received: from blade.4t2.com ([88.198.19.40]:60901 "EHLO blade.4t2.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZCJFmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:42:23 -0400
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
From: Tom Weber <l_linux-kernel@mail2news.4t2.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Michael =?ISO-8859-1?Q?B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1236508032.14878.1.camel@morgoth.abyss.4t2.com>
References: <200903041828.49972.m.bueker@berlin.de>
	 <20090304224310.GA29043@electric-eye.fr.zoreil.com>
	 <1236508032.14878.1.camel@morgoth.abyss.4t2.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 06:42:03 +0100
Message-Id: <1236663723.29428.33.camel@morgoth.abyss.4t2.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-4t2Systems-MailScanner-Information: processed at blade.4t2.com
X-4t2Systems-MailScanner: Found to be clean
X-4t2Systems-MailScanner-From: l_linux-kernel@mail2news.4t2.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 08.03.2009, 11:27 +0100 schrieb Tom Weber:
> Happens at least with 2.6.28, 2.6.28.4, 2.6.28.6 and 2.6.29-rc7.
> 
> This is a diskless box (on NFS) on GigE LAN, used for DVB-S
> recordings/playback with vdr.
[...]
> Every once in while, more likely with heavy usage of the vdr stuff (like
> recording two shows and/or cutting a recording) these show up. Of course
> the impact is realy bad on a diskless system. It takes the system from
> 10 seconds to 3 minutes to recover.

After running 2.6.29-rc7 for more than a day now with lots of data moved
around I got the impression that it is more stable than 2.6.28.6.
I only got one warning so far and a few 
r8169: eth0: link up
messages.

I know this is a vague statement, but I think I would have seen more
warnings with 2.6.28.6 and all the stuff I've done.

Below is the latest / only Call trace I've got since my earlier mail.

Note the 'eth0: link up' messages. This is where most likely the
2.6.28.6 would have barfed on me (cutting of recordings).

This is the complete dmesg output since the first warning. I didn't
remove anything before or between the 'link up' messages.

[2.6.29-rc7 - same configs etc as described in my earlier mail]

[  320.501076] nfs: server 192.168.1.8 not responding, still trying
[  321.031065] nfs: server 192.168.1.8 not responding, still trying
[  321.997042] ------------[ cut here ]------------
[  321.997050] WARNING: at net/sched/sch_generic.c:226 dev_watchdog+0x1f1/0x200()
[  321.997056] Hardware name: System Product Name
[  321.997060] NETDEV WATCHDOG: eth0 (r8169): transmit timed out
[  321.997063] Modules linked in: autofs4 powernow_k8 cpufreq_stats cpufreq_ondemand cpufreq_conservative cpufreq_performance freq_table pci_slot sbs ac battery video backlight output sbshc container sbp2 loop lnbp21 stv0299 snd_hda_codec_atihdmi snd_seq_dummy snd_seq_oss snd_hda_codec_realtek snd_seq_midi snd_hda_intel dvb_ttpci snd_hda_codec dvb_core snd_pcm_oss saa7146_vv saa7146 snd_rawmidi snd_mixer_oss videobuf_dma_sg evdev videobuf_core serio_raw psmouse videodev snd_seq_midi_event v4l1_compat ttpci_eeprom k8temp snd_pcm pcspkr snd_seq rtc_cmos rtc_core rtc_lib i2c_piix4 i2c_core snd_timer snd_seq_device button snd wmi soundcore snd_page_alloc af_packet pata_acpi ata_generic sg sr_mod cdrom ohci1394 pata_atiixp ehci_hcd ohci_hcd ahci ieee1394 libata usbcore scsi_mod raid10 raid456 async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal processor fan thermal_sys hwmon fuse
[  321.997191] Pid: 0, comm: swapper Not tainted 2.6.29-rc7 #1
[  321.997195] Call Trace:
[  321.997207]  [<c0229587>] warn_slowpath+0x87/0xe0
[  321.997216]  [<c0402177>] pskb_copy+0x27/0x160
[  321.997222]  [<c0402177>] pskb_copy+0x27/0x160
[  321.997229]  [<c0214829>] ack_apic_level+0x59/0x260
[  321.997236]  [<c0269c00>] rcu_sched_grace_period+0x1e0/0x2c0
[  321.997242]  [<c026897b>] handle_fasteoi_irq+0x8b/0xe0
[  321.997249]  [<c022eefd>] irq_exit+0x2d/0x90
[  321.997256]  [<c0204e6d>] do_IRQ+0x4d/0x90
[  321.997266]  [<c0246b41>] getnstimeofday+0x51/0x110
[  321.997272]  [<c02039e7>] common_interrupt+0x27/0x2c
[  321.997279]  [<c0369d1f>] strlcpy+0x1f/0x60
[  321.997285]  [<c0419711>] dev_watchdog+0x1f1/0x200
[  321.997291]  [<c0240039>] posix_cpu_timer_set+0x409/0x450
[  321.997298]  [<c0243d5d>] sched_clock_cpu+0x14d/0x1a0
[  321.997306]  [<c02126a0>] lapic_next_event+0x10/0x20
[  321.997312]  [<c02493e3>] clockevents_program_event+0xa3/0x170
[  321.997320]  [<c0232f8d>] cascade+0x5d/0x80
[  321.997326]  [<c0233160>] run_timer_softirq+0x130/0x1f0
[  321.997332]  [<c0419520>] dev_watchdog+0x0/0x200
[  321.997337]  [<c0419520>] dev_watchdog+0x0/0x200
[  321.997342]  [<c022ec3f>] __do_softirq+0x7f/0x130
[  321.997361]  [<c022ed45>] do_softirq+0x55/0x60
[  321.997366]  [<c022ef45>] irq_exit+0x75/0x90
[  321.997373]  [<c0212eb7>] smp_apic_timer_interrupt+0x67/0xa0
[  321.997384]  [<c0203b00>] apic_timer_interrupt+0x28/0x30
[  321.997392]  [<c0209292>] default_idle+0x42/0x50
[  321.997398]  [<c020941f>] c1e_idle+0x2f/0xf0
[  321.997403]  [<c0202353>] cpu_idle+0x63/0xa0
[  321.997412]  [<c04ac293>] start_secondary+0x19e/0x2eb
[  321.997417]  [<c020b9ce>] user_enable_single_step+0xe/0x10
[  321.997422] ---[ end trace c509771bca9f9e70 ]---
[  322.009305] nfs: server 192.168.1.8 OK
[  322.009589] r8169: eth0: link up
[  323.152320] nfs: server 192.168.1.8 OK
[  323.152397] nfs: server 192.168.1.8 OK
[  323.152508] nfs: server 192.168.1.8 OK
[68818.001610] r8169: eth0: link up
[69004.003443] r8169: eth0: link up
[90178.001567] r8169: eth0: link up

  Tom

