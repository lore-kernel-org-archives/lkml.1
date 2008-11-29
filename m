Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYK2Knb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYK2Knb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYK2KnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:43:21 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41331 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbYK2KnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:43:21 -0500
Subject: [PATCH 00/15] Kernel memory leak detector
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Sat, 29 Nov 2008 10:43:06 +0000
Message-ID: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.288.gdd3f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2008 10:43:06.0862 (UTC) FILETIME=[439560E0:01C9520F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a new version of the kernel memory leak detector. Kmemleak can
also be found in a branch on this git tree:

git://linux-arm.org/linux-2.6.git kmemleak

Changes since the previous release:

- kmemleak uses the default allocator (slab, slob or slub) instead of
  its own (which was removed), making the code simpler
- automatic scanning via a kernel thread every 10 min. The first scan
  starts 1 min after booting up. This thread prints possible memory
  leaks the first time they are encountered. Reading the
  /sys/kernel/debug/memleak file is still available to manually trigger
  a scan and show all the possible memory leaks
- scanning interruption via signals is now possible for manual scans
- implemented the comments received so far

Still to do:

- run-time and boot-time configuration like task stacks scanning,
  disabling kmemleak, enabling/disabling the automatic scanning

Thanks for your comments.


Catalin Marinas (15):
      kmemleak: Add the corresponding MAINTAINERS entry
      kmemleak: Simple testing module for kmemleak
      kmemleak: Keep the __init functions after initialization
      kmemleak: Enable the building of the memory leak detector
      kmemleak: Remove some of the kmemleak false positives
      arm: Provide _sdata and __bss_stop in the vmlinux.lds.S file
      x86: Provide _sdata in the vmlinux_*.lds.S files
      kmemleak: Add modules support
      kmemleak: Add memleak_alloc callback from alloc_large_system_hash
      kmemleak: Add the vmalloc memory allocation/freeing hooks
      kmemleak: Add the slub memory allocation/freeing hooks
      kmemleak: Add the slob memory allocation/freeing hooks
      kmemleak: Add the slab memory allocation/freeing hooks
      kmemleak: Add documentation on the memory leak detector
      kmemleak: Add the base support


 Documentation/kmemleak.txt       |  124 +++++
 MAINTAINERS                      |    6 
 arch/arm/kernel/vmlinux.lds.S    |    2 
 arch/x86/kernel/vmlinux_32.lds.S |    1 
 arch/x86/kernel/vmlinux_64.lds.S |    1 
 drivers/char/vt.c                |    7 
 include/linux/init.h             |    6 
 include/linux/memleak.h          |   87 +++
 include/linux/percpu.h           |    5 
 include/linux/slab.h             |    2 
 init/main.c                      |    4 
 kernel/module.c                  |   55 ++
 lib/Kconfig.debug                |   46 ++
 mm/Makefile                      |    2 
 mm/memleak-test.c                |  109 ++++
 mm/memleak.c                     | 1019 ++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                  |    3 
 mm/slab.c                        |   16 +
 mm/slob.c                        |   15 -
 mm/slub.c                        |    5 
 mm/vmalloc.c                     |   29 +
 21 files changed, 1533 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/kmemleak.txt
 create mode 100644 include/linux/memleak.h
 create mode 100644 mm/memleak-test.c
 create mode 100644 mm/memleak.c

-- 
Catalin
