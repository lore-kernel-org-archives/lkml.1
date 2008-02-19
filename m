Return-Path: <linux-kernel-owner+w=401wt.eu-S1761160AbYBSUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbYBSUrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYBSUrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:47:13 -0500
Received: from nowster.zetnet.co.uk ([194.247.42.226]:49303 "EHLO
	nowster.zetnet.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYBSUrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:47:11 -0500
Date: Tue, 19 Feb 2008 20:47:08 +0000
From: Paul Martin <pm@debian.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc2 Thinkpad T30 docking fails with oops.
Message-ID: <20080219204708.GA8059@nowster.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, this was working in 2.6.23, but is not in any later kernel. Previously
reported, but I guess that the previous report was ignored due to the kernel
being tainted. Well, there's nothing other than pure Linus here.

When booted up docked, there is no oops until you try to undock.

Whilst I will be looking for replies in the list, I'd appreciate being CC'd
on any replies.

ACPI: \_SB_.PCI0.PCI1.DOCK - docking
PCI: Transparent bridge - 0000:02:03.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.DOCK._PRT]
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c01dd6f2>] pdev_sort_resources+0x8a/0x116
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
Modules linked in: radeon drm rfcomm l2cap bluetooth ppdev lp ipv6 ext3 jbd mbcache fuse dm_crypt crypto_blkcipher dm_mod cpufreq_stats speedstep_ich speedstep_lib thinkpad_acpi nvram acpiphp bay dock pcmcia firmware_class joydev yenta_socket rsrc_nonstatic pcmcia_core battery irtty_sir ac sir_dev snd_intel8x0 snd_ac97_codec nsc_ircc ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer irda parport_pc i2c_i801 button shpchp pci_hotplug crc_ccitt parport snd psmouse intel_agp agpgart iTCO_wdt evdev serio_raw soundcore snd_page_alloc rtc pcspkr xfs floppy e100 mii uhci_hcd usbcore sg sr_mod cdrom sd_mod thermal processor fan ata_piix libata scsi_mod radeonfb fb_ddc i2c_algo_bit i2c_core

Pid: 39, comm: kacpi_notify Not tainted (2.6.25-rc2 #1)
EIP: 0060:[<c01dd6f2>] EFLAGS: 00010246 CPU: 0
EIP is at pdev_sort_resources+0x8a/0x116
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000fff
ESI: f5e30cc4 EDI: f74f1e80 EBP: f74f1e68 ESP: f74f1e48
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kacpi_notify (pid: 39, ti=f74f0000 task=f74cf120 task.ti=f74f0000)
Stack: 00000000 f5e30cf0 f74f1e80 f5e30c00 00000007 f5e30c00 f74cb414 f74cb400 
       f74f1e9c c02a9cce f5e30c08 f7431f90 f7431978 f5420c00 00000000 f7d6d408 
       f7d6d3c0 f74f1e9c 00000000 f7d6d3c8 f7d6d3c0 f74f1ed8 f9b278ca f74cb40c 
Call Trace:
 [<c02a9cce>] ? pci_bus_assign_resources+0x59/0x341
 [<f9b278ca>] ? acpiphp_enable_slot+0x2a1/0x3a3 [acpiphp]
 [<f9b27ad9>] ? handle_hotplug_event_func+0x63/0x101 [acpiphp]
 [<f9b27167>] ? post_dock_fixups+0x6c/0x79 [acpiphp]
 [<c013506e>] ? notifier_call_chain+0x2b/0x4a
 [<f9b27a76>] ? handle_hotplug_event_func+0x0/0x101 [acpiphp]
 [<f9b22168>] ? hotplug_dock_devices+0x39/0xe1 [dock]
 [<f9b22441>] ? dock_notify+0x75/0xc0 [dock]
 [<c01f83c9>] ? acpi_ev_notify_dispatch+0x4f/0x5a
 [<c01f32c0>] ? acpi_os_execute_deferred+0x20/0x2c
 [<c012ef41>] ? run_workqueue+0x78/0xfb
 [<c01f32a0>] ? acpi_os_execute_deferred+0x0/0x2c
 [<c012f79d>] ? worker_thread+0xb6/0xc2
 [<c0131b25>] ? autoremove_wake_function+0x0/0x30
 [<c012f6e7>] ? worker_thread+0x0/0xc2
 [<c0131a52>] ? kthread+0x3b/0x61
 [<c0131a17>] ? kthread+0x0/0x61
 [<c010568f>] ? kernel_thread_helper+0x7/0x10
 =======================
Code: 50 52 51 ff 75 f0 68 a0 af 34 c0 e8 ce 4e f4 ff 83 c4 1c e9 87 00 00 00 8b 7d e8 8d 42 01 83 7d f0 06 89 7d e0 0f 4e c8 8b 45 e0 <8b> 18 31 c0 85 db 74 29 8b 53 04 8b 43 08 89 d7 05 8c 01 00 00 
EIP: [<c01dd6f2>] pdev_sort_resources+0x8a/0x116 SS:ESP 0068:f74f1e48
---[ end trace 623ea8d57da4defe ]---


-- 
Paul Martin <pm@debian.org>
