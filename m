Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZGRUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZGRUEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 16:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZGRUEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 16:04:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:42938 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbZGRUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 16:04:13 -0400
Subject: s2r badness
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 22:03:03 +0200
Message-Id: <1247947383.4872.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

s2r seems to resume again on my latest kernel build (used to be broken
for a long-ish while).

However it does generate the blow splats.

[   74.576953] ------------[ cut here ]------------
[   74.576953] WARNING: at /usr/src/linux-2.6/kernel/softirq.c:143 local_bh_enable_ip+0x8b/0xc0()
[   74.576953] Hardware name: 2242CTO
[   74.576953] Modules linked in: cryptd aes_x86_64 aes_generic ecryptfs
nfs lockd nfs_acl auth_rpcgss sunrpc binfmt_misc fbcon tileblit font
bitblit softcursor bridge stp llc bnep autofs4 acpi_cpufreq joydev btusb
coretemp sbp2 snd_hda_codec_conexant pcmcia ecb psmouse serio_raw
iTCO_wdt iTCO_vendor_support snd_hda_intel snd_hda_codec snd_pcm_oss
pcspkr snd_mixer_oss iwlagn iwlcore snd_pcm mac80211 snd_seq_dummy
ricoh_mmc sdhci_pci sdhci snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event yenta_socket rsrc_nonstatic pcmcia_core cfg80211
snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc i915
intel_agp thinkpad_acpi led_class video nvram ohci1394 ieee1394 ehci_hcd
uhci_hcd fuse
[   74.576953] Pid: 5406, comm: bash Not tainted 2.6.31-rc3-tip #32
[   74.576953] Call Trace:
[   74.576953]  [<ffffffff8107401b>] ? local_bh_enable_ip+0x8b/0xc0
[   74.576953]  [<ffffffff8106c838>] warn_slowpath_common+0x78/0xd0
[   74.576953]  [<ffffffff8106c89f>] warn_slowpath_null+0xf/0x20
[   74.576953]  [<ffffffff8107401b>] local_bh_enable_ip+0x8b/0xc0
[   74.576953]  [<ffffffff814d08d9>] _spin_unlock_bh+0x19/0x20
[   74.576953]  [<ffffffff810d2c77>] load_debug_registers+0x67/0x80
[   74.576953]  [<ffffffff813cbcdb>] restore_processor_state+0x22b/0x280
[   74.576953]  [<ffffffff81286643>] acpi_suspend_enter+0x6a/0xeb
[   74.576953]  [<ffffffff810a217f>] suspend_devices_and_enter+0x22f/0x240
[   74.576953]  [<ffffffff810a22b9>] enter_state+0x129/0x150
[   74.576953]  [<ffffffff810a17da>] state_store+0xba/0x100
[   74.576953]  [<ffffffff81248a17>] kobj_attr_store+0x17/0x20
[   74.576953]  [<ffffffff81176155>] sysfs_write_file+0xc5/0x140
[   74.576953]  [<ffffffff8111402b>] vfs_write+0xcb/0x1a0
[   74.576953]  [<ffffffff811141f0>] sys_write+0x50/0x90
[   74.576953]  [<ffffffff8102e242>] system_call_fastpath+0x16/0x1b
[   74.576953] ---[ end trace 58ad491f88b81455 ]---


[   75.906997] Call Trace:
[   75.907001]  <IRQ>  [<ffffffff810b63c6>] __report_bad_irq+0x26/0xa0
[   75.907022]  [<ffffffff810b65c8>] note_interrupt+0x188/0x1d0
[   75.907029]  [<ffffffff810b6c85>] handle_fasteoi_irq+0xd5/0x100
[   75.907038]  [<ffffffff81030b7f>] handle_irq+0x1f/0x30
[   75.907043]  [<ffffffff8103029e>] do_IRQ+0x6e/0xf0
[   75.907052]  [<ffffffff8102ec53>] ret_from_intr+0x0/0x11
[   75.907055]  <EOI>  [<ffffffff81096130>] ? tick_nohz_stop_sched_tick+0x70/0x3a0
[   75.907072]  [<ffffffff8102ca0a>] ? cpu_idle+0x2a/0xd0
[   75.907080]  [<ffffffff814ba485>] ? rest_init+0x75/0x80
[   75.907090]  [<ffffffff817aed55>] ? start_kernel+0x37a/0x42a
[   75.907098]  [<ffffffff817ae299>] ? x86_64_start_reservations+0x99/0xb9
[   75.907106]  [<ffffffff817ae3be>] ? x86_64_start_kernel+0x105/0x120
[   75.907113]  [<ffffffff817ae140>] ? early_idt_handler+0x0/0x71
[   75.907117] handlers:
[   75.907121] [<ffffffff8137fe10>] (usb_hcd_irq+0x0/0x90)
[   75.907130] Disabling IRQ #18


