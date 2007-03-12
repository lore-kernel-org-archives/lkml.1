Return-Path: <linux-kernel-owner+w=401wt.eu-S1030320AbXCLO44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320AbXCLO44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030283AbXCLO4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:56:55 -0400
Received: from rtr.ca ([64.26.128.89]:4525 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030309AbXCLO4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:56:42 -0400
Message-ID: <45F56A2D.9010808@rtr.ca>
Date: Mon, 12 Mar 2007 10:56:45 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca>
In-Reply-To: <45EB9DC6.8010403@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Still no improvement on the b0rken usb-serial resume support in -rc*.

Today I got this ooops on resume from RAM.
Slightly tainted kernel this time (vmware), but not previously
on similar crashes.  I cannot yet get it to "crash on demaind",
so you'll just have to live with it this time.

All USB was dead until after a reboot this time.

pl2303 5-6.3:1.0: PM: resume from 2, parent 5-6.3 still 2
 usbdev5.23_ep81: PM: resume from 0, parent 5-6.3:1.0 still 2
 usbdev5.23_ep02: PM: resume from 0, parent 5-6.3:1.0 still 2
 usbdev5.23_ep83: PM: resume from 0, parent 5-6.3:1.0 still 2
 usbdev5.23: PM: resume from 0, parent 5-6.3 still 2
usb 5-6.4: PM: resume from 2, parent 5-6 still 2
 usbdev5.24_ep00: PM: resume from 0, parent 5-6.4 still 2
usbhid 5-6.4:1.0: PM: resume from 2, parent 5-6.4 still 2
 usbdev5.24_ep81: PM: resume from 0, parent 5-6.4:1.0 still 2
 usbdev5.24: PM: resume from 0, parent 5-6.4 still 2
Restarting tasks ... done.
ata1.00: configured for UDMA/100
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
usb 5-6: USB disconnect, address 22
usb 5-6.3: USB disconnect, address 23
BUG: unable to handle kernel paging request at virtual address fffffffb
 printing eip:
c01823cb
*pde = 00002067
*pte = 00000000
Oops: 0000 [#1]
PREEMPT 
Modules linked in: hci_usb radeon drm vmnet(P) vmmon(P) nfsd exportfs lockd nfs_acl sunrpc acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_stats freq_table cpufreq_conservative ac fan button thermal video battery container processor rfcomm l2cap bluetooth cfq_iosched deflate zlib_deflate twofish twofish_common serpent blowfish des cbc ecb blkcipher aes xcbc sha256 sha1 crypto_null af_key af_packet sbp2 usbhid hid pl2303 usbserial pcmcia mousedev snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss ipw2200 snd_pcm ieee80211 ieee80211_crypt snd_timer ohci1394 psmouse firmware_class sdhci mmc_core yenta_socket rsrc_nonstatic ieee1394 serio_raw b44 mii pcmcia_core snd pcspkr soundcore ehci_hcd snd_page_alloc uhci_hcd ahci usbcore intel_agp agpgart sg sr_mod cdrom unix
CPU:    0
EIP:    0060:[<c01823cb>]    Tainted: P       VLI
EFLAGS: 00010286   (2.6.21-rc3-git4 #5)
EIP is at sysfs_hash_and_remove+0x18/0x111
eax: fffffff3   ebx: c030b3d4   ecx: 00000000   edx: fffffff3
esi: fffffff3   edi: fffffff3   ebp: f62af618   esp: f74e5dec
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process khubd (pid: 1955, ti=f74e4000 task=f74d6a50 task.ti=f74e4000)
Stack: c02d15d8 fffffff3 c0158595 c030b3d4 fffffff3 fffffff3 f62af618 c01843d9 
       c030b3c8 f411f8e0 c0184422 f411f878 00000001 f2ca4880 c02005ca f411f8e0 
       c01fba1f f411f878 00000001 f2ca4880 00000000 c01fba4e f2ca4880 f8a15d0e 
Call Trace:
 [<c0158595>] lookup_one_len+0x4d/0x5c
 [<c01843d9>] remove_files+0x15/0x1e
 [<c0184422>] sysfs_remove_group+0x40/0x56
 [<c02005ca>] device_pm_remove+0x1d/0x5a
 [<c01fba1f>] device_del+0x167/0x18e
 [<c01fba4e>] device_unregister+0x8/0x10
 [<f8a15d0e>] destroy_serial+0x80/0xcc [usbserial]
 [<f8a15c8e>] destroy_serial+0x0/0xcc [usbserial]
 [<c01ab1bd>] kref_put+0x5f/0x6e
 [<f8a157f7>] usb_serial_disconnect+0x81/0xaa [usbserial]
 [<c01ab1bd>] kref_put+0x5f/0x6e
 [<f88c7cc8>] usb_unbind_interface+0x2a/0x59 [usbcore]
 [<c01fd1a2>] __device_release_driver+0x6e/0x8b
 [<c01fd444>] device_release_driver+0x1d/0x32
 [<c01fcbd2>] bus_remove_device+0x71/0x81
 [<c01fb9ec>] device_del+0x134/0x18e
 [<f88c654c>] usb_disable_device+0x5c/0xbb [usbcore]
 [<f88c2fdb>] usb_disconnect+0x82/0x104 [usbcore]
 [<f88c2fc9>] usb_disconnect+0x70/0x104 [usbcore]
 [<f88c39c8>] hub_thread+0x30b/0x9db [usbcore]
 [<c027ce7a>] schedule+0x47c/0x51f
 [<c0126a84>] autoremove_wake_function+0x0/0x33
 [<f88c36bd>] hub_thread+0x0/0x9db [usbcore]
 [<c01269ba>] kthread+0x9b/0xbf
 [<c012691f>] kthread+0x0/0xbf
 [<c0104733>] kernel_thread_helper+0x7/0x10
 =======================
Code: 8b 40 08 a8 08 74 08 5b 5e 5f e9 6c ac 0f 00 5b 5e 5f c3 55 57 56 53 83 ec 0c 85 c0 89 44 24 04 89 14 24 0f 84 ed 00 00 00 89 c2 <8b> 40 08 85 c0 0f 84 e0 00 00 00 8b 52 50 83 c0 68 89 54 24 08 
EIP: [<c01823cb>] sysfs_hash_and_remove+0x18/0x111 SS:ESP 0068:f74e5dec
