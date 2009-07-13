Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZGMG2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZGMG2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZGMG2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:28:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:60440 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbZGMG2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:28:42 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Subject: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and pci-dma-compat.h
Date: Mon, 13 Jul 2009 15:25:52 +0900
Message-Id: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jul 2009 15:27:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second version of the patchset to convert SPARC to
asm-generic/dma-mapping-common.h and pci-dma-compat.h:

http://marc.info/?l=linux-sparc&m=124686094931138&w=2

The changes are:

- I added Arnd's patch (1/8) to remove flush_write_buffers() in
  dma-mapping-common.h. so no need to define useless
  flush_write_buffers() on SPARC.

- I added a patch to remove useless flush_write_buffers() on IA64.

- I found and fixed a bug wrt dma_{alloc|free}_coherent that affects
  pci devices on SPARC32; the bug doesn't use get_dma_ops in
  dma_{alloc|free}_coherent (4/8).

- Robert asked me about the dma-debug feature so I added it (8/8).

- Robert tested [3-8/8] patches. I added 'Tested-by' tags.


This patchset touches multiple architectures so it would be appropriate
to merge it via -mm. However, I think that the changes to IA64 and X86
are not large so it would be easier to merge this via SPARC tree.

=
 arch/ia64/include/asm/dma-mapping.h      |    1 -
 arch/sparc/Kconfig                       |    2 +
 arch/sparc/include/asm/dma-mapping.h     |  145 ++++-------------------
 arch/sparc/include/asm/pci.h             |    3 +
 arch/sparc/include/asm/pci_32.h          |  105 ----------------
 arch/sparc/include/asm/pci_64.h          |   88 --------------
 arch/sparc/kernel/Makefile               |    2 +-
 arch/sparc/kernel/dma.c                  |  175 +--------------------------
 arch/sparc/kernel/dma.h                  |   14 --
 arch/sparc/kernel/iommu.c                |   20 ++-
 arch/sparc/kernel/ioport.c               |  190 ++++++++++++++++-------------
 arch/sparc/kernel/pci.c                  |    2 +-
 arch/sparc/kernel/pci_sun4v.c            |   30 ++----
 arch/x86/kernel/pci-nommu.c              |   27 ++++-
 include/asm-generic/dma-mapping-common.h |    6 -
 15 files changed, 183 insertions(+), 627 deletions(-)



