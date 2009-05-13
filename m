Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbZEMNHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbZEMNHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbZEMNGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:06:51 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52124 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759642AbZEMNGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:06:49 -0400
Message-ID: <4A0AC5E6.2010402@in.ibm.com>
Date: Wed, 13 May 2009 18:36:46 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Next May 13:[drivers/base/firmware*] Bug while booting on x86
References: <20090513164832.c8a0de7d.sfr@canb.auug.org.au>
In-Reply-To: <20090513164832.c8a0de7d.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's Next tree failed to boot on a x86 box with following Bug.

Checking/updating CPU microcode 7[?25l[80C[10D[1;32mdone[m8[?25h
tg3 0000:02:08.0: firmware: requesting tigon/tg3_tso.bin
BUG: unable to handle kernel NULL pointer dereference at 0000050c
IP: [<c0119c5d>] kunmap+0x33/0x59
*pdpt = 00000000354f2001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:02/0000:02:08.0/firmware/0000:02:08.0/loading
Modules linked in: microcode fuse loop dm_mod i2c_piix4 i2c_core ppdev sr_mod
parport_pc rtc_cmos sworks_agp tg3 button cdrom parport rtc_core rtc_lib
pcspkr libphy agpgart sg floppy ohci_hcd ehci_hcd sd_mod crc_t10dif usbcore
edd ext3 jbd fan ide_pci_generic serverworks ide_core ata_generic
pata_serverworks libata ips scsi_mod thermal processor thermal_sys hwmon [last unloaded: speedstep_lib]

Pid: 2399, comm: cat Not tainted (2.6.30-rc5-autotest-next-20090513 #1) eserver xSeries 235 -[86717AX]-
EIP: 0060:[<c0119c5d>] EFLAGS: 00010246 CPU: 0
EIP is at kunmap+0x33/0x59
EAX: 00000000 EBX: 00000b5c ECX: ff52c000 EDX: 00000001
ESI: f59d2b5c EDI: ff52cb5c EBP: f480def4 ESP: f480def4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cat (pid: 2399, ti=f480c000 task=f618a000 task.ti=f480c000)
Stack:
 f480df24 c02f417c f59d2000 f4d84f54 f51cf880 00000b5c f4d84f00 00000002
 00000002 fffffffb f4c469c0 c02f3fb1 f480df6c c01e618a 00001000 00000000
 00000b5c 0804cfb0 f50dd2a0 f54b6940 f59d2000 f5cb6bb0 00001000 00000000
Call Trace:
 [<c02f417c>] ? firmware_data_write+0x1cb/0x211
 [<c02f3fb1>] ? firmware_data_write+0x0/0x211
 [<c01e618a>] ? write+0x113/0x14a
 [<c01e6077>] ? write+0x0/0x14a
 [<c01a5b72>] ? vfs_write+0x8c/0x136
 [<c01a5cb5>] ? sys_write+0x3b/0x60
 [<c0102950>] ? sysenter_do_call+0x12/0x22
Code: 00 e0 ff ff f7 40 14 00 ff ff 07 74 04 0f 0b eb fe 8b 01 89 c2
c1 e8 1b 83 e0 03 c1 ea 1d 69 c0 20 05 00 00 03 04 95 08 f7 55 c0 <2b>
80 0c 05 00 00 3d 40 0a 00 00 74 10 3d 60 0f 00 00 75 10 83 
EIP: [<c0119c5d>] kunmap+0x33/0x59 SS:ESP 0068:f480def4
CR2: 000000000000050c
---[ end trace 6ae4ce0e4a71f239 ]---

Let me know if i can provide any other information.


Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

