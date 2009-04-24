Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbZDXQl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbZDXQl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZDXQlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:41:45 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41441 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818AbZDXQlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:41:44 -0400
Subject: [PATCH 00/14] Kernel memory leak detector
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Apr 2009 17:40:58 +0100
Message-ID: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:41:42.0675 (UTC) FILETIME=[8C516630:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

That's the latest version of kmemleak. It is also available from:

git://linux-arm.org/linux-2.6.git kmemleak

For the past couple of months, kmemleak lived in the linux-next without
major incidents. I consider that the implementation is stable for
mainline inclusion.

Is there a consensus on whether kmemleak should be merged into the
2.6.31-rc1 kernel?

Are there any other comments on the code?

Thanks.


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
 fs/block_dev.c                      |    6 
 include/linux/kmemleak.h            |   96 ++
 include/linux/percpu.h              |    5 
 include/linux/slab.h                |    2 
 init/main.c                         |    4 
 kernel/module.c                     |   56 +
 lib/Kconfig.debug                   |   33 +
 mm/Makefile                         |    2 
 mm/kmemleak-test.c                  |  111 +++
 mm/kmemleak.c                       | 1498 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                     |   11 
 mm/slab.c                           |   32 +
 mm/slob.c                           |    7 
 mm/slub.c                           |    5 
 mm/vmalloc.c                        |   30 +
 22 files changed, 2054 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/kmemleak.txt
 create mode 100644 include/linux/kmemleak.h
 create mode 100644 mm/kmemleak-test.c
 create mode 100644 mm/kmemleak.c

-- 
Catalin
