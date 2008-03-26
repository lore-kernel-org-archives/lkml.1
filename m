Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYCZQZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYCZQZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYCZQZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:25:37 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:35912 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYCZQZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:25:34 -0400
Date: Wed, 26 Mar 2008 12:25:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove "#ifdef __KERNEL__" checks from unexported headers.
Message-ID: <alpine.LFD.1.00.0803261217570.30255@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the "#ifdef __KERNEL__" tests from unexported header files in
linux/include whose entire contents are wrapped in that preprocessor
test.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  here's a first pass at getting rid of superfluous tests in
unexported headers in linux/include.  by "first pass," i mean that
this patch affects only those header files whose *entire* contents
were wrapped in that test -- it's what i call the "no-brainer" pass.

  there are certainly more unexported headers that test __KERNEL__ in
some respect, but if a header file had so much as a single line
outside of the __KERNEL__ test, i left it alone, as i'm thinking of
david w's advice that, rather than blindly toss stuff, look at it to
see if it can be segregated more intelligently.  so if a file had
*any* content both inside and outside of the __KERNEL__ test, i just
left it where it was.  for now.

  compile tested with "make defconfig" on x86.  and, obviously, this
can't possibly make any difference to what gets exported to userspace.
theoretically.  :-)

  and, no, i'm not doing this on a subsystem-by-subsystem basis.
life's way too short for that.


 include/linux/agp_backend.h      |    3 ---
 include/linux/cdev.h             |    2 --
 include/linux/coda_fs_i.h        |    2 --
 include/linux/concap.h           |    3 +--
 include/linux/configfs.h         |    4 ----
 include/linux/crc-ccitt.h        |    2 --
 include/linux/dcache.h           |    4 ----
 include/linux/device-mapper.h    |    3 ---
 include/linux/eventfd.h          |    5 -----
 include/linux/fsl_devices.h      |    2 --
 include/linux/fsnotify.h         |    4 ----
 include/linux/hw_random.h        |    2 --
 include/linux/i2o.h              |    3 ---
 include/linux/if_macvlan.h       |    3 ---
 include/linux/inet.h             |    2 --
 include/linux/isicom.h           |    7 -------
 include/linux/kfifo.h            |    5 -----
 include/linux/kobj_map.h         |    4 ----
 include/linux/kobject.h          |    3 ---
 include/linux/kref.h             |    3 ---
 include/linux/list.h             |    5 -----
 include/linux/mmzone.h           |    2 --
 include/linux/mount.h            |    2 --
 include/linux/ncp_fs_i.h         |    4 ----
 include/linux/of_device.h        |    2 --
 include/linux/pm.h               |    4 ----
 include/linux/pnp.h              |    4 ----
 include/linux/pnpbios.h          |    4 ----
 include/linux/profile.h          |    4 ----
 include/linux/rcuclassic.h       |    3 ---
 include/linux/rcupdate.h         |    3 ---
 include/linux/rcupreempt.h       |    3 ---
 include/linux/rcupreempt_trace.h |    2 --
 include/linux/rio.h              |    3 ---
 include/linux/rio_drv.h          |    3 ---
 include/linux/rwsem.h            |    3 ---
 include/linux/seq_file.h         |    2 --
 include/linux/slab.h             |    3 ---
 include/linux/smb_fs_i.h         |    2 --
 include/linux/smb_fs_sb.h        |    4 ----
 include/linux/svga.h             |    3 ---
 include/linux/textsearch.h       |    4 ----
 42 files changed, 1 insertion(+), 134 deletions(-)

diff --git a/include/linux/agp_backend.h b/include/linux/agp_backend.h
index 03e3454..661d90d 100644
--- a/include/linux/agp_backend.h
+++ b/include/linux/agp_backend.h
@@ -30,8 +30,6 @@
 #ifndef _AGP_BACKEND_H
 #define _AGP_BACKEND_H 1

-#ifdef __KERNEL__
-
 #ifndef TRUE
 #define TRUE 1
 #endif
@@ -111,5 +109,4 @@ extern struct agp_bridge_data *agp_backend_acquire(struct pci_dev *);
 extern void agp_backend_release(struct agp_bridge_data *);
 extern void agp_flush_chipset(struct agp_bridge_data *);

