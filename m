Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbXHTIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbXHTIMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXHTIL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:11:56 -0400
Received: from helios.cs.csubak.edu ([136.168.201.112]:51299 "EHLO
	helios.cs.csubak.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXHTILy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:11:54 -0400
Date: Mon, 20 Aug 2007 01:11:41 -0700 (PDT)
From: David Griffith <dgriffi@cs.csubak.edu>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: MIDI-related oops (was MOTU Fastlane USB MIDI interface)
In-Reply-To: <Pine.GSO.4.55.0708200042470.26684@helios.cs.csubak.edu>
Message-ID: <Pine.GSO.4.55.0708200052290.28584@helios.cs.csubak.edu>
References: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>  
 <20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>  
 <Pine.GSO.4.55.0708160308450.24052@helios.cs.csubak.edu>  
 <20070816174510.6o8cray64g8kosos@webmail.df.eu>  
 <Pine.GSO.4.55.0708161417270.9354@helios.cs.csubak.edu>  
 <1187331453.13767.1205847147@webmail.messagingengine.com>  
 <Pine.GSO.4.55.0708170202270.26403@helios.cs.csubak.edu>
 <1187591842.11769.1206227263@webmail.messagingengine.com>
 <Pine.GSO.4.55.0708200042470.26684@helios.cs.csubak.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5 (--)
X-Spam-Report: ---- Start Spam Filter Report
	Filter Analysis score is (-2.5/5.0)
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
	---- End Spam Filter results
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, David Griffith wrote:

> On Mon, 20 Aug 2007, Clemens Ladisch wrote:
[snip]
> $ aplaymidi -p 128:0 casablan.mid
>
> At this point, MIDI data flew by in the xterm in which amidi was running.

After I did what Clemens suggested, I started MIOS Studio
(http://www.midibox.org/mios_studio/) to see if I could jog something
started.  I patched MIOS Studio's internal in port to all available out
ports including the virtual one previously mentioned. A couple minutes
later, I pulled out the MIDI interface.  Then I quit MIOS Studio and
immediately got an Oops.  This was still when "amidi -d -p virtual" was
running.


Aug 20 00:45:34 zaphod kernel: [694784.397469] BUG: unable to handle
kernel NULL pointer dereference at virtual address 00000128
Aug 20 00:45:34 zaphod kernel: [694784.397484]  printing eip:
Aug 20 00:45:34 zaphod kernel: [694784.397487] e0883480
Aug 20 00:45:34 zaphod kernel: [694784.397490] *pde = 1e91f067
Aug 20 00:45:34 zaphod kernel: [694784.397496] Oops: 0000 [#1]
Aug 20 00:45:34 zaphod kernel: [694784.397498] SMP
Aug 20 00:45:34 zaphod kernel: [694784.397503] Modules linked in:
nls_iso8859_1 nls_cp437 vfat fat sg sd_mod usb_storage libusual
snd_rtctimer snd_usb_audio snd_usb_lib snd_hwdep isofs udf binfmt_misc
rfcomm l2cap bluetooth ppdev cpufreq_stats cpufreq_conservative
cpufreq_powersave cpufreq_ondemand freq_table cpufreq_userspace tc1100_wmi
dev_acpi sony_acpi pcc_acpi button battery sbs container ac i2c_ec
asus_acpi video backlight dock af_packet parport_pc lp parport fuse
snd_ens1371 gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse via_ircc irda
crc_ccitt i2c_viapro serio_raw snd soundc ore snd_page_alloc pcspkr
via_agp agpgart i2c_core shpchp pci_hotplug tsdev evdev ipv6 ext3 jbd
mbcache ide_cd cdrom ide_disk ata_generic libata scsi_mod usbhid hid
via82cxxx floppy via_rhine mii generic ehci_hcd uhci_hcd usbcore thermal
processor fan fbcon tileblit font bitblit softcursor vesafb capabili
Aug 20 00:45:34 zaphod kernel: y commoncap
Aug 20 00:45:34 zaphod kernel: [694784.397606] CPU:    0
Aug 20 00:45:34 zaphod kernel: [694784.397608] EIP:    0060:[<e0883480>]
Not tainted VLI
Aug 20 00:45:34 zaphod kernel: [694784.397610] EFLAGS: 00010246
(2.6.20-16-generic #2)
Aug 20 00:45:34 zaphod kernel: [694784.397664] EIP is at
hcd_buffer_free+0x20/0xa0 [usbcore]
Aug 20 00:45:34 zaphod kernel: [694784.397669] eax: 00000000   ebx: 00000004   ecx: 1fb8e020   edx: 00000000
Aug 20 00:45:34 zaphod kernel: [694784.397675] esi: dfb8e020   edi: bf94df18   ebp: dc6d9d40   esp: dd865d6c
Aug 20 00:45:34 zaphod kernel: [694784.397679] ds: 007b   es: 007b   ss: 0068
Aug 20 00:45:34 zaphod kernel: [694784.397684] Process java (pid: 4436, ti=dd864000 task=c1f74050 task.ti=dd864000)
Aug 20 00:45:34 zaphod kernel: [694784.397688] Stack: 1fb8e020 d0ebde00 00000000 e0ca4c2c 1fb8e020 dc6d9d70 dc6d9d74 e0ca4cc8
Aug 20 00:45:34 zaphod kernel: [694784.397699]        cdb5948c cdb593e0 00001fff c6a95c00 e0a43538 d42626a0 c6a95d40 e0a2f96a
Aug 20 00:45:34 zaphod kernel: [694784.397709]        dd865dd0 00001000 e0a2fa0b c6a95c00 c6a95c00 de43f4e0 00000000 e0a2b680
Aug 20 00:45:35 zaphod kernel: [694784.397718] Call Trace:
Aug 20 00:45:35 zaphod kernel: [694784.397728]  [<e0ca4c2c>] snd_usbmidi_out_endpoint_delete+0x2c/0x50 [snd_usb_lib]
Aug 20 00:45:35 zaphod kernel: [694784.397746]  [<e0ca4cc8>] snd_usbmidi_free+0x28/0x60 [snd_usb_lib]
Aug 20 00:45:35 zaphod kernel: [694784.397760]  [<e0a43538>] snd_rawmidi_free+0x68/0x80 [snd_rawmidi]
Aug 20 00:45:35 zaphod kernel: [694784.397781]  [<e0a2f96a>] snd_device_free+0x4a/0xa0 [snd]
Aug 20 00:45:35 zaphod kernel: [694784.397815]  [<e0a2fa0b>] snd_device_free_all+0x4b/0x60 [snd]
Aug 20 00:45:35 zaphod kernel: [694784.397838]  [<e0a2b680>] snd_card_do_free+0x30/0x100 [snd]
Aug 20 00:45:35 zaphod kernel: [694784.397856]  [<e0a2c0af>] snd_card_file_remove+0xdf/0x120 [snd]
Aug 20 00:45:35 zaphod kernel: [694784.397879]  [<e0a446ff>] snd_rawmidi_release+0x4f/0x70 [snd_rawmidi]
Aug 20 00:45:35 zaphod kernel: [694784.397898]  [<e0a2be92>] snd_disconnect_release+0x72/0xa0 [snd]
Aug 20 00:45:35 zaphod kernel: [694784.397922]  [__fput+167/400] __fput+0xa7/0x190
Aug 20 00:45:35 zaphod kernel: [694784.397945]  [filp_close+71/128] filp_close+0x47/0x80
Aug 20 00:45:35 zaphod kernel: [694784.397963]  [put_files_struct+143/176] put_files_struct+0x8f/0xb0
Aug 20 00:45:35 zaphod kernel: [694784.397980]  [do_exit+308/2048] do_exit+0x134/0x800
Aug 20 00:45:35 zaphod kernel: [694784.397988]  [schedule_timeout+120/208] schedule_timeout+0x78/0xd0
Aug 20 00:45:35 zaphod kernel: [694784.397997]  [get_futex_key+64/272] get_futex_key+0x40/0x110
Aug 20 00:45:35 zaphod kernel: [694784.398007]  [unqueue_me+80/160] unqueue_me+0x50/0xa0
Aug 20 00:45:35 zaphod kernel: [694784.398024]  [do_group_exit+38/128] do_group_exit+0x26/0x80
Aug 20 00:45:35 zaphod kernel: [694784.398034]  [get_signal_to_deliver+681/1056] get_signal_to_deliver+0x2a9/0x420
Aug 20 00:45:35 zaphod kernel: [694784.398053]  [do_notify_resume+147/1824] do_notify_resume+0x93/0x720
Aug 20 00:45:35 zaphod kernel: [694784.398086]  [default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 20 00:45:35 zaphod kernel: [694784.398111]  [sys_futex+145/320] sys_futex+0x91/0x140
Aug 20 00:45:35 zaphod kernel: [694784.398132]  [work_notifysig+19/24] work_notifysig+0x13/0x18
Aug 20 00:45:35 zaphod kernel: [694784.398160]  =======================
Aug 20 00:45:35 zaphod kernel: [694784.398163] Code: 89 e0 bd ed ff ff ff
eb a1 90 90 83 ec 0c 89 74 24 04 89 ce 8b 4c 24 10 85 f6 89 1c 24 89 d3 89
7c 24 08 89 c7 74 5e 8b 00 31 d2 <8b> 80 28 01 00 00 85 c0 74 5f 8d b6 00
00 00 00 3b 1c 95 ac 9c
Aug 20 00:45:35 zaphod kernel: [694784.398201] EIP: [<e0883480>] hcd_buffer_free+0x20/0xa0 [usbcore] SS:ESP 0068:dd865d6c
Aug 20 00:45:35 zaphod kernel: [694784.398228]  <1>Fixing recursive fault
but reboot is needed!


-- 
David Griffith
dgriffi@cs.csubak.edu

A: Because it fouls the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?
