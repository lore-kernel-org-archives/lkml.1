Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbXJKHiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbXJKHiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXJKHhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:37:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:22772 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbXJKHhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=fb77qcnfPxobnrjVyJTxSx5QMmhN50YPMvnhJNDRjhfdRNO1jqGtNlrfqkTaf6RQ1jQuzau0bMMU6SafyOhAn1fqkHPQWntdMcwswLgyx2NGgctS6Q3QV/RSdadoA7cGsChSyazbd0rE9n+RpkcP1G5VWf/IviXxmwgYnaxR+WU=
Message-ID: <470E1272.2030300@gmail.com>
Date: Thu, 11 Oct 2007 14:09:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: vojtech@suse.cz
CC: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc4: oops in evdev_disconnect
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after unplugging usb logitech mouse I got:

input: Logitech Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2:1.0/input/input10
input: USB HID v1.11 Mouse [Logitech Logitech USB Optical Mouse] on
usb-0000:00:1d.3-2
usb 5-2: USB disconnect, address 6
Unable to handle kernel paging request at 0000000000100100 RIP:
 [<ffffffff803b6ac4>] evdev_disconnect+0xb4/0xf0
PGD 3e960067 PUD 3e287067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: mac80211 cfg80211 stk11xx v4l2_extension videodev
v4l1_compat v4l2_common cpufreq_stats rfcomm l2cap hci_usb bluetooth
kvm_intel kvm acpi_cpufreq arc4 ecb blkcipher cryptomgr crypto_algapi
uhci_hcd ehci_hcd asus_laptop sr_mod cdrom battery
Pid: 191, comm: khubd Not tainted 2.6.23-rc4 #36
RIP: 0010:[<ffffffff803b6ac4>]  [<ffffffff803b6ac4>] evdev_disconnect+0xb4/0xf0
RSP: 0018:ffff81003fe47c80  EFLAGS: 00010216
RAX: 0000000000000000 RBX: 00000000000ffae8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff81003fe58e20 RDI: ffff810001e14d80
RBP: ffff81003e075888 R08: ffff81003fe46000 R09: ffff810001e12d68
R10: 0000000000000001 R11: ffffffff8046bd20 R12: ffff81003e075800
R13: ffff81003e075898 R14: 0000000000000000 R15: ffff81003d804c58
FS:  0000000000000000(0000) GS:ffff81003ffa3100(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000100100 CR3: 000000003f58d000 CR4: 00000000000026a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khubd (pid: 191, threadinfo ffff81003fe46000, task ffff81003fe58e20)
Stack:  ffffffff80309790 ffff810036bd0918 ffff810036bd0000 ffff810036bd0940
 ffff81003e075400 ffffffff803b3a6d ffff81003c031890 ffff8100271895c0
 ffff81003c031890 ffffffff803cbdd9 ffff810004c24030 ffff810004c24000
Call Trace:
 [<ffffffff80309790>] kobject_release+0x0/0x10
 [<ffffffff803b3a6d>] input_unregister_device+0x8d/0x130
 [<ffffffff803cbdd9>] hidinput_disconnect+0x49/0x70
 [<ffffffff803cfbaf>] hid_disconnect+0xff/0x120
 [<ffffffff803a1a2d>] usb_unbind_interface+0x6d/0xe0
 [<ffffffff8036dd82>] __device_release_driver+0x82/0xc0
 [<ffffffff8036e273>] device_release_driver+0x33/0x60
 [<ffffffff8036d53b>] bus_remove_device+0x5b/0x90
 [<ffffffff8036b6ab>] device_del+0x16b/0x2b0
 [<ffffffff8039e614>] usb_disable_device+0x94/0x120
 [<ffffffff80399b9b>] usb_disconnect+0xab/0x150
 [<ffffffff8039a408>] hub_thread+0x3e8/0xe20
 [<ffffffff804a10ab>] thread_return+0x0/0x5a5
 [<ffffffff8024cb40>] autoremove_wake_function+0x0/0x30
 [<ffffffff8039a020>] hub_thread+0x0/0xe20
 [<ffffffff8024c73b>] kthread+0x4b/0x80
 [<ffffffff8020cc38>] child_rip+0xa/0x12
 [<ffffffff8024c6f0>] kthread+0x0/0x80
 [<ffffffff8020cc2e>] child_rip+0x0/0x12


Code: 48 8b 83 18 06 00 00 0f 18 08 48 8d 83 18 06 00 00 48 39 e8
RIP  [<ffffffff803b6ac4>] evdev_disconnect+0xb4/0xf0
 RSP <ffff81003fe47c80>
CR2: 0000000000100100


It happened only once, so it's not easy to reproduce, is this known (fixed)?
 Any other info needed?

regards,
--js