-#endif				/* __KERNEL__ */
 #endif				/* _AGP_BACKEND_H */
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index 1e29b13..fb45919 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -1,6 +1,5 @@
 #ifndef _LINUX_CDEV_H
 #define _LINUX_CDEV_H
-#ifdef __KERNEL__

 #include <linux/kobject.h>
 #include <linux/kdev_t.h>
@@ -34,4 +33,3 @@ void cd_forget(struct inode *);
 extern struct backing_dev_info directly_mappable_cdev_bdi;

 #endif
-#endif
diff --git a/include/linux/coda_fs_i.h b/include/linux/coda_fs_i.h
index 424fe9c..b3ef0c4 100644
--- a/include/linux/coda_fs_i.h
+++ b/include/linux/coda_fs_i.h
@@ -8,7 +8,6 @@
 #ifndef _LINUX_CODA_FS_I
 #define _LINUX_CODA_FS_I

-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/coda.h>
@@ -52,4 +51,3 @@ struct inode *coda_fid_to_inode(struct CodaFid *fid, struct super_block *sb);
 void coda_replace_fid(struct inode *, struct CodaFid *, struct CodaFid *);

 #endif
-#endif
diff --git a/include/linux/concap.h b/include/linux/concap.h
index 2730465..977acb3 100644
--- a/include/linux/concap.h
+++ b/include/linux/concap.h
@@ -8,7 +8,7 @@

 #ifndef _LINUX_CONCAP_H
 #define _LINUX_CONCAP_H
-#ifdef __KERNEL__
+
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>

@@ -110,4 +110,3 @@ extern int concap_nop(struct concap_proto *cprot);
  */
 extern int concap_drop_skb(struct concap_proto *cprot, struct sk_buff *skb);
 #endif
-#endif
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 4b287ad..3ae65b1 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -35,8 +35,6 @@
 #ifndef _CONFIGFS_H_
 #define _CONFIGFS_H_

-#ifdef __KERNEL__
-
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/list.h>
@@ -194,6 +192,4 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 int configfs_depend_item(struct configfs_subsystem *subsys, struct config_item *target);
 void configfs_undepend_item(struct configfs_subsystem *subsys, struct config_item *target);

-#endif  /* __KERNEL__ */
-
 #endif /* _CONFIGFS_H_ */
diff --git a/include/linux/crc-ccitt.h b/include/linux/crc-ccitt.h
index 9003761..f52696a 100644
--- a/include/linux/crc-ccitt.h
+++ b/include/linux/crc-ccitt.h
@@ -1,6 +1,5 @@
 #ifndef _LINUX_CRC_CCITT_H
 #define _LINUX_CRC_CCITT_H
-#ifdef __KERNEL__

 #include <linux/types.h>

@@ -13,5 +12,4 @@ static inline u16 crc_ccitt_byte(u16 crc, const u8 c)
 	return (crc >> 8) ^ crc_ccitt_table[(crc ^ c) & 0xff];
 }

-#endif /* __KERNEL__ */
 #endif /* _LINUX_CRC_CCITT_H */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 6bd6460..96c8623 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -1,8 +1,6 @@
 #ifndef __LINUX_DCACHE_H
 #define __LINUX_DCACHE_H

-#ifdef __KERNEL__
-
 #include <asm/atomic.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -364,6 +362,4 @@ extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);

 extern int sysctl_vfs_cache_pressure;

-#endif /* __KERNEL__ */
-
 #endif	/* __LINUX_DCACHE_H */
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index cb78457..149e09a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -8,8 +8,6 @@
 #ifndef _LINUX_DEVICE_MAPPER_H
 #define _LINUX_DEVICE_MAPPER_H

-#ifdef __KERNEL__
-
 struct dm_target;
 struct dm_table;
 struct dm_dev;
@@ -256,5 +254,4 @@ int dm_swap_table(struct mapped_device *md, struct dm_table *t);
  */
 int dm_create_error_table(struct dm_table **result, struct mapped_device *md);

-#endif	/* __KERNEL__ */
 #endif	/* _LINUX_DEVICE_MAPPER_H */
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index b489fc6..a701399 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -8,9 +8,6 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H

-
-#ifdef __KERNEL__
-
 #ifdef CONFIG_EVENTFD

 struct file *eventfd_fget(int fd);
@@ -24,7 +21,5 @@ static inline int eventfd_signal(struct file *file, int n)

 #endif /* CONFIG_EVENTFD */

