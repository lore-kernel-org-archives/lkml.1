Return-Path: <linux-kernel-owner+w=401wt.eu-S1762325AbYDUNgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325AbYDUNgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933155AbYDUNbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:31:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:62832 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761901AbYDUNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:31:13 -0400
Date: Mon, 21 Apr 2008 15:31:13 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.25 on parisc - CPU 1 is stuck
Message-ID: <20080421133113.GA2223@ska.dandreoli.com>
Mail-Followup-To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-parisc@vger.kernel.org
References: <20080420231818.GA2162@ska.dandreoli.com> <20080421050029.GC15080@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421050029.GC15080@colo.lackof.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 11:00:29PM -0600, Grant Grundler wrote:
> On Mon, Apr 21, 2008 at 01:18:18AM +0200, Domenico Andreoli wrote:
> > 
> >   as soon as I booted my dual PA8600 with 2.6.25 I got 1 CPU less. The
> > only other kernel I successfully used on that box is Debian's 2.6.22-3.
> 
> Sorry, I can't reproduce this on my j6000.
>
> But there are some differences:
> 1) I'm using gcc 4.2

how do you build with gcc 4.2? if i try with make -j2 CC=gcc-4.2 build
fails almost immediately (yes, I have package gcc-4.2).

> 2) I'm testing 32-bit kernels.

indeeed disabling 64 bit support brings the cpu back

> ...
> > model 9000/785/J5600
> > Total Memory: 3840 MB
> 
> Is this really 4GB with IO Hole?
> The memory behind the IO Hole should be visible at a phys addr above 4GB.

really don't know, please read the diff between the two boots. thank you.

--- dmesg.txt	2008-04-21 11:19:16.000000000 +0200
+++ dmesg2.txt	2008-04-21 15:27:46.000000000 +0200
@@ -1,6 +1,7 @@
-Linux version 2.6.22-3-parisc64-smp (Debian 2.6.22-6) (maks@debian.org) (gcc version 4.1.3 20071019 (prerelease) (Debian 4.1.2-17)) #2 SMP Mon Nov 12 21:04:20 CET 2007
+Linux version 2.6.25 (cavok@ska) (gcc version 4.1.3 20080308 (prerelease) (Debian 4.1.2-21)) #8 SMP Mon Apr 21 12:25:50 CES8
 FP[0] enabled: Rev 1 Model 16
 The 64-bit Kernel has started...
+console [ttyB0] enabled
 Initialized PDC Console for debugging.
 Determining PDC firmware type: System Map.
 model 00005d10 00000491 00000000 00000002 77b406fc 100000f0 00000008 000000b2 000000b2
@@ -8,41 +9,28 @@
 CPUID vers 17 rev 10 (0x0000022a)
 capabilities 0x3
 model 9000/785/J5600
-Memory Ranges:
- 0) Start 0x0000000000000000 End 0x00000000efffffff Size   3840 MB
- 1) Start 0x00000010f0000000 End 0x00000010ffffffff Size    256 MB
-Total Memory: 4096 MB
-initrd: 7fa75000-7ffee77e
-initrd: reserving 3fa75000-3ffee77e (mem_max 100000000)
-On node 0 totalpages: 983040
-  Normal zone: 13440 pages used for memmap
-  Normal zone: 0 pages reserved
-  Normal zone: 969600 pages, LIFO batch:31
-On node 1 totalpages: 65536
-  Normal zone: 896 pages used for memmap
-  Normal zone: 0 pages reserved
-  Normal zone: 64640 pages, LIFO batch:15
+Total Memory: 3840 MB
 LCD display at fffffff0f05d0008,fffffff0f05d0000 registered
 SMP: bootstrap CPU ID is 0
-Built 2 zonelists.  Total pages: 1034240
-Kernel command line: root=/dev/sdb5 panic=60 HOME=/ console=ttyS0 TERM=vt102 palo_kernel=2/vmlinux.failsafe
+Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 969600
+Kernel command line: root=/dev/sdb5 panic=60 HOME=/ console=ttyS0 TERM=vt102 palo_kernel=2/vmlinux
 PID hash table entries: 4096 (order: 12, 32768 bytes)
 Console: colour dummy device 160x64
 Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
 Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
-Memory: 4110336k/4194304k available (3041k kernel code, 83172k reserved, 1302k data, 296k init)
+Memory: 3858944k/3932160k available (2925k kernel code, 72904k reserved, 1278k data, 236k init)
 virtual kernel memory layout:
     vmalloc : 0x0000000000008000 - 0x000000003f000000   (1007 MB)
-    memory  : 0x0000000040000000 - 0x0000001140000000   (69632 MB)
-      .init : 0x0000000040608000 - 0x0000000040652000   ( 296 kB)
-      .data : 0x00000000403f8500 - 0x000000004053e000   (1302 kB)
-      .text : 0x0000000040100000 - 0x00000000403f8500   (3041 kB)
-Calibrating delay loop... 1101.82 BogoMIPS (lpj=2203648)
-Security Framework v1.0.0 initialized
-SELinux:  Disabled at boot.
+    memory  : 0x0000000040000000 - 0x0000000130000000   (3840 MB)
+      .init : 0x00000000405b4000 - 0x00000000405ef000   ( 236 kB)
+      .data : 0x00000000403db720 - 0x000000004051b000   (1278 kB)
+      .text : 0x0000000040100000 - 0x00000000403db720   (2925 kB)
+SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
+Security Framework initialized
 Capability LSM initialized
 Mount-cache hash table entries: 256
 Brought up 1 CPUs
+net_namespace: 1008 bytes
 NET: Registered protocol family 16
 EISA bus registered
 Searching for devices...
@@ -58,11 +46,9 @@
 9. Memory at 0xfffffffffed10200 [49] { 1, 0x0, 0x09e, 0x00009 }
 Enabling regular chassis codes support v0.05
 Releasing cpu 1 now, hpa=fffffffffffa2000
-FP[1] enabled: Rev 1 Model 16
-migration_cost=4000
+SMP: CPU:1 is stuck.
 CPU(s): 2 x PA8600 (PCX-W+) at 552.000000 MHz
-Whole cache flush 177618 cycles, flushing 5578752 bytes 826963 cycles
-Setting cache flush threshold to 100000 (2 CPUs online)
+Setting cache flush threshold to fc880 (1 CPUs online)
 SBA found Astro 2.1 at 0xfffffffffed00000
 Elroy version TR2.1 (0x2) found at 0xfffffffffed30000
 PCI: Enabled native mode for NS87415 (pif=0x8f)

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
