Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbXFQTlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbXFQTlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758657AbXFQTlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:41:18 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33977
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbXFQTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:41:18 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: Random oops in Ubuntu 7.04 stock kernel (usb hotplug null pointer dereference).
Date: Sun, 17 Jun 2007 15:41:28 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171541.28959.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed this in the log.  The system's still running fine, I can only assume 
this happened when I unplugged my external USB disk after the cat knocked it 
on the floor.  Quite possibly already fixed in kernel.org, but just for the 
record:

cat /proc/version
Linux version 2.6.20-15-generic (root@palmer) (gcc version 4.1.2 (Ubuntu 
4.1.2-0ubuntu4)) #2 SMP Sun Apr 15 07:36:31 UTC 2007

[   40.330921] usb 4-3: USB disconnect, address 2
[   40.331150] BUG: unable to handle kernel NULL pointer dereference at 
virtual address 00000000
[   40.331157]  printing eip:
[   40.331159] c0258315
[   40.331161] *pde = 00000000
[   40.331166] Oops: 0000 [#1]
[   40.331167] SMP
[   40.331172] Modules linked in: cpufreq_powersave cpufreq_conservative 
cpufreq_stats cpufreq_userspace cpufreq_ondemand freq_table pcc_acpi dev_acpi 
sony_acpi tc1100_wmi ac asus_acpi container video sbs i2c_ec i2c_core dock 
battery backlight button ipv6 lp fuse usb_storage snd_intel8x0 snd_ac97_codec 
ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss usbhid 
snd_seq_midi snd_rawmidi snd_seq_midi_event libusual snd_seq snd_timer 
snd_seq_device hid snd psmouse serio_raw parport_pc parport pcspkr soundcore 
snd_page_alloc sis_agp agpgart shpchp pci_hotplug af_packet tsdev evdev ext3 
jbd mbcache sg sr_mod cdrom sd_mod sis5513 generic ata_generic floppy sis900 
mii ehci_hcd ohci_hcd usbcore pata_sis libata scsi_mod thermal processor fan 
fbcon tileblit font bitblit softcursor vesafb capability commoncap
[   40.331245] CPU:    0
[   40.331247] EIP:    0060:[<c0258315>]    Not tainted VLI
[   40.331249] EFLAGS: 00010202   (2.6.20-15-generic #2)
[   40.331266] EIP is at make_class_name+0x35/0xa0
[   40.331270] eax: 00000000   ebx: ffffffff   ecx: ffffffff   edx: 0000000b
[   40.331274] esi: d788cc91   edi: 00000000   ebp: 00000000   esp: d6067e50
[   40.331278] ds: 007b   es: 007b   ss: 0068
[   40.331282] Process khubd (pid: 1956, ti=d6066000 task=d6f9ba90 
task.ti=d6066000)
[   40.331284] Stack: ced67204 d789eec0 ced671fc ced67204 d789ee40 c0258591 
00000000 d789eec8
[   40.331293]        ced671fc cf92a000 00000246 ffffffed c0258618 ced67000 
d7886a50 ced67000
[   40.331301]        cf92a000 d788412b cf92a030 cf92a000 d787e825 cf92a2f4 
d69d4e18 d7ac5f60
[   40.331309] Call Trace:
[   40.331317]  [<c0258591>] class_device_del+0xa1/0x120
[   40.331327]  [<c0258618>] class_device_unregister+0x8/0x10
[   40.331334]  [<d7886a50>] __scsi_remove_device+0x30/0x80 [scsi_mod]
[   40.331383]  [<d788412b>] scsi_forget_host+0x4b/0x60 [scsi_mod]
[   40.331405]  [<d787e825>] scsi_remove_host+0x55/0xe0 [scsi_mod]
[   40.331426]  [<d7ab7cae>] storage_disconnect+0xe/0x20 [usb_storage]
[   40.331443]  [<d785dd20>] usb_unbind_interface+0x50/0xa0 [usbcore]
[   40.331492]  [<c02578a8>] __device_release_driver+0x68/0xa0
[   40.331500]  [<c0257dd3>] device_release_driver+0x23/0x40
[   40.331506]  [<c025721c>] bus_remove_device+0x5c/0x90
[   40.331513]  [<c0255672>] device_del+0x152/0x1b0
[   40.331522]  [<d785b1ee>] usb_disable_device+0x7e/0xe0 [usbcore]
[   40.331544]  [<d7857597>] usb_disconnect+0x97/0x130 [usbcore]
[   40.331570]  [<d78582ff>] hub_thread+0x26f/0xc20 [usbcore]
[   40.331604]  [<c013adf0>] autoremove_wake_function+0x0/0x50
[   40.331619]  [<d7858090>] hub_thread+0x0/0xc20 [usbcore]
[   40.331636]  [<c013ac3a>] kthread+0xba/0xf0
[   40.331643]  [<c013ab80>] kthread+0x0/0xf0
[   40.331649]  [<c01044c7>] kernel_thread_helper+0x7/0x10
[   40.331661]  =======================
[   40.331663] Code: ff ff 89 6c 24 10 31 ed 89 d9 89 74 24 08 89 c6 89 7c 24 
0c 89 c7 89 e8 89 14 24 f2 ae f7 d1 49 8b 04 24 89 ca 89 d9 8b 38 89 e8 <f2> 
ae f7 d1 49 8d 44 0a 02 ba d0 00 00 00 e8 38 ae f1 ff ba f4
[   40.331693] EIP: [<c0258315>] make_class_name+0x35/0xa0 SS:ESP 
0068:d6067e50
[   40.331700]  <5>sdb : READ CAPACITY failed.
[   40.334887] sdb : status=0, message=00, host=1, driver=00
[   40.334895] sdb : sense not available.
[   40.336498] sdb: Write Protect is off
[   40.336502] sdb: Mode Sense: 00 00 00 00
[   40.336505] sdb: assuming drive cache: write through
[   40.336605] sd 2:0:0:0: Attached scsi disk sdb
[   40.336675] sd 2:0:0:0: Attached scsi generic sg2 type 0

Nice recovery, I thought.  My kernel's tainted now, isn't it? :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