-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_EVENTFD_H */

diff --git a/include/linux/fsl_devices.h b/include/linux/fsl_devices.h
index 1831b19..049f62c 100644
--- a/include/linux/fsl_devices.h
+++ b/include/linux/fsl_devices.h
@@ -14,7 +14,6 @@
  * option) any later version.
  */

-#ifdef __KERNEL__
 #ifndef _FSL_DEVICE_H_
 #define _FSL_DEVICE_H_

@@ -127,4 +126,3 @@ struct mpc8xx_pcmcia_ops {
 };

 #endif /* _FSL_DEVICE_H_ */
-#endif /* __KERNEL__ */
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index d4b7c4a..a895131 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -11,8 +11,6 @@
  * (C) Copyright 2005 Robert Love
  */

-#ifdef __KERNEL__
-
 #include <linux/dnotify.h>
 #include <linux/inotify.h>
 #include <linux/audit.h>
@@ -296,6 +294,4 @@ static inline void fsnotify_oldname_free(const char *old_name)

 #endif	/* ! CONFIG_INOTIFY */

-#endif	/* __KERNEL__ */
-
 #endif	/* _LINUX_FS_NOTIFY_H */
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 4213182..f397cf4 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -11,7 +11,6 @@

 #ifndef LINUX_HWRANDOM_H_
 #define LINUX_HWRANDOM_H_
-#ifdef __KERNEL__

 #include <linux/types.h>
 #include <linux/list.h>
@@ -54,5 +53,4 @@ static inline void hwrng_unregister_suspended(struct hwrng *rng)
 	__hwrng_unregister(rng, true);
 }

-#endif /* __KERNEL__ */
 #endif /* LINUX_HWRANDOM_H_ */
diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 7da5b98..57b26d7 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -18,8 +18,6 @@
 #ifndef _I2O_H
 #define _I2O_H

-#ifdef __KERNEL__		/* This file to be included by kernel only */
-
 #include <linux/i2o-dev.h>

 /* How many different OSM's are we allowing */
@@ -1260,5 +1258,4 @@ extern void i2o_dump_message(struct i2o_message *);
 extern void i2o_dump_hrt(struct i2o_controller *c);
 extern void i2o_debug_state(struct i2o_controller *c);

-#endif				/* __KERNEL__ */
 #endif				/* _I2O_H */
diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index 0d9d7ea..5f200ba 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -1,9 +1,6 @@
 #ifndef _LINUX_IF_MACVLAN_H
 #define _LINUX_IF_MACVLAN_H

-#ifdef __KERNEL__
-
 extern struct sk_buff *(*macvlan_handle_frame_hook)(struct sk_buff *);

-#endif /* __KERNEL__ */
 #endif /* _LINUX_IF_MACVLAN_H */
diff --git a/include/linux/inet.h b/include/linux/inet.h
index 675a7db..1354080 100644
--- a/include/linux/inet.h
+++ b/include/linux/inet.h
@@ -42,11 +42,9 @@
 #ifndef _LINUX_INET_H
 #define _LINUX_INET_H

-#ifdef __KERNEL__
 #include <linux/types.h>

 extern __be32 in_aton(const char *str);
 extern int in4_pton(const char *src, int srclen, u8 *dst, int delim, const char **end);
 extern int in6_pton(const char *src, int srclen, u8 *dst, int delim, const char **end);
-#endif
 #endif	/* _LINUX_INET_H */
diff --git a/include/linux/isicom.h b/include/linux/isicom.h
index 8f4c717..bbd4219 100644
--- a/include/linux/isicom.h
+++ b/include/linux/isicom.h
@@ -1,11 +1,6 @@
 #ifndef _LINUX_ISICOM_H
 #define _LINUX_ISICOM_H

-/*#define		ISICOM_DEBUG*/
-/*#define		ISICOM_DEBUG_DTR_RTS*/
-
-#ifdef __KERNEL__
-
 #define		YES	1
 #define		NO	0

@@ -85,6 +80,4 @@

 #define		ISI_TXOK		0x0001

-#endif	/*	__KERNEL__	*/
-
 #endif	/*	ISICOM_H	*/
diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 404f446..29f62e1 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -21,8 +21,6 @@
 #ifndef _LINUX_KFIFO_H
 #define _LINUX_KFIFO_H

