Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXKFFDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXKFFDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 00:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbXKFFDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 00:03:38 -0500
Received: from helios.cs.csubak.edu ([136.168.201.112]:42384 "EHLO
	helios.cs.csubak.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbXKFFDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 00:03:36 -0500
Date: Mon, 5 Nov 2007 21:03:08 -0800 (PST)
From: David Griffith <dgriffi@cs.csubak.edu>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vitaliy Ivanov <vitalivanov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Clemens Ladisch <clemens@ladisch.de>,
       linux-usb-devel@lists.sourceforge.net, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: fixing usb-midi device support
In-Reply-To: <20071105192153.2bbae10f.akpm@linux-foundation.org>
Message-ID: <Pine.GSO.4.55.0711052029180.16561@helios.cs.csubak.edu>
References: <Pine.GSO.4.55.0710311423530.10148@helios.cs.csubak.edu>
 <35fbaa3e0711010346y5963d929w5054fabad1569d66@mail.gmail.com>
 <Pine.GSO.4.55.0711011018360.13024@helios.cs.csubak.edu>
 <20071105192153.2bbae10f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Spam-Score: -0.1 (/)
X-Spam-Report: ---- Start Spam Filter Report
	Filter Analysis score is (-0.1/5.0)
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-0.1 AWL                    AWL: From: address is in the auto white-list
	---- End Spam Filter results
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Andrew Morton wrote:

> On Thu, 1 Nov 2007 10:20:24 -0700 (PDT) David Griffith <dgriffi@cs.csubak.edu> wrote:
>
> > On Thu, 1 Nov 2007, Vitaliy Ivanov wrote:
>
> Lots of cc's added.
>
> > > David,
> > >
> > > On 10/31/07, David Griffith <dgriffi@cs.csubak.edu> wrote:
> > > >
> > > > I have a MOTU Fastlane and an Emu Xmidi 2x2 USB midi interfaces.  The Emu
> > > > unit works fine with current kernels.  The MOTU unit won't work with
> > > > kernels newer than 2.6.17.
>
> It's a regression.

> > The oops is still present.  I was hoping that the patch I found and lost
> > would help me understand what was going on.
> >
>
> Are you able to send a copy of the oops output?

Yes.

To refresh everyone, I got this by doing "amidi -d -p virtual" in
one xterm.  Then I started MIOS Studio
(http://www.midibox.org/mios_studio/) and patched the internal in port to
all available out ports including the virtual one just created.  Remove
the MIDI interface, then quit MIOS Studio.  An oops will immediately
occur.

Aug 20 00:28:34 zaphod kernel: [693764.415579] usb 3-1: new full speed USB device using uhci_hcd and address 8
Aug 20 00:28:34 zaphod kernel: [693764.592629] usb 3-1: configuration #1 chosen from 1 choice
Aug 20 00:28:34 zaphod kernel: [693764.596652] usb_submit_urb: -22
Aug 20 00:28:34 zaphod kernel: [693764.596664] usb_submit_urb: -22
Aug 20 00:28:34 zaphod kernel: [693764.597322] kobject_add failed for usbdev3.8_ep81 with -EEXIST, don't try to register things with the same name in the same directory.
Aug 20 00:28:34 zaphod kernel: [693764.597370]  [kobject_add+281/416] kobject_add+0x119/0x1a0
Aug 20 00:28:34 zaphod kernel: [693764.597396]  [device_add+183/1328] device_add+0xb7/0x530
Aug 20 00:28:34 zaphod kernel: [693764.597417]  [kobject_get+15/32] kobject_get+0xf/0x20
Aug 20 00:28:34 zaphod kernel: [693764.597424]  [kobject_init+43/64] kobject_init+0x2b/0x40
Aug 20 00:28:34 zaphod kernel: [693764.597437]  [<e08844aa>] usb_create_ep_files+0x17a/0x2f0 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.597504]  [sysfs_create_group+143/176] sysfs_create_group+0x8f/0xb0
Aug 20 00:28:34 zaphod kernel: [693764.597525]  [<e0883eec>] usb_create_sysfs_intf_files+0x7c/0x110 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.597561]  [<e087ffa1>] usb_set_configuration+0x401/0x4d0 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.597608]  [<e0887a84>] generic_probe+0x164/0x230 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.597655]  [<e08818d3>] usb_probe_device+0x33/0x40 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.597678]  [really_probe+102/400] really_probe+0x66/0x190
Aug 20 00:28:34 zaphod kernel: [693764.597688]  [driver_probe_device+73/192] driver_probe_device+0x49/0xc0
Aug 20 00:28:34 zaphod kernel: [693764.597696]  [klist_next+83/160] klist_next+0x53/0xa0
Aug 20 00:28:34 zaphod kernel: [693764.597711]  [bus_for_each_drv+68/112] bus_for_each_drv+0x44/0x70
Aug 20 00:28:34 zaphod kernel: [693764.597727]  [device_attach+144/160] device_attach+0x90/0xa0
Aug 20 00:28:34 zaphod kernel: [693764.597734]  [__device_attach+0/16] __device_attach+0x0/0x10
Aug 20 00:28:34 zaphod kernel: [693764.597743]  [bus_attach_device+38/96] bus_attach_device+0x26/0x60
Aug 20 00:28:34 zaphod kernel: [693764.597753]  [device_add+1109/1328] device_add+0x455/0x530
Aug 20 00:28:34 zaphod kernel: [693764.597778]  [<e087b462>] __usb_new_device+0x92/0x120 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.597813]  [<e087c81e>] hub_thread+0x78e/0xc20 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.597864]  [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
Aug 20 00:28:34 zaphod kernel: [693764.597886]  [<e087c090>] hub_thread+0x0/0xc20 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.597909]  [kthread+186/240] kthread+0xba/0xf0
Aug 20 00:28:34 zaphod kernel: [693764.597918]  [kthread+0/240] kthread+0x0/0xf0
Aug 20 00:28:34 zaphod kernel: [693764.597927]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Aug 20 00:28:34 zaphod kernel: [693764.597943]  =======================
Aug 20 00:28:34 zaphod kernel: [693764.597956] kobject_add failed for usbdev3.8_ep02 with -EEXIST, don't try to register things with the same name in the same directory.
Aug 20 00:28:34 zaphod kernel: [693764.597964]  [kobject_add+281/416] kobject_add+0x119/0x1a0
Aug 20 00:28:34 zaphod kernel: [693764.597980]  [device_add+183/1328] device_add+0xb7/0x530
Aug 20 00:28:34 zaphod kernel: [693764.597994]  [kobject_get+15/32] kobject_get+0xf/0x20
Aug 20 00:28:34 zaphod kernel: [693764.598001]  [kobject_init+43/64] kobject_init+0x2b/0x40
Aug 20 00:28:34 zaphod kernel: [693764.598013]  [<e08844aa>] usb_create_ep_files+0x17a/0x2f0 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598050]  [sysfs_create_group+143/176] sysfs_create_group+0x8f/0xb0
Aug 20 00:28:34 zaphod kernel: [693764.598065]  [<e0883eec>] usb_create_sysfs_intf_files+0x7c/0x110 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598100]  [<e087ffa1>] usb_set_configuration+0x401/0x4d0 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598146]  [<e0887a84>] generic_probe+0x164/0x230 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598191]  [<e08818d3>] usb_probe_device+0x33/0x40 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598215]  [really_probe+102/400] really_probe+0x66/0x190
Aug 20 00:28:34 zaphod kernel: [693764.598224]  [driver_probe_device+73/192] driver_probe_device+0x49/0xc0
Aug 20 00:28:34 zaphod kernel: [693764.598230]  [klist_next+83/160] klist_next+0x53/0xa0
Aug 20 00:28:34 zaphod kernel: [693764.598244]  [bus_for_each_drv+68/112] bus_for_each_drv+0x44/0x70
Aug 20 00:28:34 zaphod kernel: [693764.598259]  [device_attach+144/160] device_attach+0x90/0xa0
Aug 20 00:28:34 zaphod kernel: [693764.598266]  [__device_attach+0/16] __device_attach+0x0/0x10
Aug 20 00:28:34 zaphod kernel: [693764.598275]  [bus_attach_device+38/96] bus_attach_device+0x26/0x60
Aug 20 00:28:34 zaphod kernel: [693764.598284]  [device_add+1109/1328] device_add+0x455/0x530
Aug 20 00:28:34 zaphod kernel: [693764.598309]  [<e087b462>] __usb_new_device+0x92/0x120 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598344]  [<e087c81e>] hub_thread+0x78e/0xc20 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598395]  [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
Aug 20 00:28:34 zaphod kernel: [693764.598412]  [<e087c090>] hub_thread+0x0/0xc20 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598453]  [kthread+186/240] kthread+0xba/0xf0
Aug 20 00:28:34 zaphod kernel: [693764.598462]  [kthread+0/240] kthread+0x0/0xf0
Aug 20 00:28:34 zaphod kernel: [693764.598471]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Aug 20 00:28:34 zaphod kernel: [693764.598484]  =======================
Aug 20 00:28:34 zaphod kernel: [693764.598494] kobject_add failed for usbdev3.8_ep83 with -EEXIST, don't try to register things with the same name in the same directory.
Aug 20 00:28:34 zaphod kernel: [693764.598501]  [kobject_add+281/416] kobject_add+0x119/0x1a0
Aug 20 00:28:34 zaphod kernel: [693764.598517]  [device_add+183/1328] device_add+0xb7/0x530
Aug 20 00:28:34 zaphod kernel: [693764.598531]  [kobject_get+15/32] kobject_get+0xf/0x20
Aug 20 00:28:34 zaphod kernel: [693764.598538]  [kobject_init+43/64] kobject_init+0x2b/0x40
Aug 20 00:28:34 zaphod kernel: [693764.598550]  [<e08844aa>] usb_create_ep_files+0x17a/0x2f0 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598587]  [sysfs_create_group+143/176] sysfs_create_group+0x8f/0xb0
Aug 20 00:28:34 zaphod kernel: [693764.598602]  [<e0883eec>] usb_create_sysfs_intf_files+0x7c/0x110 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598637]  [<e087ffa1>] usb_set_configuration+0x401/0x4d0 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598683]  [<e0887a84>] generic_probe+0x164/0x230 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598729]  [<e08818d3>] usb_probe_device+0x33/0x40 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598752]  [really_probe+102/400] really_probe+0x66/0x190
Aug 20 00:28:34 zaphod kernel: [693764.598761]  [driver_probe_device+73/192] driver_probe_device+0x49/0xc0
Aug 20 00:28:34 zaphod kernel: [693764.598768]  [klist_next+83/160] klist_next+0x53/0xa0
Aug 20 00:28:34 zaphod kernel: [693764.598781]  [bus_for_each_drv+68/112] bus_for_each_drv+0x44/0x70
Aug 20 00:28:34 zaphod kernel: [693764.598797]  [device_attach+144/160] device_attach+0x90/0xa0
Aug 20 00:28:34 zaphod kernel: [693764.598804]  [__device_attach+0/16] __device_attach+0x0/0x10
Aug 20 00:28:34 zaphod kernel: [693764.598813]  [bus_attach_device+38/96] bus_attach_device+0x26/0x60
Aug 20 00:28:34 zaphod kernel: [693764.598822]  [device_add+1109/1328] device_add+0x455/0x530
Aug 20 00:28:34 zaphod kernel: [693764.598846]  [<e087b462>] __usb_new_device+0x92/0x120 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598881]  [<e087c81e>] hub_thread+0x78e/0xc20 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598932]  [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
Aug 20 00:28:34 zaphod kernel: [693764.598950]  [<e087c090>] hub_thread+0x0/0xc20 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.598972]  [kthread+186/240] kthread+0xba/0xf0
Aug 20 00:28:34 zaphod kernel: [693764.598981]  [kthread+0/240] kthread+0x0/0xf0
Aug 20 00:28:34 zaphod kernel: [693764.598990]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Aug 20 00:28:34 zaphod kernel: [693764.599003]  =======================
Aug 20 00:28:34 zaphod kernel: [693764.599012] kobject_add failed for usbdev3.8_ep04 with -EEXIST, don't try to register things with the same name in the same directory.
Aug 20 00:28:34 zaphod kernel: [693764.599019]  [kobject_add+281/416] kobject_add+0x119/0x1a0
Aug 20 00:28:34 zaphod kernel: [693764.599036]  [device_add+183/1328] device_add+0xb7/0x530
Aug 20 00:28:34 zaphod kernel: [693764.599049]  [kobject_get+15/32] kobject_get+0xf/0x20
Aug 20 00:28:34 zaphod kernel: [693764.599056]  [kobject_init+43/64] kobject_init+0x2b/0x40
Aug 20 00:28:34 zaphod kernel: [693764.599069]  [<e08844aa>] usb_create_ep_files+0x17a/0x2f0 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.599116]  [sysfs_create_group+143/176] sysfs_create_group+0x8f/0xb0
Aug 20 00:28:34 zaphod kernel: [693764.599131]  [<e0883eec>] usb_create_sysfs_intf_files+0x7c/0x110 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.599166]  [<e087ffa1>] usb_set_configuration+0x401/0x4d0 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.599212]  [<e0887a84>] generic_probe+0x164/0x230 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.599258]  [<e08818d3>] usb_probe_device+0x33/0x40 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.599281]  [really_probe+102/400] really_probe+0x66/0x190
Aug 20 00:28:34 zaphod kernel: [693764.599290]  [driver_probe_device+73/192] driver_probe_device+0x49/0xc0
Aug 20 00:28:34 zaphod kernel: [693764.599297]  [klist_next+83/160] klist_next+0x53/0xa0
Aug 20 00:28:34 zaphod kernel: [693764.599310]  [bus_for_each_drv+68/112] bus_for_each_drv+0x44/0x70
Aug 20 00:28:34 zaphod kernel: [693764.599326]  [device_attach+144/160] device_attach+0x90/0xa0
Aug 20 00:28:34 zaphod kernel: [693764.599333]  [__device_attach+0/16] __device_attach+0x0/0x10
Aug 20 00:28:34 zaphod kernel: [693764.599342]  [bus_attach_device+38/96] bus_attach_device+0x26/0x60
Aug 20 00:28:34 zaphod kernel: [693764.599351]  [device_add+1109/1328] device_add+0x455/0x530
Aug 20 00:28:34 zaphod kernel: [693764.599376]  [<e087b462>] __usb_new_device+0x92/0x120 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.599411]  [<e087c81e>] hub_thread+0x78e/0xc20 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.599468]  [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
Aug 20 00:28:34 zaphod kernel: [693764.599485]  [<e087c090>] hub_thread+0x0/0xc20 [usbcore]
Aug 20 00:28:34 zaphod kernel: [693764.599508]  [kthread+186/240] kthread+0xba/0xf0
Aug 20 00:28:34 zaphod kernel: [693764.599533]  [kthread+0/240] kthread+0x0/0xf0
Aug 20 00:28:34 zaphod kernel: [693764.599543]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Aug 20 00:28:34 zaphod kernel: [693764.599556]  =======================
Aug 20 00:28:34 zaphod NetworkManager: <debug info>^I[1187594914.863131] nm_hal_device_added (): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial').
Aug 20 00:28:34 zaphod NetworkManager: <debug info>^I[1187594914.881075] nm_hal_device_added (): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_alsa_midi_0').
Aug 20 00:28:34 zaphod NetworkManager: <debug info>^I[1187594914.896564] nm_hal_device_added (): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_oss_midi_0').
Aug 20 00:28:34 zaphod NetworkManager: <debug info>^I[1187594914.945756] nm_hal_device_added (): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_oss_mixer__1').
Aug 20 00:28:35 zaphod NetworkManager: <debug info>^I[1187594915.058688] nm_hal_device_added (): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_alsa_control__1').
Aug 20 00:28:35 zaphod NetworkManager: <debug info>^I[1187594915.493426] nm_hal_device_added (): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_if1').
Aug 20 00:28:35 zaphod NetworkManager: <debug info>^I[1187594915.526018] nm_hal_device_added (): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_if0').
Aug 20 00:28:35 zaphod NetworkManager: <debug info>^I[1187594915.578271] nm_hal_device_added (): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_usbraw').
Aug 20 00:29:52 zaphod kernel: [693841.466852] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693841.706776] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693841.714781] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693841.749735] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693841.752149] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.422584] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.423950] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.426577] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.430582] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.431942] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.434598] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.435942] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.439946] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.445363] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.447945] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.494574] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.559909] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.589286] usb_submit_urb: -22
Aug 20 00:29:52 zaphod kernel: [693842.738506] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693842.799837] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693842.945744] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.018430] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.180980] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.210380] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.242364] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.274369] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.275691] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.318341] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.402325] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.442312] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.482295] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.594263] usb_submit_urb: -22
Aug 20 00:29:53 zaphod kernel: [693843.655585] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693843.788661] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693843.838208] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693843.839523] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693843.878190] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693843.882202] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.526022] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.530019] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.542009] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.546016] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.550005] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.583307] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.617992] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.619294] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.651282] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.735256] usb_submit_urb: -22
Aug 20 00:29:54 zaphod kernel: [693844.783245] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693844.929916] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693844.991182] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693845.121852] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693845.175128] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693845.309811] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693845.359074] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693845.489765] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693845.543020] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693845.673705] usb_submit_urb: -22
Aug 20 00:29:55 zaphod kernel: [693845.742961] usb_submit_urb: -22
Aug 20 00:29:56 zaphod kernel: [693845.961637] usb_submit_urb: -22
Aug 20 00:29:56 zaphod kernel: [693846.038871] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693942.826025] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693942.867522] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.008676] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.035470] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.069950] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.071459] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.107449] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.109939] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.111444] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.176738] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.221901] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.263407] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.271413] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.272684] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.353860] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.377857] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.379389] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.416612] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.417839] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.421843] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.533811] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.563327] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.565799] usb_submit_urb: -22
Aug 20 00:31:33 zaphod kernel: [693943.601790] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693943.697762] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693943.720452] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693943.721751] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693943.759281] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693943.761739] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693943.897701] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693943.955231] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.085641] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.088259] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.089643] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.125634] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.159167] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.160223] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.161621] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.273589] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.331127] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.453536] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.495081] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.496043] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.535072] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.536025] usb_submit_urb: -22
Aug 20 00:31:34 zaphod kernel: [693944.537507] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693965.843160] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693965.843188] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.067098] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.067111] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.119083] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.119102] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.124758] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.124773] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.129258] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.129273] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.165243] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.165262] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.217235] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.217250] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.291035] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.291055] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.393189] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.393204] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.452580] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.452599] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.457172] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.457187] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.521141] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.521156] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.577138] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.577154] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.646921] usb_submit_urb: -22
Aug 20 00:31:56 zaphod kernel: [693966.646937] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693966.769086] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693966.769101] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693966.825071] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693966.825086] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693966.969025] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693966.969040] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.054805] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.054823] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.160979] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.160994] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.206759] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.206777] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.336932] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.336948] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.392918] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.392934] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.528880] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.528895] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.584859] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.584878] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.708831] usb_submit_urb: -22
Aug 20 00:31:57 zaphod kernel: [693967.708846] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693967.766590] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693967.766607] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693967.894554] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693967.894571] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693967.984753] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693967.984773] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693968.622339] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693968.622360] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693968.623387] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693968.623400] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693968.628595] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693968.628611] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693968.632572] usb_submit_urb: -22
Aug 20 00:31:58 zaphod kernel: [693968.632587] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693968.974233] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693968.974251] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.030216] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.030235] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.182171] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.182189] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.224438] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.224454] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.366111] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.366127] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.422099] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.422118] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.558059] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.558077] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.598046] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.598066] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.742003] usb_submit_urb: -22
Aug 20 00:31:59 zaphod kernel: [693969.742021] usb_submit_urb: -22
Aug 20 00:32:00 zaphod kernel: [693969.817978] usb_submit_urb: -22
Aug 20 00:32:00 zaphod kernel: [693969.817996] usb_submit_urb: -22
Aug 20 00:33:02 zaphod dhcpd: DHCPREQUEST for 10.0.0.240 from 00:19:5b:4f:00:aa via eth0
Aug 20 00:33:02 zaphod dhcpd: DHCPACK on 10.0.0.240 to 00:19:5b:4f:00:aa via eth0
Aug 20 00:38:02 zaphod dhcpd: DHCPREQUEST for 10.0.0.240 from 00:19:5b:4f:00:aa via eth0
Aug 20 00:38:02 zaphod dhcpd: DHCPACK on 10.0.0.240 to 00:19:5b:4f:00:aa via eth0
Aug 20 00:41:07 zaphod kernel: [694516.720870] usb 3-1: USB disconnect, address 8
Aug 20 00:41:07 zaphod NetworkManager: <debug info>^I[1187595667.109799] nm_hal_device_removed (): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_oss_mixer__1').
Aug 20 00:41:07 zaphod NetworkManager: <debug info>^I[1187595667.116756] nm_hal_device_removed (): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_oss_midi_0').
Aug 20 00:41:07 zaphod NetworkManager: <debug info>^I[1187595667.131176] nm_hal_device_removed (): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_alsa_midi_0').
Aug 20 00:41:07 zaphod NetworkManager: <debug info>^I[1187595667.138222] nm_hal_device_removed (): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_alsa_control__1').
Aug 20 00:41:07 zaphod NetworkManager: <debug info>^I[1187595667.144661] nm_hal_device_removed (): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_if0').
Aug 20 00:41:07 zaphod NetworkManager: <debug info>^I[1187595667.152050] nm_hal_device_removed (): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_if1').
Aug 20 00:41:07 zaphod NetworkManager: <debug info>^I[1187595667.162733] nm_hal_device_removed (): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial_usbraw').
Aug 20 00:41:07 zaphod NetworkManager: <debug info>^I[1187595667.172718] nm_hal_device_removed (): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_7fd_1_noserial').
Aug 20 00:43:02 zaphod dhcpd: DHCPREQUEST for 10.0.0.240 from 00:19:5b:4f:00:aa via eth0
Aug 20 00:43:02 zaphod dhcpd: DHCPACK on 10.0.0.240 to 00:19:5b:4f:00:aa via eth0
Aug 20 00:43:40 zaphod named[4744]: Cleaned cache of 261 RRsets
Aug 20 00:43:40 zaphod named[4744]: USAGE 1187595820 1186901020 CPU=33.5181u/16.773s CHILDCPU=0u/0s
Aug 20 00:43:40 zaphod named[4744]: NSTATS 1187595820 1186901020 A=37194 SOA=31 PTR=721 MX=1 AAAA=26477 SRV=27
Aug 20 00:43:40 zaphod named[4744]: XSTATS 1187595820 1186901020 RR=80420 RNXD=4288 RFwdR=29712 RDupR=13 RFail=55 RFErr=3488 RErr=1 RAXFR=0 RLame=196 ROpts=0 SSysQ=4400 SAns=59084 SFwdQ=47930 SDupQ=28548 SErr=580 RQ=64451 RIQ=0 RFwdQ=47930 RDupQ=299 RTCP=9 SFwdR=29712 SFail=33 SFErr=0 SNaAns=55045 SNXD=3543 RUQ=0 RURQ=0 RUXFR=0 RUUpd=0
Aug 20 00:43:44 zaphod thttpd[4914]: up 694800 seconds, stats for 3600 seconds:
Aug 20 00:43:44 zaphod thttpd[4914]:   thttpd - 9 connections (0.0025/sec), 1 max simultaneous, 73767 bytes (20.4908/sec), 5 httpd_conns allocated
Aug 20 00:43:44 zaphod thttpd[4914]:   libhttpd - 73 strings allocated, 31425 bytes (430.479 bytes/str)
Aug 20 00:43:44 zaphod thttpd[4914]:   map cache - 40 allocated, 2 active (17961 bytes), 38 free; hash size: 1024; expire age: 1800
Aug 20 00:43:44 zaphod thttpd[4914]:   fdwatch - 6072 selects (1.68667/sec)
Aug 20 00:43:44 zaphod thttpd[4914]:   timers - 3 allocated, 3 active, 0 free
Aug 20 00:45:34 zaphod kernel: [694784.397469] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000128
Aug 20 00:45:34 zaphod kernel: [694784.397484]  printing eip:
Aug 20 00:45:34 zaphod kernel: [694784.397487] e0883480
Aug 20 00:45:34 zaphod kernel: [694784.397490] *pde = 1e91f067
Aug 20 00:45:34 zaphod kernel: [694784.397496] Oops: 0000 [#1]
Aug 20 00:45:34 zaphod kernel: [694784.397498] SMP
Aug 20 00:45:34 zaphod kernel: [694784.397503] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat sg sd_mod usb_storage libusual snd_rtctimer snd_usb_audio snd_usb_lib snd_hwdep isofs udf binfmt_misc rfcomm l2cap bluetooth ppdev cpufreq_stats cpufreq_conservative cpufreq_powersave cpufreq_ondemand freq_table cpufreq_userspace tc1100_wmi dev_acpi sony_acpi pcc_acpi button battery sbs container ac i2c_ec asus_acpi video backlight dock af_packet parport_pc lp parport fuse snd_ens1371 gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse via_ircc irda crc_ccitt i2c_viapro serio_raw snd soundcore snd_page_alloc pcspkr via_agp agpgart i2c_core shpchp pci_hotplug tsdev evdev ipv6 ext3 jbd mbcache ide_cd cdrom ide_disk ata_generic libata scsi_mod usbhid hid via82cxxx floppy via_rhine mii generic ehci_hcd uhci_hcd usbcore thermal processor fan fbcon tileblit font bitblit softcursor vesafb capabili
Aug 20 00:45:34 zaphod kernel: y commoncap
Aug 20 00:45:34 zaphod kernel: [694784.397606] CPU:    0
Aug 20 00:45:34 zaphod kernel: [694784.397608] EIP:    0060:[<e0883480>]    Not tainted VLI
Aug 20 00:45:34 zaphod kernel: [694784.397610] EFLAGS: 00010246   (2.6.20-16-generic #2)
Aug 20 00:45:34 zaphod kernel: [694784.397664] EIP is at hcd_buffer_free+0x20/0xa0 [usbcore]
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
Aug 20 00:45:35 zaphod kernel: [694784.398163] Code: 89 e0 bd ed ff ff ff eb a1 90 90 83 ec 0c 89 74 24 04 89 ce 8b 4c 24 10 85 f6 89 1c 24 89 d3 89 7c 24 08 89 c7 74 5e 8b 00 31 d2 <8b> 80 28 01 00 00 85 c0 74 5f 8d b6 00 00 00 00 3b 1c 95 ac 9c
Aug 20 00:45:35 zaphod kernel: [694784.398201] EIP: [<e0883480>] hcd_buffer_free+0x20/0xa0 [usbcore] SS:ESP 0068:dd865d6c
Aug 20 00:45:35 zaphod kernel: [694784.398228]  <1>Fixing recursive fault but reboot is needed!
Aug 20 00:48:03 zaphod dhcpd: DHCPREQUEST for 10.0.0.240 from 00:19:5b:4f:00:aa via eth0
Aug 20 00:48:03 zaphod dhcpd: DHCPACK on 10.0.0.240 to 00:19:5b:4f:00:aa via eth0
Aug 20 00:49:11 zaphod thttpd[4914]: spawned indexing process 5149 for directory 'sgate/files'

