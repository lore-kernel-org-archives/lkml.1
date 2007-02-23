Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbXBWLIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbXBWLIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932294AbXBWLIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:08:13 -0500
Received: from marvin.h-e-r-e-s-y.com ([87.106.62.5]:37862 "EHLO
	marvin.h-e-r-e-s-y.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbXBWLIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:08:12 -0500
From: Andrew Walrond <andrew@walrond.org>
To: sparclinux@vger.kernel.org
Subject: (Sparc64) 2.6.20 seems to ignore initramfs
Date: Fri, 23 Feb 2007 11:08:10 +0000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702231108.10185.andrew@walrond.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a Sun T1000 I am trying to boot 2.6.20 using initramfs. (I use the same 
procedure successfully on x86_64 and itanium2 servers).

The relevent silo section looks like this:

image=/boot/2.6.20.image
        label=2.6.20
        initrd=/boot/2.6.20.initramfs
        partition=2
        read-only

The kernel loads and boots and I see

Allocated 8 Megs of memory at 0x40000000 for kernel
Loaded kernel version 2.6.20
Loading initial ramdisk (127932430 bytes at 0x1000000 phys, 0x40C00000 
virt)...
/
Remapping the kernel... done.
Booting Linux...
PROMLIB: Sun IEEE Boot Prom 'OBP 4.23.0 2006/06/02 16:14'
PROMLIB: Root node compatible: sun4v
Linux version 2.6.20 (nobody@spawn1.secure) (gcc version 4.1.1) #1 SMP Thu Feb 
22 16:25:18 GMT 2007
ARCH: SUN4V
Ethernet address: 00:14:4f:2a:90:92
PROM: Built device tree with 65903 bytes of memory.
Built 1 zonelists.  Total pages: 242541
Kernel command line: ro

[snip]

checking if image is initramfs... it is
Freeing initrd memory: 124934k freed

[snip]

VFS: Cannot open root device "<NULL>" or unknown-block(0,0)
Please append a correct "root=" boot option
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
 <0>Press Stop-A (L1-A) to return to the boot prom


So it knows about the initramfs, but then tries to mount a root filesystem 
instead...

I haven't tried this (initramfs)  with earlier kernels, so I don't know 
whether this is a regression. Any clues about how to solve this would be 
greatly appreciated.

Andrew Walrond