-#ifdef __KERNEL__
-
 #include <linux/kernel.h>
 #include <linux/spinlock.h>

@@ -151,7 +149,4 @@ static inline unsigned int kfifo_len(struct kfifo *fifo)
 	return ret;
 }

-#else
-#warning "don't include kernel headers in userspace"
-#endif /* __KERNEL__ */
 #endif
diff --git a/include/linux/kobj_map.h b/include/linux/kobj_map.h
index bafe178..73717ed 100644
--- a/include/linux/kobj_map.h
+++ b/include/linux/kobj_map.h
@@ -1,5 +1,3 @@
-#ifdef __KERNEL__
-
 #include <linux/mutex.h>

 typedef struct kobject *kobj_probe_t(dev_t, int *, void *);
@@ -10,5 +8,3 @@ int kobj_map(struct kobj_map *, dev_t, unsigned long, struct module *,
 void kobj_unmap(struct kobj_map *, dev_t, unsigned long);
 struct kobject *kobj_lookup(struct kobj_map *, dev_t, int *);
 struct kobj_map *kobj_map_init(kobj_probe_t *, struct mutex *);
-
-#endif
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index caa3f41..39e709f 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -16,8 +16,6 @@
 #ifndef _KOBJECT_H_
 #define _KOBJECT_H_

-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/sysfs.h>
@@ -224,5 +222,4 @@ static inline int kobject_action_type(const char *buf, size_t count,
 { return -EINVAL; }
 #endif

-#endif /* __KERNEL__ */
 #endif /* _KOBJECT_H_ */
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 5d18563..0cef6ba 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -15,8 +15,6 @@
 #ifndef _KREF_H_
 #define _KREF_H_

-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <asm/atomic.h>

@@ -29,5 +27,4 @@ void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));

-#endif /* __KERNEL__ */
 #endif /* _KREF_H_ */
diff --git a/include/linux/list.h b/include/linux/list.h
index 75ce2cb..e1e75b0 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_LIST_H
 #define _LINUX_LIST_H

-#ifdef __KERNEL__
-
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/prefetch.h>
@@ -991,7 +989,4 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)

-#else
-#warning "don't include kernel headers in userspace"
-#endif /* __KERNEL__ */
 #endif
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8d8d197..5d7a8e0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_MMZONE_H
 #define _LINUX_MMZONE_H

-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__

 #include <linux/spinlock.h>
@@ -940,5 +939,4 @@ unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
 #endif

 #endif /* !__ASSEMBLY__ */
-#endif /* __KERNEL__ */
 #endif /* _LINUX_MMZONE_H */
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 6d3047d..6a94153 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -10,7 +10,6 @@
  */
 #ifndef _LINUX_MOUNT_H
 #define _LINUX_MOUNT_H
-#ifdef __KERNEL__

 #include <linux/types.h>
 #include <linux/list.h>
@@ -103,5 +102,4 @@ extern void shrink_submounts(struct vfsmount *mountpoint, struct list_head *moun
 extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);

-#endif
 #endif /* _LINUX_MOUNT_H */
diff --git a/include/linux/ncp_fs_i.h b/include/linux/ncp_fs_i.h
index bdb4c8a..4b0bec4 100644
--- a/include/linux/ncp_fs_i.h
+++ b/include/linux/ncp_fs_i.h
@@ -8,8 +8,6 @@
 #ifndef _LINUX_NCP_FS_I
 #define _LINUX_NCP_FS_I

-#ifdef __KERNEL__
-
 /*
  * This is the ncpfs part of the inode structure. This must contain
  * all the information we need to work with an inode after creation.
@@ -28,6 +26,4 @@ struct ncp_inode_info {
 	struct inode vfs_inode;
 };

-#endif	/* __KERNEL__ */
-
 #endif	/* _LINUX_NCP_FS_I */
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 6dc1195..afe3382 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -1,6 +1,5 @@
 #ifndef _LINUX_OF_DEVICE_H
 #define _LINUX_OF_DEVICE_H
-#ifdef __KERNEL__

 #include <linux/device.h>
 #include <linux/of.h>
@@ -25,5 +24,4 @@ static inline void of_device_free(struct of_device *dev)
 	of_release_dev(&dev->dev);
 }

-#endif /* __KERNEL__ */
 #endif /* _LINUX_OF_DEVICE_H */
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 015b735..9ec4beb 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -21,8 +21,6 @@
 #ifndef _LINUX_PM_H
 #define _LINUX_PM_H

