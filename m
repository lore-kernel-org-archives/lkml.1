Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbZJUFEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbZJUFEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 01:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZJUFEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 01:04:05 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:44130 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbZJUFED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 01:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dqN5qJXzygVKLrWpAmm1gbvrg/9HIsDOjHf0F5Ynt6xKpcMitjfIDBZnPzqWUUrmXz
         UaZ0YXJ/lwId10GBQt889acWvgA5hA+azRkqvOak2Hh/rRKOpbU1BsBKkw1ur0nCxzhQ
         MOKyaCifQa96TKxJvj3VziPWwtmA0HoJLBwD8=
MIME-Version: 1.0
Date: Wed, 21 Oct 2009 13:04:07 +0800
Message-ID: <df9815e70910202204q5a0593e1gd14b9d36c368861e@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference at 
	0000000000000004
From: Jike Song <albcamus@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not sure if this BUG was reported before. It happens on 2.6.32-rc5-11.

[arc@git ~]$ cat /proc/version
Linux version 2.6.32-rc5-00011-g2fdc246 (arc@git) (gcc version 4.4.0
20090506 (Red Hat 4.4.0-4) (GCC) ) #1 SMP Mon Oct 19 15:10:14 CST 2009

Part of dmesg is:

[drm:radeon_cp_cmdbuf_kms] *ERROR* invalid ioctl with kms radeon_cp_cmdbuf_kms
[drm:radeon_mem_init_heap_kms] *ERROR* invalid ioctl with kms
radeon_mem_init_heap_kms
BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [<ffffffffa0195352>] radeon_cs_parser_relocs+0x53/0x21f [radeon]
PGD 19b4ff067 PUD 19b4fe067 PMD 0
Oops: 0000 [#2] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/resource
CPU 0
Modules linked in: fuse ipv6 cpufreq_ondemand acpi_cpufreq freq_table
dm_multipath uinput snd_hda_codec_atihdmi dcdbas snd_hda_codec_realtek
joydev i2c_i801 serio_raw pcspkr radeon snd_hda_intel snd_hda_codec
ttm btusb bluetooth drm_kms_helper snd_hwdep drm snd_pcm snd_timer
firewire_ohci firewire_core i2c_algo_bit iTCO_wdt snd usb_storage
crc_itu_t i2c_core soundcore iTCO_vendor_support snd_page_alloc e1000e
ata_generic pata_acpi [last unloaded: microcode]
Pid: 3427, comm: Xorg Tainted: G      D    2.6.32-rc5-00011-g2fdc246
#1 Studio XPS 435MT
RIP: 0010:[<ffffffffa0195352>]  [<ffffffffa0195352>]
radeon_cs_parser_relocs+0x53/0x21f [radeon]
RSP: 0018:ffff88019b589c18  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88019b589c88 RCX: 0000000000000010
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88019b589c88
RBP: ffff88019b589c78 R08: ffff8801b6bdce70 R09: 0000000017284cf7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88019b589c88
R13: ffff8801b6bdd2b0 R14: ffff8801b6bdc090 R15: 0000000000000000
FS:  00007fd422ff67b0(0000) GS:ffff880032200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000004 CR3: 000000019b4a5000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process Xorg (pid: 3427, threadinfo ffff88019b588000, task ffff8801a0438000)
Stack:
 ffff8801b6bdc090 0000000017284cf7 ffff8801b65561b0 ffffffffa01949c2
<0> ffff88019d72f770 0000000017284cf7 ffff88019b589c78 0000000000000000
<0> ffff88019b589c88 ffff8801b6bdd2b0 ffff8801b6bdc090 ffff8801ad443c30
Call Trace:
 [<ffffffffa01949c2>] ? radeon_ib_get+0xae/0x1e8 [radeon]
 [<ffffffffa0195957>] radeon_cs_ioctl+0xcf/0x1b8 [radeon]
 [<ffffffffa0195888>] ? radeon_cs_ioctl+0x0/0x1b8 [radeon]
 [<ffffffffa00c6bdc>] drm_ioctl+0x23d/0x2fd [drm]
 [<ffffffff811d1034>] ? ext4_file_write+0xa0/0xc0
 [<ffffffff8115cc5c>] vfs_ioctl+0x7e/0xaa
 [<ffffffff8115d1d1>] do_vfs_ioctl+0x4aa/0x506
 [<ffffffff8114ce8c>] ? fsnotify_modify+0x7b/0x9a
 [<ffffffff81157535>] ? path_put+0x31/0x4c
 [<ffffffff8115d292>] sys_ioctl+0x65/0x9c
 [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
Code: 48 89 fb 48 8b 40 08 48 89 45 b0 44 8b 7f 54 31 c0 41 83 ff ff
0f 84 6f 01 00 00 4d 63 ff be 08 00 00 00 4d 6b ff 38 4c 03 7f 18 <41>
8b 7f 04 c1 ef 02 89 7b 2c 89 ff e8 44 ff ff ff 48 85 c0 48
RIP  [<ffffffffa0195352>] radeon_cs_parser_relocs+0x53/0x21f [radeon]
 RSP <ffff88019b589c18>
CR2: 0000000000000004
---[ end trace 4a156201f3e63636 ]---
[drm:drm_release] *ERROR* Device busy: 1
[drm:radeon_cp_cmdbuf_kms] *ERROR* invalid ioctl with kms radeon_cp_cmdbuf_kms
[drm:radeon_mem_init_heap_kms] *ERROR* invalid ioctl with kms
radeon_mem_init_heap_kms


I don't know what else to provide, so feel free to ask for more information.

-- 
Thanks,
Jike
