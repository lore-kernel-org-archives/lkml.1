Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYCaKZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYCaKZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYCaKZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:25:39 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40814 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbYCaKZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:25:37 -0400
Date: Mon, 31 Mar 2008 06:25:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Pass two of removing "__KERNEL__" tests from unexported
 headers.
Message-ID: <alpine.LFD.1.00.0803310619240.20975@localhost.localdomain>
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


This is the second pass of removing superfluous "__KERNEL__"
preprocessor tests from headers under include/linux that aren't
exported to userspace.  The first pass (the "no-brainer" pass) dealt
with headers whose *entire* contents were wrapped in a __KERNEL__
test, while this pass goes on to handle those headers that had at
least a *little* content outside of the __KERNEL__ tests.  (Thus,
there is no overlap between the patches.)

This pass doesn't deal with any of the ext*.h or jbd*.h headers, since
those headers had a little too much __KERNEL__ testing for my comfort
level.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  compile tested after "make defconfig" on x86.

 include/linux/a.out.h           |    8 --------
 include/linux/arcdevice.h       |    3 ---
 include/linux/bitops.h          |    2 --
 include/linux/blktrace_api.h    |    2 --
 include/linux/bsg.h             |    4 ----
 include/linux/compiler.h        |    7 -------
 include/linux/cyclomx.h         |    4 ----
 include/linux/dio.h             |    3 ---
 include/linux/dnotify.h         |    5 -----
 include/linux/etherdevice.h     |    3 ---
 include/linux/fcdevice.h        |    2 --
 include/linux/fddidevice.h      |    2 --
 include/linux/hid.h             |    3 ---
 include/linux/hidraw.h          |    6 ------
 include/linux/hippidevice.h     |    3 ---
 include/linux/inetdevice.h      |    4 ----
 include/linux/isapnp.h          |    3 ---
 include/linux/ivtv.h            |    4 ----
 include/linux/ivtvfb.h          |    4 ----
 include/linux/key.h             |    3 ---
 include/linux/kvm_para.h        |    2 --
 include/linux/mc146818rtc.h     |    2 --
 include/linux/mm.h              |    3 ---
 include/linux/mnt_namespace.h   |    2 --
 include/linux/ncp_fs_sb.h       |    4 ----
 include/linux/notifier.h        |    3 ---
 include/linux/phonedev.h        |    3 ---
 include/linux/ppp_channel.h     |    2 --
 include/linux/reiserfs_fs_sb.h  |    2 --
 include/linux/rwsem-spinlock.h  |    3 ---
 include/linux/sctp.h            |    2 --
 include/linux/skbuff.h          |    6 +-----
 include/linux/sony-laptop.h     |    4 ----
 include/linux/swap.h            |    3 ---
 include/linux/thread_info.h     |    4 ----
 include/linux/trdevice.h        |    3 ---
 include/linux/usb.h             |    4 ----
 include/linux/virtio_console.h  |    2 --
 include/linux/virtio_ring.h     |    3 +--
 include/linux/zorro.h           |    5 -----
 41 files changed, 2 insertions(+), 150 deletions(-)

diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index 208f4e8..d1c6b15 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -132,20 +132,12 @@ enum machine_type {
 #endif

 #ifdef linux
-#ifdef __KERNEL__
 #include <asm/page.h>
-#else
-#include <unistd.h>
-#endif
 #if defined(__i386__) || defined(__mc68000__)
 #define SEGMENT_SIZE	1024
 #else
 #ifndef SEGMENT_SIZE
-#ifdef __KERNEL__
 #define SEGMENT_SIZE	PAGE_SIZE
-#else
-#define SEGMENT_SIZE   getpagesize()
-#endif
 #endif
 #endif
 #endif
diff --git a/include/linux/arcdevice.h b/include/linux/arcdevice.h
index fde6758..49dec4c 100644
--- a/include/linux/arcdevice.h
+++ b/include/linux/arcdevice.h
@@ -19,8 +19,6 @@
 #include <asm/timex.h>
 #include <linux/if_arcnet.h>

-#ifdef __KERNEL__
-
 #ifndef bool
 #define bool int
 #endif
@@ -337,5 +335,4 @@ void arcnet_unregister_proto(struct ArcProto *proto);
 irqreturn_t arcnet_interrupt(int irq, void *dev_id);
 struct net_device *alloc_arcdev(char *name);

-#endif				/* __KERNEL__ */
 #endif				/* _LINUX_ARCDEVICE_H */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 40d5473..ef4fcab 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -2,13 +2,11 @@
 #define _LINUX_BITOPS_H
 #include <asm/types.h>

-#ifdef	__KERNEL__
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
 #define BITS_PER_BYTE		8
-#endif

 /*
  * Include this here because some architectures need generic_ffs/fls in
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index cfc3147..8edbd34 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -142,7 +142,6 @@ struct blk_user_trace_setup {
 	u32 pid;
 };

-#ifdef __KERNEL__
 #if defined(CONFIG_BLK_DEV_IO_TRACE)
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
 extern void blk_trace_shutdown(struct request_queue *);
@@ -300,5 +299,4 @@ extern int blk_trace_remove(struct request_queue *q);
 #define blk_trace_startstop(q, start)		(-ENOTTY)
 #define blk_trace_remove(q)			(-ENOTTY)
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
-#endif /* __KERNEL__ */
 #endif
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 60e377b..ab6280c 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -51,8 +51,6 @@ struct sg_io_v4 {
 	__u32 padding;
 };

-#ifdef __KERNEL__
-
 #if defined(CONFIG_BLK_DEV_BSG)
 struct bsg_class_device {
 	struct class_device *class_dev;
@@ -73,6 +71,4 @@ static inline void bsg_unregister_queue(struct request_queue *rq)
 }
 #endif

-#endif /* __KERNEL__ */
-
 #endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index dcae0c8..ef722c7 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -34,8 +34,6 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __cond_lock(x,c) (c)
 #endif

-#ifdef __KERNEL__
-
 #if __GNUC__ >= 4
 # include <linux/compiler-gcc4.h>
 #elif __GNUC__ == 3 && __GNUC_MINOR__ >= 2
@@ -72,11 +70,8 @@ extern void __chk_io_ptr(const volatile void __iomem *);
     (typeof(ptr)) (__ptr + (off)); })
 #endif

-#endif /* __KERNEL__ */
-
 #endif /* __ASSEMBLY__ */

-#ifdef __KERNEL__
 /*
  * Allow us to mark functions as 'deprecated' and have gcc emit a nice
  * warning for each use, in hopes of speeding the functions removal.
@@ -148,8 +143,6 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #define __always_inline inline
 #endif

-#endif /* __KERNEL__ */
-
 /*
  * From the GCC manual:
  *
diff --git a/include/linux/cyclomx.h b/include/linux/cyclomx.h
index b88f7f4..2e882c6 100644
--- a/include/linux/cyclomx.h
+++ b/include/linux/cyclomx.h
@@ -27,9 +27,6 @@
 #include <linux/wanrouter.h>
 #include <linux/spinlock.h>

-#ifdef	__KERNEL__
-/* Kernel Interface */
-
 #include <linux/cycx_drv.h>	/* Cyclom 2X support module API definitions */
 #include <linux/cycx_cfm.h>	/* Cyclom 2X firmware module definitions */
 #ifdef CONFIG_CYCLOMX_X25
@@ -73,5 +70,4 @@ void cycx_set_state(struct cycx_device *card, int state);
 #ifdef CONFIG_CYCLOMX_X25
 int cycx_x25_wan_init(struct cycx_device *card, wandev_conf_t *conf);
 #endif
-#endif	/* __KERNEL__ */
 #endif	/* _CYCLOMX_H */
diff --git a/include/linux/dio.h b/include/linux/dio.h
index 1e65ebc..b6c9e79 100644
--- a/include/linux/dio.h
+++ b/include/linux/dio.h
@@ -31,8 +31,6 @@

 #include <linux/device.h>

-#ifdef __KERNEL__
-
 #include <asm/hp300hw.h>

 typedef __u16 dio_id;
@@ -276,5 +274,4 @@ static inline void dio_set_drvdata (struct dio_dev *d, void *data)
 	dev_set_drvdata(&d->dev, data);
 }

-#endif /* __KERNEL__ */
 #endif /* ndef _LINUX_DIO_H */
diff --git a/include/linux/dnotify.h b/include/linux/dnotify.h
index 102a902..d9af8c3 100644
--- a/include/linux/dnotify.h
+++ b/include/linux/dnotify.h
@@ -16,9 +16,6 @@ struct dnotify_struct {
 	fl_owner_t		dn_owner;
 };

