Return-Path: <linux-kernel-owner+w=401wt.eu-S965715AbXCSGlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965715AbXCSGlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 02:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965717AbXCSGlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 02:41:37 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:58200 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965715AbXCSGlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 02:41:35 -0400
Date: Mon, 19 Mar 2007 08:41:33 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: 2.6.21-rc4: pl2303 disconnect oops
Message-ID: <Pine.SOC.4.64.0703190835280.28512@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was using my laptop as the serial console of another computer with 
pl2303 usb-to-serial cable. minicom was running but I do not remember 
whether the other end was connected or was already disconnected. Anyway, 
I unplugged the usb cable and got a couple of oopses from pl2303. Kernel 
2.6.21-rc4 on a thinkpad X20.

usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
pl2303 1-1.1:1.0: pl2303 converter detected
usb 1-1.1: pl2303 converter now attached to ttyUSB0
usbcore: registered new interface driver pl2303
drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
[...]
usb 1-1.1: USB disconnect, address 3
pl2303 1-1.1:1.0: device disconnected
usb 1-1: USB disconnect, address 2
usb 1-1: new full speed USB device using uhci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 2 ports detected
usb 1-1.1: new full speed USB device using uhci_hcd and address 5
usb 1-1.1: configuration #1 chosen from 1 choice
pl2303 1-1.1:1.0: pl2303 converter detected
usb 1-1.1: pl2303 converter now attached to ttyUSB1
usb 1-1.1: USB disconnect, address 5
pl2303 ttyUSB1: pl2303 converter now disconnected from ttyUSB1
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000168
 printing eip:
d495afd4
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: rfcomm l2cap bluetooth nvram uinput button ac battery dm_snapshot dm_mirror dm_mod ipv6 cpufreq_ondemand freq_table cpufreq_conservative cpufreq_powersave cpufreq_userspace snd_cs4281 gameport snd_seq_dummy snd_seq_oss tsdev snd_seq_midi snd_seq_midi_event snd_seq pcmcia firmware_class parport_pc parport snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss rtc pl2303 snd_mixer_oss usbserial snd_pcm snd_page_alloc snd_opl3_lib snd_seq_device snd_timer snd_hwdep intel_agp agpgart snd psmouse serio_raw evdev soundcore yenta_socket rsrc_nonstatic pcspkr pcmcia_core ext3 jbd mbcache sd_mod uhci_hcd usbcore e100 mii ata_piix libata scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<d495afd4>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-rc4 #1)
EIP is at pl2303_shutdown+0x24/0x80 [pl2303]
eax: 00000000   ebx: d2a5ef60   ecx: d3fef540   edx: d495afb0
esi: 00000000   edi: d2a5ef60   ebp: d3c3be18   esp: d3c3be00
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process khubd (pid: 542, ti=d3c3b000 task=d3cff050 task.ti=d3c3b000)
Stack: c01b9174 d3c3be0c c021becf d2a5ef60 00000001 00000000 d3c3be3c d4951b96 
       d3f49294 d3c3be30 cfda81a0 00000000 d2a5ef94 d4951b10 d2a5ef60 d3c3be5c 
       c01b9f3b d3c3be58 d48bda56 cde04400 cd918600 cd918600 00000001 d3c3be64 
Call Trace:
 [<c0104dda>] show_trace_log_lvl+0x1a/0x30
 [<c0104e99>] show_stack_log_lvl+0xa9/0xd0
 [<c01050a9>] show_registers+0x1e9/0x2f0
 [<c0105296>] die+0xe6/0x1d0
 [<c01145c7>] do_page_fault+0x277/0x610
 [<c029e364>] error_code+0x74/0x7c
 [<d4951b96>] destroy_serial+0x86/0x150 [usbserial]
 [<c01b9f3b>] kref_put+0x2b/0x80
 [<d4951960>] usb_serial_put+0x10/0x20 [usbserial]
 [<d49519db>] usb_serial_disconnect+0x6b/0xc0 [usbserial]
 [<d48be7d7>] usb_unbind_interface+0x47/0x90 [usbcore]
 [<c021e877>] __device_release_driver+0x67/0x90
 [<c021ed40>] device_release_driver+0x20/0x40
 [<c021e1ff>] bus_remove_device+0x5f/0x90
 [<c021c3d7>] device_del+0x157/0x1c0
 [<d48bbde8>] usb_disable_device+0x78/0xe0 [usbcore]
 [<d48b8554>] usb_disconnect+0x94/0x100 [usbcore]
 [<d48b9128>] hub_thread+0x178/0xba0 [usbcore]
 [<c012a223>] kthread+0xa3/0xd0
 [<c0104a17>] kernel_thread_helper+0x7/0x10
 =======================
