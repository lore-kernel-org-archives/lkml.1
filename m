Return-Path: <linux-kernel-owner+w=401wt.eu-S1030573AbXCLQOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbXCLQOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXCLQOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:14:15 -0400
Received: from rtr.ca ([64.26.128.89]:4401 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030514AbXCLQOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:14:11 -0400
Message-ID: <45F57C52.1010105@rtr.ca>
Date: Mon, 12 Mar 2007 12:14:10 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca> <200703121606.06601.oneukum@suse.de> <45F56E37.9050506@rtr.ca> <20070312152920.GA29597@kroah.com> <45F579CF.7040802@rtr.ca> <45F57BB8.5010705@rtr.ca>
In-Reply-To: <45F57BB8.5010705@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

..and here is a retest with linux-2.6.21-rc3-git7
of simply plug/wait/unplug a USB hub/serial/parallel/PS2 gizmo.

I have two of these, with different serial port hardware in each,
and doing this with either of them produces an ooops.

12:12:02 kernel: usb 4-2: new full speed USB device using uhci_hcd and address 2
12:12:02 kernel: usb 4-2: configuration #1 chosen from 1 choice
12:12:02 kernel: hub 4-2:1.0: USB hub found
12:12:02 kernel: hub 4-2:1.0: 5 ports detected
12:12:02 kernel: usb 4-2.3: new full speed USB device using uhci_hcd and address 3
12:12:02 kernel: usb 4-2.3: configuration #1 chosen from 1 choice
12:12:02 kernel: input: MTC PS/2 to USB converter as /class/input/input9
12:12:02 kernel: input: USB HID v1.10 Keyboard [MTC PS/2 to USB converter] on usb-0000:00:1d.3-2.3
12:12:02 kernel: input: MTC PS/2 to USB converter as /class/input/input10
12:12:02 kernel: input: USB HID v1.10 Mouse [MTC PS/2 to USB converter] on usb-0000:00:1d.3-2.3
12:12:02 kernel: usb 4-2.4: new full speed USB device using uhci_hcd and address 4
12:12:03 kernel: usb 4-2.4: configuration #1 chosen from 1 choice
12:12:03 kernel: drivers/usb/serial/usb-serial.c: USB Serial support registered for MCT U232
12:12:03 kernel: usb 4-2.5: new full speed USB device using uhci_hcd and address 5
12:12:03 kernel: usb 4-2.5: configuration #1 chosen from 1 choice
12:12:03 kernel: mct_u232 4-2.4:1.0: MCT U232 converter detected
12:12:03 kernel: usb 4-2.4: MCT U232 converter now attached to ttyUSB2
12:12:03 kernel: usbcore: registered new interface driver mct_u232
12:12:03 kernel: drivers/usb/serial/mct_u232.c: Magic Control Technology USB-RS232 converter driver z2.0
12:12:03 kernel: drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 5 if 0 alt 1 proto 2 vid 0x0711 pid 0x0300
12:12:03 kernel: usbcore: registered new interface driver usblp
12:12:03 kernel: drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
12:12:06 kernel: usb 4-2: USB disconnect, address 2
12:12:06 kernel: usb 4-2.3: USB disconnect, address 3
12:12:06 kernel: usb 4-2.4: USB disconnect, address 4
12:12:06 kernel: mct_u232 ttyUSB2: MCT U232 converter now disconnected from ttyUSB2
12:12:06 kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000168
12:12:06 kernel:  printing eip:
12:12:06 kernel: f8ca6542
12:12:06 kernel: *pde = 00000000
12:12:06 kernel: Oops: 0000 [#2]
12:12:06 kernel: PREEMPT 
12:12:06 kernel: Modules linked in: usblp mct_u232 radeon drm nfsd exportfs lockd nfs_acl sunrpc acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_stats freq_table cpufreq_conservative ac fan button thermal video battery container processor rfcomm l2cap bluetooth cfq_iosched deflate zlib_deflate twofish twofish_common serpent blowfish des cbc ecb blkcipher aes xcbc sha256 sha1 crypto_null af_key af_packet sbp2 usbhid hid pl2303 usbserial mousedev pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer ipw2200 snd ieee80211 ieee80211_crypt ohci1394 serio_raw psmouse soundcore snd_page_alloc pcspkr sdhci firmware_class ahci ieee1394 yenta_socket rsrc_nonstatic pcmcia_core ehci_hcd mmc_core b44 mii uhci_hcd usbcore intel_agp agpgart sg sr_mod cdrom unix
12:12:06 kernel: CPU:    0
12:12:06 kernel: EIP:    0060:[<f8ca6542>]    Not tainted VLI
12:12:06 kernel: EFLAGS: 00010206   (2.6.21-rc3-git7 #7)
12:12:06 kernel: EIP is at mct_u232_shutdown+0x39/0x65 [mct_u232]
12:12:06 kernel: eax: 00000001   ebx: f7649cc0   ecx: c20df5c0   edx: 00000078
12:12:06 kernel: esi: 00000000   edi: f7649cc0   ebp: f5c45c18   esp: f7437e38
12:12:06 kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
12:12:06 kernel: Process khubd (pid: 1949, ti=f7436000 task=f7d8da10 task.ti=f7436000)
12:12:06 kernel: Stack: f6c2c478 00000000 f6c2c478 f7649cc0 00000001 f7649cc0 f8a29ca1 f7649cc0 
12:12:06 kernel:        f7649cc0 f5c45c18 f88c5a43 f7649cf4 f8a29c18 c01ab1b5 00000202 00000000 
12:12:06 kernel:        f6c2c400 f7649cc0 f6c2c400 f7649cc4 f8a297f7 c01ab1b5 00000001 f5abec67 
12:12:06 kernel: Call Trace:
12:12:06 kernel:  [<f8a29ca1>] destroy_serial+0x89/0x122 [usbserial]
12:12:06 kernel:  [<f88c5a43>] usb_kill_urb+0x4e/0xcb [usbcore]
12:12:06 kernel:  [<f8a29c18>] destroy_serial+0x0/0x122 [usbserial]
12:12:06 kernel:  [kref_put+95/110] kref_put+0x5f/0x6e
12:12:06 kernel:  [<f8a297f7>] usb_serial_disconnect+0x81/0xaa [usbserial]
12:12:06 kernel:  [kref_put+95/110] kref_put+0x5f/0x6e
12:12:06 kernel:  [<f88c7ca8>] usb_unbind_interface+0x2a/0x59 [usbcore]
12:12:06 kernel:  [__device_release_driver+110/139] __device_release_driver+0x6e/0x8b
12:12:06 kernel:  [device_release_driver+29/50] device_release_driver+0x1d/0x32
12:12:06 kernel:  [bus_remove_device+113/129] bus_remove_device+0x71/0x81
12:12:06 kernel:  [device_del+308/405] device_del+0x134/0x195
12:12:06 kernel:  [<f88c652d>] usb_disable_device+0x5c/0xbb [usbcore]
12:12:06 kernel:  [<f88c2f8d>] usb_disconnect+0x82/0x104 [usbcore]
12:12:06 kernel:  [<f88c2f7b>] usb_disconnect+0x70/0x104 [usbcore]
12:12:06 kernel:  [<f88c397a>] hub_thread+0x30b/0x9ed [usbcore]
12:12:06 kernel:  [activate_task+153/172] activate_task+0x99/0xac
12:12:06 kernel:  [schedule+1148/1311] schedule+0x47c/0x51f
12:12:06 kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
12:12:06 kernel:  [<f88c366f>] hub_thread+0x0/0x9ed [usbcore]
12:12:06 kernel:  [kthread+155/191] kthread+0x9b/0xbf
12:12:06 kernel:  [kthread+0/191] kthread+0x0/0xbf
12:12:06 kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
12:12:06 kernel:  =======================
12:12:06 kernel: Code: 00 74 1c c7 44 24 08 35 6e ca f8 c7 44 24 04 ca 6e ca f8 c7 04 24 47 71 ca f8 e8 46 1b 47 c7 89 fb 31 f6 eb 23 8b 53 14 83 c2 78 <8b> 82 f0 00 00 00 85 c0 74 0f c7 82 f0 00 00 00 00 00 00 00 e8 
12:12:06 kernel: EIP: [<f8ca6542>] mct_u232_shutdown+0x39/0x65 [mct_u232] SS:ESP 0068:f7437e38
