Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbZBCXvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbZBCXvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZBCXuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:50:51 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:28924 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZBCXuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:50:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Xk4JOccI8LBEK829iftN5lnmrqM4QalQ9pUKipNaSnmY9FRXHMqZTT6BuGAl8d51sF
         Qj/t71jjbXdgDo9Bb8JdV68t/DWZsTFBy5QmIRWUtUmTlzceykNLu381UtdQyrp8G79H
         gmz3isY+Sq+5eM1Atn14U1VsXYw8a3nx3xSSw=
Date: Tue, 3 Feb 2009 18:50:38 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-laptop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: WARNING: at drivers/pci/pci-driver.c:368
In-Reply-To: <200902032315.27113.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0902031821590.7302@parag-laptop>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200902031029.30739.rjw@sisk.pl> <alpine.DEB.2.00.0902031622070.5481@parag-desktop> <200902032315.27113.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Today's git triggers the below warning on suspending my laptop, which is -

if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))

Would it be helpful to also print info about the device that was not in 
PCI_D0?


pci_legacy_suspend+0x7e/0xc3()[  123.510055] WARNING: at 
drivers/pci/pci-driver.c:368 
pci_legacy_suspend+0x7e/0xc3()                                                        
[  123.510056] Hardware name: HP Compaq 6910p                                                                                                 
[  123.510058] Modules linked in: ipv6 aes_x86_64 aes_generic af_packet 
radeon drm i2c_core binfmt_misc kvm_intel kvm ppdev acpi_cpufreq cpufr
eq_userspace cpufreq_ondemand cpufreq_conservative cpufreq_stats 
freq_table cpufreq_powersave pci_slot iptable_filter ip_tables x_tables 
input
_polldev sbp2 ieee1394 parport_pc lp parport joydev snd_hda_codec_analog 
snd_hda_intel snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss ecb snd_pc
m sdhci_pci sdhci snd_seq_dummy mmc_core snd_seq_oss iwlagn iwlcore evdev 
ricoh_mmc psmouse serio_raw pcspkr rfkill snd_seq_midi led_class mac
80211 iTCO_wdt iTCO_vendor_support snd_rawmidi cfg80211 snd_seq_midi_event 
snd_seq snd_timer snd_seq_device video output container snd tpm_inf
ineon tpm tpm_bios intel_agp wmi battery shpchp ac button soundcore 
snd_page_alloc pci_hotplug ext3 jbd mbcache sr_mod cdrom ata_generic sd_mo
d crc_t10dif sg ata_piix pata_acpi ahci libata scsi_mod ehci_hcd uhci_hcd 
usbcore e1000e thermal processor fan fuse
[  123.510112] Pid: 6370, comm: pm-suspend Not tainted 2.6.29-rc3 #5
[  123.510114] Call Trace:
[  123.510119]  [<ffffffff8023fc1f>] warn_slowpath+0xd3/0x10f
[  123.510124]  [<ffffffff804689d4>] ? _spin_lock_irqsave+0x28/0x31
[  123.510127]  [<ffffffff80249044>] ? lock_timer_base+0x26/0x4a
[  123.510130]  [<ffffffff80227adf>] ? default_spin_lock_flags+0x9/0xe
[  123.510140]  [<ffffffff8025640e>] ? down_timeout+0x45/0x50
[  123.510142]  [<ffffffff80227adf>] ? default_spin_lock_flags+0x9/0xe
[  123.510144]  [<ffffffff802563c4>] ? up+0x34/0x39
[  123.510148]  [<ffffffff8036a969>] ? acpi_os_signal_semaphore+0x23/0x27
[  123.510151]  [<ffffffff80383c11>] ? acpi_ut_release_mutex+0x5d/0x61
[  123.510154]  [<ffffffff80379dfa>] ? acpi_get_data+0x5e/0x70
[  123.510156]  [<ffffffff8038501d>] ? acpi_bus_get_device+0x25/0x39
[  123.510159]  [<ffffffff803850dc>] ? acpi_bus_power_manageable+0x11/0x29
[  123.510161]  [<ffffffff8035f16e>] ? acpi_pci_power_manageable+0x17/0x19
[  123.510164]  [<ffffffff80355dbf>] ? pci_set_power_state+0xcc/0x101
[  123.510170]  [<ffffffff803581c6>] pci_legacy_suspend+0x7e/0xc3
[  123.510173]  [<ffffffff80358305>] pci_pm_suspend+0x37/0x8a
[  123.510176]  [<ffffffff803c1aee>] pm_op+0x52/0xe5
[  123.510179]  [<ffffffff803c2087>] device_suspend+0x31d/0x442
[  123.510182]  [<ffffffff802663f4>] suspend_devices_and_enter+0x3e/0x13a
[  123.510184]  [<ffffffff80266658>] enter_state+0x110/0x164
[  123.510187]  [<ffffffff80266763>] state_store+0xb7/0xd7
[  123.510190]  [<ffffffff80345037>] kobj_attr_store+0x17/0x19
[  123.510193]  [<ffffffff802fec33>] sysfs_write_file+0xdf/0x114
[  123.510196]  [<ffffffff802b125b>] vfs_write+0xa7/0xe1
[  123.510198]  [<ffffffff802b1359>] sys_write+0x47/0x6f
[  123.510200]  [<ffffffff8021126a>] system_call_fastpath+0x16/0x1b
[  123.510202] ---[ end trace 0a834135293f05a3 ]---


