Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYAaPi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYAaPi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYAaPis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:38:48 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:44029 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYAaPiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:38:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jv4EPvrwI/gchLUMWpBxu9tas4gEl0eEw/09nTjb/bkqu7+3Phwf6Nvwp2OOO+XPnVayL1N4r9fB1kCrQqzJaPwktRlf6BVn4gqk1BeVEzq5zfcSs82sWVp3QXxNZDeYPgYMBjXFFxrAmUaU7pBkdrR8RcWZbXlxBxXcmXqwiic=
Message-ID: <15577be70801310738x3afcc393k6cf8f7151677528c@mail.gmail.com>
Date: Thu, 31 Jan 2008 16:38:44 +0100
From: "Abel Bernabeu" <abelbg@m2grp.com>
Reply-To: abelbg@m2grp.com
To: linux-kernel@vger.kernel.org
Subject: Re: Elf loader crash while zero-filling .bss
In-Reply-To: <15577be70801300309k4eb84047peb4bffd4b41cbaa7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15577be70801300309k4eb84047peb4bffd4b41cbaa7@mail.gmail.com>
X-Google-Sender-Auth: c1d53789139a1e44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/30, Abel Bernabeu <abelbg@m2grp.com>:

> Now I am trying to execute some bigger C applications: in instance
> BusyBox. I've chosen the buildroot package in order to produce a small
> "distro".
>
> Then I've tried to boot the system using init=/bin/sh but I am getting
> a crash while loading this non-toy binary.
>
> And believe me, this is not a problem of EABI/OABI compatibility (I
> hope I could cope with that without messing here), seems more serious.

I would like to add some more info may be useful if you are curious
about the crash.

 The ELF binary I try to load (and the whole file system) are available here:

 http://www.arrakis.es/~abelbg/root.tar.bz2

 The boot log of the kernel follows. This time I tried gcc 4.1.0 to
discard a bad code generation problem but I got the same crash as with
gcc 4.2.1, so is not a gcc bug).

Thanks in advance guys.



Linux version 2.6.22.10m2grp (root@abel) (gcc version 4.1.0) #1 Thu
Jan 31 13:43:35 CET 2008
CPU: XScale-PXA255 [69052d06] revision 6 (ARMv5TE), cr=0000397f
Machine: M2
Ignoring unrecognised tag 0x00000000
Memory policy: ECC disabled, Data cache writeback
Memory clock: 99.53MHz (*27)
Run Mode clock: 398.13MHz (*4)
Turbo Mode clock: 398.13MHz (*1.0, active)
CPU0: D VIVT undefined 5 cache
CPU0: I cache: 32768 bytes, associativity 32, 32 byte lines, 32 sets
CPU0: D cache: 32768 bytes, associativity 32, 32 byte lines, 32 sets
Built 1 zonelists.  Total pages: 8128
Kernel command line: console=tty0 console=ttyS0,115200n8
memmap=32M@0xa0000000 rw
mtdparts=physmap-flash.0:0x80000(boot),0x780000(kernel),-(fs)
root=mtd2 rootfstype=jffs2 init=/bin/sh
PID hash table entries: 128 (order: 7, 512 bytes)
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 32MB = 32MB total
Memory: 32336KB available (1300K code, 113K data, 8K init)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Time: pxa_timer clocksource has been installed.
JFFS2 version 2.2. (c) 2001-2006 Red Hat, Inc.
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
ipmi message handler version 39.1
pxa2xx-uart.0: ttyS0 at MMIO 0x40100000 (irq = 15) is a FFUART
pxa2xx-uart.1: ttyS1 at MMIO 0x40200000 (irq = 14) is a BTUART
pxa2xx-uart.2: ttyS2 at MMIO 0x40700000 (irq = 13) is a STUART
pxa2xx-uart.3: ttyS3 at MMIO 0x41600000 (irq = 0) is a HWUART
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
physmap platform flash device: 02000000 at 00000000
physmap-flash.0: Found 2 x16 devices at 0x0 in 32-bit bank
Intel/Sharp Extended Query Table at 0x0031
Using buffer write method
cfi_cmdset_0001: Erase suspend on write enabled
3 cmdlinepart partitions found on MTD device physmap-flash.0
Creating 3 MTD partitions on "physmap-flash.0":
0x00000000-0x00080000 : "boot"
mtd: Giving out device 0 to boot
0x00080000-0x00800000 : "kernel"
mtd: Giving out device 1 to kernel
0x00800000-0x02000000 : "fs"
mtd: Giving out device 2 to fs
Generic platform RAM MTD, (c) 2004 Simtec Electronics
pxa2xx_udc: version 4-May-2005
gs_bind: Gadget Serial v2.2 bound
gs_module_init: Gadget Serial v2.2 loaded
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
XScale DSP coprocessor detected.
MTDSB: dev_name "mtd2"
MTDSB: mtd%d, mtdnr 2
MTDSB: New superblock for device 2 ("fs")
Empty flash at 0x0000fffc ends at 0x00010000
CLEANMARKER node found at 0x00010000, not first node in block (0x00000000)
Empty flash at 0x0001fffc ends at 0x00020000
CLEANMARKER node found at 0x00020000, not first node in block (0x00000000)
Empty flash at 0x0002fffc ends at 0x00030000
CLEANMARKER node found at 0x00030000, not first node in block (0x00000000)
Empty flash at 0x0004fffc ends at 0x00050000
CLEANMARKER node found at 0x00050000, not first node in block (0x00040000)
Empty flash at 0x0005ffd8 ends at 0x00060000
CLEANMARKER node found at 0x00060000, not first node in block (0x00040000)
Empty flash at 0x0006fffc ends at 0x00070000
CLEANMARKER node found at 0x00070000, not first node in block (0x00040000)
Empty flash at 0x0008fffc ends at 0x00090000
CLEANMARKER node found at 0x00090000, not first node in block (0x00080000)
Empty flash at 0x0009ffe8 ends at 0x000a0000
CLEANMARKER node found at 0x000a0000, not first node in block (0x00080000)
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a2cac:
0x0008 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a2d88:
0x0004 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a2e2c:
0x0002 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a2e88:
0x1000 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a2e98:
0x0040 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a2f08:
0x0010 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a2f30:
0x0020 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a2f78:
0x0001 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a2f90:
0x0001 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x000a30e8:
0x4000 instead
Further such events for this erase block will not be printed
Empty flash at 0x000a3800 ends at 0x000a381c
Empty flash at 0x000a3820 ends at 0x000a3838
Empty flash at 0x000a383c ends at 0x000a3840

 ---- 8< ----- JFFS2 is producing a lot noisy "Empty flash at " messages I ommit

