Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYHTSgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYHTSgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYHTSgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:36:11 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48800 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYHTSgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:36:10 -0400
Subject: Re: WARNING: at drivers/base/power/main.c:82
	device_pm_add+0x53/0xbd()
From: Marcel Holtmann <marcel@holtmann.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30808201120s568efcaasb31ec741405fad4a@mail.gmail.com>
References: <dd18b0c30808201120s568efcaasb31ec741405fad4a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 20:36:15 +0200
Message-Id: <1219257375.7591.367.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

> I't seems I'm receiving this message
> upon wakeup from suspend:
> 
> [  544.200039] ------------[ cut here ]------------
> [  544.200039] WARNING: at drivers/base/power/main.c:82
> device_pm_add+0x53/0xbd()
> [  544.200039] Modules linked in: vboxdrv wlan_scan_sta
> ath_rate_sample ath_pci wlan ath_hal(P) usb_storage fglrx(P) agpgart
> btusb cpufreq_ondemand cpufreq_performance cpufreq_powersave
> acpi_cpufreq speedstep_lib rfcomm hidp l2cap bluetooth fan battery
> applesmc uvcvideo joydev firewire_ohci firewire_core appletouch
> isight_firmware snd_hda_intel snd_pcm snd_timer ohci1394
> snd_page_alloc ieee1394 snd_hwdep thermal evdev pata_acpi ehci_hcd
> uhci_hcd ac processor video button sbshc
> [  544.200039] Pid: 4590, comm: bash Tainted: P
> 2.6.27-rc3-00632-g1bbe44f #11
> [  544.200039]  [<c01236ea>] warn_on_slowpath+0x41/0x65
> [  544.200039]  [<c021bb00>] ? spin_bug+0x47/0xbd
> [  544.200039]  [<c021bbea>] ? _raw_spin_unlock+0x74/0x78
> [  544.200039]  [<c039b73a>] ? _spin_unlock+0x8/0xa
> [  544.200039]  [<c01a9d23>] ? sysfs_addrm_finish+0x16/0x1d1
> [  544.200039]  [<c01a9533>] ? sysfs_add_file_mode+0x52/0x71
> [  544.200039]  [<c013c8c4>] ? debug_mutex_add_waiter+0x14/0x4a
> [  544.200039]  [<c039a856>] ? __mutex_lock_slowpath+0x1cd/0x1d5
> [  544.200039]  [<c01240d4>] ? printk+0x15/0x17
> [  544.200039]  [<c0286f6e>] device_pm_add+0x53/0xbd
> [  544.200039]  [<c02827d4>] device_add+0x35c/0x4cc
> [  544.200039]  [<c0282956>] device_register+0x12/0x15
> [  544.200039]  [<f8c87330>] hci_register_sysfs+0x4e/0x5b [bluetooth]
> [  544.200039]  [<f8c83218>] hci_register_dev+0x2a0/0x2c3 [bluetooth]
> [  544.200039]  [<f8caed5c>] btusb_probe+0x39a/0x3cc [btusb]
> [  544.200039]  [<c02ce660>] usb_probe_interface+0xbd/0xf1
> [  544.200039]  [<c02840a4>] driver_probe_device+0xb8/0x133
> [  544.200039]  [<c028417e>] ? __device_attach+0x0/0xa
> [  544.200039]  [<c0284186>] __device_attach+0x8/0xa
> [  544.200039]  [<c028368d>] bus_for_each_drv+0x39/0x64
> [  544.200039]  [<c02841f8>] device_attach+0x51/0x65
> [  544.200039]  [<c028417e>] ? __device_attach+0x0/0xa
> [  544.200039]  [<c02ce0ef>] usb_rebind_intf+0x2a/0x55
> [  544.200039]  [<c02ce187>] do_unbind_rebind+0x50/0x5e
> [  544.200039]  [<c02ce1d8>] usb_external_resume_device+0x43/0x55
> [  544.200039]  [<c02ce20a>] usb_resume+0x20/0x26
> [  544.200039]  [<c0286b7a>] device_resume+0x8b/0x303
> [  544.200039]  [<c01439e9>] suspend_devices_and_enter+0xea/0x126
> [  544.200039]  [<c0143b55>] enter_state+0xe5/0x136
> [  544.200039]  [<c0143c3c>] state_store+0x96/0xaa
> [  544.200039]  [<c0143ba6>] ? state_store+0x0/0xaa
> [  544.200039]  [<c0214435>] kobj_attr_store+0x1a/0x22
> [  544.200039]  [<c01a929f>] sysfs_write_file+0xa8/0xda
> [  544.200039]  [<c01a91f7>] ? sysfs_write_file+0x0/0xda
> [  544.200039]  [<c0175104>] vfs_write+0x8c/0x108
> [  544.200039]  [<c017555d>] sys_write+0x3b/0x60
> [  544.200039]  [<c01030b6>] syscall_call+0x7/0xb
> [  544.200039]  [<c0390000>] ? quirk_intel_irqbalance+0x67/0xc6
> [  544.200039]  =======================
> [  544.200039] ---[ end trace 858fabc3359085d2 ]---
> [  544.200039] PM: Device 4-1 failed to resume: error -19
> [  544.200039] Restarting tasks ... <6>usb 4-1: USB disconnect, address 3
> [  544.210017] done.
> [  544.240024] type=1701 audit(1219255439.181:15): auid=4294967295
> uid=0 gid=0 ses=4294967295 subj=system_u:system_r:bluetooth_t pid=3063
> comm="hcid" sig=6
> [  544.800224] usb 4-1: new full speed USB device using uhci_hcd and address 4
> [  544.807405] evdev.c(EVIOCGBIT): Suspicious buffer size 511,
> limiting output to 64 bytes. See
> http://userweb.kernel.org/~dtor/eviocgbit-bug.html
> [  544.990682] usb 4-1: configuration #1 chosen from 1 choice
> [  545.010741] input: HID 05ac:1000 as /class/input/input16
> [  545.022783] input: USB HID v1.11 Keyboard [HID 05ac:1000] on
> usb-0000:00:1d.3-1
> [  545.040255] input: HID 05ac:1000 as /class/input/input17
> [  545.042653] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> 
> Doesn't seem harmful just a warning.

it is one of these combo HID/Bluetooth device. What hardware are you
actually using?

Regards

Marcel


