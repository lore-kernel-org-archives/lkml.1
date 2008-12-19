Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbYLSSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbYLSSNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYLSSNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:13:01 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50300 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbYLSSNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:13:00 -0500
Subject: [PATCH 00/14] Kernel memory leak detector
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 19 Dec 2008 18:12:56 +0000
Message-ID: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2008 18:12:57.0861 (UTC) FILETIME=[6BBBFB50:01C96205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new kmemleak version is available. Thanks to all who reviewed the code
and provided feedback. Kmemleak can also be found on this git tree:

git://linux-arm.org/linux-2.6.git kmemleak

Main changes since the previous release:

- run-time configuration by writing to the /sys/kernel/debug/memleak
  file (see Documentation/kmemleak.txt)
- boot-time disabling by passing kmemleak=off
- no scanning of the array_cache structures in slab to avoid false
  negatives
- aesthetic change - s/memleak/kmemleak for all the functions as it is
  more consistent with the documentation
- various other changes following comments received

Thanks for your comments.


Catalin Marinas (14):
      kmemleak: Add the corresponding MAINTAINERS entry
      kmemleak: Simple testing module for kmemleak
      kmemleak: Enable the building of the memory leak detector
      kmemleak: Remove some of the kmemleak false positives
      arm: Provide _sdata and __bss_stop in the vmlinux.lds.S file
      x86: Provide _sdata in the vmlinux_*.lds.S files
      kmemleak: Add modules support
      kmemleak: Add kmemleak_alloc callback from alloc_large_system_hash
      kmemleak: Add the vmalloc memory allocation/freeing hooks
      kmemleak: Add the slub memory allocation/freeing hooks
      kmemleak: Add the slob memory allocation/freeing hooks
      kmemleak: Add the slab memory allocation/freeing hooks
      kmemleak: Add documentation on the memory leak detector
      kmemleak: Add the base support


 Documentation/kernel-parameters.txt |    4 
 Documentation/kmemleak.txt          |  142 +++
 MAINTAINERS                         |    6 
 arch/arm/kernel/vmlinux.lds.S       |    2 
 arch/x86/kernel/vmlinux_32.lds.S    |    1 
 arch/x86/kernel/vmlinux_64.lds.S    |    1 
 drivers/char/vt.c                   |    7 
 include/linux/kmemleak.h            |   96 ++
 include/linux/percpu.h              |    5 
 include/linux/slab.h                |    2 
 init/main.c                         |    4 
 kernel/module.c                     |   56 +
 lib/Kconfig.debug                   |   33 +
 mm/Makefile                         |    2 
 mm/kmemleak-test.c                  |  111 +++
 mm/kmemleak.c                       | 1468 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                     |   11 
 mm/slab.c                           |   33 +
 mm/slob.c                           |   15 
 mm/slub.c                           |    5 
 mm/vmalloc.c                        |   28 +
 21 files changed, 2021 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/kmemleak.txt
 create mode 100644 include/linux/kmemleak.h
 create mode 100644 mm/kmemleak-test.c
 create mode 100644 mm/kmemleak.c

-- 
Catalin
