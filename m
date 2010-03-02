Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0CBX3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:39 -0500
Received: from kroah.org ([198.145.64.141]:38562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab0CBX32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:28 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/62] Driver core: Constify struct sysfs_ops in struct kobj_type
Date: Tue,  2 Mar 2010 15:28:26 -0800
Message-Id: <1267572541-410-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct sysfs_ops.

This is part of the ops structure constification
effort started by Arjan van de Ven et al.

Benefits of this constification:

 * prevents modification of data that is shared
   (referenced) by many other structure instances
   at runtime

 * detects/prevents accidental (but not intentional)
   modification attempts on archs that enforce
   read-only kernel data at runtime

 * potentially better optimized code as the compiler
   can assume that the const data cannot be changed

 * the compiler/linker move const data into .rodata
   and therefore exclude them from false sharing

Signed-off-by: Emese Revfy <re.emese@gmail.com>
Acked-by: David Teigland <teigland@redhat.com>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kobject.txt             |    2 +-
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
 kernel/params.c                       |    2 +-
 lib/kobject.c                         |    2 +-
 mm/slub.c                             |    2 +-
 net/bridge/br_private.h               |    2 +-
 net/bridge/br_sysfs_if.c              |    2 +-
 samples/kobject/kset-example.c        |    2 +-
 54 files changed, 69 insertions(+), 70 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index c79ab99..bdb1381 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -266,7 +266,7 @@ kobj_type:
 
     struct kobj_type {
 	    void (*release)(struct kobject *);
-	    struct sysfs_ops	*sysfs_ops;
+	    const struct sysfs_ops *sysfs_ops;
 	    struct attribute	**default_attrs;
     };
 
diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index 8f06035..b3a5818 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -282,7 +282,7 @@ static ssize_t cache_show(struct kobject * kobj, struct attribute * attr, char *
 	return ret;
 }
 
