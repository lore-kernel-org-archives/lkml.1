Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbXCEEeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbXCEEeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXCEEeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:34:17 -0500
Received: from rtr.ca ([64.26.128.89]:4419 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbXCEEeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:34:16 -0500
Message-ID: <45EB9DC6.8010403@rtr.ca>
Date: Sun, 04 Mar 2007 23:34:14 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: [BUG} usb regression in 2.6.21-rc2-git3
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de>
In-Reply-To: <20070305015031.GF3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This email lists some known regressions in 2.6.21-rc2 compared to 2.6.20
> that are not yet fixed in Linus' tree.


Here's another one for Greg:

I have a Targus USB 1.1 "dock", basically a hub with built-in
serial, parallel, PS/2 KB, PS/2 Mouse, and extra USB ports.

Simply connecting, and then disconnecting it causes an oops with 2.6.21-rc2:

Mar  4 23:29:51 silvy kernel: usb 4-2: new full speed USB device using uhci_hcd and address 2
Mar  4 23:29:51 silvy kernel: usb 4-2: configuration #1 chosen from 1 choice
Mar  4 23:29:51 silvy kernel: hub 4-2:1.0: USB hub found
Mar  4 23:29:51 silvy kernel: hub 4-2:1.0: 5 ports detected
Mar  4 23:29:52 silvy kernel: usb 4-2.3: new full speed USB device using uhci_hcd and address 3
Mar  4 23:29:52 silvy kernel: usb 4-2.3: configuration #1 chosen from 1 choice
Mar  4 23:29:52 silvy kernel: input: MTC PS/2 to USB converter as /class/input/input9
Mar  4 23:29:52 silvy kernel: input: USB HID v1.10 Keyboard [MTC PS/2 to USB converter] on usb-0000:00:1d.3-2.3
Mar  4 23:29:52 silvy kernel: input: MTC PS/2 to USB converter as /class/input/input10
Mar  4 23:29:52 silvy kernel: input: USB HID v1.10 Mouse [MTC PS/2 to USB converter] on usb-0000:00:1d.3-2.3
Mar  4 23:29:52 silvy kernel: usb 4-2.5: new full speed USB device using uhci_hcd and address 4
Mar  4 23:29:52 silvy kernel: usb 4-2.5: configuration #1 chosen from 1 choice
Mar  4 23:29:52 silvy kernel: usb 4-2.4: new full speed USB device using uhci_hcd and address 5
Mar  4 23:29:52 silvy kernel: usb 4-2.4: configuration #1 chosen from 1 choice
Mar  4 23:29:52 silvy kernel: drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 4 if 0 alt 1 proto 2 vid 0x0711 pid 0x0300
Mar  4 23:29:52 silvy kernel: usbcore: registered new interface driver usblp
Mar  4 23:29:52 silvy kernel: drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Mar  4 23:29:52 silvy kernel: drivers/usb/serial/usb-serial.c: USB Serial support registered for MCT U232
Mar  4 23:29:52 silvy kernel: mct_u232 4-2.4:1.0: MCT U232 converter detected
Mar  4 23:29:52 silvy kernel: usb-serial ttyUSB0: Error registering port device, continuing
Mar  4 23:29:52 silvy kernel: usbcore: registered new interface driver mct_u232
Mar  4 23:29:52 silvy kernel: drivers/usb/serial/mct_u232.c: Magic Control Technology USB-RS232 converter driver z2.0
Mar  4 23:29:57 silvy kernel: usb 4-2: USB disconnect, address 2
Mar  4 23:29:57 silvy kernel: usb 4-2.3: USB disconnect, address 3
Mar  4 23:29:57 silvy kernel: usb 4-2.4: USB disconnect, address 5
Mar  4 23:29:57 silvy kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000c
Mar  4 23:29:57 silvy kernel:  printing eip:
Mar  4 23:29:57 silvy kernel: c027c251
Mar  4 23:29:57 silvy kernel: *pde = 00000000
Mar  4 23:29:57 silvy kernel: Oops: 0000 [#1]
Mar  4 23:29:57 silvy kernel: PREEMPT 
Mar  4 23:29:57 silvy kernel: Modules linked in: mct_u232 usblp radeon drm nfsd exportfs lockd nfs_acl sunrpc acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_stats freq_table cpufreq_conservative ac fan button thermal video battery container processor rfcomm l2cap bluetooth cfq_iosched deflate zlib_deflate twofish twofish_common serpent blowfish des cbc ecb blkcipher aes xcbc sha256 sha1 crypto_null af_key af_packet sbp2 usbhid hid pl2303 usbserial mousedev snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss pcmcia snd_pcm snd_timer snd ipw2200 soundcore ieee80211 ieee80211_crypt pcspkr psmouse serio_raw b44 ahci ohci1394 ieee1394 snd_page_alloc sdhci mmc_core firmware_class yenta_socket rsrc_nonstatic pcmcia_core mii intel_agp ehci_hcd uhci_hcd usbcore agpgart sg sr_mod cdrom unix
Mar  4 23:29:57 silvy kernel: CPU:    0
Mar  4 23:29:57 silvy kernel: EIP:    0060:[klist_del+6/69]    Not tainted VLI
Mar  4 23:29:57 silvy kernel: EFLAGS: 00010286   (2.6.21-rc2-git3 #5)
Mar  4 23:29:57 silvy kernel: EIP is at klist_del+0x6/0x45
Mar  4 23:29:57 silvy kernel: eax: 00000000   ebx: f619f278   ecx: 00000001   edx: f66873c8
Mar  4 23:29:57 silvy kernel: esi: f619f288   edi: f66873c0   ebp: f619f618   esp: f742fe24
Mar  4 23:29:57 silvy kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Mar  4 23:29:57 silvy kernel: Process khubd (pid: 1970, ti=f742e000 task=f7c20070 task.ti=f742e000)
Mar  4 23:29:57 silvy kernel: Stack: f619f278 00000001 c01fb571 f619f278 00000001 f66873c0 00000000 c01fb6f2 
Mar  4 23:29:57 silvy kernel:        f66873c0 f8a05d0e fffffffe f6146340 f66873c0 f66873c0 f66873f4 f8a05c8e 
Mar  4 23:29:57 silvy kernel:        f66873c0 f619f618 c01aafd5 00000202 00000000 f619f200 f66873c0 f619f200 
Mar  4 23:29:57 silvy kernel: Call Trace:
Mar  4 23:29:57 silvy kernel:  [device_del+21/398] device_del+0x15/0x18e
Mar  4 23:29:57 silvy kernel:  [device_unregister+8/16] device_unregister+0x8/0x10
Mar  4 23:29:57 silvy kernel:  [<f8a05d0e>] destroy_serial+0x80/0xcc [usbserial]
Mar  4 23:29:57 silvy kernel:  [<f8a05c8e>] destroy_serial+0x0/0xcc [usbserial]
Mar  4 23:29:57 silvy kernel:  [kref_put+95/110] kref_put+0x5f/0x6e
Mar  4 23:29:57 silvy kernel:  [<f8a057f7>] usb_serial_disconnect+0x81/0xaa [usbserial]
Mar  4 23:29:57 silvy kernel:  [kref_put+95/110] kref_put+0x5f/0x6e
Mar  4 23:29:57 silvy kernel:  [<f887fcc8>] usb_unbind_interface+0x2a/0x59 [usbcore]
Mar  4 23:29:57 silvy kernel:  [__device_release_driver+110/139] __device_release_driver+0x6e/0x8b
Mar  4 23:29:57 silvy kernel:  [device_release_driver+29/50] device_release_driver+0x1d/0x32
Mar  4 23:29:57 silvy kernel:  [bus_remove_device+113/129] bus_remove_device+0x71/0x81
Mar  4 23:29:57 silvy kernel:  [device_del+308/398] device_del+0x134/0x18e
Mar  4 23:29:57 silvy kernel:  [<f887e54c>] usb_disable_device+0x5c/0xbb [usbcore]
Mar  4 23:29:57 silvy kernel:  [<f887afdb>] usb_disconnect+0x82/0x104 [usbcore]
Mar  4 23:29:57 silvy kernel:  [<f887afc9>] usb_disconnect+0x70/0x104 [usbcore]
Mar  4 23:29:57 silvy kernel:  [<f887b9c8>] hub_thread+0x30b/0x9db [usbcore]
Mar  4 23:29:57 silvy kernel:  [__activate_task+28/40] __activate_task+0x1c/0x28
Mar  4 23:29:57 silvy kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
Mar  4 23:29:57 silvy kernel:  [<f887b6bd>] hub_thread+0x0/0x9db [usbcore]
Mar  4 23:29:57 silvy kernel:  [kthread+155/191] kthread+0x9b/0xbf
Mar  4 23:29:57 silvy kernel:  [kthread+0/191] kthread+0x0/0xbf
Mar  4 23:29:57 silvy kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Mar  4 23:29:57 silvy kernel:  =======================
Mar  4 23:29:57 silvy kernel: Code: 8b 4b 04 8d 46 04 89 43 04 89 5e 04 89 48 04 89 01 ff 4a 14 8b 42 08 a8 08 74 07 5b 5e e9 83 09 00 00 5b 5e c3 56 89 c6 53 8b 00 <8b> 58 0c 89 e0 25 00 e0 ff ff ff 40 14 89 f0 e8 f5 fe ff ff 85 
Mar  4 23:29:57 silvy kernel: EIP: [klist_del+6/69] klist_del+0x6/0x45 SS:ESP 0068:f742fe24
