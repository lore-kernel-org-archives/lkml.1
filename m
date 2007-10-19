Return-Path: <linux-kernel-owner+w=401wt.eu-S935552AbXJSIA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935552AbXJSIA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 04:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966963AbXJSH7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:59:18 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54707 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966730AbXJSH7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:59:16 -0400
Date: Fri, 19 Oct 2007 03:59:15 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 9/9] irq-remove: misc fixes and cleanups
Message-ID: <20071019075915.GJ6407@havoc.gtf.org>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 497cd0c681f0d7144a240af45f5d5eaf5aea75ae
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 01:27:46 2007 -0400

    [IRQ ARG REMOVAL] x86-64 build fixes, cleanups

 arch/x86/kernel/time_64.c              |    2 +-
 drivers/atm/horizon.c                  |    2 +-
 drivers/input/touchscreen/ucb1400_ts.c |    2 +-
 drivers/mtd/onenand/onenand_base.c     |    2 +-
 drivers/net/cxgb3/adapter.h            |    2 +-
 drivers/net/netxen/netxen_nic_main.c   |    2 +-
 drivers/parport/parport_mfc3.c         |    2 +-
 drivers/scsi/gdth.c                    |   27 +++++++++++++--------------
 sound/drivers/mts64.c                  |    2 --
 sound/drivers/portman2x4.c             |    2 --
 10 files changed, 20 insertions(+), 25 deletions(-)

497cd0c681f0d7144a240af45f5d5eaf5aea75ae
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index c821edc..dd16458 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -148,7 +148,7 @@ int update_persistent_clock(struct timespec now)
 	return set_rtc_mmss(now.tv_sec);
 }
 
