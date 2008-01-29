Return-Path: <linux-kernel-owner+w=401wt.eu-S1765692AbYA2RD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765692AbYA2RD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYA2RDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:03:17 -0500
Received: from nowster.zetnet.co.uk ([194.247.42.226]:49282 "EHLO
	nowster.zetnet.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYA2RDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:03:16 -0500
X-Greylist: delayed 2567 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 12:03:15 EST
Date: Tue, 29 Jan 2008 16:20:25 +0000
From: Paul Martin <pm@debian.org>
To: linux-kernel@vger.kernel.org
Subject: Thinkpad Docking Oops
Message-ID: <20080129162024.GA9297@nowster.org.uk>
Reply-To: pm@debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware: IBM Thinkpad T30, Thinkpad Dock (Model 2631).

When attempting to dock, the following oops occurs. The tainting is from the
Atheros driver's non-free HAL. (I'm eagerly awaiting ath5k's inclusion.)

Docking worked in 2.6.23 and earlier with the out-of-tree lt_hotswap module.
<http://www.thinkwiki.org/wiki/Lt_hotswap>

Please CC me in any replies.


ACPI: \_SB_.PCI0.PCI1.DOCK - docking
PCI: Transparent bridge - 0000:02:03.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.DOCK._PRT]
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
printing eip: c01e2390 *pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
Modules linked in: arc4 ecb blkcipher rt2500pci rt2x00pci rt2x00lib mac80211 cfg80211 eeprom_93cx6 tun wlan_wep rfcomm l2cap bluetooth ppdev lp ipv6 ext3 jbd mbcache fuse dm_crypt dm_mod cpufreq_stats speedstep_ich speedstep_lib thinkpad_acpi nvram acpiphp bay dock pcmcia firmware_class joydev wlan_scan_sta ath_rate_sample irtty_sir sir_dev nsc_ircc irda parport_pc crc_ccitt parport battery ac psmouse yenta_socket rtc ath_pci serio_raw rsrc_nonstatic pcmcia_core video output wlan ath_hal(P) pcspkr snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer button snd i2c_i801 soundcore snd_page_alloc iTCO_wdt intel_agp agpgart shpchp pci_hotplug evdev xfs sg sr_mod cdrom sd_mod floppy ata_piix ata_generic libata e100 mii scsi_mod generic ide_core uhci_hcd usbcore thermal processor fan radeonfb fb_ddc i2c_algo_bit i2c_core

Pid: 42, comm: kacpi_notify Tainted: P        (2.6.24 #5)
EIP: 0060:[<c01e2390>] EFLAGS: 00010246 CPU: 0
EIP is at pdev_sort_resources+0xa4/0x134
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000fff
ESI: f47c28c4 EDI: f7cc7e6c EBP: f47c2800 ESP: f7cc7e14
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kacpi_notify (pid: 42, ti=f7cc6000 task=f7cc3250 task.ti=f7cc6000)
Stack: 00001001 c020e31d c020e31d c020e22f f7cc7e6c f7c23950 c020e22f 00000000 
       f47c28f4 f7cc7e6c 00000007 f47c2800 f7c5a0d4 f7c5a0c0 f7cc7e6c c01e60c0 
       c0210593 f7cc7e64 f7c21978 f47c2808 f7c21f90 f7c21978 00000000 f447b000 
Call Trace:
 [<c020e31d>] acpi_ut_acquire_mutex+0x32/0x79
 [<c020e31d>] acpi_ut_acquire_mutex+0x32/0x79
 [<c020e22f>] acpi_ut_release_mutex+0x5b/0x63
 [<c020e22f>] acpi_ut_release_mutex+0x5b/0x63
 [<c01e60c0>] pci_bus_assign_resources+0x5e/0x372
 [<c0210593>] acpi_bus_scan+0x6e/0x191
 [<f9be0a1a>] acpiphp_enable_slot+0x2d3/0x3de [acpiphp]
 [<f9be0c46>] handle_hotplug_event_func+0x6f/0x12f [acpiphp]
 [<c0249362>] pci_write+0x2e/0x34
 [<f9be0243>] post_dock_fixups+0x6f/0x79 [acpiphp]
 [<f9be0bd7>] handle_hotplug_event_func+0x0/0x12f [acpiphp]
 [<f9bdb18a>] hotplug_dock_devices+0x37/0xe8 [dock]
 [<c01f8288>] acpi_os_execute_notify+0x0/0x2b
 [<c01f8288>] acpi_os_execute_notify+0x0/0x2b
 [<f9bdb48c>] dock_notify+0x7a/0xc9 [dock]
 [<c01fd83f>] acpi_ev_notify_dispatch+0x4c/0x55
 [<c01f82aa>] acpi_os_execute_notify+0x22/0x2b
 [<c01319ff>] run_workqueue+0x77/0x104
 [<c01322dd>] worker_thread+0x0/0xc7
 [<c0132399>] worker_thread+0xbc/0xc7
 [<c0134d38>] autoremove_wake_function+0x0/0x33
 [<c01322dd>] worker_thread+0x0/0xc7
 [<c0134c6a>] kthread+0x38/0x5e
 [<c0134c32>] kthread+0x0/0x5e
 [<c0104b63>] kernel_thread_helper+0x7/0x10
 =======================
Code: 00 89 44 24 04 c7 04 24 fb da 30 c0 e8 ad 26 f4 ff e9 8b 00 00 00 8b 7c 24 24 40 83 7c 24 28 06 89 7c 24 1c 0f 4e c8 8b 44 24 1c <8b> 18 31 c0 85 db 74 29 8b 53 04 8b 43 08 89 d7 05 a4 01 00 00 
EIP: [<c01e2390>] pdev_sort_resources+0xa4/0x134 SS:ESP 0068:f7cc7e14
---[ end trace 350a85072f0f30f5 ]---


-- 
Paul Martin <pm@debian.org>
