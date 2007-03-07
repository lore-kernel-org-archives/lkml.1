Return-Path: <linux-kernel-owner+w=401wt.eu-S965494AbXCGOPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965494AbXCGOPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965514AbXCGOPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:15:42 -0500
Received: from rtr.ca ([64.26.128.89]:1635 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965494AbXCGOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:15:41 -0500
Message-ID: <45EEC90B.6030407@rtr.ca>
Date: Wed, 07 Mar 2007 09:15:39 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux v2.6.21-rc3
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <1173263132.9349.47.camel@localhost.localdomain> <20070307132621.GA8084@kroah.com>
In-Reply-To: <20070307132621.GA8084@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg / Adrian,

I didn't see anything in -rc3 to address the USB hub/serial crashes
reported here for -rc2.  What's the status for those, or who should
I be pinging to get them fixed?

Thanks

Mark

> Message-ID: <45EB9FD6.9080403@rtr.ca>
> Date: Sun, 04 Mar 2007 23:43:02 -0500
> From: Mark Lord <lkml@rtr.ca>
> User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
> MIME-Version: 1.0
> To: Greg KH <greg@kroah.com>
> CC: Adrian Bunk <bunk@stusta.de>, 
>  Andrew Morton <akpm@linux-foundation.org>,
>  Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Subject: Re: [BUG} usb regression in 2.6.21-rc2-git3
> References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca>
> In-Reply-To: <45EB9DC6.8010403@rtr.ca>
> Content-Type: text/plain; charset=UTF-8; format=flowed
> Content-Transfer-Encoding: 7bit
> 
> Mark Lord wrote:
>>
>> Here's another one for Greg:
>> 
>> I have a Targus USB 1.1 "dock", basically a hub with built-in
>> serial, parallel, PS/2 KB, PS/2 Mouse, and extra USB ports.
>> 
>> Simply connecting, and then disconnecting it causes an oops with 
>> 2.6.21-rc2:
> ..
> 
> Same behaviour with a second, different USB 1.1 "dock" here as well:
> 
> Mar  4 23:40:16 silvy kernel: usb 5-8: new high speed USB device using ehci_hcd and address 5
> Mar  4 23:40:16 silvy kernel: usb 5-8: configuration #1 chosen from 1 choice
> Mar  4 23:40:16 silvy kernel: hub 5-8:1.0: USB hub found
> Mar  4 23:40:16 silvy kernel: hub 5-8:1.0: 4 ports detected
> Mar  4 23:40:16 silvy kernel: usb 5-8.4: new full speed USB device using ehci_hcd and address 6
> Mar  4 23:40:17 silvy kernel: usb 5-8.4: configuration #1 chosen from 1 choice
> Mar  4 23:40:17 silvy kernel: hub 5-8.4:1.0: USB hub found
> Mar  4 23:40:17 silvy kernel: hub 5-8.4:1.0: 4 ports detected
> Mar  4 23:40:17 silvy kernel: usb 5-8.4.1: new full speed USB device using ehci_hcd and address 7
> Mar  4 23:40:17 silvy kernel: usb 5-8.4.1: configuration #1 chosen from 1 choice
> Mar  4 23:40:17 silvy kernel: usb 5-8.4.3: new low speed USB device using ehci_hcd and address 8
> Mar  4 23:40:17 silvy kernel: usb 5-8.4.3: configuration #1 chosen from 1 choice
> Mar  4 23:40:17 silvy kernel: input: Composite USB PS2 Converter USB to PS2 Adaptor  v1.12 as /class/input/input8
> Mar  4 23:40:17 silvy kernel: input: USB HID v1.10 Keyboard [Composite USB PS2 Converter USB to PS2 Adaptor  v1.12] on usb-0000:00:1d.7-8.4.3
> Mar  4 23:40:17 silvy kernel: input: Composite USB PS2 Converter USB to PS2 Adaptor  v1.12 as /class/input/input9
> Mar  4 23:40:17 silvy kernel: input: USB HID v1.10 Mouse [Composite USB PS2 Converter USB to PS2 Adaptor  v1.12] on usb-0000:00:1d.7-8.4.3
> Mar  4 23:40:17 silvy kernel: usb 5-8.4.4: new full speed USB device using ehci_hcd and address 9
> Mar  4 23:40:17 silvy kernel: usb 5-8.4.4: configuration #1 chosen from 1 choice
> Mar  4 23:40:17 silvy kernel: pl2303 5-8.4.4:1.0: pl2303 converter detected
> Mar  4 23:40:17 silvy kernel: usb-serial ttyUSB0: Error registering port device, continuing
> Mar  4 23:40:17 silvy kernel: drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 7 if 0 alt 1 proto 2 vid 0x0B39 pid 0x0801
> Mar  4 23:40:17 silvy kernel: usbcore: registered new interface driver usblp
> Mar  4 23:40:17 silvy kernel: drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
> Mar  4 23:41:05 silvy kernel: usb 5-8: USB disconnect, address 5
> Mar  4 23:41:05 silvy kernel: usb 5-8.4: USB disconnect, address 6
> Mar  4 23:41:05 silvy kernel: usb 5-8.4.1: USB disconnect, address 7
> Mar  4 23:41:05 silvy kernel: drivers/usb/class/usblp.c: usblp0: removed
> Mar  4 23:41:05 silvy kernel: usb 5-8.4.3: USB disconnect, address 8
> Mar  4 23:41:05 silvy kernel: usb 5-8.4.4: USB disconnect, address 9
> Mar  4 23:41:05 silvy kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000c
> Mar  4 23:41:05 silvy kernel:  printing eip:
> Mar  4 23:41:05 silvy kernel: c027c251
> Mar  4 23:41:05 silvy kernel: *pde = 00000000
> Mar  4 23:41:05 silvy kernel: Oops: 0000 [#1]
> Mar  4 23:41:05 silvy kernel: PREEMPT 
> Mar  4 23:41:05 silvy kernel: Modules linked in: usblp radeon drm nfsd exportfs lockd nfs_acl sunrpc acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_stats freq_table cpufreq_conservative ac fan button thermal video battery container processor rfcomm l2cap bluetooth cfq_iosched deflate zlib_deflate twofish twofish_common serpent blowfish des cbc ecb blkcipher aes xcbc sha256 sha1 crypto_null af_key af_packet sbp2 usbhid hid pl2303 usbserial mousedev pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore ipw2200 ahci psmouse serio_raw pcspkr ieee80211 ieee80211_crypt sdhci mmc_core snd_page_alloc yenta_socket rsrc_nonstatic firmware_class ohci1394 ieee1394 b44 mii pcmcia_core intel_agp ehci_hcd uhci_hcd usbcore agpgart sg sr_mod cdrom unix
> Mar  4 23:41:05 silvy kernel: CPU:    0
> Mar  4 23:41:05 silvy kernel: EIP:    0060:[klist_del+6/69]    Not tainted VLI
> Mar  4 23:41:05 silvy kernel: EFLAGS: 00010286   (2.6.21-rc2-git3 #5)
> Mar  4 23:41:05 silvy kernel: EIP is at klist_del+0x6/0x45
> Mar  4 23:41:05 silvy kernel: eax: 00000000   ebx: f6730a78   ecx: 00000001   edx: f63f5248
> Mar  4 23:41:05 silvy kernel: esi: f6730a88   edi: f63f5240   ebp: f6706618   esp: f7ba7e00
> Mar  4 23:41:05 silvy kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Mar  4 23:41:05 silvy kernel: Process khubd (pid: 1925, ti=f7ba6000 task=f7c275e0 task.ti=f7ba6000)
> Mar  4 23:41:05 silvy kernel: Stack: f6730a78 00000001 c01fb571 f6730a78 00000001 f63f5240 00000000 c01fb6f2 
> Mar  4 23:41:05 silvy kernel:        f63f5240 f89ffd0e fffffffe f6c62a40 f63f5240 f63f5240 f63f5274 f89ffc8e 
> Mar  4 23:41:05 silvy kernel:        f63f5240 f6706618 c01aafd5 00000202 00000000 f6730a00 f63f5240 f6730a00 
> Mar  4 23:41:05 silvy kernel: Call Trace:
> Mar  4 23:41:05 silvy kernel:  [device_del+21/398] device_del+0x15/0x18e
> Mar  4 23:41:05 silvy kernel:  [device_unregister+8/16] device_unregister+0x8/0x10
> Mar  4 23:41:05 silvy kernel:  [<f89ffd0e>] destroy_serial+0x80/0xcc [usbserial]
> Mar  4 23:41:05 silvy kernel:  [<f89ffc8e>] destroy_serial+0x0/0xcc [usbserial]
> Mar  4 23:41:05 silvy kernel:  [kref_put+95/110] kref_put+0x5f/0x6e
> Mar  4 23:41:05 silvy kernel:  [<f89ff7f7>] usb_serial_disconnect+0x81/0xaa [usbserial]
> Mar  4 23:41:05 silvy kernel:  [kref_put+95/110] kref_put+0x5f/0x6e
> Mar  4 23:41:05 silvy kernel:  [<f887fcc8>] usb_unbind_interface+0x2a/0x59 [usbcore]
> Mar  4 23:41:05 silvy kernel:  [__device_release_driver+110/139] __device_release_driver+0x6e/0x8b
> Mar  4 23:41:05 silvy kernel:  [device_release_driver+29/50] device_release_driver+0x1d/0x32
> Mar  4 23:41:05 silvy kernel:  [bus_remove_device+113/129] bus_remove_device+0x71/0x81
> Mar  4 23:41:05 silvy kernel:  [device_del+308/398] device_del+0x134/0x18e
> Mar  4 23:41:05 silvy kernel:  [<f887e54c>] usb_disable_device+0x5c/0xbb [usbcore]
> Mar  4 23:41:05 silvy kernel:  [<f887afdb>] usb_disconnect+0x82/0x104 [usbcore]
> Mar  4 23:41:05 silvy kernel:  [<f887afc9>] usb_disconnect+0x70/0x104 [usbcore]
> Mar  4 23:41:05 silvy kernel:  [<f887afc9>] usb_disconnect+0x70/0x104 [usbcore]
> Mar  4 23:41:05 silvy kernel:  [<f887b9c8>] hub_thread+0x30b/0x9db [usbcore]
> Mar  4 23:41:05 silvy kernel:  [__activate_task+28/40] __activate_task+0x1c/0x28
> Mar  4 23:41:05 silvy kernel:  [autoremove_wake_function+0/51] autoremove_wake_function+0x0/0x33
> Mar  4 23:41:05 silvy kernel:  [<f887b6bd>] hub_thread+0x0/0x9db [usbcore]
> Mar  4 23:41:05 silvy kernel:  [kthread+155/191] kthread+0x9b/0xbf
> Mar  4 23:41:05 silvy kernel:  [kthread+0/191] kthread+0x0/0xbf
> Mar  4 23:41:05 silvy kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
> Mar  4 23:41:05 silvy kernel:  =======================
> Mar  4 23:41:05 silvy kernel: Code: 8b 4b 04 8d 46 04 89 43 04 89 5e 04 89 48 04 89 01 ff 4a 14 8b 42 08 a8 08 74 07 5b 5e e9 83 09 00 00 5b 5e c3 56 89 c6 53 8b 00 <8b> 58 0c 89 e0 25 00 e0 ff ff ff 40 14 89 f0 e8 f5 fe ff ff 85 
> Mar  4 23:41:05 silvy kernel: EIP: [klist_del+6/69] klist_del+0x6/0x45 SS:ESP 0068:f7ba7e00
> 
> 