-static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
+static irqreturn_t timer_event_interrupt(void *dev_id)
 {
 	add_pda(irq0_irqs, 1);
 
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 9b2cf25..ddd1064 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -1382,7 +1382,7 @@ static inline void rx_data_av_handler (hrz_dev * dev) {
 
 /********** interrupt handler **********/
 
-static irqreturn_t interrupt_handler(int irq, void *dev_id)
+static irqreturn_t interrupt_handler(void *dev_id)
 {
   hrz_dev *dev = dev_id;
   u32 int_source;
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 68dac18..1a15e7f 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -356,7 +356,7 @@ static int ucb1400_ts_thread(void *_ucb)
  * interrupt by scheduling a RT kernel thread to run in process
  * context instead of interrupt context.
  */
-static irqreturn_t ucb1400_hard_irq(int irqnr, void *devid)
+static irqreturn_t ucb1400_hard_irq(void *devid)
 {
 	struct ucb1400 *ucb = devid;
 
diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index 1b0b320..ebc92dc 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -357,7 +357,7 @@ static int onenand_wait(struct mtd_info *mtd, int state)
  *
  * complete the work
  */
-static irqreturn_t onenand_interrupt(int irq, void *data)
+static irqreturn_t onenand_interrupt(void *data)
 {
 	struct onenand_chip *this = data;
 
diff --git a/drivers/net/cxgb3/adapter.h b/drivers/net/cxgb3/adapter.h
index 3814cc6..0333841 100644
--- a/drivers/net/cxgb3/adapter.h
+++ b/drivers/net/cxgb3/adapter.h
@@ -277,6 +277,6 @@ int t3_sge_alloc_qset(struct adapter *adapter, unsigned int id, int nports,
 		      int ntxq, struct net_device *dev);
 int t3_get_desc(const struct sge_qset *qs, unsigned int qnum, unsigned int idx,
 		unsigned char *data);
-irqreturn_t t3_sge_intr_msix(int irq, void *cookie);
+irqreturn_t t3_sge_intr_msix(void *cookie);
 
 #endif				/* __T3_ADAPTER_H__ */
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index c506398..76cfa8a 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -1266,7 +1266,7 @@ netxen_handle_int(struct netxen_adapter *adapter, struct net_device *netdev)
  * @irq: interrupt number
  * data points to adapter stucture (which may be handling more than 1 port
  */
-irqreturn_t netxen_intr(int irq, void *data)
+irqreturn_t netxen_intr(void *data)
 {
 	struct netxen_adapter *adapter = data;
 	struct net_device *netdev = adapter->netdev;
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 6dec9ba..137c828 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -211,7 +211,7 @@ static void mfc3_change_mode( struct parport *p, int m)
 
 static int use_cnt = 0;
 
-static irqreturn_t mfc3_interrupt(int irq, void *dev_id)
+static irqreturn_t mfc3_interrupt(void *dev_id)
 {
 	int i;
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3ac080e..4165350 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -140,8 +140,8 @@
 
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
-static irqreturn_t gdth_interrupt(int irq, void *dev_id);
-static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
+static irqreturn_t gdth_interrupt(void *dev_id);
+static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                                     int gdth_from_wait, int* pIndex);
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                                                                Scsi_Cmnd *scp);
@@ -165,7 +165,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
 static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
 
 static void gdth_enable_int(gdth_ha_str *ha);
-static unchar gdth_get_status(gdth_ha_str *ha, int irq);
+static unchar gdth_get_status(gdth_ha_str *ha);
 static int gdth_test_busy(gdth_ha_str *ha);
 static int gdth_get_cmd_index(gdth_ha_str *ha);
 static void gdth_release_event(gdth_ha_str *ha);
@@ -1334,14 +1334,12 @@ static void __init gdth_enable_int(gdth_ha_str *ha)
 }
 
 /* return IStatus if interrupt was from this card else 0 */
-static unchar gdth_get_status(gdth_ha_str *ha, int irq)
+static unchar gdth_get_status(gdth_ha_str *ha)
 {
     unchar IStatus = 0;
 
-    TRACE(("gdth_get_status() irq %d ctr_count %d\n", irq, gdth_ctr_count));
+    TRACE(("gdth_get_status() irq %d ctr_count %d\n", ha->irq, gdth_ctr_count));
 
-        if (ha->irq != (unchar)irq)             /* check IRQ */
-            return false;
         if (ha->type == GDT_EISA)
             IStatus = inb((ushort)ha->bmic + EDOORREG);
         else if (ha->type == GDT_ISA)
@@ -1523,7 +1521,7 @@ static int gdth_wait(gdth_ha_str *ha, int index, ulong32 time)
         return 1;                               /* no wait required */
 
     do {
-        __gdth_interrupt(ha, (int)ha->irq, true, &wait_index);
+        __gdth_interrupt(ha, true, &wait_index);
         if (wait_index == index) {
             answer_found = TRUE;
             break;
@@ -3036,7 +3034,7 @@ static void gdth_clear_events(void)
 
 /* SCSI interface functions */
 
-static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
+static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                                     int gdth_from_wait, int* pIndex)
 {
     gdt6m_dpram_str __iomem *dp6m_ptr = NULL;
@@ -3054,7 +3052,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
     int act_int_coal = 0;       
 #endif
 
-    TRACE(("gdth_interrupt() IRQ %d\n",irq));
+    TRACE(("gdth_interrupt() IRQ %d\n", ha->irq));
 
     /* if polling and not from gdth_wait() -> return */
     if (gdth_polling) {
@@ -3067,7 +3065,8 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
         spin_lock_irqsave(&ha->smp_lock, flags);
 
     /* search controller */
-    if (0 == (IStatus = gdth_get_status(ha, irq))) {
+    IStatus = gdth_get_status(ha);
+    if (!IStatus) {
         /* spurious interrupt */
         if (!gdth_polling)
             spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -3292,11 +3291,11 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
     return IRQ_HANDLED;
 }
 
-static irqreturn_t gdth_interrupt(int irq, void *dev_id)
+static irqreturn_t gdth_interrupt(void *dev_id)
 {
-	gdth_ha_str *ha = (gdth_ha_str *)dev_id;
+	gdth_ha_str *ha = dev_id;
 
-	return __gdth_interrupt(ha, irq, false, NULL);
+	return __gdth_interrupt(ha, false, NULL);
 }
 
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
diff --git a/sound/drivers/mts64.c b/sound/drivers/mts64.c
index 4990b35..dcc90f9 100644
--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -853,8 +853,6 @@ static void snd_mts64_interrupt(void *private)
 	}
 __out:
 	spin_unlock(&mts->lock);
-
-	return IRQ_HANDLED;
 }
 
 static int __devinit snd_mts64_probe_port(struct parport *p)
diff --git a/sound/drivers/portman2x4.c b/sound/drivers/portman2x4.c
index 7e4ac0b..e065b2a 100644
--- a/sound/drivers/portman2x4.c
+++ b/sound/drivers/portman2x4.c
@@ -645,8 +645,6 @@ static void snd_portman_interrupt(void *userdata)
 	}
 
 	spin_unlock(&pm->reg_lock);
-
-	return IRQ_HANDLED;
 }
 
 static int __devinit snd_portman_probe_port(struct parport *p)
