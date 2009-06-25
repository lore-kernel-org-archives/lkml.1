Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZFYKZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZFYKZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZFYKZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:25:06 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48818 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZFYKZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=lN/+iUT0pd4N3CietQEZEPr4xbkin/IDozXXR0AW2C61xQBoEZIua8NktlycNWdmGA
         q6vnh9dhHm1CayulMxbgtS2LByZM/GMbMkGxWir5yURLq1+P4nWYwhYMYzrALAzbDA9K
         A8FIPCs/6rnNWCEAqVKxEa5LAZ9YCe8yerZRg=
MIME-Version: 1.0
Date: Thu, 25 Jun 2009 12:25:05 +0200
Message-ID: <5a4c581d0906250325q1dd9ca67na9a8c7ecbffe4897@mail.gmail.com>
Subject: [2.6.31-rc1] oops in acpi_get_pci_dev
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On boot:

[snip]

kernel: ricoh-mmc: Controller is now disabled.
kernel: firewire_ohci 0000:03:01.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
kernel: BUG: unable to handle kernel NULL pointer dereference at
0000000000000018
kernel: IP: [<ffffffff8121b556>] acpi_get_pci_dev+0x113/0x179
kernel: PGD 11b0f1067 PUD 11b0e5067 PMD 0
kernel: Oops: 0000 [#1] SMP
kernel: last sysfs file: /sys/devices/virtual/misc/rfkill/dev
kernel: CPU 0
kernel: Modules linked in: dell_laptop(+) snd firewire_ohci(+)
ricoh_mmc firewire_core soundcore sdhci_pci snd_page_alloc rfkill
i2c_i801 sdhci pcspkr mmc_core joydev dcdbas i2c_core video output
crc_itu_t battery ac [last unloaded: scsi_wait_scan]
kernel: Pid: 1258, comm: modprobe Not tainted 2.6.31-rc1 #1 Latitude
E6400
kernel: RIP: 0010:[<ffffffff8121b556>]  [<ffffffff8121b556>]
acpi_get_pci_dev+0x113/0x179
kernel: RSP: 0018:ffff88011b0f3bf8  EFLAGS: 00010287
kernel: RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000824bb959
kernel: RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffffffff815a0f74
kernel: RBP: ffff88011b0f3c68 R08: ffff88011b7396f0 R09: 0000000000000000
kernel: R10: 0000000000000052 R11: ffff88011b176338 R12: ffff88011b427560
kernel: R13: ffff88011f9a4000 R14: ffff88011f814d60 R15: ffff88011f814d20
kernel: FS:  00007f715ffc06f0(0000) GS:ffff88002801f000(0000)
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: 0000000000000018 CR3: 000000011b0e6000 CR4: 00000000000006f0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process modprobe (pid: 1258, threadinfo ffff88011b0f2000, task
ffff88011b7396f0)
kernel: Stack:
kernel: ffff88011b0f3c38 ffff88011b0f3c08 ffff88011b427560 ffff88011b427e60
kernel: <0> ffff88011b0f3c68 ffff88011f812020 0000000000010000 00000000824bb959
kernel: <0> ffff88011b0f3c68 ffff88011f814d60 ffff88011b0f3de8 ffff88011f814d20
kernel: Call Trace:
kernel: [<ffffffff8121ef98>] find_video+0x62/0xa2
kernel: [<ffffffff81233240>] acpi_ns_walk_namespace+0xc4/0x14d
kernel: [<ffffffff8121ef36>] ? find_video+0x0/0xa2
kernel: [<ffffffff8121ef36>] ? find_video+0x0/0xa2
kernel: [<ffffffff81230b0a>] acpi_walk_namespace+0x82/0xd0
kernel: [<ffffffff8121ecdd>] acpi_video_get_capabilities+0x61/0xe2
kernel: [<ffffffffa000a060>] ? dell_send_request+0x60/0x82 [dell_laptop]
kernel: [<ffffffff8121ede9>] acpi_video_backlight_support+0x27/0x64
kernel: [<ffffffffa001c1db>] dell_init+0x1db/0x329 [dell_laptop]
kernel: [<ffffffff811d9db9>] ? __up_read+0x9c/0xbb
kernel: [<ffffffffa001c000>] ? dell_init+0x0/0x329 [dell_laptop]
kernel: [<ffffffff81009092>] do_one_initcall+0x65/0x153
kernel: [<ffffffff8106cf69>] ? __blocking_notifier_call_chain+0x63/0x83
kernel: [<ffffffff8107ed7e>] sys_init_module+0xe0/0x22e
kernel: [<ffffffff8100be2b>] system_call_fastpath+0x16/0x1b
kernel: Code: 75 4a 48 8b 45 c0 4c 89 ef 48 89 c6 83 e0 07 48 c1 ee 10
c1 e6 03 81 e6 f8 00 00 00 09 c6 e8 29 3e fd ff 4d 39 f7 48 89 c3 74
21 <4c> 8b 68 18 48 89 c7 e8 d0 34 fd ff 4d 8b 24 24 49 8b 04 24 4c
kernel: RIP  [<ffffffff8121b556>] acpi_get_pci_dev+0x113/0x179
kernel: RSP <ffff88011b0f3bf8>
kernel: CR2: 0000000000000018
kernel: ---[ end trace 96ab648bd362f7da ]---


Dell Latitude E6400 x86_64 SMP with Fedora 11 userspace.

Box continues working after Oops, but locks up when exiting X session.

2.6.30-git22 works fine (probably because acpi_get_pci_dev is
introduced in -rc1)


Thanks,

--alessandro

 "And if a God will lay to rest anywhere we want to go
  In your house I long to be, room by room, patiently"

   (Audioslave, "Like A Stone")
