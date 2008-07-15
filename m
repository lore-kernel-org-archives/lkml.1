Return-Path: <linux-kernel-owner+w=401wt.eu-S1762911AbYGOTHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762911AbYGOTHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762750AbYGOTGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:06:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52450 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762826AbYGOTGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:06:40 -0400
Subject: Re: [PATCH 00/20] generic show_mem() v5
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20080704160737.750988999@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 12:06:34 -0700
Message-Id: <1216148794.25942.11.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's holding this up?

I'm getting a pretty regular oops that this series would have fixed.  I
have a temporary workaround patch attached, but it would conflict with
this, and I'd hate to muck up its merge.

[127227.081586] IP: [<c011c5bb>] show_mem+0x8b/0x250
[127227.091751] Oops: 0000 [#1] SMP
[127227.095152] Modules linked in: kqemu authenc esp4 aead xfrm4_mode_tunnel nls_iso8859_1 vfat fat rfcomm l2cap kvm_intel kvm tun ppdev acpi_cpufreq cpufreq_stats cpufreq_ondemand freq_table cpufreq_powersave cpufreq_userspace cpufreq_conservative sbs container sbshc iptable_filter ip_tables x_tables deflate zlib_deflate des_generic cbc aes_generic xcbc sha256_generic sha1_generic af_key dummy dm_crypt dm_mod lp joydev snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss af_packet snd_seq_midi_event snd_seq arc4 ecb usbhid snd_timer pcmcia crypto_blkcipher usb_storage snd_seq_device psmouse thinkpad_acpi iwl4965 iwlcore hid serio_raw libusual hci_usb sdhci mac80211 led_class snd parport_pc parport mmc_core ricoh_mmc yenta_socket rsrc_nonstatic pcmcia_core button soundcore cfg80211 nvram evdev snd_page_alloc ohci1394 ieee1394 ehci_hcd uhci_hcd usbcore e1000 thermal processor fan fuse
[127227.095152]
[127227.095152] Pid: 0, comm: swapper Not tainted (2.6.26-rc8-00089-ge1441b9 #24)
[127227.095152] EIP: 0060:[<c011c5bb>] EFLAGS: 00010206 CPU: 0
[127227.095152] EIP is at show_mem+0x8b/0x250
[127227.095152] EAX: 01800000 EBX: 000c0000 ECX: 00000018 EDX: 01800000
[127227.095152] ESI: c04b5700 EDI: 0013c000 EBP: c0536e10 ESP: c0536de8
[127227.095152]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[127227.095152] Process swapper (pid: 0, ti=c0536000 task=c04afa40 task.ti=c04e8000)
[127227.095152] Stack: c04574fa 00000000 00088000 0000000b 00060e45 00002f19 000c0001 c04b6b24
[127227.095152]        c04afa40 00004020 c0536e5c c016b067 c045fddc c04afd41 00000002 00004020
[127227.095152]        c04b6b04 00000000 00000032 00000000 00000001 00000000 c04b6b00 00000002
[127227.095152] Call Trace:
[127227.095152]  [<c016b067>] ? __alloc_pages_internal+0x3d7/0x420
[127227.095152]  [<c016b0c2>] ? __alloc_pages+0x12/0x20
[127227.095152]  [<c016b102>] ? __get_free_pages+0x12/0x30
[127227.095152]  [<c018d262>] ? __kmalloc_track_caller+0xd2/0x100
[127227.095152]  [<c031bb44>] ? skb_copy+0x34/0x90
[127227.095152]  [<c031b43b>] ? __alloc_skb+0x4b/0x100
[127227.095152]  [<c031bb44>] ? skb_copy+0x34/0x90
[127227.095152]  [<f8ba234b>] ? __ieee80211_rx_handle_packet+0x13b/0x1f0 [mac80211]
[127227.095152]  [<f8ba2906>] ? __ieee80211_rx+0xb6/0xc0 [mac80211]
[127227.095152]  [<f8b91ad3>] ? ieee80211_tasklet_handler+0x103/0x110 [mac80211]
[127227.095152]  [<c013257b>] ? tasklet_action+0xcb/0xe0
[127227.095152]  [<c0132161>] ? __do_softirq+0x81/0x110
[127227.095152]  [<c0105f1e>] ? do_softirq+0x6e/0xd0
[127227.095152]  [<c0160cd0>] ? handle_fasteoi_irq+0x0/0xd0
[127227.095152]  [<c0132255>] ? irq_exit+0x45/0x50
[127227.095152]  [<c0105da1>] ? do_IRQ+0x91/0xf0
[127227.095152]  [<c010479b>] ? common_interrupt+0x23/0x28
[127227.095152]  [<c014007b>] ? sys_timer_create+0xeb/0x2a0
[127227.095152]  [<f8862079>] ? acpi_processor_idle+0x30f/0x47c [processor]
[127227.095152]  [<f8861d6a>] ? acpi_processor_idle+0x0/0x47c [processor]
[127227.095152]  [<c0102122>] ? cpu_idle+0x92/0xe0
[127227.095152]  [<c038d6de>] ? rest_init+0x4e/0x50
[127227.095152]  =======================
[127227.095152] Code: f7 c3 ff 03 00 00 0f 84 bc 01 00 00 8b 86 34 14 00 00 ff 45 f0 01 d8 89 c2 c1 ea 11 8b 14 d5 00 a3 59 c0 c1 e0 05 83 e2 fc 01 c2 <8b> 0a 89 c8 c1 e8 17 83 e0 03 8d 04 80 c1 e0 08 05 00 57 4b c0
[127227.095152] EIP: [<c011c5bb>] show_mem+0x8b/0x250 SS:ESP 0068:c0536de8
[127227.704832] Kernel panic - not syncing: Fatal exception in interrupt

-- Dave

>From 55b1d0caade20e9597e07759d923f6ce1350e522 Mon Sep 17 00:00:00 2001
From: Dave Hansen <dave@sr71.net>
Date: Tue, 15 Jul 2008 10:32:56 -0700
Subject: [PATCH] fix i386 show_mem() oops

I've had the occasional kernel hang with 2.6.26 since I
upgraded my laptop to 4G of RAM.  But, I have a hole at
3-4GB, so I need PAE, and I'm running with SPARSEMEM=y.

I figured it was something to do with PAE, but never
got a clean oops until this morning.  The oops was in
show_mem()'s pgdat_page_nr().  It was passing a pfn of
a page from the memory hole and oopsing.

Dumping my sparsemem section table, you can clearly see
the hole:

00000000  03 10 00 c1 00 02 00 c1  03 10 00 c1 80 02 00 c1  |................|
00000010  03 10 00 c1 00 03 00 c1  03 10 00 c1 80 03 00 c1  |................|
00000020  03 10 00 c1 00 04 00 c1  03 10 00 c1 80 04 00 c1  |................|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000040  03 10 80 c0 00 05 00 c1  03 10 80 c0 80 05 00 c1  |................|
00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000400

The sections are 512MB, and you can see 6 valid ones
followed by two holes, and then two more valid ones.

Anyway, I believe this patch will fix the oops.
---
 arch/x86/mm/pgtable_32.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 369cf06..eb2a480 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -37,6 +37,8 @@ void show_mem(void)
 		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
 			if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
 				touch_nmi_watchdog();
+			if (!pfn_valid(pgdat->node_start_pfn + i))
+				continue;
 			page = pgdat_page_nr(pgdat, i);
 			total++;
 			if (PageHighMem(page))
-- 
1.5.4.3