-#ifdef __KERNEL__
-
-
 #ifdef CONFIG_DNOTIFY

 extern void __inode_dir_notify(struct inode *, unsigned long);
@@ -57,6 +54,4 @@ static inline void inode_dir_notify(struct inode *inode, unsigned long event)

 #endif /* CONFIG_DNOTIFY */

-#endif /* __KERNEL __ */
-
 #endif /* _LINUX_DNOTIFY_H */
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 25d62e6..96396c2 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -28,7 +28,6 @@
 #include <linux/netdevice.h>
 #include <linux/random.h>

-#ifdef __KERNEL__
 extern __be16		eth_type_trans(struct sk_buff *skb, struct net_device *dev);
 extern const struct header_ops eth_header_ops;

@@ -136,6 +135,4 @@ static inline unsigned compare_ether_addr(const u8 *addr1, const u8 *addr2)
 	BUILD_BUG_ON(ETH_ALEN != 6);
 	return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) != 0;
 }
-#endif	/* __KERNEL__ */
-
 #endif	/* _LINUX_ETHERDEVICE_H */
diff --git a/include/linux/fcdevice.h b/include/linux/fcdevice.h
index e460ef8..8263b5c 100644
--- a/include/linux/fcdevice.h
+++ b/include/linux/fcdevice.h
@@ -26,8 +26,6 @@

 #include <linux/if_fc.h>

-#ifdef __KERNEL__
 extern struct net_device *alloc_fcdev(int sizeof_priv);
-#endif

 #endif	/* _LINUX_FCDEVICE_H */
diff --git a/include/linux/fddidevice.h b/include/linux/fddidevice.h
index e61e42d..5fae307 100644
--- a/include/linux/fddidevice.h
+++ b/include/linux/fddidevice.h
@@ -24,10 +24,8 @@

 #include <linux/if_fddi.h>

-#ifdef __KERNEL__
 extern __be16	fddi_type_trans(struct sk_buff *skb,
 				struct net_device *dev);
 extern struct net_device *alloc_fddidev(int sizeof_priv);
-#endif

 #endif	/* _LINUX_FDDIDEVICE_H */
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 74ff575..84620c1 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -64,8 +64,6 @@

 #define HID_MAX_DESCRIPTOR_SIZE		4096

-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/list.h>
@@ -573,5 +571,4 @@ static inline int hid_ff_init(struct hid_device *hid) { return -1; }
 #define err_hid(format, arg...) printk(KERN_ERR "%s: " format "\n" , \
 		__FILE__ , ## arg)
 #endif
-#endif

