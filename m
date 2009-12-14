Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZLNABu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZLNABu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbZLNABl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:01:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34669 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbZLMX6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:39 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, shemminger@vyatta.com,
       torvalds@linux-foundation.org, jbarnes@virtuousgeek.org,
       hjk@linutronix.de, akpm@linux-foundation.org
Subject: [PATCH 00/25] Constify struct sysfs_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:07 +0100
Message-Id: <cover.1260663004.git.re.emese@gmail.com>
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
dma_map_ops
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
* sysfs_ops
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

 arch/ia64/kernel/topology.c           |    2 +-
 arch/powerpc/kernel/cacheinfo.c       |    2 +-
 arch/sh/kernel/cpu/sh4/sq.c           |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    2 +-
 block/blk-integrity.c                 |    2 +-
 block/blk-sysfs.c                     |    2 +-
 block/elevator.c                      |    2 +-
 drivers/base/bus.c                    |    4 ++--
 drivers/base/class.c                  |    2 +-
 drivers/base/core.c                   |    2 +-
 drivers/base/sys.c                    |    4 ++--
 drivers/block/pktcdvd.c               |    2 +-
 drivers/cpufreq/cpufreq.c             |    2 +-
 drivers/cpuidle/sysfs.c               |    4 ++--
 drivers/dma/ioat/dma.c                |    2 +-
 drivers/dma/ioat/dma.h                |    2 +-
 drivers/edac/edac_device_sysfs.c      |    6 +++---
 drivers/edac/edac_mc_sysfs.c          |    4 ++--
 drivers/edac/edac_pci_sysfs.c         |    4 ++--
 drivers/firmware/edd.c                |    2 +-
 drivers/firmware/efivars.c            |    2 +-
 drivers/firmware/iscsi_ibft.c         |    2 +-
 drivers/firmware/memmap.c             |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c          |    2 +-
 drivers/gpu/drm/ttm/ttm_memory.c      |    2 +-
 drivers/infiniband/core/cm.c          |    2 +-
 drivers/infiniband/core/sysfs.c       |    2 +-
 drivers/md/dm-sysfs.c                 |    2 +-
 drivers/md/md.c                       |    4 ++--
 drivers/net/ibmveth.c                 |    2 +-
 drivers/net/iseries_veth.c            |    4 ++--
 drivers/parisc/pdc_stable.c           |    2 +-
 drivers/pci/hotplug/fakephp.c         |    2 +-
 drivers/pci/slot.c                    |    2 +-
 drivers/uio/uio.c                     |    4 ++--
 drivers/uwb/wlp/sysfs.c               |    3 +--
 drivers/video/omap2/dss/manager.c     |    2 +-
 drivers/video/omap2/dss/overlay.c     |    2 +-
 drivers/xen/sys-hypervisor.c          |    2 +-
 fs/btrfs/sysfs.c                      |    4 ++--
 fs/dlm/lockspace.c                    |    2 +-
 fs/ext4/super.c                       |    2 +-
 fs/gfs2/sys.c                         |    2 +-
 fs/ocfs2/cluster/masklog.c            |    2 +-
 fs/sysfs/file.c                       |    8 ++++----
 include/linux/kobject.h               |    4 ++--
 include/linux/sysfs.h                 |    4 ++--
 kernel/params.c                       |    2 +-
 lib/kobject.c                         |    2 +-
 mm/slub.c                             |    2 +-
 net/bridge/br_private.h               |    2 +-
 net/bridge/br_sysfs_if.c              |    2 +-
 samples/kobject/kset-example.c        |    2 +-
 54 files changed, 70 insertions(+), 71 deletions(-)

