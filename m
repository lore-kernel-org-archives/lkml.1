Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbXFPUnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbXFPUnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 16:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXFPUnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 16:43:14 -0400
Received: from nn7.de ([85.214.94.156]:57672 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbXFPUnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 16:43:13 -0400
Subject: git-current: latest coretemp changes break s2ram
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: r.marek@assembler.cz, khali@linux-fr.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Jun 2007 22:43:05 +0200
Message-Id: <1182026585.4230.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this commit makes coretemp fail on my macbook pro.

1) rmmod oopses (see below)
2) it breaks s2ram

Soeren

commit 67f363b1f6a31cf5027a97372f64bcced4f05ba6
Author: Rudolf Marek <r.marek@assembler.cz>
Date:   Sun May 27 22:17:43 2007 +0200

    hwmon/coretemp: Add more safety checks

    Add detection of AE18 Errata of Core processor and warns
    users that the absolute readings might be wrong for Core2 processor.

    Signed-off-by: Rudolf Marek <r.marek@assembler.cz>
    Signed-off-by: Jean Delvare <khali@linux-fr.org>

[...]
PM: Adding info for platform:coretemp.0
coretemp coretemp.0: Errata AE18 not fixed, update BIOS or microcode of the CPU!
PM: Adding info for platform:coretemp.1
coretemp coretemp.1: Errata AE18 not fixed, update BIOS or microcode of the CPU!
[...]
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
f887c09f
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP 
Modules linked in: ohci1394 ieee1394 hfsplus binfmt_misc fuse eeprom coretemp applesmc hwmon snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm firewire_ohci firewire_core snd_timer i2c_i801 appletouch sky2 crc_itu_t snd soundcore snd_page_alloc intel_agp agpgart evdev
CPU:    0
EIP:    0060:[<f887c09f>]    Not tainted VLI
EFLAGS: 00010286   (2.6.22-rc4-sonne #20)
EIP is at coretemp_remove+0x1f/0x60 [coretemp]
eax: f78c2800   ebx: f78c2890   ecx: 00000000   edx: f887d23c
esi: f78c2808   edi: 00000000   ebp: c0496760   esp: f7c07ef4
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rmmod (pid: 2646, ti=f7c06000 task=dfc07440 task.ti=f7c06000)
Stack: f78c2808 f887d23c f78c2890 c02b714c c02b580b f78c2808 f78c2808 c02b5c5e 
       f78c2808 c02b50c0 00000000 c02b3508 f78c2800 f78c2800 f7a298f0 f7c06000 
       c02b73f0 f78c2800 f7a298b0 c02b7828 f7a298f0 f887c69a 00000000 f887d380 
Call Trace:
 [<c02b714c>] platform_drv_remove+0xc/0x10
 [<c02b580b>] __device_release_driver+0x6b/0xa0
 [<c02b5c5e>] device_release_driver+0x1e/0x40
 [<c02b50c0>] bus_remove_device+0x50/0x80
 [<c02b3508>] device_del+0x138/0x230
 [<c02b73f0>] platform_device_del+0x10/0x70
 [<c02b7828>] platform_device_unregister+0x8/0x10
 [<f887c69a>] coretemp_exit+0x3a/0x7d [coretemp]
 [<c0150528>] sys_delete_module+0x148/0x1b0
 [<c011f653>] do_page_fault+0x333/0x620
 [<c0169ab7>] do_munmap+0x197/0x1f0
 [<c01041a2>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 87 f8 5e 5f 5d e9 72 6a b4 c7 66 90 83 ec 0c 89 1c 24 89 c3 89 74 24 04 8d 70 08 81 c3 90 00 00 00 89 7c 24 08 8b be 20 01 00 00 <8b> 07 e8 5a 7f fc ff 89 d8 ba e0 c6 87 f8 e8 3e 20 94 c7 31 c0 
EIP: [<f887c09f>] coretemp_remove+0x1f/0x60 [coretemp] SS:ESP 0068:f7c07ef4

-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