diff --git a/include/linux/hidraw.h b/include/linux/hidraw.h
index 0536f29..d2662ba 100644
--- a/include/linux/hidraw.h
+++ b/include/linux/hidraw.h
@@ -38,10 +38,6 @@ struct hidraw_devinfo {
 /* number of reports to buffer */
 #define HIDRAW_BUFFER_SIZE 64

-
-/* kernel-only API declarations */
-#ifdef __KERNEL__
-
 struct hidraw {
 	unsigned int minor;
 	int exist;
@@ -82,5 +78,3 @@ static inline void hidraw_disconnect(struct hid_device *hid) { }
 #endif

 #endif
-
-#endif
diff --git a/include/linux/hippidevice.h b/include/linux/hippidevice.h
index bab303d..e80517f 100644
--- a/include/linux/hippidevice.h
+++ b/include/linux/hippidevice.h
@@ -25,8 +25,6 @@

 #include <linux/if_hippi.h>

-#ifdef __KERNEL__
-
 struct hippi_cb {
 	__u32	ifield;
 };
@@ -34,6 +32,5 @@ struct hippi_cb {
 extern __be16 hippi_type_trans(struct sk_buff *skb, struct net_device *dev);

 extern struct net_device *alloc_hippi_dev(int sizeof_priv);
-#endif

 #endif	/* _LINUX_HIPPIDEVICE_H */
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index fc4e3db..3da23ae 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_INETDEVICE_H
 #define _LINUX_INETDEVICE_H

-#ifdef __KERNEL__
-
 #include <linux/bitmap.h>
 #include <linux/if.h>
 #include <linux/netdevice.h>
@@ -203,8 +201,6 @@ static inline void in_dev_put(struct in_device *idev)
 #define __in_dev_put(idev)  atomic_dec(&(idev)->refcnt)
 #define in_dev_hold(idev)   atomic_inc(&(idev)->refcnt)

-#endif /* __KERNEL__ */
-
 static __inline__ __be32 inet_make_mask(int logmask)
 {
 	if (logmask)
diff --git a/include/linux/isapnp.h b/include/linux/isapnp.h
index 1e8728a..dc8b3dc 100644
--- a/include/linux/isapnp.h
+++ b/include/linux/isapnp.h
@@ -52,8 +52,6 @@
  *
  */

-#ifdef __KERNEL__
-
 #define DEVICE_COUNT_COMPATIBLE 4

 #define ISAPNP_ANY_ID		0xffff
@@ -137,5 +135,4 @@ static inline struct pnp_dev *pnp_find_dev(struct pnp_card *card,

 #endif /* CONFIG_ISAPNP */

-#endif /* __KERNEL__ */
 #endif /* LINUX_ISAPNP_H */
diff --git a/include/linux/ivtv.h b/include/linux/ivtv.h
index 794b8da..ecac0ea 100644
--- a/include/linux/ivtv.h
+++ b/include/linux/ivtv.h
@@ -21,11 +21,7 @@
 #ifndef __LINUX_IVTV_H__
 #define __LINUX_IVTV_H__

-#ifdef __KERNEL__
 #include <linux/compiler.h> /* need __user */
-#else
-#define __user
-#endif
 #include <linux/types.h>

 /* ivtv knows several distinct output modes: MPEG streaming,
diff --git a/include/linux/ivtvfb.h b/include/linux/ivtvfb.h
index e980ba6..3e2d49a 100644
--- a/include/linux/ivtvfb.h
+++ b/include/linux/ivtvfb.h
@@ -21,11 +21,7 @@
 #ifndef __LINUX_IVTVFB_H__
 #define __LINUX_IVTVFB_H__

-#ifdef __KERNEL__
 #include <linux/compiler.h> /* need __user */
-#else
-#define __user
-#endif
 #include <linux/types.h>

 /* Framebuffer external API */
diff --git a/include/linux/key.h b/include/linux/key.h
index a70b8a8..b656723 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -21,8 +21,6 @@
 #include <linux/rcupdate.h>
 #include <asm/atomic.h>

-#ifdef __KERNEL__
-
 /* key handle serial number */
 typedef int32_t key_serial_t;

@@ -311,5 +309,4 @@ extern struct key root_user_keyring;
 extern struct key root_session_keyring;

 #endif /* CONFIG_KEYS */
-#endif /* __KERNEL__ */
 #endif /* _LINUX_KEY_H */
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index 5497aac..0759f98 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -19,13 +19,11 @@
  */
 #include <asm/kvm_para.h>

-#ifdef __KERNEL__
 static inline int kvm_para_has_feature(unsigned int feature)
 {
 	if (kvm_arch_para_features() & (1UL << feature))
 		return 1;
 	return 0;
 }
-#endif /* __KERNEL__ */
 #endif /* __LINUX_KVM_PARA_H */

diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index 2f4e957..6635967 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -15,7 +15,6 @@
 #include <linux/rtc.h>			/* get the user-level API */
 #include <asm/mc146818rtc.h>		/* register access macros */

-#ifdef __KERNEL__
 #include <linux/spinlock.h>		/* spinlock_t */
 extern spinlock_t rtc_lock;		/* serialize CMOS RAM access */

@@ -35,7 +34,6 @@ struct cmos_rtc_board_info {
 	u8	rtc_mon_alarm;		/* zero, or register index */
 	u8	rtc_century;		/* zero, or register index */
 };
-#endif

 /**********************************************************************
  * register summary
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b695875..0398260 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3,8 +3,6 @@

 #include <linux/errno.h>

-#ifdef __KERNEL__
-
 #include <linux/gfp.h>
 #include <linux/list.h>
 #include <linux/mmzone.h>
@@ -1230,5 +1228,4 @@ int vmemmap_populate_basepages(struct page *start_page,
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);

-#endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 8eed44f..ece28b7 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -1,6 +1,5 @@
 #ifndef _NAMESPACE_H_
 #define _NAMESPACE_H_
-#ifdef __KERNEL__

 #include <linux/mount.h>
 #include <linux/sched.h>
@@ -38,4 +37,3 @@ static inline void get_mnt_ns(struct mnt_namespace *ns)
 }

 #endif
-#endif
diff --git a/include/linux/ncp_fs_sb.h b/include/linux/ncp_fs_sb.h
index 6330fc7..16354ba 100644
--- a/include/linux/ncp_fs_sb.h
+++ b/include/linux/ncp_fs_sb.h
@@ -13,8 +13,6 @@
 #include <linux/net.h>
 #include <linux/mutex.h>

-#ifdef __KERNEL__
-
 #include <linux/workqueue.h>

 #define NCP_DEFAULT_OPTIONS 0		/* 2 for packet signatures */
@@ -154,7 +152,5 @@ static inline void ncp_invalidate_conn(struct ncp_server *server)
 	server->conn_status |= 0x01;
 }

-#endif				/* __KERNEL__ */
-
 #endif

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index f4df400..63accbf 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -110,8 +110,6 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
 	struct raw_notifier_head name =				\
 		RAW_NOTIFIER_INIT(name)

-#ifdef __KERNEL__
-
 extern int atomic_notifier_chain_register(struct atomic_notifier_head *nh,
 		struct notifier_block *nb);
 extern int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
@@ -248,5 +246,4 @@ extern struct blocking_notifier_head reboot_notifier_list;
 #define VT_WRITE		0x0003 /* A char got output */
 #define VT_UPDATE		0x0004 /* A bigger update occurred */

-#endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff --git a/include/linux/phonedev.h b/include/linux/phonedev.h
index 4269de9..e1a567f 100644
--- a/include/linux/phonedev.h
+++ b/include/linux/phonedev.h
@@ -3,8 +3,6 @@

 #include <linux/types.h>

-#ifdef __KERNEL__
-
 #include <linux/poll.h>

 struct phone_device {
@@ -22,4 +20,3 @@ extern int phone_register_device(struct phone_device *, int unit);
 extern void phone_unregister_device(struct phone_device *);

 #endif
-#endif
diff --git a/include/linux/ppp_channel.h b/include/linux/ppp_channel.h
index a942892..52ebc35 100644
--- a/include/linux/ppp_channel.h
+++ b/include/linux/ppp_channel.h
@@ -44,7 +44,6 @@ struct ppp_channel {
 	int		latency;	/* overhead time in milliseconds */
 };

-#ifdef __KERNEL__
 /* Called by the channel when it can send some more data. */
 extern void ppp_output_wakeup(struct ppp_channel *);

@@ -77,5 +76,4 @@ extern int ppp_unit_number(struct ppp_channel *);
  * that ppp_unregister_channel returns.
  */

-#endif /* __KERNEL__ */
 #endif
diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
index db5ef9b..a2ed621 100644
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -4,10 +4,8 @@
 #ifndef _LINUX_REISER_FS_SB
 #define _LINUX_REISER_FS_SB

-#ifdef __KERNEL__
 #include <linux/workqueue.h>
 #include <linux/rwsem.h>
-#endif

 typedef enum {
 	reiserfs_attrs_cleared = 0x00000001,
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index 6c3c0f6..cba4887 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -15,8 +15,6 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>

-#ifdef __KERNEL__
-
 #include <linux/types.h>

 struct rwsem_waiter;
@@ -74,5 +72,4 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return (sem->activity != 0);
 }

-#endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 8ba1c32..aea704b 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -63,14 +63,12 @@ typedef struct sctphdr {
 	__be32 checksum;
 } __attribute__((packed)) sctp_sctphdr_t;

-#ifdef __KERNEL__
 #include <linux/skbuff.h>

 static inline struct sctphdr *sctp_hdr(const struct sk_buff *skb)
 {
 	return (struct sctphdr *)skb_transport_header(skb);
 }
-#endif

 /* Section 3.2.  Chunk Field Descriptions. */
 typedef struct sctp_chunkhdr {
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bbd8d00..98f395e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -333,10 +333,6 @@ struct sk_buff {
 	atomic_t		users;
 };

-#ifdef __KERNEL__
-/*
- *	Handling routines are only of interest to the kernel
- */
 #include <linux/slab.h>

 #include <asm/system.h>
@@ -1813,5 +1809,5 @@ static inline void skb_forward_csum(struct sk_buff *skb)
 }

 bool skb_partial_csum_set(struct sk_buff *skb, u16 start, u16 off);
-#endif	/* __KERNEL__ */
+
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/include/linux/sony-laptop.h b/include/linux/sony-laptop.h
index e2e036d..ddf9402 100644
--- a/include/linux/sony-laptop.h
+++ b/include/linux/sony-laptop.h
@@ -3,8 +3,6 @@

 #include <linux/types.h>

-#ifdef __KERNEL__
-
 /* used only for communication between v4l and sony-laptop */

 #define SONY_PIC_COMMAND_GETCAMERA		 1	/* obsolete */
@@ -29,6 +27,4 @@

 int sony_pic_camera_command(int command, u8 value);

-#endif	/* __KERNEL__ */
-
 #endif /* _SONYLAPTOP_H_ */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 878459a..8146202 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -87,8 +87,6 @@ struct reclaim_state {
 	unsigned long reclaimed_slab;
 };

-#ifdef __KERNEL__
-
 struct address_space;
 struct sysinfo;
 struct writeback_control;
@@ -356,5 +354,4 @@ static inline swp_entry_t get_swap_page(void)
 #define disable_swap_token() do { } while(0)

 #endif /* CONFIG_SWAP */
-#endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 421323e..bc3b75e 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -34,8 +34,6 @@ extern long do_no_restart_syscall(struct restart_block *parm);
 #include <linux/bitops.h>
 #include <asm/thread_info.h>

-#ifdef __KERNEL__
-
 /*
  * flag set/clear/test wrappers
  * - pass TIF_xxxx constants to these functions
@@ -80,6 +78,4 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 #define set_need_resched()	set_thread_flag(TIF_NEED_RESCHED)
 #define clear_need_resched()	clear_thread_flag(TIF_NEED_RESCHED)

-#endif
-
 #endif /* _LINUX_THREAD_INFO_H */
diff --git a/include/linux/trdevice.h b/include/linux/trdevice.h
index bfc84a7..2c95c49 100644
--- a/include/linux/trdevice.h
+++ b/include/linux/trdevice.h
@@ -27,11 +27,8 @@

 #include <linux/if_tr.h>

-#ifdef __KERNEL__
 extern __be16 tr_type_trans(struct sk_buff *skb, struct net_device *dev);
 extern void tr_source_route(struct sk_buff *skb, struct trh_hdr *trh, struct net_device *dev);
 extern struct net_device *alloc_trdev(int sizeof_priv);

-#endif
-
 #endif	/* _LINUX_TRDEVICE_H */
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 583e048..8273bdf 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -8,8 +8,6 @@
 #define USB_DEVICE_MAJOR		189


-#ifdef __KERNEL__
-
 #include <linux/errno.h>        /* for -ENODEV */
 #include <linux/delay.h>	/* for mdelay() */
 #include <linux/interrupt.h>	/* for in_interrupt() */
@@ -1669,6 +1667,4 @@ extern void usb_unregister_notify(struct notifier_block *nb);
 	__FILE__ , ## arg)


-#endif  /* __KERNEL__ */
-
 #endif
diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
index ed2d4ea..c001782 100644
--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -5,8 +5,6 @@
 /* The ID for virtio console */
 #define VIRTIO_ID_CONSOLE	3

-#ifdef __KERNEL__
 int __init virtio_cons_early_init(int (*put_chars)(u32, const char *, int));
-#endif /* __KERNEL__ */

 #endif /* _LINUX_VIRTIO_CONSOLE_H */
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index abe481e..09d0282 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -109,7 +109,6 @@ static inline unsigned vring_size(unsigned int num, unsigned long pagesize)
 		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
 }

-#ifdef __KERNEL__
 #include <linux/irqreturn.h>
 struct virtio_device;
 struct virtqueue;
@@ -122,5 +121,5 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 void vring_del_virtqueue(struct virtqueue *vq);

 irqreturn_t vring_interrupt(int irq, void *_vq);
-#endif /* __KERNEL__ */
+
 #endif /* _LINUX_VIRTIO_RING_H */
diff --git a/include/linux/zorro.h b/include/linux/zorro.h
index 913bfc2..b7206f8 100644
--- a/include/linux/zorro.h
+++ b/include/linux/zorro.h
@@ -112,8 +112,6 @@ struct ConfigDev {

 #define ZORRO_NUM_AUTO		16

-#ifdef __KERNEL__
-
 #include <linux/init.h>
 #include <linux/ioport.h>

@@ -248,7 +246,4 @@ extern DECLARE_BITMAP(zorro_unused_z2ram, 128);
 #define Z2RAM_CHUNKMASK		(0x0000ffff)
 #define Z2RAM_CHUNKSHIFT	(16)

-
-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_ZORRO_H */


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