-#ifdef __KERNEL__
-
 #include <linux/list.h>
 #include <asm/atomic.h>
 #include <asm/errno.h>
@@ -262,6 +260,4 @@ extern unsigned int	pm_flags;
 #define PM_APM	1
 #define PM_ACPI	2

-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_PM_H */
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 29dd558..a317684 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -6,8 +6,6 @@
 #ifndef _LINUX_PNP_H
 #define _LINUX_PNP_H

-#ifdef __KERNEL__
-
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/errno.h>
@@ -466,6 +464,4 @@ static inline void pnp_unregister_driver(struct pnp_driver *drv) { }
 #define pnp_dbg(format, arg...) do {} while (0)
 #endif

-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_PNP_H */
diff --git a/include/linux/pnpbios.h b/include/linux/pnpbios.h
index 329192a..4e2391f 100644
--- a/include/linux/pnpbios.h
+++ b/include/linux/pnpbios.h
@@ -23,8 +23,6 @@
 #ifndef _LINUX_PNPBIOS_H
 #define _LINUX_PNPBIOS_H

-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/pnp.h>

@@ -146,6 +144,4 @@ extern int pnp_bios_dock_station_info(struct pnp_docking_station_info *data);

 #endif /* CONFIG_PNPBIOS */

-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_PNPBIOS_H */
diff --git a/include/linux/profile.h b/include/linux/profile.h
index ff576d1..05c1cc7 100644
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_PROFILE_H
 #define _LINUX_PROFILE_H

-#ifdef __KERNEL__
-
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/cpumask.h>
@@ -118,6 +116,4 @@ static inline void unregister_timer_hook(int (*hook)(struct pt_regs *))

 #endif /* CONFIG_PROFILING */

-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_PROFILE_H */
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index b3dccd6..b3aa05b 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -33,8 +33,6 @@
 #ifndef __LINUX_RCUCLASSIC_H
 #define __LINUX_RCUCLASSIC_H

-#ifdef __KERNEL__
-
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -163,5 +161,4 @@ extern long rcu_batches_completed_bh(void);
 #define rcu_enter_nohz()	do { } while (0)
 #define rcu_exit_nohz()		do { } while (0)

-#endif /* __KERNEL__ */
 #endif /* __LINUX_RCUCLASSIC_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 37a642c..8082d65 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -33,8 +33,6 @@
 #ifndef __LINUX_RCUPDATE_H
 #define __LINUX_RCUPDATE_H

-#ifdef __KERNEL__
-
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -245,5 +243,4 @@ extern long rcu_batches_completed_bh(void);
 extern void rcu_init(void);
 extern int rcu_needs_cpu(int cpu);

-#endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index d038aa6..8a05c7e 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -33,8 +33,6 @@
 #ifndef __LINUX_RCUPREEMPT_H
 #define __LINUX_RCUPREEMPT_H

-#ifdef __KERNEL__
-
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -104,5 +102,4 @@ static inline void rcu_exit_nohz(void)
 #define rcu_exit_nohz()		do { } while (0)
 #endif /* CONFIG_NO_HZ */

-#endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPREEMPT_H */
diff --git a/include/linux/rcupreempt_trace.h b/include/linux/rcupreempt_trace.h
index 21cd6b2..b99ae07 100644
--- a/include/linux/rcupreempt_trace.h
+++ b/include/linux/rcupreempt_trace.h
@@ -32,7 +32,6 @@
 #ifndef __LINUX_RCUPREEMPT_TRACE_H
 #define __LINUX_RCUPREEMPT_TRACE_H

-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/kernel.h>

@@ -95,5 +94,4 @@ extern void rcupreempt_trace_done_remove(struct rcupreempt_trace *trace);
 extern void rcupreempt_trace_invoke(struct rcupreempt_trace *trace);
 extern void rcupreempt_trace_next_add(struct rcupreempt_trace *trace);

-#endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPREEMPT_TRACE_H */
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 68e3f68..78ea9ef 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -14,8 +14,6 @@
 #ifndef LINUX_RIO_H
 #define LINUX_RIO_H

-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
@@ -321,5 +319,4 @@ extern void rio_close_inb_mbox(struct rio_mport *, int);
 extern int rio_open_outb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_outb_mbox(struct rio_mport *, int);

