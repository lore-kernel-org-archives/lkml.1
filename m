Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbXFLXar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbXFLXar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbXFLXaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:30:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbXFLXah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:30:37 -0400
Date: Tue, 12 Jun 2007 19:30:35 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: fix placement of inline keyword.
Message-ID: <20070612233035.GA24146@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

gcc gets whiney about the placement of 'inline' at some warning levels.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/i386/oprofile/op_model_p4.c b/arch/i386/oprofile/op_model_p4.c
index 4792592..cf6d792 100644
--- a/arch/i386/oprofile/op_model_p4.c
+++ b/arch/i386/oprofile/op_model_p4.c
@@ -47,7 +47,7 @@ static inline void setup_num_counters(void)
 #endif
 }
 
-static int inline addr_increment(void)
+static inline int addr_increment(void)
 {
 #ifdef CONFIG_SMP
 	return smp_num_siblings == 2 ? 2 : 1;
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 4fb5938..7dc7773 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -429,14 +429,14 @@ static int __init prom_next_node(phandle *nodep)
 	}
 }
 
-static int inline prom_getprop(phandle node, const char *pname,
+static inline int prom_getprop(phandle node, const char *pname,
 			       void *value, size_t valuelen)
 {
 	return call_prom("getprop", 4, 1, node, ADDR(pname),
 			 (u32)(unsigned long) value, (u32) valuelen);
 }
 
-static int inline prom_getproplen(phandle node, const char *pname)
+static inline int prom_getproplen(phandle node, const char *pname)
 {
 	return call_prom("getproplen", 2, 1, node, ADDR(pname));
 }
diff --git a/drivers/acpi/tables/tbfadt.c b/drivers/acpi/tables/tbfadt.c
index 807c711..727ec23 100644
--- a/drivers/acpi/tables/tbfadt.c
+++ b/drivers/acpi/tables/tbfadt.c
@@ -48,7 +48,7 @@
 ACPI_MODULE_NAME("tbfadt")
 
 /* Local prototypes */
-static void inline
+static inline void
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
 			     u8 bit_width, u64 address);
 
