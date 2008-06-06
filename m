Return-Path: <linux-kernel-owner+w=401wt.eu-S1764545AbYFFH0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764545AbYFFH0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYFFH0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:26:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308AbYFFH0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:26:36 -0400
Date: Fri, 6 Jun 2008 00:26:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [ 88.628451] BUG: unable to handle kernel paging request at
 f8dbf000 "isight_firmware"
Message-Id: <20080606002601.a0f6c47c.akpm@linux-foundation.org>
In-Reply-To: <dd18b0c30806041213x45b7efdfo42de9b214a7ce9df@mail.gmail.com>
References: <dd18b0c30806041213x45b7efdfo42de9b214a7ce9df@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 19:13:46 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:

> Yesterday I compiled the isight_firmware module, and was happy with
> the result's, "no more udev",
> This morning I wasn't so lucky, upon a cold boot my system was stuck
> during boot, I tried numerous boot's but still the same results,
> luckily I was hoping to gather the info on what was going on here it is:
> 
> [   88.517109] firmware: requesting isight.fw
> [   88.628451] BUG: unable to handle kernel paging request at f8dbf000
> [   88.628463] IP: [<f8bc90f7>] :isight_firmware:isight_firmware_load+0xf2/0x1c3
> [   88.628474] *pde = 375a8067 *pte = 00000000
> [   88.628483] Oops: 0000 [#1] SMP
> [   88.628490] Modules linked in: isight_firmware(+) hci_usb
> cpufreq_ondemand cpufreq_performance cpufreq_powersave rfcomm hidp
> l2cap bluetooth fan ipmi_watchdog ipmi_msghandler uvcvideo uinput
> wlan_tkip ieee80211_crypt_tkip ieee80211_crypt arpt_mangle
> arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
> iptable_mangle iptable_filter ip_tables x_tables i2c_i810 i2c_algo_bit
> coretemp eeprom acpi_cpufreq fglrx(P) agpgart appletouch joydev
> applesmc wlan_scan_sta firewire_ohci firewire_core ath_rate_sample
> snd_hda_intel snd_pcm ath_pci ohci1394 snd_timer snd_page_alloc
> snd_hwdep wlan ieee1394 ath_hal(P) evdev ehci_hcd uhci_hcd pata_acpi
> button thermal video processor
> [   88.628581]
> [   88.628587] Pid: 2568, comm: modprobe Tainted: P
> (2.6.26-rc4-00173-gd53a1a8 #6)

there's the kernel version

> [   88.628593] EIP: 0060:[<f8bc90f7>] EFLAGS: 00010207 CPU: 0
> [   88.628600] EIP is at isight_firmware_load+0xf2/0x1c3 [isight_firmware]
> [   88.628606] EAX: f2120150 EBX: 00000032 ECX: 0000000a EDX: c17f5638
> [   88.628610] ESI: f8dbf000 EDI: f2120158 EBP: f2111dac ESP: f2111d7c
> [   88.628615]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   88.628621] Process modprobe (pid: 2568, ti=f2110000 task=f5495380
> task.ti=f2110000)
> [   88.628625] Stack: 00003def f2120150 f5728c90 00000578 f8dbeff8
> c02b3854 f5728ff8 00006743
> [   88.628640]        f492c700 f571ef50 f8bc97c4 f8bc9750 f2111dc8
> c02b42d4 f5728c90 00000000
> [   88.628654]        f571ef6c 00000000 f8bc9790 f2111ddc c026e58e
> f571ef6c f571f054 f8bc9790
> [   88.628667] Call Trace:
> [   88.628676]  [<c02b3854>] ? usb_autopm_do_device+0xb1/0xb9
> [   88.628694]  [<c02b42d4>] ? usb_probe_interface+0xc0/0xee
> [   88.628707]  [<c026e58e>] ? driver_probe_device+0xa0/0x11b
> [   88.628720]  [<c026e646>] ? __driver_attach+0x3d/0x5f
> [   88.628731]  [<c026ddea>] ? bus_for_each_dev+0x3b/0x5d
> [   88.628744]  [<c026e425>] ? driver_attach+0x14/0x16
> [   88.628753]  [<c026e609>] ? __driver_attach+0x0/0x5f
> [   88.628762]  [<c026e180>] ? bus_add_driver+0x9a/0x1aa
> [   88.628775]  [<c026e7c3>] ? driver_register+0x71/0xcd
> [   88.628783]  [<c016427e>] ? __vunmap+0x93/0x9b
> [   88.628797]  [<c02b3f01>] ? usb_register_driver+0x71/0xcb
> [   88.628808]  [<f8be6017>] ? isight_firmware_init+0x17/0x19 [isight_firmware]
> [   88.628818]  [<c0140d4a>] ? sys_init_module+0x163c/0x17ea
> [   88.628835]  [<c020fe2e>] ? prio_tree_insert+0x1c/0x1cb
> [   88.628854]  [<c0160f21>] ? vma_link+0xc0/0xce
> [   88.628866]  [<c0161597>] ? mmap_region+0x2ca/0x377
> [   88.628877]  [<c016ec1c>] ? __kmalloc+0x0/0xdb
> [   88.628905]  [<c01038fa>] ? syscall_call+0x7/0xb
> [   88.628925]  =======================
> [   88.628928] Code: e9 8e 00 00 00 83 7d d0 32 bb 32 00 00 00 0f 4e
> 5d d0 ba d0 00 00 00 89 d8 e8 32 5b 5a c7 89 d9 8b 75 e0 c1 e9 02 89
> 45 d4 89 c7 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 8b 45 d8 b9 a0 00 00 00
> 8b 10
> [   88.629002] EIP: [<f8bc90f7>] isight_firmware_load+0xf2/0x1c3
> [isight_firmware] SS:ESP 0068:f2111d7c
> [   88.629015] ---[ end trace 0d6c893753a1cd98 ]---
> 
> like I said yesterday there was no problem at all, maybe because the
> system was warm from being on all day.
> after renaming isight_firmware.ko so I can boot up the system runs fine.
> hope this helps in the kernel development.
> regards;

I get this:

y:/usr/src/25> AFLAGS=--32 /bin/sh scripts/decodecode < ~/x
Code: e9 8e 00 00 00 83 7d d0 32 bb 32 00 00 00 0f 4e 5d d0 ba d0 00 00 00 89 d8 e8 32 5b 5a c7 89 d9 8b 75 e0 c1 e9 02 89 45 d4 89 c7 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 8b 45 d8 b9 a0 00 00 00 8b 10

/tmp/tmp.QXepc15200.o:     file format elf32-i386

Disassembly of section .text:

00000000 <.text>:
   0:   e9 8e 00 00 00          jmp    0x93
   5:   83 7d d0 32             cmpl   $0x32,-0x30(%ebp)
   9:   bb 32 00 00 00          mov    $0x32,%ebx
   e:   0f 4e 5d d0             cmovle -0x30(%ebp),%ebx
  12:   ba d0 00 00 00          mov    $0xd0,%edx
  17:   89 d8                   mov    %ebx,%eax
  19:   e8 32 5b 5a c7          call   0xc75a5b50
  1e:   89 d9                   mov    %ebx,%ecx
  20:   8b 75 e0                mov    -0x20(%ebp),%esi
  23:   c1 e9 02                shr    $0x2,%ecx
  26:   89 45 d4                mov    %eax,-0x2c(%ebp)
  29:   89 c7                   mov    %eax,%edi

/tmp/tmp.QXepc15200.o:     file format elf32-i386

Disassembly of section .text:

00000000 <.text>:
   0:   f3 a5                   rep movsl %ds:(%esi),%es:(%edi)
   2:   89 d9                   mov    %ebx,%ecx
   4:   83 e1 03                and    $0x3,%ecx
   7:   74 02                   je     0xb
   9:   f3 a4                   rep movsb %ds:(%esi),%es:(%edi)
   b:   8b 45 d8                mov    -0x28(%ebp),%eax
   e:   b9 a0 00 00 00          mov    $0xa0,%ecx
  13:   8b 10                   mov    (%eax),%edx


So at a guess I'd say that firnware->data is garbage (esi=f8dbf000).
But I didn't try very hard.

btw,

: static int isight_firmware_load(struct usb_interface *intf,
: 				const struct usb_device_id *id)
: {
: 	struct usb_device *dev = interface_to_usbdev(intf);
: 	int llen, len, req, ret = 0;
: 	const struct firmware *firmware;
: 	unsigned char *buf;
: 	unsigned char data[4];
: 	const u8 *ptr;
: 
: 	if (request_firmware(&firmware, "isight.fw", &dev->dev) != 0) {
: 		printk(KERN_ERR "Unable to load isight firmware\n");
: 		return -ENODEV;
: 	}
: 
: 	ptr = firmware->data;
:
: 	if (usb_control_msg
: 	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, "\1", 1,
: 	     300) != 1) {
: 		printk(KERN_ERR
: 		       "Failed to initialise isight firmware loader\n");
: 		ret = -ENODEV;
: 		goto out;
: 	}
: 
: 	while (1) {
: 		memcpy(data, ptr, 4);
: 		len = (data[0] << 8 | data[1]);
: 		req = (data[2] << 8 | data[3]);
: 		ptr += 4;
: 
: 		if (len == 0x8001)
: 			break;	/* success */
: 		else if (len == 0)
: 			continue;

This looks like it can overrun the buffer and go oops if we were given
unexpected data.


: 		for (; len > 0; req += 50) {
: 			llen = len > 50 ? 50 : len;

min()

: 			len -= llen;
: 
: 			buf = kmalloc(llen, GFP_KERNEL);
: 			memcpy(buf, ptr, llen);
: 
: 			ptr += llen;
: 
: 			if (usb_control_msg
: 			    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, req, 0,
: 			     buf, llen, 300) != llen) {
: 				printk(KERN_ERR
: 				       "Failed to load isight firmware\n");
: 				kfree(buf);
: 				ret = -ENODEV;
: 				goto out;
: 			}
: 
: 			kfree(buf);

Could just kmalloc a single 50-byte buffer and then reuse it multiple times.

: 		}
: 	}
: 	if (usb_control_msg
: 	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, "\0", 1,
: 	     300) != 1) {
: 		printk(KERN_ERR "isight firmware loading completion failed\n");
: 		ret = -ENODEV;
: 	}
: out:
: 	release_firmware(firmware);
: 	return ret;
: }