-#endif				/* __KERNEL__ */
 #endif				/* LINUX_RIO_H */
diff --git a/include/linux/rio_drv.h b/include/linux/rio_drv.h
index 7adb2a1..90987b7 100644
--- a/include/linux/rio_drv.h
+++ b/include/linux/rio_drv.h
@@ -13,8 +13,6 @@
 #ifndef LINUX_RIO_DRV_H
 #define LINUX_RIO_DRV_H

-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
@@ -465,5 +463,4 @@ extern struct rio_dev *rio_get_device(u16 vid, u16 did, struct rio_dev *from);
 extern struct rio_dev *rio_get_asm(u16 vid, u16 did, u16 asm_vid, u16 asm_did,
 				   struct rio_dev *from);

-#endif				/* __KERNEL__ */
 #endif				/* LINUX_RIO_DRV_H */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 7b524b4..efd348f 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -9,8 +9,6 @@

 #include <linux/linkage.h>

-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <asm/system.h>
@@ -90,5 +88,4 @@ extern void up_read_non_owner(struct rw_semaphore *sem);
 # define up_read_non_owner(sem)			up_read(sem)
 #endif

-#endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_H */
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 67c2563..676440e 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -1,6 +1,5 @@
 #ifndef _LINUX_SEQ_FILE_H
 #define _LINUX_SEQ_FILE_H
-#ifdef __KERNEL__

 #include <linux/types.h>
 #include <linux/string.h>
@@ -76,4 +75,3 @@ static inline struct net *seq_file_net(struct seq_file *seq)
 }

 #endif
-#endif
diff --git a/include/linux/slab.h b/include/linux/slab.h
index f62caaa..986f26e 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -9,8 +9,6 @@
 #ifndef _LINUX_SLAB_H
 #define	_LINUX_SLAB_H

-#ifdef __KERNEL__
-
 #include <linux/gfp.h>
 #include <linux/types.h>

@@ -276,5 +274,4 @@ extern const struct seq_operations slabinfo_op;
 ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
 #endif

-#endif	/* __KERNEL__ */
 #endif	/* _LINUX_SLAB_H */
diff --git a/include/linux/smb_fs_i.h b/include/linux/smb_fs_i.h
index 8516954..8ccf4ec 100644
--- a/include/linux/smb_fs_i.h
+++ b/include/linux/smb_fs_i.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_SMB_FS_I
 #define _LINUX_SMB_FS_I

-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/fs.h>

@@ -36,4 +35,3 @@ struct smb_inode_info {
 };

 #endif
-#endif
diff --git a/include/linux/smb_fs_sb.h b/include/linux/smb_fs_sb.h
index 3aa97aa..8a060a7 100644
--- a/include/linux/smb_fs_sb.h
+++ b/include/linux/smb_fs_sb.h
@@ -9,8 +9,6 @@
 #ifndef _SMB_FS_SB
 #define _SMB_FS_SB

-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/smb.h>

@@ -96,6 +94,4 @@ smb_unlock_server(struct smb_sb_info *server)
 	up(&(server->sem));
 }

-#endif /* __KERNEL__ */
-
 #endif
diff --git a/include/linux/svga.h b/include/linux/svga.h
index 13ad0b8..c59a51a 100644
--- a/include/linux/svga.h
+++ b/include/linux/svga.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_SVGA_H
 #define _LINUX_SVGA_H

-#ifdef __KERNEL__
-
 #include <linux/pci.h>
 #include <video/vga.h>

@@ -122,6 +120,5 @@ void svga_set_timings(const struct svga_timing_regs *tm, struct fb_var_screeninf

 int svga_match_format(const struct svga_fb_format *frm, struct fb_var_screeninfo *var, struct fb_fix_screeninfo *fix);

-#endif /* __KERNEL__  */
 #endif /* _LINUX_SVGA_H */

diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index 004808a..6f371f2 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -1,8 +1,6 @@
 #ifndef __LINUX_TEXTSEARCH_H
 #define __LINUX_TEXTSEARCH_H

-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
@@ -177,6 +175,4 @@ static inline void *ts_config_priv(struct ts_config *conf)
 	return ((u8 *) conf + TS_PRIV_ALIGN(sizeof(struct ts_config)));
 }

-#endif /* __KERNEL__ */
-
 #endif

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