-static struct sysfs_ops cache_sysfs_ops = {
+static const struct sysfs_ops cache_sysfs_ops = {
 	.show   = cache_show
 };
 
diff --git a/arch/powerpc/kernel/cacheinfo.c b/arch/powerpc/kernel/cacheinfo.c
index bb37b1d..01fe9ce 100644
--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -642,7 +642,7 @@ static struct kobj_attribute *cache_index_opt_attrs[] = {
 	&cache_assoc_attr,
 };
 
-static struct sysfs_ops cache_index_ops = {
+static const struct sysfs_ops cache_index_ops = {
 	.show = cache_index_show,
 };
 
diff --git a/arch/sh/kernel/cpu/sh4/sq.c b/arch/sh/kernel/cpu/sh4/sq.c
index fc065f9..14726ee 100644
--- a/arch/sh/kernel/cpu/sh4/sq.c
+++ b/arch/sh/kernel/cpu/sh4/sq.c
@@ -326,7 +326,7 @@ static struct attribute *sq_sysfs_attrs[] = {
 	NULL,
 };
 
-static struct sysfs_ops sq_sysfs_ops = {
+static const struct sysfs_ops sq_sysfs_ops = {
 	.show	= sq_sysfs_show,
 	.store	= sq_sysfs_store,
 };
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index eddb1bd..b3eeb66 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -903,7 +903,7 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show   = show,
 	.store  = store,
 };
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 83a3d1f..cda932c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -388,7 +388,7 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops threshold_ops = {
+static const struct sysfs_ops threshold_ops = {
 	.show			= show,
 	.store			= store,
 };
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 15c6308..96e83c2 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -278,7 +278,7 @@ static struct attribute *integrity_attrs[] = {
 	NULL,
 };
 
-static struct sysfs_ops integrity_ops = {
+static const struct sysfs_ops integrity_ops = {
 	.show	= &integrity_attr_show,
 	.store	= &integrity_attr_store,
 };
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e854424..2ae2cb3 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -450,7 +450,7 @@ static void blk_release_queue(struct kobject *kobj)
 	kmem_cache_free(blk_requestq_cachep, q);
 }
 
-static struct sysfs_ops queue_sysfs_ops = {
+static const struct sysfs_ops queue_sysfs_ops = {
 	.show	= queue_attr_show,
 	.store	= queue_attr_store,
 };
diff --git a/block/elevator.c b/block/elevator.c
index ee3a883..df75676 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -892,7 +892,7 @@ elv_attr_store(struct kobject *kobj, struct attribute *attr,
 	return error;
 }
 
-static struct sysfs_ops elv_sysfs_ops = {
+static const struct sysfs_ops elv_sysfs_ops = {
 	.show	= elv_attr_show,
 	.store	= elv_attr_store,
 };
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 2afe599..cca1aa1 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -70,7 +70,7 @@ static ssize_t drv_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops driver_sysfs_ops = {
+static const struct sysfs_ops driver_sysfs_ops = {
 	.show	= drv_attr_show,
 	.store	= drv_attr_store,
 };
@@ -115,7 +115,7 @@ static ssize_t bus_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops bus_sysfs_ops = {
+static const struct sysfs_ops bus_sysfs_ops = {
 	.show	= bus_attr_show,
 	.store	= bus_attr_store,
 };
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 2e297cc..0147f47 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -63,7 +63,7 @@ static void class_release(struct kobject *kobj)
 	kfree(cp);
 }
 
-static struct sysfs_ops class_sysfs_ops = {
+static const struct sysfs_ops class_sysfs_ops = {
 	.show	= class_attr_show,
 	.store	= class_attr_store,
 };
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 313db11..bbfcea0 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -100,7 +100,7 @@ static ssize_t dev_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops dev_sysfs_ops = {
+static const struct sysfs_ops dev_sysfs_ops = {
 	.show	= dev_attr_show,
 	.store	= dev_attr_store,
 };
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 747c99e..8980fee 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -54,7 +54,7 @@ sysdev_store(struct kobject *kobj, struct attribute *attr,
 	return -EIO;
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show	= sysdev_show,
 	.store	= sysdev_store,
 };
@@ -104,7 +104,7 @@ static ssize_t sysdev_class_store(struct kobject *kobj, struct attribute *attr,
 	return -EIO;
 }
 
-static struct sysfs_ops sysfs_class_ops = {
+static const struct sysfs_ops sysfs_class_ops = {
 	.show	= sysdev_class_show,
 	.store	= sysdev_class_store,
 };
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 73d815d..39c8514 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -284,7 +284,7 @@ static ssize_t kobj_pkt_store(struct kobject *kobj,
 	return len;
 }
 
-static struct sysfs_ops kobj_pkt_ops = {
+static const struct sysfs_ops kobj_pkt_ops = {
 	.show = kobj_pkt_show,
 	.store = kobj_pkt_store
 };
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 67bc2ec..2d5d575 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -766,7 +766,7 @@ static void cpufreq_sysfs_release(struct kobject *kobj)
 	complete(&policy->kobj_unregister);
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show	= show,
 	.store	= store,
 };
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index c9cefac..8719b36 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -195,7 +195,7 @@ static ssize_t cpuidle_store(struct kobject * kobj, struct attribute * attr,
 	return ret;
 }
 
-static struct sysfs_ops cpuidle_sysfs_ops = {
+static const struct sysfs_ops cpuidle_sysfs_ops = {
 	.show = cpuidle_show,
 	.store = cpuidle_store,
 };
@@ -281,7 +281,7 @@ static ssize_t cpuidle_state_show(struct kobject * kobj,
 	return ret;
 }
 
-static struct sysfs_ops cpuidle_state_sysfs_ops = {
+static const struct sysfs_ops cpuidle_state_sysfs_ops = {
 	.show = cpuidle_state_show,
 };
 
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index dcc4ab7..cc834bb 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -1146,7 +1146,7 @@ ioat_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 	return entry->show(&chan->common, page);
 }
 
-struct sysfs_ops ioat_sysfs_ops = {
+const struct sysfs_ops ioat_sysfs_ops = {
 	.show	= ioat_attr_show,
 };
 
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index bbc3e78..f2db62c 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -347,7 +347,7 @@ bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
 			   unsigned long *phys_complete);
 void ioat_kobject_add(struct ioatdma_device *device, struct kobj_type *type);
 void ioat_kobject_del(struct ioatdma_device *device);
-extern struct sysfs_ops ioat_sysfs_ops;
+extern const struct sysfs_ops ioat_sysfs_ops;
 extern struct ioat_sysfs_entry ioat_version_attr;
 extern struct ioat_sysfs_entry ioat_cap_attr;
 #endif /* IOATDMA_H */
diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index 5376457..5fdedbc 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -137,7 +137,7 @@ static ssize_t edac_dev_ctl_info_store(struct kobject *kobj,
 }
 
 /* edac_dev file operations for an 'ctl_info' */
-static struct sysfs_ops device_ctl_info_ops = {
+static const struct sysfs_ops device_ctl_info_ops = {
 	.show = edac_dev_ctl_info_show,
 	.store = edac_dev_ctl_info_store
 };
@@ -373,7 +373,7 @@ static ssize_t edac_dev_instance_store(struct kobject *kobj,
 }
 
 /* edac_dev file operations for an 'instance' */
-static struct sysfs_ops device_instance_ops = {
+static const struct sysfs_ops device_instance_ops = {
 	.show = edac_dev_instance_show,
 	.store = edac_dev_instance_store
 };
@@ -476,7 +476,7 @@ static ssize_t edac_dev_block_store(struct kobject *kobj,
 }
 
 /* edac_dev file operations for a 'block' */
-static struct sysfs_ops device_block_ops = {
+static const struct sysfs_ops device_block_ops = {
 	.show = edac_dev_block_show,
 	.store = edac_dev_block_store
 };
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index e1d4ce0..88840e9 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -245,7 +245,7 @@ static ssize_t csrowdev_store(struct kobject *kobj, struct attribute *attr,
 	return -EIO;
 }
 
-static struct sysfs_ops csrowfs_ops = {
+static const struct sysfs_ops csrowfs_ops = {
 	.show = csrowdev_show,
 	.store = csrowdev_store
 };
@@ -575,7 +575,7 @@ static ssize_t mcidev_store(struct kobject *kobj, struct attribute *attr,
 }
 
 /* Intermediate show/store table */
-static struct sysfs_ops mci_ops = {
+static const struct sysfs_ops mci_ops = {
 	.show = mcidev_show,
 	.store = mcidev_store
 };
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index fb60a87..bef94e3 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -121,7 +121,7 @@ static ssize_t edac_pci_instance_store(struct kobject *kobj,
 }
 
 /* fs_ops table */
-static struct sysfs_ops pci_instance_ops = {
+static const struct sysfs_ops pci_instance_ops = {
 	.show = edac_pci_instance_show,
 	.store = edac_pci_instance_store
 };
@@ -261,7 +261,7 @@ static ssize_t edac_pci_dev_store(struct kobject *kobj,
 	return -EIO;
 }
 
-static struct sysfs_ops edac_pci_sysfs_ops = {
+static const struct sysfs_ops edac_pci_sysfs_ops = {
 	.show = edac_pci_dev_show,
 	.store = edac_pci_dev_store
 };
diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 9e4f59d..110e24e 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -122,7 +122,7 @@ edd_attr_show(struct kobject * kobj, struct attribute *attr, char *buf)
 	return ret;
 }
 
-static struct sysfs_ops edd_attr_ops = {
+static const struct sysfs_ops edd_attr_ops = {
 	.show = edd_attr_show,
 };
 
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index f4f709d..082f06e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -362,7 +362,7 @@ static ssize_t efivar_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops efivar_attr_ops = {
+static const struct sysfs_ops efivar_attr_ops = {
 	.show = efivar_attr_show,
 	.store = efivar_attr_store,
 };
diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index f82bcda..e9baeab 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -523,7 +523,7 @@ static ssize_t ibft_show_attribute(struct kobject *kobj,
 	return ret;
 }
 
-static struct sysfs_ops ibft_attr_ops = {
+static const struct sysfs_ops ibft_attr_ops = {
 	.show = ibft_show_attribute,
 };
 
diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 56f9234..8c58c7b 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -74,7 +74,7 @@ static struct attribute *def_attrs[] = {
 	NULL
 };
 
-static struct sysfs_ops memmap_attr_ops = {
+static const struct sysfs_ops memmap_attr_ops = {
 	.show = memmap_attr_show,
 };
 
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index c7320ce..89c38c4 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -128,7 +128,7 @@ static struct attribute *ttm_bo_global_attrs[] = {
 	NULL
 };
 
-static struct sysfs_ops ttm_bo_global_ops = {
+static const struct sysfs_ops ttm_bo_global_ops = {
 	.show = &ttm_bo_global_show
 };
 
diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index f5245c0..eb143e0 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -152,7 +152,7 @@ static struct attribute *ttm_mem_zone_attrs[] = {
 	NULL
 };
 
-static struct sysfs_ops ttm_mem_zone_ops = {
+static const struct sysfs_ops ttm_mem_zone_ops = {
 	.show = &ttm_mem_zone_show,
 	.store = &ttm_mem_zone_store
 };
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 5130fc5..764787e 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3597,7 +3597,7 @@ static ssize_t cm_show_counter(struct kobject *obj, struct attribute *attr,
 		       atomic_long_read(&group->counter[cm_attr->index]));
 }
 
-static struct sysfs_ops cm_counter_ops = {
+static const struct sysfs_ops cm_counter_ops = {
 	.show = cm_show_counter
 };
 
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 158a214..1558bb7 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -79,7 +79,7 @@ static ssize_t port_attr_show(struct kobject *kobj,
 	return port_attr->show(p, port_attr, buf);
 }
 
-static struct sysfs_ops port_sysfs_ops = {
+static const struct sysfs_ops port_sysfs_ops = {
 	.show = port_attr_show
 };
 
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index f91b409..84d2b91 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -75,7 +75,7 @@ static struct attribute *dm_attrs[] = {
 	NULL,
 };
 
-static struct sysfs_ops dm_sysfs_ops = {
+static const struct sysfs_ops dm_sysfs_ops = {
 	.show	= dm_attr_show,
 };
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index a20a71e..fdc1890 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2642,7 +2642,7 @@ static void rdev_free(struct kobject *ko)
 	mdk_rdev_t *rdev = container_of(ko, mdk_rdev_t, kobj);
 	kfree(rdev);
 }
-static struct sysfs_ops rdev_sysfs_ops = {
+static const struct sysfs_ops rdev_sysfs_ops = {
 	.show		= rdev_attr_show,
 	.store		= rdev_attr_store,
 };
@@ -4059,7 +4059,7 @@ static void md_free(struct kobject *ko)
 	kfree(mddev);
 }
 
-static struct sysfs_ops md_sysfs_ops = {
+static const struct sysfs_ops md_sysfs_ops = {
 	.show	= md_attr_show,
 	.store	= md_attr_store,
 };
diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index a866939..50715b4 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -1577,7 +1577,7 @@ static struct attribute * veth_pool_attrs[] = {
 	NULL,
 };
 
-static struct sysfs_ops veth_pool_ops = {
+static const struct sysfs_ops veth_pool_ops = {
 	.show   = veth_pool_show,
 	.store  = veth_pool_store,
 };
diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
index 16c9191..3fa4677 100644
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -384,7 +384,7 @@ static struct attribute *veth_cnx_default_attrs[] = {
 	NULL
 };
 
-static struct sysfs_ops veth_cnx_sysfs_ops = {
+static const struct sysfs_ops veth_cnx_sysfs_ops = {
 		.show = veth_cnx_attribute_show
 };
 
@@ -441,7 +441,7 @@ static struct attribute *veth_port_default_attrs[] = {
 	NULL
 };
 
-static struct sysfs_ops veth_port_sysfs_ops = {
+static const struct sysfs_ops veth_port_sysfs_ops = {
 	.show = veth_port_attribute_show
 };
 
diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index 0bc5d47..1062b8f 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -481,7 +481,7 @@ pdcspath_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops pdcspath_attr_ops = {
+static const struct sysfs_ops pdcspath_attr_ops = {
 	.show = pdcspath_attr_show,
 	.store = pdcspath_attr_store,
 };
diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 6151389..0a894ef 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -73,7 +73,7 @@ static void legacy_release(struct kobject *kobj)
 }
 
 static struct kobj_type legacy_ktype = {
-	.sysfs_ops = &(struct sysfs_ops){
+	.sysfs_ops = &(const struct sysfs_ops){
 		.store = legacy_store, .show = legacy_show
 	},
 	.release = &legacy_release,
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 49c9e6c..f75a44d 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -29,7 +29,7 @@ static ssize_t pci_slot_attr_store(struct kobject *kobj,
 	return attribute->store ? attribute->store(slot, buf, len) : -EIO;
 }
 
-static struct sysfs_ops pci_slot_sysfs_ops = {
+static const struct sysfs_ops pci_slot_sysfs_ops = {
 	.show = pci_slot_attr_show,
 	.store = pci_slot_attr_store,
 };
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index e941367..4de382a 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -129,7 +129,7 @@ static ssize_t map_type_show(struct kobject *kobj, struct attribute *attr,
 	return entry->show(mem, buf);
 }
 
-static struct sysfs_ops map_sysfs_ops = {
+static const struct sysfs_ops map_sysfs_ops = {
 	.show = map_type_show,
 };
 
@@ -217,7 +217,7 @@ static ssize_t portio_type_show(struct kobject *kobj, struct attribute *attr,
 	return entry->show(port, buf);
 }
 
-static struct sysfs_ops portio_sysfs_ops = {
+static const struct sysfs_ops portio_sysfs_ops = {
 	.show = portio_type_show,
 };
 
diff --git a/drivers/uwb/wlp/sysfs.c b/drivers/uwb/wlp/sysfs.c
index 0370399..6627c94 100644
--- a/drivers/uwb/wlp/sysfs.c
+++ b/drivers/uwb/wlp/sysfs.c
@@ -615,8 +615,7 @@ ssize_t wlp_wss_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static
-struct sysfs_ops wss_sysfs_ops = {
+static const struct sysfs_ops wss_sysfs_ops = {
 	.show	= wlp_wss_attr_show,
 	.store	= wlp_wss_attr_store,
 };
diff --git a/drivers/video/omap2/dss/manager.c b/drivers/video/omap2/dss/manager.c
index 27d9c46..378f493 100644
--- a/drivers/video/omap2/dss/manager.c
+++ b/drivers/video/omap2/dss/manager.c
@@ -341,7 +341,7 @@ static ssize_t manager_attr_store(struct kobject *kobj, struct attribute *attr,
 	return manager_attr->store(manager, buf, size);
 }
 
-static struct sysfs_ops manager_sysfs_ops = {
+static const struct sysfs_ops manager_sysfs_ops = {
 	.show = manager_attr_show,
 	.store = manager_attr_store,
 };
diff --git a/drivers/video/omap2/dss/overlay.c b/drivers/video/omap2/dss/overlay.c
index b7f9a73..465b141 100644
--- a/drivers/video/omap2/dss/overlay.c
+++ b/drivers/video/omap2/dss/overlay.c
@@ -320,7 +320,7 @@ static ssize_t overlay_attr_store(struct kobject *kobj, struct attribute *attr,
 	return overlay_attr->store(overlay, buf, size);
 }
 
-static struct sysfs_ops overlay_sysfs_ops = {
+static const struct sysfs_ops overlay_sysfs_ops = {
 	.show = overlay_attr_show,
 	.store = overlay_attr_store,
 };
diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
index ae5cb05..bb71ab2 100644
--- a/drivers/xen/sys-hypervisor.c
+++ b/drivers/xen/sys-hypervisor.c
@@ -426,7 +426,7 @@ static ssize_t hyp_sysfs_store(struct kobject *kobj,
 	return 0;
 }
 
-static struct sysfs_ops hyp_sysfs_ops = {
+static const struct sysfs_ops hyp_sysfs_ops = {
 	.show = hyp_sysfs_show,
 	.store = hyp_sysfs_store,
 };
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index a240b6f..4ce16ef 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -164,12 +164,12 @@ static void btrfs_root_release(struct kobject *kobj)
 	complete(&root->kobj_unregister);
 }
 
-static struct sysfs_ops btrfs_super_attr_ops = {
+static const struct sysfs_ops btrfs_super_attr_ops = {
 	.show	= btrfs_super_attr_show,
 	.store	= btrfs_super_attr_store,
 };
 
-static struct sysfs_ops btrfs_root_attr_ops = {
+static const struct sysfs_ops btrfs_root_attr_ops = {
 	.show	= btrfs_root_attr_show,
 	.store	= btrfs_root_attr_store,
 };
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 26a8bd4..f994a7d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -148,7 +148,7 @@ static void lockspace_kobj_release(struct kobject *k)
 	kfree(ls);
 }
 
-static struct sysfs_ops dlm_attr_ops = {
+static const struct sysfs_ops dlm_attr_ops = {
 	.show  = dlm_attr_show,
 	.store = dlm_attr_store,
 };
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 735c20d..af2eb20 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2292,7 +2292,7 @@ static void ext4_sb_release(struct kobject *kobj)
 }
 
 
-static struct sysfs_ops ext4_attr_ops = {
+static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
 	.store	= ext4_attr_store,
 };
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 9be733e..49410d8 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -49,7 +49,7 @@ static ssize_t gfs2_attr_store(struct kobject *kobj, struct attribute *attr,
 	return a->store ? a->store(sdp, buf, len) : len;
 }
 
-static struct sysfs_ops gfs2_attr_ops = {
+static const struct sysfs_ops gfs2_attr_ops = {
 	.show  = gfs2_attr_show,
 	.store = gfs2_attr_store,
 };
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 1cd2934..880b5d2 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -135,7 +135,7 @@ static ssize_t mlog_store(struct kobject *obj, struct attribute *attr,
 	return mlog_mask_store(mlog_attr->mask, buf, count);
 }
 
-static struct sysfs_ops mlog_attr_ops = {
+static const struct sysfs_ops mlog_attr_ops = {
 	.show  = mlog_show,
 	.store = mlog_store,
 };
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 50b725b..ced2299 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -53,7 +53,7 @@ struct sysfs_buffer {
 	size_t			count;
 	loff_t			pos;
 	char			* page;
-	struct sysfs_ops	* ops;
+	const struct sysfs_ops	* ops;
 	struct mutex		mutex;
 	int			needs_read_fill;
 	int			event;
@@ -75,7 +75,7 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_ops * ops = buffer->ops;
+	const struct sysfs_ops * ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
 
@@ -199,7 +199,7 @@ flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_ops * ops = buffer->ops;
+	const struct sysfs_ops * ops = buffer->ops;
 	int rc;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
@@ -335,7 +335,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_buffer *buffer;
-	struct sysfs_ops *ops;
+	const struct sysfs_ops *ops;
 	int error = -EACCES;
 	char *p;
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 57a1eaa..3950d3c 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -106,7 +106,7 @@ extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
 
 struct kobj_type {
 	void (*release)(struct kobject *kobj);
-	struct sysfs_ops *sysfs_ops;
+	const struct sysfs_ops *sysfs_ops;
 	struct attribute **default_attrs;
 };
 
@@ -132,7 +132,7 @@ struct kobj_attribute {
 			 const char *buf, size_t count);
 };
 
-extern struct sysfs_ops kobj_sysfs_ops;
+extern const struct sysfs_ops kobj_sysfs_ops;
 
 /**
  * struct kset - a set of kobjects of a specific type, belonging to a specific subsystem.
diff --git a/kernel/params.c b/kernel/params.c
index ac5de7d..4e27762 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -723,7 +723,7 @@ static ssize_t module_attr_store(struct kobject *kobj,
 	return ret;
 }
 
-static struct sysfs_ops module_sysfs_ops = {
+static const struct sysfs_ops module_sysfs_ops = {
 	.show = module_attr_show,
 	.store = module_attr_store,
 };
diff --git a/lib/kobject.c b/lib/kobject.c
index cecf5a0..8115eb1 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -700,7 +700,7 @@ static ssize_t kobj_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-struct sysfs_ops kobj_sysfs_ops = {
+const struct sysfs_ops kobj_sysfs_ops = {
 	.show	= kobj_attr_show,
 	.store	= kobj_attr_store,
 };
diff --git a/mm/slub.c b/mm/slub.c
index 02b5a83..b98a4f7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4519,7 +4519,7 @@ static void kmem_cache_release(struct kobject *kobj)
 	kfree(s);
 }
 
-static struct sysfs_ops slab_sysfs_ops = {
+static const struct sysfs_ops slab_sysfs_ops = {
 	.show = slab_attr_show,
 	.store = slab_attr_store,
 };
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2114e45..c53bdd9 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -254,7 +254,7 @@ extern void br_ifinfo_notify(int event, struct net_bridge_port *port);
 
 #ifdef CONFIG_SYSFS
 /* br_sysfs_if.c */
-extern struct sysfs_ops brport_sysfs_ops;
+extern const struct sysfs_ops brport_sysfs_ops;
 extern int br_sysfs_addif(struct net_bridge_port *p);
 
 /* br_sysfs_br.c */
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 820643a..ce77fb3 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -220,7 +220,7 @@ static ssize_t brport_store(struct kobject * kobj,
 	return ret;
 }
 
-struct sysfs_ops brport_sysfs_ops = {
+const struct sysfs_ops brport_sysfs_ops = {
 	.show = brport_show,
 	.store = brport_store,
 };
diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index 7c60881..3b126d1 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -87,7 +87,7 @@ static ssize_t foo_attr_store(struct kobject *kobj,
 }
 
 /* Our custom sysfs_ops that we will associate with our ktype later on */
-static struct sysfs_ops foo_sysfs_ops = {
+static const struct sysfs_ops foo_sysfs_ops = {
 	.show = foo_attr_show,
 	.store = foo_attr_store,
 };
-- 
1.7.0.1

