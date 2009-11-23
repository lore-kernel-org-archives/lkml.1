Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZKWQAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZKWQAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZKWQAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:00:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45271 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZKWQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dgtdmO0RkFOduHqlz6LGmTdrftg3ZOCkhN98eWArx+3xw1IFwJ3RBMmy4GyU1q9ioN
         DQOXxa75xlF+K1lueQrYdEuwj9QTvk3C3Ixch9TtWw//J+WpUgxWiG+Z7eUxlgwYZUYy
         jCI/+2+jIhmmh540ubTgO4fSgw63WyzeiAcho=
MIME-Version: 1.0
Date: Mon, 23 Nov 2009 17:00:17 +0100
Message-ID: <40a4ed590911230800v4862b7b5ofc5c0c65be5dc794@mail.gmail.com>
Subject: ath9k Kernel Bug on eeePC 1101HA
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am on Linux zdavatz-eeepc 2.6.30.9 #13 SMP Mon Nov 23 18:49:51 CET
2009 i686 Intel(R) Atom(TM) CPU Z520 @ 1.33GHz GenuineIntel GNU/Linux

but with the latest ath9k driver from:

http://linuxwireless.org/en/users/Drivers/ath9k

I set everything depending on ath9k to M according to the Howto above.
Now when I restart my machine ath9k gives me:

[    6.427276] ------------[ cut here ]------------
[    6.427414] kernel BUG at kernel/workqueue.c:192!
[    6.427541] invalid opcode: 0000 [#1] SMP
[    6.427757] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/uevent
[    6.427954] Modules linked in: ath9k(+) ath9k_common mac80211
ath9k_hw ath cfg80211 rfkill_backport
[    6.428031]
[    6.428031] Pid: 1115, comm: modprobe Not tainted (2.6.30.9 #13) 1101HA
[    6.428031] EIP: 0060:[<c0134ce4>] EFLAGS: 00010217 CPU: 0
[    6.428031] EIP is at queue_work_on+0x1e/0x48
[    6.428031] EAX: f6aadd04 EBX: 00000000 ECX: f6aadd00 EDX: 00000000
[    6.428031] ESI: f7002380 EDI: f6418a18 EBP: f6ae7dcc ESP: f6ae7dc4
[    6.428031]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    6.428031] Process modprobe (pid: 1115, ti=f6ae6000 task=f6adb0c0
task.ti=f6ae6000)
[    6.428031] Stack:
[    6.428031]  f7002380 00000000 f6ae7dd8 c0134df1 f641927c f6ae7de0
c0134e03 f6ae7de8
[    6.428031]  f800bc4b f6ae7df0 f8562801 f6ae7e20 f86da7f4 f6418a18
f6420000 0000002b
[    6.428031]  f6420090 f6418220 00000000 00000008 f86e8dc0 f70f1800
f6418a18 f6ae7e94
[    6.428031] Call Trace:
[    6.428031]  [<c0134df1>] ? queue_work+0x15/0x18
[    6.428031]  [<c0134e03>] ? schedule_work+0xf/0x11
[    6.428031]  [<f800bc4b>] ?
backport_rfkill_resume_polling+0x20/0x22 [rfkill_backport]
[    6.428031]  [<f8562801>] ? wiphy_rfkill_start_polling+0x2f/0x31 [cfg80211]
[    6.428031]  [<f86da7f4>] ? ath_init_device+0xa02/0xa76 [ath9k]
[    6.428031]  [<f86e0469>] ? ath_pci_probe+0x1df/0x2c1 [ath9k]
[    6.428031]  [<c019f256>] ? iput+0x24/0x4e
[    6.428031]  [<c01cd46a>] ? sysfs_addrm_finish+0x48/0xc9
[    6.428031]  [<c01cd17f>] ? sysfs_add_one+0x14/0xbd
[    6.428031]  [<c0274404>] ? local_pci_probe+0xe/0x10
[    6.428031]  [<c0274e1e>] ? pci_device_probe+0x43/0x66
[    6.428031]  [<c02d929f>] ? really_probe+0x6a/0xf5
[    6.428031]  [<c02d9346>] ? driver_probe_device+0x1c/0x1f
[    6.428031]  [<c02d938c>] ? __driver_attach+0x43/0x5f
[    6.428031]  [<c02d8d2f>] ? bus_for_each_dev+0x3d/0x67
[    6.428031]  [<c02d9187>] ? driver_attach+0x14/0x16
[    6.428031]  [<c02d9349>] ? __driver_attach+0x0/0x5f
[    6.428031]  [<c02d87ae>] ? bus_add_driver+0xa2/0x1c9
[    6.428031]  [<c02d95d3>] ? driver_register+0x8b/0xeb
[    6.428031]  [<c022b003>] ? debugfs_create_file+0x3e/0x94
[    6.428031]  [<c0275149>] ? __pci_register_driver+0x38/0x93
[    6.428031]  [<f8530000>] ? ath9k_init+0x0/0x62 [ath9k]
[    6.428031]  [<f86e0562>] ? ath_pci_init+0x17/0x19 [ath9k]
[    6.428031]  [<f853003d>] ? ath9k_init+0x3d/0x62 [ath9k]
[    6.428031]  [<c0101139>] ? do_one_initcall+0x4c/0x131
[    6.428031]  [<c014861b>] ? sys_init_module+0x87/0x18b
[    6.428031]  [<c0102b45>] ? syscall_call+0x7/0xb
[    6.428031] Code: 04 8d 48 9e 77 c0 e8 a7 ff ff ff 5d c3 55 89 e5
56 89 d6 53 89 c3 f0 0f ba 29 00 19 c0 31 d2 85 c0 75 2c 8d 41 04 39
41 04 74 04 <0f> 0b eb fe 83 7e 10 00 89 ca 0f 45 1d 34 9f 77 c0 8b 06
03 04
[    6.428031] EIP: [<c0134ce4>] queue_work_on+0x1e/0x48 SS:ESP 0068:f6ae7dc4
[    6.439435] ---[ end trace a388dd29efbb57fd ]---

If I modprobe ath9k my modprobe just hangs an goes nowhere.

I also tested this on 2.6.32-rc8. There I get a shorter error-message:

zdavatz-eeepc ~ # /etc/init.d/net.wlan0 start
* Bringing up network interface wlan0...
SIOCSIFFLAGS: Unknown error 132
SIOCSIFFLAGS: Unknown error 132
                                           [!!]
* ERROR: net.wlan0 failed to sta

Thank you for your Feedback.

I am happy to test more code.

Best
Zeno
