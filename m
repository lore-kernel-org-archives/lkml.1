Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbYG2GEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbYG2GEC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:04:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYG2GCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:02:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:4620 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbYG2GBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KR90rl9oXcq39iJu5XIxVJXPzLvF/CcNoL4aJbIKSYsIH3m71LhklwIma6jyJ8OoX/
         IWuc0yU92SxFT4sSSWKNNwcJYx9eQzEVyxNzfWyK/x410yfSPHAolV+9706ynpn76J0j
         i42jy0w2TTU9i3VTT7kpgMtbB2ARJR1vsbjTU=
Subject: [PATCH 8/8] misc: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 23:01:37 -0700
Message-Id: <1217311297.23389.31.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The leftovers.

 arch/m32r/kernel/process.c                 |    2 +-
 arch/x86/kvm/x86.c                         |    2 +-
 arch/xtensa/kernel/irq.c                   |    2 +-
 drivers/gpu/drm/i915/i915_dma.c            |    4 ++--
 drivers/gpu/drm/i915/i915_irq.c            |    2 +-
 drivers/input/joystick/xpad.c              |    4 ++--
 drivers/media/video/cx23885/cx23885-core.c |    2 +-
 drivers/pci/hotplug/pciehp_hpc.c           |    2 +-
 drivers/s390/net/ctcm_mpc.c                |    2 +-
 mm/bootmem.c                               |    2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index a689e29..5973df8 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -11,7 +11,7 @@
 #undef DEBUG_PROCESS
 #ifdef DEBUG_PROCESS
 #define DPRINTK(fmt, args...)  printk("%s:%d:%s: " fmt, __FILE__, __LINE__, \
-  __FUNCTION__, ##args)
+  __func__, ##args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5916191..4d92b26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -564,7 +564,7 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 	hv_clock->tsc_to_system_mul = div_frac(nsecs, tps32);
 
 	pr_debug("%s: tsc_khz %u, tsc_shift %d, tsc_mul %u\n",
-		 __FUNCTION__, tsc_khz, hv_clock->tsc_shift,
+		 __func__, tsc_khz, hv_clock->tsc_shift,
 		 hv_clock->tsc_to_system_mul);
 }
 
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index c9ea73b..5fbcde5 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -48,7 +48,7 @@ asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
-				__FUNCTION__, irq);
+				__func__, irq);
 	}
 
 	irq_enter();
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 8897434..9ac4720 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -517,7 +517,7 @@ static int i915_dispatch_flip(struct drm_device * dev)
 	RING_LOCALS;
 
 	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
-		  __FUNCTION__,
+		  __func__,
 		  dev_priv->current_page,
 		  dev_priv->sarea_priv->pf_current_page);
 
@@ -642,7 +642,7 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 static int i915_flip_bufs(struct drm_device *dev, void *data,
 			  struct drm_file *file_priv)
 {
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index df03611..17a7420 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -243,7 +243,7 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 
 	temp &= (USER_INT_FLAG | VSYNC_PIPEA_FLAG | VSYNC_PIPEB_FLAG);
 
-	DRM_DEBUG("%s flag=%08x\n", __FUNCTION__, temp);
+	DRM_DEBUG("%s flag=%08x\n", __func__, temp);
 
 	if (temp == 0)
 		return IRQ_NONE;
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 87d3e7e..0a480ed 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -454,10 +454,10 @@ static void xpad_bulk_out(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		break;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 	}
 }
 
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 6286a9c..c370de9 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1442,7 +1442,7 @@ void cx23885_cancel_buffers(struct cx23885_tsport *port)
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_dmaqueue *q = &port->mpegq;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	del_timer_sync(&q->timeout);
 	cx23885_stop_dma(port);
 	do_cancel_buffers(port, "cancel", 0);
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index ad27e9e..8268189 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -765,7 +765,7 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 		}
 	} while (detected);
 
-	dbg("%s: intr_loc %x\n", __FUNCTION__, intr_loc);
+	dbg("%s: intr_loc %x\n", __func__, intr_loc);
 
 	/* Check Command Complete Interrupt Pending */
 	if (intr_loc & CMD_COMPLETED) {
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 49ae1cd..7297b35 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -1674,7 +1674,7 @@ static int mpc_validate_xid(struct mpcg_info *mpcginfo)
 
 done:
 	if (rc) {
-		ctcm_pr_info("ctcmpc	   :  %s() failed\n", __FUNCTION__);
+		ctcm_pr_info("ctcmpc	   :  %s() failed\n", __func__);
 		priv->xid->xid2_flag2 = 0x40;
 		grp->saved_xid2->xid2_flag2 = 0x40;
 	}
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 4af15d0..dd73036 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -48,7 +48,7 @@ early_param("bootmem_debug", bootmem_debug_setup);
 	if (unlikely(bootmem_debug))			\
 		printk(KERN_INFO			\
 			"bootmem::%s " fmt,		\
-			__FUNCTION__, ## args);		\
+			__func__, ## args);		\
 })
 
 static unsigned long __init bootmap_bytes(unsigned long pages)
-- 
1.6.0.rc1.154.ge3fc