@@ -122,7 +122,7 @@ static struct acpi_fadt_info fadt_info_table[] = {
  *
  ******************************************************************************/
 
-static void inline
+static inline void
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
 			     u8 bit_width, u64 address)
 {
diff --git a/drivers/isdn/hardware/eicon/divasmain.c b/drivers/isdn/hardware/eicon/divasmain.c
index 5e862e2..49bc3e7 100644
--- a/drivers/isdn/hardware/eicon/divasmain.c
+++ b/drivers/isdn/hardware/eicon/divasmain.c
@@ -448,32 +448,32 @@ void divasa_unmap_pci_bar(void __iomem *bar)
 /*********************************************************
  ** I/O port access 
  *********************************************************/
-byte __inline__ inpp(void __iomem *addr)
+inline byte inpp(void __iomem *addr)
 {
 	return (inb((unsigned long) addr));
 }
 
-word __inline__ inppw(void __iomem *addr)
+inline word inppw(void __iomem *addr)
 {
 	return (inw((unsigned long) addr));
 }
 
-void __inline__ inppw_buffer(void __iomem *addr, void *P, int length)
+inline void inppw_buffer(void __iomem *addr, void *P, int length)
 {
 	insw((unsigned long) addr, (word *) P, length >> 1);
 }
 
-void __inline__ outppw_buffer(void __iomem *addr, void *P, int length)
+inline void outppw_buffer(void __iomem *addr, void *P, int length)
 {
 	outsw((unsigned long) addr, (word *) P, length >> 1);
 }
 
-void __inline__ outppw(void __iomem *addr, word w)
+inline void outppw(void __iomem *addr, word w)
 {
 	outw(w, (unsigned long) addr);
 }
 
-void __inline__ outpp(void __iomem *addr, word p)
+inline void outpp(void __iomem *addr, word p)
 {
 	outb(p, (unsigned long) addr);
 }
diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index ff09f07..6ef28c8 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -275,13 +275,13 @@ void diva_os_get_time (dword* sec, dword* usec);
 **  atomic operation, fake because we use threads
 */
 typedef int diva_os_atomic_t;
-static diva_os_atomic_t __inline__
+static inline diva_os_atomic_t
 diva_os_atomic_increment(diva_os_atomic_t* pv)
 {
   *pv += 1;
   return (*pv);
 }
-static diva_os_atomic_t __inline__
+static inline diva_os_atomic_t
 diva_os_atomic_decrement(diva_os_atomic_t* pv)
 {
   *pv -= 1;
diff --git a/drivers/media/common/ir-functions.c b/drivers/media/common/ir-functions.c
index cbf7c05..14bf46b 100644
--- a/drivers/media/common/ir-functions.c
+++ b/drivers/media/common/ir-functions.c
@@ -125,7 +125,7 @@ u32 ir_extract_bits(u32 data, u32 mask)
 	return value;
 }
 
-static int inline getbit(u32 *samples, int bit)
+static inline int getbit(u32 *samples, int bit)
 {
 	return (samples[bit/32] & (1 << (31-(bit%32)))) ? 1 : 0;
 }
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index d86813b..49c9d65 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -636,22 +636,22 @@ int cx88_reset(struct cx88_core *core)
 
 /* ------------------------------------------------------------------ */
 
-static unsigned int inline norm_swidth(v4l2_std_id norm)
+static inline unsigned int norm_swidth(v4l2_std_id norm)
 {
 	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 754 : 922;
 }
 
-static unsigned int inline norm_hdelay(v4l2_std_id norm)
+static inline unsigned int norm_hdelay(v4l2_std_id norm)
 {
 	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 135 : 186;
 }
 
-static unsigned int inline norm_vdelay(v4l2_std_id norm)
+static inline unsigned int norm_vdelay(v4l2_std_id norm)
 {
 	return (norm & V4L2_STD_625_50) ? 0x24 : 0x18;
 }
 
-static unsigned int inline norm_fsc8(v4l2_std_id norm)
+static inline unsigned int norm_fsc8(v4l2_std_id norm)
 {
 	if (norm & V4L2_STD_PAL_M)
 		return 28604892;      // 3.575611 MHz
@@ -671,7 +671,7 @@ static unsigned int inline norm_fsc8(v4l2_std_id norm)
 	return 35468950;      // 4.43361875 MHz +/- 5 Hz
 }
 
-static unsigned int inline norm_htotal(v4l2_std_id norm)
+static inline unsigned int norm_htotal(v4l2_std_id norm)
 {
 
 	unsigned int fsc4=norm_fsc8(norm)/2;
@@ -682,7 +682,7 @@ static unsigned int inline norm_htotal(v4l2_std_id norm)
 				((fsc4+262)/525*1001+15000)/30000;
 }
 
-static unsigned int inline norm_vbipack(v4l2_std_id norm)
+static inline unsigned int norm_vbipack(v4l2_std_id norm)
 {
 	return (norm & V4L2_STD_625_50) ? 511 : 400;
 }
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index a4f7bef..d3c4d7f 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -91,13 +91,13 @@ enum cx8802_board_access {
 /* ----------------------------------------------------------- */
 /* tv norms                                                    */
 
-static unsigned int inline norm_maxw(v4l2_std_id norm)
+static inline unsigned int norm_maxw(v4l2_std_id norm)
 {
 	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 720 : 768;
 }
 
 
-static unsigned int inline norm_maxh(v4l2_std_id norm)
+static inline unsigned int norm_maxh(v4l2_std_id norm)
 {
 	return (norm & V4L2_STD_625_50) ? 576 : 480;
 }
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index ab0ab92..bf709f7 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -3000,7 +3000,7 @@ static int sky2_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void inline sky2_add_filter(u8 filter[8], const u8 *addr)
+static inline void sky2_add_filter(u8 filter[8], const u8 *addr)
 {
 	u32 bit;
 
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index c878a2f..8809443 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -3923,7 +3923,7 @@ static const char *ipw_get_status_code(u16 status)
 	return "Unknown status value.";
 }
 
-static void inline average_init(struct average *avg)
+static inline void average_init(struct average *avg)
 {
 	memset(avg, 0, sizeof(*avg));
 }
--- linux-2.6.21.noarch/drivers/scsi/tmscsim.c~	2007-05-27 19:55:19.000000000 -0400
+++ linux-2.6.21.noarch/drivers/scsi/tmscsim.c	2007-05-27 19:56:31.000000000 -0400
@@ -372,7 +372,7 @@ static unsigned long inline dc390_advanc
 	return xfer;
 }
 
-static struct dc390_dcb __inline__ *dc390_findDCB ( struct dc390_acb* pACB, u8 id, u8 lun)
+static inline struct dc390_dcb *dc390_findDCB ( struct dc390_acb* pACB, u8 id, u8 lun)
 {
    struct dc390_dcb* pDCB = pACB->pLinkDCB; if (!pDCB) return NULL;
    while (pDCB->TargetID != id || pDCB->TargetLUN != lun)
@@ -387,14 +387,14 @@ static struct dc390_dcb __inline__ *dc39
 }
 
 /* Insert SRB oin top of free list */
-static __inline__ void dc390_Free_insert (struct dc390_acb* pACB, struct dc390_srb* pSRB)
+static inline void dc390_Free_insert (struct dc390_acb* pACB, struct dc390_srb* pSRB)
 {
     DEBUG0(printk ("DC390: Free SRB %p\n", pSRB));
     pSRB->pNextSRB = pACB->pFreeSRB;
     pACB->pFreeSRB = pSRB;
 }
 
-static __inline__ void dc390_Going_append (struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
+static inline void dc390_Going_append (struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
 {
     pDCB->GoingSRBCnt++;
     DEBUG0(printk("DC390: Append SRB %p to Going\n", pSRB));
@@ -409,7 +409,7 @@ static __inline__ void dc390_Going_appen
     pSRB->pNextSRB = NULL;
 }
 
-static __inline__ void dc390_Going_remove (struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
+static inline void dc390_Going_remove (struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
 {
 	DEBUG0(printk("DC390: Remove SRB %p from Going\n", pSRB));
    if (pSRB == pDCB->pGoingSRB)
diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_serial.c
index 5a03a3f..c16c8fc 100644
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -198,7 +198,7 @@ static const __u16 crc10_table[256] = {
  * Perform a memcpy and calculate fcs using ppp 10bit CRC algorithm. Return
  * new 10 bit FCS.
  */
-static __u16 __inline__ fcs_compute10 (unsigned char *sp, int len, __u16 fcs)
+static inline __u16 fcs_compute10 (unsigned char *sp, int len, __u16 fcs)
 {
 	for (; len-- > 0; fcs = CRC10_FCS (fcs, *sp++));
 	return fcs;
diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
index b75eda8..34704bd 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -939,7 +939,7 @@ intelfb_pci_unregister(struct pci_dev *pdev)
  *                       helper functions                      *
  ***************************************************************/
 
-int __inline__
+inline int
 intelfb_var_to_depth(const struct fb_var_screeninfo *var)
 {
 	DBG_MSG("intelfb_var_to_depth: bpp: %d, green.length is %d\n",
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 28dd757..f8de8e7 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -69,7 +69,7 @@
 #define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
 #define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
-static int inline ocfs2_search_dirblock(struct buffer_head *bh,
+static inline int ocfs2_search_dirblock(struct buffer_head *bh,
 					struct inode *dir,
 					const char *name, int namelen,
 					unsigned long offset,
@@ -1926,7 +1926,7 @@ bail:
 /*
  * Returns 0 if not found, -1 on failure, and 1 on success
  */
-static int inline ocfs2_search_dirblock(struct buffer_head *bh,
+static inline int ocfs2_search_dirblock(struct buffer_head *bh,
 					struct inode *dir,
 					const char *name, int namelen,
 					unsigned long offset,
diff --git a/include/asm-powerpc/spinlock.h b/include/asm-powerpc/spinlock.h
index cc4cfce..14fc13b 100644
--- a/include/asm-powerpc/spinlock.h
+++ b/include/asm-powerpc/spinlock.h
@@ -103,7 +103,7 @@ extern void __rw_yield(raw_rwlock_t *lock);
 #define SHARED_PROCESSOR	0
 #endif
 
-static void __inline__ __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
 	while (1) {
@@ -118,7 +118,7 @@ static void __inline__ __raw_spin_lock(raw_spinlock_t *lock)
 	}
 }
 
-static void __inline__ __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+static inline void  __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 {
 	unsigned long flags_dis;
 
@@ -223,7 +223,7 @@ static __inline__ long __write_trylock(raw_rwlock_t *rw)
 	return tmp;
 }
 
-static void __inline__ __raw_read_lock(raw_rwlock_t *rw)
+static inline void __raw_read_lock(raw_rwlock_t *rw)
 {
 	while (1) {
 		if (likely(__read_trylock(rw) > 0))
@@ -237,7 +237,7 @@ static void __inline__ __raw_read_lock(raw_rwlock_t *rw)
 	}
 }
 
-static void __inline__ __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(raw_rwlock_t *rw)
 {
 	while (1) {
 		if (likely(__write_trylock(rw) == 0))
@@ -261,7 +261,7 @@ static int __inline__ __raw_write_trylock(raw_rwlock_t *rw)
 	return __write_trylock(rw) == 0;
 }
 
-static void __inline__ __raw_read_unlock(raw_rwlock_t *rw)
+static inline void __raw_read_unlock(raw_rwlock_t *rw)
 {
 	long tmp;
 
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 826b15e..7944036 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -33,13 +33,13 @@ int cpuset_zonelist_valid_mems_allowed(struct zonelist *zl);
 extern int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask);
 extern int __cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask);
 
-static int inline cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+static inline int cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
 {
 	return number_of_cpusets <= 1 ||
 		__cpuset_zone_allowed_softwall(z, gfp_mask);
 }
 
-static int inline cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
+static inline int cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
 {
 	return number_of_cpusets <= 1 ||
 		__cpuset_zone_allowed_hardwall(z, gfp_mask);
diff --git a/kernel/mutex.c b/kernel/mutex.c
index e7cbbb8..a812273 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -81,7 +81,7 @@ __mutex_lock_slowpath(atomic_t *lock_count);
  *
  * This function is similar to (but not equivalent to) down().
  */
-void inline fastcall __sched mutex_lock(struct mutex *lock)
+inline void fastcall __sched mutex_lock(struct mutex *lock)
 {
 	might_sleep();
 	/*
diff --git a/sound/drivers/opl4/opl4_lib.c b/sound/drivers/opl4/opl4_lib.c
index 01997f2..cbc1195 100644
--- a/sound/drivers/opl4/opl4_lib.c
+++ b/sound/drivers/opl4/opl4_lib.c
@@ -27,7 +27,7 @@ MODULE_AUTHOR("Clemens Ladisch <clemens@ladisch.de>");
 MODULE_DESCRIPTION("OPL4 driver");
 MODULE_LICENSE("GPL");
 
-static void inline snd_opl4_wait(struct snd_opl4 *opl4)
+static inline void snd_opl4_wait(struct snd_opl4 *opl4)
 {
 	int timeout = 10;
 	while ((inb(opl4->fm_port) & OPL4_STATUS_BUSY) && --timeout > 0)
diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index 5ccf0b1..485a05b 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -215,7 +215,7 @@ static void vortex_adbdma_startfifo(vortex_t * vortex, int adbdma);
 //static void vortex_adbdma_stopfifo(vortex_t *vortex, int adbdma);
 static void vortex_adbdma_pausefifo(vortex_t * vortex, int adbdma);
 static void vortex_adbdma_resumefifo(vortex_t * vortex, int adbdma);
-static int inline vortex_adbdma_getlinearpos(vortex_t * vortex, int adbdma);
+static inline int vortex_adbdma_getlinearpos(vortex_t * vortex, int adbdma);
 static void vortex_adbdma_resetup(vortex_t *vortex, int adbdma);
 
 #ifndef CHIP_AU8810
@@ -223,7 +223,7 @@ static void vortex_wtdma_startfifo(vortex_t * vortex, int wtdma);
 static void vortex_wtdma_stopfifo(vortex_t * vortex, int wtdma);
 static void vortex_wtdma_pausefifo(vortex_t * vortex, int wtdma);
 static void vortex_wtdma_resumefifo(vortex_t * vortex, int wtdma);
-static int inline vortex_wtdma_getlinearpos(vortex_t * vortex, int wtdma);
+static inline int vortex_wtdma_getlinearpos(vortex_t * vortex, int wtdma);
 #endif
 
 /* global stuff. */
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 4a336ea..687986c 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -1250,7 +1250,7 @@ static void vortex_adbdma_resetup(vortex_t *vortex, int adbdma) {
 	}
 }
 
-static int inline vortex_adbdma_getlinearpos(vortex_t * vortex, int adbdma)
+static inline int vortex_adbdma_getlinearpos(vortex_t * vortex, int adbdma)
 {
 	stream_t *dma = &vortex->dma_adb[adbdma];
 	int temp;
@@ -1499,7 +1499,7 @@ static int vortex_wtdma_getcursubuffer(vortex_t * vortex, int wtdma)
 		 POS_SHIFT) & POS_MASK);
 }
 #endif
-static int inline vortex_wtdma_getlinearpos(vortex_t * vortex, int wtdma)
+static inline int vortex_wtdma_getlinearpos(vortex_t * vortex, int wtdma)
 {
 	stream_t *dma = &vortex->dma_wt[wtdma];
 	int temp;
--- linux-2.6.20.noarch/net/mac80211/ieee80211.c~	2007-04-04 19:32:30.000000000 -0400
+++ linux-2.6.20.noarch/net/mac80211/ieee80211.c	2007-04-04 19:32:51.000000000 -0400
@@ -1045,7 +1045,7 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
 }
 
 
-static void inline
+static inline void
 __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 		       struct sk_buff *skb,
 		       struct net_device *dev,
@@ -1091,7 +1091,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 
 }
 
-static int inline is_ieee80211_device(struct net_device *dev,
+static inline int is_ieee80211_device(struct net_device *dev,
 				      struct net_device *master)
 {
 	return (wdev_priv(dev->ieee80211_ptr) ==
@@ -1100,7 +1100,7 @@ static int inline is_ieee80211_device(st
 
 /* Device in tx->dev has a reference added; use dev_put(tx->dev) when
  * finished with it. */
-static int inline ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
+static inline int ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 				       struct sk_buff *skb,
 				       struct net_device *mdev,
 				       struct ieee80211_tx_control *control)
--- linux-2.6.20.noarch/arch/ia64/kernel/mca.c~	2007-04-04 19:33:39.000000000 -0400
+++ linux-2.6.20.noarch/arch/ia64/kernel/mca.c	2007-04-04 19:33:43.000000000 -0400
@@ -303,7 +303,7 @@ static void ia64_mlogbuf_dump_from_init(
 	ia64_mlogbuf_dump();
 }
 
-static void inline
+static inline void
 ia64_mca_spin(const char *func)
 {
 	if (monarch_cpu == smp_processor_id())
--- linux-2.6.20.noarch/arch/ia64/sn/pci/tioce_provider.c~	2007-04-04 19:34:30.000000000 -0400
+++ linux-2.6.20.noarch/arch/ia64/sn/pci/tioce_provider.c	2007-04-04 19:34:40.000000000 -0400
@@ -51,7 +51,7 @@
  * All registers defined in struct tioce will meet that criteria.
  */
 
-static void inline
+static inline void
 tioce_mmr_war_pre(struct tioce_kernel *kern, void __iomem *mmr_addr)
 {
 	u64 mmr_base;
@@ -77,7 +77,7 @@ tioce_mmr_war_pre(struct tioce_kernel *k
 	}
 }
 
-static void inline
+static inline void
 tioce_mmr_war_post(struct tioce_kernel *kern, void __iomem *mmr_addr)
 {
 	u64 mmr_base;
--- linux-2.6.20.noarch/arch/ia64/sn/pci/pcibr/pcibr_ate.c~	2007-04-04 19:34:50.000000000 -0400
+++ linux-2.6.20.noarch/arch/ia64/sn/pci/pcibr/pcibr_ate.c	2007-04-04 19:34:56.000000000 -0400
@@ -138,7 +138,7 @@ static inline u64 __iomem *pcibr_ate_add
 /*
  * Update the ate.
  */
-void inline
+inline void
 ate_write(struct pcibus_info *pcibus_info, int ate_index, int count,
 	  volatile u64 ate)
 {
--- linux-2.6.20.noarch/drivers/char/mmtimer.c~	2007-04-04 19:35:07.000000000 -0400
+++ linux-2.6.20.noarch/drivers/char/mmtimer.c	2007-04-04 19:35:46.000000000 -0400
@@ -75,7 +75,7 @@ static const struct file_operations mmti
  */
 #define NUM_COMPARATORS 3
 /* Check for an RTC interrupt pending */
-static int inline mmtimer_int_pending(int comparator)
+static inline int mmtimer_int_pending(int comparator)
 {
 	if (HUB_L((unsigned long *)LOCAL_MMR_ADDR(SH_EVENT_OCCURRED)) &
 			SH_EVENT_OCCURRED_RTC1_INT_MASK << comparator)
@@ -84,14 +84,14 @@ static int inline mmtimer_int_pending(in
 		return 0;
 }
 /* Clear the RTC interrupt pending bit */
-static void inline mmtimer_clr_int_pending(int comparator)
+static inline void mmtimer_clr_int_pending(int comparator)
 {
 	HUB_S((u64 *)LOCAL_MMR_ADDR(SH_EVENT_OCCURRED_ALIAS),
 		SH_EVENT_OCCURRED_RTC1_INT_MASK << comparator);
 }
 
 /* Setup timer on comparator RTC1 */
-static void inline mmtimer_setup_int_0(u64 expires)
+static inline void mmtimer_setup_int_0(u64 expires)
 {
 	u64 val;
 
@@ -121,7 +121,7 @@ static void inline mmtimer_setup_int_0(u
 }
 
 /* Setup timer on comparator RTC2 */
-static void inline mmtimer_setup_int_1(u64 expires)
+static inline void mmtimer_setup_int_1(u64 expires)
 {
 	u64 val;
 
@@ -143,7 +143,7 @@ static void inline mmtimer_setup_int_1(u
 }
 
 /* Setup timer on comparator RTC3 */
-static void inline mmtimer_setup_int_2(u64 expires)
+static inline void mmtimer_setup_int_2(u64 expires)
 {
 	u64 val;
 
@@ -169,7 +169,7 @@ static void inline mmtimer_setup_int_2(u
  * in order to insure that the setup succeeds in a deterministic time frame.
  * It will check if the interrupt setup succeeded.
  */
-static int inline mmtimer_setup(int comparator, unsigned long expires)
+static inline int mmtimer_setup(int comparator, unsigned long expires)
 {
 
 	switch (comparator) {
@@ -194,7 +194,7 @@ static int inline mmtimer_setup(int comp
 	return mmtimer_int_pending(comparator);
 }
 
-static int inline mmtimer_disable_int(long nasid, int comparator)
+static inline int mmtimer_disable_int(long nasid, int comparator)
 {
 	switch (comparator) {
 	case 0:
@@ -396,7 +396,7 @@ static int sgi_clock_set(clockid_t clock
  * exponentially in order to ensure that the next interrupt
  * can be properly scheduled..
  */
-static int inline reschedule_periodic_timer(mmtimer_t *x)
+static inline int reschedule_periodic_timer(mmtimer_t *x)
 {
 	int n;
 	struct k_itimer *t = x->timer;
--- linux-2.6.20.noarch/drivers/serial/ioc4_serial.c~	2007-04-04 19:37:40.000000000 -0400
+++ linux-2.6.20.noarch/drivers/serial/ioc4_serial.c	2007-04-04 19:38:00.000000000 -0400
@@ -823,7 +823,7 @@ pending_intrs(struct ioc4_soft *soft, in
  *			called per port from attach...
  * @port: port to initialize
  */
-static int inline port_init(struct ioc4_port *port)
+static inline int port_init(struct ioc4_port *port)
 {
 	uint32_t sio_cr;
 	struct hooks *hooks = port->ip_hooks;
@@ -1046,7 +1046,7 @@ static irqreturn_t ioc4_intr(int irq, vo
  *			IOC4 with serial ports in the system.
  * @idd: Master module data for this IOC4
  */
-static int inline ioc4_attach_local(struct ioc4_driver_data *idd)
+static inline int ioc4_attach_local(struct ioc4_driver_data *idd)
 {
 	struct ioc4_port *port;
 	struct ioc4_port *ports[IOC4_NUM_SERIAL_PORTS];
--- linux-2.6.20.noarch/drivers/serial/ioc3_serial.c~	2007-04-04 19:38:01.000000000 -0400
+++ linux-2.6.20.noarch/drivers/serial/ioc3_serial.c	2007-04-04 19:38:16.000000000 -0400
@@ -375,7 +375,7 @@ static struct ioc3_port *get_ioc3_port(s
  *			called per port from attach...
  * @port: port to initialize
  */
-static int inline port_init(struct ioc3_port *port)
+static inline int port_init(struct ioc3_port *port)
 {
 	uint32_t sio_cr;
 	struct port_hooks *hooks = port->ip_hooks;
@@ -1430,7 +1430,7 @@ static int receive_chars(struct uart_por
  * @pending: interrupts to handle
  */
 
-static int inline
+static inline int
 ioc3uart_intr_one(struct ioc3_submodule *is,
 			struct ioc3_driver_data *idd,
 			unsigned int pending)
--- linux-2.6.20.noarch/include/asm-powerpc/spinlock.h~	2007-04-04 19:38:42.000000000 -0400
+++ linux-2.6.20.noarch/include/asm-powerpc/spinlock.h	2007-04-04 19:39:59.000000000 -0400
@@ -72,7 +72,7 @@ static __inline__ unsigned long __spin_t
 	return tmp;
 }
 
-static int __inline__ __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
 	return __spin_trylock(lock) == 0;
@@ -179,7 +179,7 @@ extern void __raw_spin_unlock_wait(raw_s
  * This returns the old value in the lock + 1,
  * so we got a read lock if the return value is > 0.
  */
-static long __inline__ __read_trylock(raw_rwlock_t *rw)
+static inline long __read_trylock(raw_rwlock_t *rw)
 {
 	long tmp;
 
@@ -251,12 +251,12 @@ static inline void __raw_write_lock(raw_
 	}
 }
 
-static int __inline__ __raw_read_trylock(raw_rwlock_t *rw)
+static inline int __raw_read_trylock(raw_rwlock_t *rw)
 {
 	return __read_trylock(rw) > 0;
 }
 
-static int __inline__ __raw_write_trylock(raw_rwlock_t *rw)
+static inline int __raw_write_trylock(raw_rwlock_t *rw)
 {
 	return __write_trylock(rw) == 0;
 }
--- linux-2.6.20.noarch/arch/s390/kernel/traps.c~	2007-04-04 19:43:26.000000000 -0400
+++ linux-2.6.20.noarch/arch/s390/kernel/traps.c	2007-04-04 19:43:53.000000000 -0400
@@ -304,7 +304,7 @@ void die(const char * str, struct pt_reg
         do_exit(SIGSEGV);
 }
 
-static void inline
+static inline void
 report_user_fault(long interruption_code, struct pt_regs *regs)
 {
 #if defined(CONFIG_SYSCTL)
@@ -318,7 +318,7 @@ report_user_fault(long interruption_code
 #endif
 }
 
-static void __kprobes inline do_trap(long interruption_code, int signr,
+static inline void __kprobes do_trap(long interruption_code, int signr,
 					char *str, struct pt_regs *regs,
 					siginfo_t *info)
 {
--- linux-2.6.20.noarch/drivers/s390/net/ctcmain.c~	2007-04-04 19:44:07.000000000 -0400
+++ linux-2.6.20.noarch/drivers/s390/net/ctcmain.c	2007-04-04 19:44:18.000000000 -0400
@@ -1827,7 +1827,7 @@ channel_get(enum channel_types type, cha
  *
  * @return Type class of channel to be used for that interface.
  */
-static enum channel_types inline
+static inline enum channel_types
 extract_channel_media(char *name)
 {
 	enum channel_types ret = channel_type_unknown;

-- 
http://www.codemonkey.org.uk
