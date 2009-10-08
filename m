Return-Path: <linux-kernel-owner+w=401wt.eu-S933492AbZJHVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbZJHVCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbZJHVCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:02:16 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:45200 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbZJHVCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:02:14 -0400
Message-ID: <4ACE532C.5040708@mandriva.org>
Date: Fri, 09 Oct 2009 00:01:32 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WARNING: at net/mac80211/agg-tx.c:145 ___ieee80211_stop_tx_ba_session+0x91/0xa0
 [mac80211]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I hit this today:

kernel is a 2.6.31.3 based one built for x86_64

the wireless is connected to a WPA2 encrypted network

Wireless card is:
04:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 4965 
AG or AGN [Kedron] Network Connection [8086:4229] (rev 61)

ucode is 228.61.2.24


> [  108.478772] iwlagn 0000:04:00.0: iwl_tx_agg_start on ra = 00:24:01:38:cb:48 tid = 0
> [  108.478979] iwlagn 0000:04:00.0: Microcode HW error detected.  Restarting.
> [  108.706591] Registered led device: iwl-phy0::radio
> [  108.706607] Registered led device: iwl-phy0::assoc
> [  108.706620] Registered led device: iwl-phy0::RX
> [  108.706632] Registered led device: iwl-phy0::TX
> [  109.479039] iwlagn 0000:04:00.0: Stopping AGG while state not IWL_AGG_ON
> [  109.479045] iwlagn 0000:04:00.0: queue number out of range: 0, must be 7 to 14
> [  109.479046] ------------[ cut here ]------------
> [  109.479066] WARNING: at net/mac80211/agg-tx.c:145 ___ieee80211_stop_tx_ba_session+0x91/0xa0 [mac80211]()
> [  109.479068] Hardware name: TravelMate 5720                
> [  109.479070] Modules linked in: cryptd aes_x86_64 aes_generic af_packet ipv6 binfmt_misc loop fuse dm_mirror dm_region_hash dm_log dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table tifm_sd mmc_block tifm_7xx1 tifm_core nvram radeon ttm drm_kms_helper drm i2c_algo_bit btusb bluetooth arc4 ecb snd_hda_codec_realtek snd_hda_intel snd_hda_codec iwlagn pcmcia iwlcore mac80211 snd_hwdep snd_seq_dummy firewire_ohci snd_seq_oss firewire_core snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss cfg80211 snd_pcm crc_itu_t nsc_ircc uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 iTCO_wdt yenta_socket rsrc_nonstatic acer_wmi irda tg3 rfkill ohci1394 ieee1394 snd_timer snd_mixer_oss libphy crc_ccitt snd i2c_i801 joydev serio_raw pcspkr sdhci_pci i2c_core iTCO_vendor_support soundcore evdev sdhci pcmcia_core mmc_core snd_page_alloc led_class rtc_cmos wmi battery container button ac video processor thermal sr_mod output sg ata_piix ahci libata sd_
mod scsi_mod crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore [last unloaded: scsi_wait_scan]
> [  109.479141] Pid: 0, comm: swapper Not tainted 2.6.31.3-tmb-desktop-1mdv #1
> [  109.479143] Call Trace:
> [  109.479145]  <IRQ>  [<ffffffff81043a88>] warn_slowpath_common+0x78/0xb0
> [  109.479154]  [<ffffffff81043acf>] warn_slowpath_null+0xf/0x20
> [  109.479161]  [<ffffffffa0361081>] ___ieee80211_stop_tx_ba_session+0x91/0xa0 [mac80211]
> [  109.479169]  [<ffffffffa0361286>] sta_addba_resp_timer_expired+0x56/0x90 [mac80211]
> [  109.479177]  [<ffffffffa0361230>] ? sta_addba_resp_timer_expired+0x0/0x90 [mac80211]
> [  109.479181]  [<ffffffff8104e3fb>] run_timer_softirq+0x15b/0x250
> [  109.479183]  [<ffffffff810493bf>] __do_softirq+0xaf/0x140
> [  109.479187]  [<ffffffff8100fa2a>] ? timer_interrupt+0x1a/0x30
> [  109.479190]  [<ffffffff8100d06c>] call_softirq+0x1c/0x30
> [  109.479192]  [<ffffffff8100f075>] do_softirq+0x45/0x80
> [  109.479194]  [<ffffffff81049805>] irq_exit+0x95/0xa0
> [  109.479196]  [<ffffffff8100e600>] do_IRQ+0x70/0xe0
> [  109.479199]  [<ffffffff8100c8d3>] ret_from_intr+0x0/0xa
> [  109.479201]  <EOI>  [<ffffffffa016cd25>] ? acpi_idle_enter_bm+0x26c/0x297 [processor]
> [  109.479215]  [<ffffffffa016cd1b>] ? acpi_idle_enter_bm+0x262/0x297 [processor]
> [  109.479219]  [<ffffffff812406eb>] ? cpuidle_idle_call+0x9b/0x100
> [  109.479221]  [<ffffffff8100aa32>] ? cpu_idle+0x62/0xd0
> [  109.479225]  [<ffffffff812db9a1>] ? rest_init+0x81/0x90
> [  109.479229]  [<ffffffff814c01af>] ? start_kernel+0x356/0x362
> [  109.479232]  [<ffffffff814bf808>] ? x86_64_start_reservations+0x125/0x129
> [  109.479234]  [<ffffffff814bf8ed>] ? x86_64_start_kernel+0xe1/0xe8
> [  109.479236] ---[ end trace d34a38827329a2d4 ]---


--
Thomas

