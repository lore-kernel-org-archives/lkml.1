Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZLNAWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZLNAWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbZLNAW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:22:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34028 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbZLMX5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:36 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, mingo@elte.hu, akpm@linux-foundation.org,
       benh@kernel.crashing.org, torvalds@linux-foundation.org,
       sfr@canb.auug.org.au, gregkh@suse.de
Subject: [PATCH 00/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:15 +0100
Message-Id: <cover.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Hello everyone!

The following patch series attempts to constify several structures
that hold function pointers. This is only the initial batch, there
are about over 150 candidate structures, some of which can be
constified as well, I plan to submit them in the future.

The list of constified structures in this series (* marks this thread):
acpi_dock_ops
address_space_operations
backlight_ops
block_device_operations
* dma_map_ops
extent_io_ops
file_lock_operations
file_operations
hv_ops
intel_dvo_dev_ops
item_operations
iwl_ops
kgdb_arch
kgdb_io
kset_uevent_ops
lock_manager_operations
microcode_ops
mtrr_ops
neigh_ops
nlmsvc_binding
pci_raw_ops
platform_hibernation_ops
platform_suspend_ops
snd_ac97_build_ops
sysfs_ops
usb_mon_operations
wd_ops

There are certain exceptions where a given instance of the structure
cannot be const, they are marked with a comment in the patch.

The patches compile fine with an allyesconfig kernel on i386 and x86_64.

Please let me know if any of these structures should not be constified
and any other issues you see with them.


Changelog:
----------
v1 -> v2
	- updated to linus-git-053fe57
	- extended comments with a reference to code that prevents constification
	- split up patches by subsystem as suggested by Greg KH, Jiri Slaby
	- added all Acked-by's received so far
	- removed patch for super_operations for now
	- removed patch for ptmx_fops

Thanks,
   Emese

 arch/ia64/hp/common/hwsw_iommu.c         |    4 +-
 arch/ia64/hp/common/sba_iommu.c          |    4 +-
 arch/ia64/include/asm/dma-mapping.h      |   10 ++++----
 arch/ia64/include/asm/machvec.h          |    4 +-
 arch/ia64/kernel/dma-mapping.c           |    4 +-
 arch/ia64/kernel/pci-dma.c               |    2 +-
 arch/ia64/kernel/pci-swiotlb.c           |    2 +-
 arch/ia64/sn/pci/pci_dma.c               |    2 +-
 arch/powerpc/include/asm/device.h        |    2 +-
 arch/powerpc/include/asm/dma-mapping.h   |   18 ++++++++--------
 arch/powerpc/include/asm/iommu.h         |    3 ++
 arch/powerpc/include/asm/pci.h           |    4 +-
 arch/powerpc/include/asm/swiotlb.h       |    2 +-
 arch/powerpc/kernel/dma-iommu.c          |    4 +-
 arch/powerpc/kernel/dma-swiotlb.c        |    2 +-
 arch/powerpc/kernel/dma.c                |    2 +-
 arch/powerpc/kernel/ibmebus.c            |    2 +-
 arch/powerpc/kernel/pci-common.c         |    6 ++--
 arch/powerpc/kernel/vio.c                |    5 +--
 arch/powerpc/platforms/cell/iommu.c      |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c  |    4 +-
 arch/sh/include/asm/dma-mapping.h        |   14 ++++++------
 arch/sh/kernel/dma-nommu.c               |    2 +-
 arch/sh/mm/consistent.c                  |    2 +-
 arch/sparc/include/asm/dma-mapping.h     |    8 +++---
 arch/sparc/kernel/iommu.c                |    4 +-
 arch/sparc/kernel/ioport.c               |    6 ++--
 arch/sparc/kernel/pci_sun4v.c            |    2 +-
 arch/x86/include/asm/device.h            |    2 +-
 arch/x86/include/asm/dma-mapping.h       |   10 ++++----
 arch/x86/include/asm/iommu.h             |    4 ++-
 arch/x86/kernel/amd_iommu.c              |    2 +-
 arch/x86/kernel/pci-calgary_64.c         |    2 +-
 arch/x86/kernel/pci-dma.c                |    4 +-
 arch/x86/kernel/pci-gart_64.c            |    2 +-
 arch/x86/kernel/pci-nommu.c              |    2 +-
 arch/x86/kernel/pci-swiotlb.c            |    2 +-
 drivers/pci/intel-iommu.c                |    2 +-
 include/asm-generic/dma-mapping-common.h |   24 +++++++++++-----------
 include/linux/dma-mapping.h              |   32 +++++++++++++++---------------
 40 files changed, 109 insertions(+), 105 deletions(-)

