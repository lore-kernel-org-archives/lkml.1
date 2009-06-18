Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbZFRJSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbZFRJSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZFRJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:18:09 -0400
Received: from mail-qy0-f201.google.com ([209.85.221.201]:61268 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZFRJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HdJvLv5hyqdsAUJrnyf09WLzuQR9xCkuIsbiyonYHjXTcjrdSTKbN5mRfZy1SOh82v
         syZRn2QFyKs2eU1iYihmFPmr/H4qo857q0m41yKFEH182EkQklmSFqRSYogXptbRZZ3p
         ytNF2KW0pvQeKB1LJJ92tK4G3uS7aNmzEGTLY=
MIME-Version: 1.0
Date: Thu, 18 Jun 2009 14:48:10 +0530
Message-ID: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
Subject: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Sudeep K N <sudeepholla.maillist@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to boot linux on SMP system with root file system(ext2) on eMMC.
The eMMC is partitioned in 3 parts and I am trying to use 2nd
partition of 128M to keep
the rootfs.
The command line used is:
Kernel command line: cachepolicy=writealloc noinitrd
root=/dev/mmcblk0p2 rootfstype=ext2 rootdelay=1 init=/bin/sh rw
console=ttyAMA2,115200n8 mem=128M

After mounting the rootfs in eMMC, it panics.
Panic log as below.  When I traced, I observed it fails while its
execution "run_init_process"
I have tried with different init process,i.e. init=/linuxrc,
init=/bin/busybox, init=/sbin/init
Even I tried initramfs and the switch_root/pivot_root to rootfs on
eMMC partition.
In all the cases, I got the same panic.
Can anybody help me in understanding the exact reason for this panic?


Panic Log:
DRIVER MMC: probe
Waiting 1sec before mounting root device...
mmc0: new MMC card at address 0001
mmcblk0: mmc0:0001 M8G4DD 8028160KiB
 mmcblk0: p1 p2 p3
VFS: Mounted root (ext2 filesystem).
Freeing init memory: 108K
Kernel panic - not syncing: Attempted to kill init!
CPU0: stopping
[<c0028950>] (dump_stack+0x0/0x14) from [<c0023384>] (do_IPI+0xd4/0x140)
[<c00232b0>] (do_IPI+0x0/0x140) from [<c0023a88>] (__irq_svc+0x48/0xdc)
Exception stack(0xc01fdf40 to 0xc01fdf88)
df40: 00000000 c01fc000 c01fdf88 00000000 c0025754 c01fc000 00322000 00000004
df60: c001d000 410fc090 c001dfc0 c01fdf94 c01fdf98 c01fdf88 c0025794 c0025798
df80: 60000013 ffffffff
 r9:c01fc000 r8:00000001 r7:00000002 r6:00000401 r5:f0410100
r4:ffffffff
[<c0025754>] (default_idle+0x0/0x4c) from [<c0025634>] (cpu_idle+0x64/0x94)
[<c00255d0>] (cpu_idle+0x0/0x94) from [<c018666c>] (rest_init+0x6c/0x80)
 r5:c02188dc r4:c0225358
[<c0186600>] (rest_init+0x0/0x80) from [<c0008bf4>] (start_kernel+0x2f0/0x358)
[<c0008904>] (start_kernel+0x0/0x358) from [<0000807c>] (0x807c)


--
Regards,
Sudeep