Code: ff ff 90 8d 74 26 00 55 89 e5 57 89 c7 56 53 83 ec 0c 8b 35 e0 d7 95 d4 85 f6 75 44 80 7f 0d 00 74 36 31 f6 8d 76 00 8b 44 b7 14 <8b> 98 68 01 00 00 85 db 74 1a 8b 03 e8 0b e6 ff ff 89 d8 e8 f4 
EIP: [<d495afd4>] pl2303_shutdown+0x24/0x80 [pl2303] SS:ESP 0068:d3c3be00
pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000168
 printing eip:
d495afd4
*pde = 00000000
Oops: 0000 [#2]
Modules linked in: rfcomm l2cap bluetooth nvram uinput button ac battery dm_snapshot dm_mirror dm_mod ipv6 cpufreq_ondemand freq_table cpufreq_conservative cpufreq_powersave cpufreq_userspace snd_cs4281 gameport snd_seq_dummy snd_seq_oss tsdev snd_seq_midi snd_seq_midi_event snd_seq pcmcia firmware_class parport_pc parport snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss rtc pl2303 snd_mixer_oss usbserial snd_pcm snd_page_alloc snd_opl3_lib snd_seq_device snd_timer snd_hwdep intel_agp agpgart snd psmouse serio_raw evdev soundcore yenta_socket rsrc_nonstatic pcspkr pcmcia_core ext3 jbd mbcache sd_mod uhci_hcd usbcore e100 mii ata_piix libata scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<d495afd4>]    Not tainted VLI
EFLAGS: 00210246   (2.6.21-rc4 #1)
EIP is at pl2303_shutdown+0x24/0x80 [pl2303]
eax: 00000000   ebx: d39fba20   ecx: d3fef540   edx: d495afb0
esi: 00000000   edi: d39fba20   ebp: cdac2e50   esp: cdac2e38
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process minicom (pid: 3051, ti=cdac2000 task=d3c70a70 task.ti=cdac2000)
Stack: c01b9174 cdac2e44 c021becf d39fba20 00000001 00000000 cdac2e74 d4951b96 
       00000000 00000bb8 cdac2e9c d495a125 d39fba54 d4951b10 cec5fe40 cdac2e94 
       c01b9f3b 00000000 d3c70a70 c0116760 00100100 d301f800 d301f808 cdac2e9c 
Call Trace:
 [<c0104dda>] show_trace_log_lvl+0x1a/0x30
 [<c0104e99>] show_stack_log_lvl+0xa9/0xd0
 [<c01050a9>] show_registers+0x1e9/0x2f0
 [<c0105296>] die+0xe6/0x1d0
 [<c01145c7>] do_page_fault+0x277/0x610
 [<c029e364>] error_code+0x74/0x7c
 [<d4951b96>] destroy_serial+0x86/0x150 [usbserial]
 [<c01b9f3b>] kref_put+0x2b/0x80
 [<d4951960>] usb_serial_put+0x10/0x20 [usbserial]
 [<d4951a7b>] serial_close+0x4b/0xe0 [usbserial]
 [<c02043dc>] release_dev+0x13c/0x600
 [<c02048aa>] tty_release+0xa/0x10
 [<c015bd69>] __fput+0x99/0x150
 [<c015be88>] fput+0x18/0x20
 [<c0159467>] filp_close+0x47/0x70
 [<c015a6fc>] sys_close+0x6c/0xa0
 [<c0103e96>] sysenter_past_esp+0x5f/0x85
 =======================
Code: ff ff 90 8d 74 26 00 55 89 e5 57 89 c7 56 53 83 ec 0c 8b 35 e0 d7 95 d4 85 f6 75 44 80 7f 0d 00 74 36 31 f6 8d 76 00 8b 44 b7 14 <8b> 98 68 01 00 00 85 db 74 1a 8b 03 e8 0b e6 ff ff 89 d8 e8 f4 
EIP: [<d495afd4>] pl2303_shutdown+0x24/0x80 [pl2303] SS:ESP 0068:cdac2e38

-- 
Meelis Roos (mroos@linux.ee)
