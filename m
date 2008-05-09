Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbYEIRub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbYEIRub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbYEIRuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:50:23 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:18953 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759756AbYEIRuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:50:20 -0400
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2008 13:50:20 EDT
Date: Fri, 9 May 2008 10:19:56 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.25-mm1: kmmcd NULL pointer dereference at klist_del+0xe/0x30
Message-ID: <20080509171956.GJ30021@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this twice with 2.6.25-mm1 on my Thinkpad X40, AData 16GB SDHC card
in mmc0 but no filesystem mounted.  I think the oops happened at
suspend/resume time.  Previous kernel was 2.6.25-rc5-mm1 which didn't
exhibit this problem across multiple suspend-resume cycles.

Complete logs and pretty much everything else you could want at
http://web.hexapodia.org/~adi/bobble/bobble_2.6.25-mm1-dirty_20080509100634/

[104375.816331] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[104375.816338] IP: [<c02d86ce>] klist_del+0xe/0x30
[104375.816350] *pde = 00000000 
[104375.816356] Oops: 0000 [#1] 
[104375.816361] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0/rf_kill
[104375.816367] Modules linked in: ipw2200 michael_mic arc4 ecb crypto_blkcipher ieee80211_crypt_tkip crc32 i915 drm rfcomm l2cap bluetooth ipv6 acpi_cpufreq cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats af_packet dm_snapshot dm_mirror dm_log dm_mod loop mmc_block battery ac video output sdhci ieee80211 ieee80211_crypt yenta_socket rsrc_nonstatic pcmcia_core mmc_core firmware_class dock button psmouse snd_intel8x0m snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc thinkpad_acpi pcspkr intel_agp agpgart rtc hwmon backlight evdev nvram e1000 ehci_hcd uhci_hcd usbcore thermal processor fan unix [last unloaded: ipw2200]
[104375.816442] 
[104375.816448] Pid: 3130, comm: kmmcd Tainted: G        W (2.6.25-mm1-dirty #1)
[104375.816455] EIP: 0060:[<c02d86ce>] EFLAGS: 00010292 CPU: 0
[104375.816464] EIP is at klist_del+0xe/0x30
[104375.816469] EAX: 00000000 EBX: f7b0a04c ECX: f7804f40 EDX: f896f474
[104375.816476] ESI: f7b0a004 EDI: f7b0a090 EBP: f896f680 ESP: f2923ebc
[104375.816482]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[104375.816490] Process kmmcd (pid: 3130, ti=f2922000 task=f291d9b0 task.ti=f2922000)
[104375.816495] Stack: f7b0a06c f7b0a004 c024b048 fffffff0 f7b0a004 c0249cd0 f7b0a06c f28cf86c 
[104375.816507]        c032e90c f7b0a090 f7b0a06c f28cf804 f28cf890 00000000 f896f680 f7b0a000 
[104375.816518]        f28cf800 00000000 f896a83f f7b0a000 f28cf800 00000000 f896a83f f8965c62 
[104375.816529] Call Trace:
[104375.816535]  [<c024b048>] bus_remove_device+0x58/0x80
[104375.816546]  [<c0249cd0>] device_add+0x4f0/0x5a0
[104375.816574]  [<f8965c62>] mmc_add_card+0xb2/0x160 [mmc_core]
[104375.816608]  [<f896788e>] mmc_attach_sd+0x21e/0x8d0 [mmc_core]
[104375.816644]  [<f8965950>] mmc_rescan+0x0/0x150 [mmc_core]
[104375.816668]  [<f8965a7e>] mmc_rescan+0x12e/0x150 [mmc_core]
[104375.816693]  [<c0129f3b>] run_workqueue+0x8b/0x110
[104375.816704]  [<c01177dc>] set_next_entity+0x1c/0x50
[104375.816716]  [<c012a070>] worker_thread+0x0/0xd0
[104375.816726]  [<c012a0ea>] worker_thread+0x7a/0xd0
[104375.816737]  [<c012d150>] autoremove_wake_function+0x0/0x40
[104375.816750]  [<c012a070>] worker_thread+0x0/0xd0
[104375.816758]  [<c012cdd2>] kthread+0x42/0x70
[104375.816766]  [<c012cd90>] kthread+0x0/0x70
[104375.816775]  [<c0103a6b>] kernel_thread_helper+0x7/0x1c
[104375.816790]  =======================
[104375.816793] Code: 04 8b 14 24 8b 30 85 d2 0f 95 44 24 07 eb 9e 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 83 ec 08 89 1c 24 89 c3 89 74 24 04 8b 00 <8b> 70 0c 89 d8 e8 28 ff ff ff 85 c0 74 08 85 f6 74 04 89 d8 ff 
[104375.816839] EIP: [<c02d86ce>] klist_del+0xe/0x30 SS:ESP 0068:f2923ebc
[104375.816851] ---[ end trace 29b5951e01a37ec3 ]---

-andy
