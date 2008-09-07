Return-Path: <linux-kernel-owner+w=401wt.eu-S1751853AbYIGXOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbYIGXOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 19:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYIGXOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 19:14:40 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:44274 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbYIGXOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 19:14:40 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [regression] __tick_program_event of hpet is stuck
Date: Mon, 8 Sep 2008 01:14:35 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809080114.36106.elendil@planet.nl>
X-OriginalArrivalTime: 07 Sep 2008 23:14:38.0388 (UTC) FILETIME=[7FF0F740:01C9113F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current git head (v2.6.27-rc5-319-g7686ad5) I'm seeing repeated 
occurrences of the following on my HP Compaq 2510p laptop. Not seen with 
earlier kernels, including 2.6.27-rc5.

CE: __tick_program_event of hpet is stuck 1468f1b3c9 1468f1c751
CE: increasing min_delta_ns 5000 to 10000 nsec
------------[ cut here ]------------
WARNING: at kernel/time/tick-oneshot.c:52 tick_dev_program_event+0x9c/0xd0
()
Modules linked in: tcp_diag inet_diag i915 drm ipv6 ext2 coretemp 
acpi_cpufreq loop joydev snd_hda_intel snd_pcm_oss arc4 snd_pcm ecb 
snd_mixer_oss snd_seq_dummy snd_seq_oss iwlagn snd_seq_midi iwlcore 
snd_rawmidi snd_seq_midi_event snd_seq pcmcia rfkill snd_timer 
snd_seq_device led_class mac80211 snd wmi video yenta_socket 
rsrc_nonstatic cfg80211 intel_agp soundcore ac psmouse serio_raw output 
container iTCO_wdt pcspkr pcmcia_core evdev battery button snd_page_alloc 
ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc dm_crypt 
crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod sg sr_mod cdrom 
sd_mod piix ide_pci_generic ide_core ata_piix ohci1394 sdhci_pci sdhci 
ricoh_mmc mmc_core ieee1394 ata_generic ehci_hcd libata scsi_mod uhci_hcd 
dock e1000e thermal processor fan thermal_sys
Pid: 0, comm: swapper Not tainted 2.6.27-rc5 #74

Call Trace:
 [<ffffffff802375d2>] warn_on_slowpath+0x58/0x7f
 [<ffffffff80434a10>] ? printk+0x67/0x6f
 [<ffffffff8024f2e7>] ? getnstimeofday+0x3a/0x96
 [<ffffffff8024f2e7>] ? getnstimeofday+0x3a/0x96
 [<ffffffff8024d35f>] ? ktime_get_ts+0x49/0x4e
 [<ffffffff80252c9f>] tick_dev_program_event+0x9c/0xd0
 [<ffffffff80252756>] tick_broadcast_oneshot_control+0xa3/0xfd
 [<ffffffff80251fe7>] tick_notify+0x22f/0x385
 [<ffffffff8024dc5b>] notifier_call_chain+0x33/0x5b
 [<ffffffff8024dd17>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff80251a62>] clockevents_notify+0x2b/0x7a
 [<ffffffffa000a00a>] acpi_state_timer_broadcast+0x41/0x43 [processor]
 [<ffffffffa000a6cd>] acpi_idle_enter_simple+0x8c/0x172 [processor]
 [<ffffffff803b5036>] cpuidle_idle_call+0x86/0xba
 [<ffffffff8020b282>] cpu_idle+0x80/0xd4
 [<ffffffff804270bd>] rest_init+0x61/0x63

---[ end trace 94cf18f10b9270b8 ]---