Empty flash at 0x000bff78 ends at 0x000bff84
Empty flash at 0x000bff8c ends at 0x000bffbc
Empty flash at 0x000bffc0 ends at 0x000bfff0
VFS: Mounted root (jffs2 filesystem).
Freeing init memory: 8K
Unhandled fault: section translation fault (0x8f5) at 0x000a3801
Internal error: : 8f5 [#1]
CPU: 0    Not tainted  (2.6.22.10m2grp #1)
PC is at __clear_user+0x1c/0x64
LR is at padzero+0x5c/0x70
pc : [<bf0b95a8>]    lr : [<bf088f88>]    psr: 80000013
sp : c0087db0  ip : 00000001  fp : c0087dc4
r10: 000a3801  r9 : 000a4ec8  r8 : c0087ef8
r7 : 00000000  r6 : c01d6000  r5 : c009e680  r4 : 000a4ec8
r3 : 00000000  r2 : 00000000  r1 : 000007ff  r0 : 000a3801
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: 0000397f  Table: a0208000  DAC: 00000015
Process sh (pid: 1, stack limit = 0xc0086260)
Stack: (0xc0087db0 to 0xc0088000)
7da0:                                     000007ff bf088f88 c0087e9c c0087dc8
7dc0: bf089aa0 bf088f38 00001812 00000002 c0086000 c009e5c0 00000003 00000000
7de0: c01e4720 00008000 00000000 00000001 c01ed260 00000002 000a3801 c01d607c
7e00: c0085cc0 00008000 0009ae1c 000a3000 000a3801 c01d6130 c0087e6c c0087e28
7e20: bf049878 bf048bc0 000200d2 c0011e08 00000010 c002a200 00008000 0009ae1c
7e40: 000a3000 000a3801 00000000 c01d6000 c01d6000 00000000 00000005 00000003
7e60: 00000008 00000007 00000007 c01d6000 00000000 c0012400 c01d6000 c0087ef8
7e80: fffffffe c0086000 c0021e00 00000000 c0087ecc c0087ea0 bf061ef8 bf089258
7ea0: c000a404 c006617b c000d5f8 c01d6000 00000000 c000d684 c000a404 c0087ef8
7ec0: c0087ef4 c0087ed0 bf0637dc bf061e98 c006617b c000d684 c000d5f8 c0087ef8
7ee0: c0086000 00000000 c0087f5c c0087ef8 bf01ae50 bf0636c4 00000000 00000000
7f00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
7f20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
7f40: c0017124 00000000 bf016dd8 00000000 c0087f6c c0087f60 bf017288 bf01ae1c
7f60: c0087f84 c0087f70 bf017310 bf017274 00000000 c0017128 c0087ff4 c0087f88
7f80: bf008a1c bf0172a0 ea000000 e5d73034 e2844001 e31300ff 00000000 00000000
7fa0: 00000000 c0087fb0 bf017d04 bf0229ec 00000000 00000000 bf0088c4 bf0288f8
7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
7fe0: 00000000 00000000 00000000 c0087ff8 bf0288f8 bf0088d0 81c730b0 e2800005
Backtrace:
[<bf088f2c>] (padzero+0x0/0x70) from [<bf089aa0>] (load_elf_binary+0x854/0x192c)
[<bf08924c>] (load_elf_binary+0x0/0x192c) from [<bf061ef8>]
(search_binary_handler+0x6c/0x12c)
[<bf061e8c>] (search_binary_handler+0x0/0x12c) from [<bf0637dc>]
(do_execve+0x124/0x1e4)
[<bf0636b8>] (do_execve+0x0/0x1e4) from [<bf01ae50>] (kernel_execve+0x40/0x88)
[<bf01ae10>] (kernel_execve+0x0/0x88) from [<bf017288>]
(run_init_process+0x20/0x2c)
r7:00000000 r6:bf016dd8 r5:00000000 r4:c0017124
[<bf017268>] (run_init_process+0x0/0x2c) from [<bf017310>] (init_post+0x7c/0xec)
[<bf017294>] (init_post+0x0/0xec) from [<bf008a1c>] (kernel_init+0x158/0x2a0)
r4:c0017128
[<bf0088c4>] (kernel_init+0x0/0x2a0) from [<bf0288f8>] (do_exit+0x0/0x768)
Code: ba00000d e210c003 0a000005 e35c0002 (e4e02001)
Kernel panic - not syncing: Attempted to kill init!
