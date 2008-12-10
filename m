Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYLJS1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYLJS1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYLJS05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:26:57 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33122 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbYLJS04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:26:56 -0500
Subject: [PATCH 00/15] Kernel memory leak detector
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 10 Dec 2008 18:26:53 +0000
Message-ID: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 18:26:54.0029 (UTC) FILETIME=[E06957D0:01C95AF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new kmemleak version is available. Thanks to all who reviewed the code
and gave feedback. Kmemleak can also be found on this git tree:

git://linux-arm.org/linux-2.6.git kmemleak

Please note that even though I already got the ack from the
slab/slob/slub maintainers, I haven't included the corresponding lines
in the patch description because the patches were slightly modified to
pass the GFP flags to the kmemleak callbacks. I would be grateful if you
review these changes and re-acknowledge them.

Changes since the previous release:

- fatal errors for kmemleak are no longer fatal for the full system.
  Kmemleak can disable and clean-up after itself at run-time if such a
  condition occurs
- re-worked locking in the memleak.c file together with documentation on
  how it works
- kmemleak internal allocations use the GFP flags of the caller and are
  no longer restricted to GFP_ATOMIC
- better (hopefully) comments all over the code
- implemented most of the comments received so far (an important
  omission here is the tracking of alloc_bootmem calls since it looks a
  bit difficult to pair them with free_bootmem, the latter being used
  with reserve_bootmem or without a corresponding alloc_bootmem)

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


 Documentation/kmemleak.txt       |  127 ++++
 MAINTAINERS                      |    6 
 arch/arm/kernel/vmlinux.lds.S    |    2 
 arch/x86/kernel/vmlinux_32.lds.S |    1 
 arch/x86/kernel/vmlinux_64.lds.S |    1 
 drivers/char/vt.c                |    7 
 include/linux/init.h             |    6 
 include/linux/memleak.h          |   93 +++
 include/linux/percpu.h           |    5 
 include/linux/slab.h             |    2 
 init/main.c                      |    4 
 kernel/module.c                  |   56 ++
 lib/Kconfig.debug                |   46 +
 mm/Makefile                      |    2 
 mm/memleak-test.c                |  110 +++
 mm/memleak.c                     | 1263 ++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                  |    3 
 mm/slab.c                        |   18 -
 mm/slob.c                        |   15 
 mm/slub.c                        |    5 
 mm/vmalloc.c                     |   29 +
 21 files changed, 1790 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/kmemleak.txt
 create mode 100644 include/linux/memleak.h
 create mode 100644 mm/memleak-test.c
 create mode 100644 mm/memleak.c

-- 
Catalin
