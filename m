Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZALM5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZALM5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZALM4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:56:50 -0500
Received: from cpsmtpo-eml04.KPNXCHANGE.COM ([213.75.38.153]:58103 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329AbZALM4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:56:49 -0500
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.28] Kernel panic after closing lid on HP 2510p
Date: Mon, 12 Jan 2009 13:56:45 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121356.46236.elendil@planet.nl>
X-OriginalArrivalTime: 12 Jan 2009 12:56:46.0884 (UTC) FILETIME=[3A109E40:01C974B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the following series of errors while closing the lid of my notebook.
The end result was a frozen system that needed a hard power off.

The notebook was docked and connected to external monitor. Closing the lid
will only power off both displays, not suspend.

I possibly tried to do a few things too quickly in succession, but
AFAIK that should still not result in the kernel crapping out on me ;-)

System is HP 2510p notebook running 2.6.28 (x86_64, Debian amd64/lenny)
with a few additional patches on top. 

Cheers,
FJP

Errors in kern.log after rebooting:

BUG: unable to handle kernel paging request at ffff88007ceeb5a0
IP: [<ffffffff8034e077>] acpi_ex_field_datum_io+0xec/0x17e
PGD 202063 PUD 8067 PMD 6ff52163 PTE 800000007ceeb163
Oops: 0011 [#1] SMP
last sysfs file: /sys/class/power_supply/C23D/charge_full
CPU 1
Modules linked in: iwlagn iwlcore mac80211 cfg80211 isofs zlib_inflate usbhid hid vboxdrv tcp_diag inet_diag i915 
drm ppdev parport_pc lp parport nfs lockd nfs_acl sunrpc ipv6 ext2 coretemp hp_wmi acpi_cpufreq loop joydev 
snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy ecb snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer rfkill snd_seq_device pcmcia snd soundcore psmouse yenta_socket 
rsrc_nonstatic iTCO_wdt snd_page_alloc serio_raw pcspkr pcmcia_core intel_agp battery video output wmi 
leds_hp_disk led_class container ac button evdev ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc 
dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix ata_piix ide_pci_generic 
ide_core pata_acpi ricoh_mmc sdhci_pci sdhci mmc_core ohci1394 ieee1394 ata_generic ehci_hcd libata uhci_hcd 
e1000e scsi_mod thermal processor fan thermal_sys [last unloaded: cfg80211]
Pid: 70, comm: kacpid Not tainted 2.6.28-rjw #83
RIP: 61a0:[<ffffffff803534ed>]  [<ffffffff803534ed>] acpi_ns_search_one_scope+0x1d/0x46
RSP: ffffffff8028fbf2:ffff88007e1d7b10  EFLAGS: 00000005
RAX: ffff88007e046510 RBX: ffff88007ceeb5a0 RCX: ffff88007e1d7b70
RDX: 0000000000000000 RSI: ffff88007e1d7ae0 RDI: ffffffff8028fbf2
RBP: ffff88007e1d7b80 R08: 00000003000000b2 R09: ffff88007e1d7b70
R10: 0000000000000000 R11: ffff88007e1d7c60 R12: ffff88007e1d7b10
R13: ffffffff8034df7e R14: ffff88007e1d7ad0 R15: ffff88007e046510
FS:  0000000000000000(0000) GS:ffff88007e002a80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff88007ceeb5a0 CR3: 0000000063b35000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kacpid (pid: 70, threadinfo ffff88007e1d6000, task ffff88007e1d95f0)
Stack:
BUG: unable to handle kernel paging request at 000000007e1d7b00
IP: [<ffffffff8020f140>] show_stack_log_lvl+0xb0/0x125
PGD 63b00067 PUD 73867067 PMD 0
Oops: 0000 [#2] SMP
last sysfs file: /sys/class/power_supply/C23D/charge_full
CPU 1
Modules linked in: iwlagn iwlcore mac80211 cfg80211 isofs zlib_inflate usbhid hid vboxdrv tcp_diag inet_diag i915 
drm ppdev parport_pc lp parport nfs lockd nfs_acl sunrpc ipv6 ext2 coretemp hp_wmi acpi_cpufreq loop joydev 
snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy ecb snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer rfkill snd_seq_device pcmcia snd soundcore psmouse yenta_socket 
rsrc_nonstatic iTCO_wdt snd_page_alloc serio_raw pcspkr pcmcia_core intel_agp battery video output wmi 
leds_hp_disk led_class container ac button evdev ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc 
dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix ata_piix ide_pci_generic 
ide_core pata_acpi ricoh_mmc sdhci_pci sdhci mmc_core ohci1394 ieee1394 ata_generic ehci_hcd libata uhci_hcd 
e1000e scsi_mod thermal processor fan thermal_sys [last unloaded: cfg80211]
Pid: 70, comm: kacpid Not tainted 2.6.28-rjw #83
RIP: 0010:[<ffffffff8020f140>]  [<ffffffff8020f140>] show_stack_log_lvl+0xb0/0x125
RSP: 0018:ffff88007e1d7818  EFLAGS: 00010046
RAX: ffff88007e093fc0 RBX: 000000007e1d7b00 RCX: ffff88007e1d7b80
RDX: ffff880001017c00 RSI: ffff88007e1d7a58 RDI: 0000000000000000
RBP: ffff88007e1d7868 R08: ffffffff80513f7d R09: 0000000000000000
R10: ffffffff8067ee90 R11: 00000000000253d4 R12: 0000000000000000
R13: ffffffff80513f7d R14: 0000000000000000 R15: ffff88007e097fc0
FS:  0000000000000000(0000) GS:ffff88007e002a80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000007e1d7b00 CR3: 0000000063b35000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kacpid (pid: 70, threadinfo ffff88007e1d6000, task ffff88007e1d95f0)
Stack:
 ffff88007e1d7868 ffff88007e1d7b80 ffff88007e1d7a58 ffff88007e093fc0
 000000007e1d7b00 ffff88007e1d95f0 0000000000000ac0 ffff88007e1d7a58
 0000000000000040 000000007e1d7b00 ffff88007e1d78a8 ffffffff8020f26b
Call Trace:
Code: e8 8c a8 22 00 eb 08 f7 c3 ff 1f 00 00 74 42 45 85 e4 74 17 41 f6 c4 03 75 11 4c 89 ee 48 c7 c7 21 3f 51 80 
31 c0 e8 66 a8 22 00 <48> 8b 33 48 c7 c7 25 3f 51 80 31 c0 48 83 c3 08 41 ff c4 e8 4e
RIP  [<ffffffff8020f140>] show_stack_log_lvl+0xb0/0x125
 RSP <ffff88007e1d7818>
CR2: 000000007e1d7b00
---[ end trace ddc817f6d2e9b476 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
------------[ cut here ]------------
WARNING: at kernel/smp.c:333 smp_call_function_mask+0x40/0x1e9()
Modules linked in: iwlagn iwlcore mac80211 cfg80211 isofs zlib_inflate usbhid hid vboxdrv tcp_diag inet_diag i915 
drm ppdev parport_pc lp parport nfs lockd nfs_acl sunrpc ipv6 ext2 coretemp hp_wmi acpi_cpufreq loop joydev 
snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy ecb snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer rfkill snd_seq_device pcmcia snd soundcore psmouse yenta_socket 
rsrc_nonstatic iTCO_wdt snd_page_alloc serio_raw pcspkr pcmcia_core intel_agp battery video output wmi 
leds_hp_disk led_class container ac button evdev ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc 
dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix ata_piix ide_pci_generic 
ide_core pata_acpi ricoh_mmc sdhci_pci sdhci mmc_core ohci1394 ieee1394 ata_generic ehci_hcd libata uhci_hcd 
e1000e scsi_mod thermal processor fan thermal_sys [last unloaded: cfg80211]
Pid: 0, comm: swapper Tainted: G      D    2.6.28-rjw #83
Call Trace:
---[ end trace ddc817f6d2e9b476 ]---
------------[ cut here ]------------
WARNING: at kernel/smp.c:220 smp_call_function_single+0x3d/0xb8()
Modules linked in: iwlagn iwlcore mac80211 cfg80211 isofs zlib_inflate usbhid hid vboxdrv tcp_diag inet_diag i915 
drm ppdev parport_pc lp parport nfs lockd nfs_acl sunrpc ipv6 ext2 coretemp hp_wmi acpi_cpufreq loop joydev 
snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy ecb snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer rfkill snd_seq_device pcmcia snd soundcore psmouse yenta_socket 
rsrc_nonstatic iTCO_wdt snd_page_alloc serio_raw pcspkr pcmcia_core intel_agp battery video output wmi 
leds_hp_disk led_class container ac button evdev ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc 
dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix ata_piix ide_pci_generic 
ide_core pata_acpi ricoh_mmc sdhci_pci sdhci mmc_core ohci1394 ieee1394 ata_generic ehci_hcd libata uhci_hcd 
e1000e scsi_mod thermal processor fan thermal_sys [last unloaded: cfg80211]
Pid: 0, comm: swapper Tainted: G      D W  2.6.28-rjw #83
Call Trace:
---[ end trace ddc817f6d2e9b476 ]---
