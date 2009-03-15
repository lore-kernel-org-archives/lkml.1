Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbZCOVz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbZCOVz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZCOVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:55:13 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:50508 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZCOVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:55:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Rm8/uCBNKJFNVlGO7QxS81hcVVoGnMkmP8mKOi3cF95ev672O2K+TpJLta+BP9AeBR
         ko6pVxtoIoG6BahvtZEl1PddTG705cc2cx31kqNsMdlAjOZGhwvgFWNLBNVEDXzM9RMd
         Sz2PaQI83whlF6qdPiwGY7HFj91wTfZ8AG+t4=
Date: Mon, 16 Mar 2009 00:54:53 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
       David Kiliani <mail@davidkiliani.de>
Subject: [PATCH] Staging: meilhaus: remove dependence on kernel version
Message-ID: <20090315215453.GA20194@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/meilhaus/me0600_ext_irq.c |    4 ---
 drivers/staging/meilhaus/me1400_ext_irq.c |    5 ---
 drivers/staging/meilhaus/me1600_ao.c      |   17 ------------
 drivers/staging/meilhaus/me1600_ao.h      |    4 ---
 drivers/staging/meilhaus/me4600_ai.c      |   25 -----------------
 drivers/staging/meilhaus/me4600_ai.h      |    4 ---
 drivers/staging/meilhaus/me4600_ao.c      |   41 +++--------------------------
 drivers/staging/meilhaus/me4600_ao.h      |    4 ---
 drivers/staging/meilhaus/me4600_ext_irq.c |    5 ---
 drivers/staging/meilhaus/me6000_ao.c      |   29 +-------------------
 drivers/staging/meilhaus/me6000_ao.h      |    4 ---
 drivers/staging/meilhaus/me8100_di.c      |    4 ---
 drivers/staging/meilhaus/me8200_di.c      |   16 -----------
 drivers/staging/meilhaus/me8200_do.c      |    4 ---
 14 files changed, 5 insertions(+), 161 deletions(-)

diff --git a/drivers/staging/meilhaus/me0600_ext_irq.c b/drivers/staging/meilhaus/me0600_ext_irq.c
index eba18ad..7863fbe 100644
--- a/drivers/staging/meilhaus/me0600_ext_irq.c
+++ b/drivers/staging/meilhaus/me0600_ext_irq.c
@@ -337,11 +337,7 @@ static void me0600_ext_irq_destructor(struct me_subdevice *subdevice)
 	kfree(instance);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me0600_isr(int irq, void *dev_id)
-#else
-static irqreturn_t me0600_isr(int irq, void *dev_id, struct pt_regs *regs)
-#endif
 {
 	me0600_ext_irq_subdevice_t *instance;
 	uint32_t status;
diff --git a/drivers/staging/meilhaus/me1400_ext_irq.c b/drivers/staging/meilhaus/me1400_ext_irq.c
index b4df7cc..766e42d 100644
--- a/drivers/staging/meilhaus/me1400_ext_irq.c
+++ b/drivers/staging/meilhaus/me1400_ext_irq.c
@@ -323,12 +323,7 @@ static int me1400_ext_irq_query_subdevice_caps_args(struct me_subdevice
 	return ME_ERRNO_NOT_SUPPORTED;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me1400_ext_irq_isr(int irq, void *dev_id)
-#else
-static irqreturn_t me1400_ext_irq_isr(int irq, void *dev_id,
-				      struct pt_regs *regs)
-#endif
 {
 	me1400_ext_irq_subdevice_t *instance;
 	uint32_t status;
diff --git a/drivers/staging/meilhaus/me1600_ao.c b/drivers/staging/meilhaus/me1600_ao.c
index 52b3b03..6ead7a3 100644
--- a/drivers/staging/meilhaus/me1600_ao.c
+++ b/drivers/staging/meilhaus/me1600_ao.c
@@ -55,11 +55,7 @@
 
 static void me1600_ao_destructor(struct me_subdevice *subdevice);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void me1600_ao_work_control_task(void *subdevice);
-#else
 static void me1600_ao_work_control_task(struct work_struct *work);
-#endif
 
 static int me1600_ao_io_reset_subdevice(me_subdevice_t * subdevice,
 					struct file *filep, int flags);
@@ -200,13 +196,8 @@ me1600_ao_subdevice_t *me1600_ao_constructor(uint32_t reg_base,
 	subdevice->me1600_workqueue = me1600_wq;
 
 /* workqueue API changed in kernel 2.6.20 */
-#if ( LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20) )
-	INIT_WORK(&subdevice->ao_control_task, me1600_ao_work_control_task,
-		  (void *)subdevice);
-#else
 	INIT_DELAYED_WORK(&subdevice->ao_control_task,
 			  me1600_ao_work_control_task);
-#endif
 	return subdevice;
 }
 
@@ -962,22 +953,14 @@ static int me1600_ao_query_range_info(me_subdevice_t * subdevice,
 	return ME_ERRNO_SUCCESS;
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void me1600_ao_work_control_task(void *subdevice)
-#else
 static void me1600_ao_work_control_task(struct work_struct *work)
-#endif
 {
 	me1600_ao_subdevice_t *instance;
 	int reschedule = 1;
 	int signaling = 0;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	instance = (me1600_ao_subdevice_t *) subdevice;
-#else
 	instance =
 	    container_of((void *)work, me1600_ao_subdevice_t, ao_control_task);
-#endif
 
 	PINFO("<%s: %ld> executed. idx=%d\n", __func__, jiffies,
 	      instance->ao_idx);
diff --git a/drivers/staging/meilhaus/me1600_ao.h b/drivers/staging/meilhaus/me1600_ao.h
index b82bf5a..4827dcb 100644
--- a/drivers/staging/meilhaus/me1600_ao.h
+++ b/drivers/staging/meilhaus/me1600_ao.h
@@ -98,11 +98,7 @@ typedef struct me1600_ao_subdevice {
 	wait_queue_head_t wait_queue;							/**< Wait queue to put on tasks waiting for data to arrive. */
 	me1600_ao_timeout_t timeout;							/**< The timeout for start in blocking and non-blocking mode. */
 	struct workqueue_struct *me1600_workqueue;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	struct work_struct ao_control_task;
-#else
 	struct delayed_work ao_control_task;
-#endif
 
 	volatile int ao_control_task_flag;						/**< Flag controling reexecuting of control task */
 } me1600_ao_subdevice_t;
diff --git a/drivers/staging/meilhaus/me4600_ai.c b/drivers/staging/meilhaus/me4600_ai.c
index 0a8c9d7..35bde02 100644
--- a/drivers/staging/meilhaus/me4600_ai.c
+++ b/drivers/staging/meilhaus/me4600_ai.c
@@ -125,11 +125,7 @@ static int me4600_ai_query_subdevice_caps(me_subdevice_t * subdevice,
 static int me4600_ai_query_subdevice_caps_args(struct me_subdevice *subdevice,
 					       int cap, int *args, int count);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me4600_ai_isr(int irq, void *dev_id);
-#else
-static irqreturn_t me4600_ai_isr(int irq, void *dev_id, struct pt_regs *regs);
-#endif
 
 static int ai_mux_toggler(me4600_ai_subdevice_t * subdevice);
 
@@ -177,11 +173,7 @@ void inline ai_limited_ISM(me4600_ai_subdevice_t * instance,
 /** Set ISM to next stage for limited mode */
 void inline ai_data_acquisition_logic(me4600_ai_subdevice_t * instance);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void me4600_ai_work_control_task(void *subdevice);
-#else
 static void me4600_ai_work_control_task(struct work_struct *work);
-#endif
 
 /* Definitions
  */
@@ -360,13 +352,8 @@ me4600_ai_subdevice_t *me4600_ai_constructor(uint32_t reg_base,
 	subdevice->me4600_workqueue = me4600_wq;
 
 /* workqueue API changed in kernel 2.6.20 */
-#if ( LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20) )
-	INIT_WORK(&subdevice->ai_control_task, me4600_ai_work_control_task,
-		  (void *)subdevice);
-#else
 	INIT_DELAYED_WORK(&subdevice->ai_control_task,
 			  me4600_ai_work_control_task);
-#endif
 
 	return subdevice;
 }
@@ -2603,11 +2590,7 @@ void ai_infinite_isr(me4600_ai_subdevice_t * instance,
 	}
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me4600_ai_isr(int irq, void *dev_id)
-#else
-static irqreturn_t me4600_ai_isr(int irq, void *dev_id, struct pt_regs *regs)
-#endif
 {				/// @note This is time critical function!
 	uint32_t irq_status;
 	uint32_t ctrl_status;
@@ -3310,11 +3293,7 @@ static int inline ai_read_data_pooling(me4600_ai_subdevice_t * instance)
 	return (!status) ? copied : -ME_ERRNO_RING_BUFFER_OVERFLOW;
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void me4600_ai_work_control_task(void *subdevice)
-#else
 static void me4600_ai_work_control_task(struct work_struct *work)
-#endif
 {
 	me4600_ai_subdevice_t *instance;
 	uint32_t status;
@@ -3323,12 +3302,8 @@ static void me4600_ai_work_control_task(struct work_struct *work)
 	int reschedule = 0;
 	int signaling = 0;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	instance = (me4600_ai_subdevice_t *) subdevice;
-#else
 	instance =
 	    container_of((void *)work, me4600_ai_subdevice_t, ai_control_task);
-#endif
 	PINFO("<%s: %ld> executed.\n", __func__, jiffies);
 
 	status = inl(instance->status_reg);
diff --git a/drivers/staging/meilhaus/me4600_ai.h b/drivers/staging/meilhaus/me4600_ai.h
index 1d5a1b9..106e195 100644
--- a/drivers/staging/meilhaus/me4600_ai.h
+++ b/drivers/staging/meilhaus/me4600_ai.h
@@ -139,11 +139,7 @@ typedef struct me4600_ai_subdevice {
 	wait_queue_head_t wait_queue;					/**< Wait queue to put on tasks waiting for data to arrive. */
 
 	struct workqueue_struct *me4600_workqueue;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	struct work_struct ai_control_task;
-#else
 	struct delayed_work ai_control_task;
-#endif
 
 	volatile int ai_control_task_flag;				/**< Flag controling reexecuting of control task */
 
diff --git a/drivers/staging/meilhaus/me4600_ao.c b/drivers/staging/meilhaus/me4600_ao.c
index 2571caf..fe7ad3a 100644
--- a/drivers/staging/meilhaus/me4600_ao.c
+++ b/drivers/staging/meilhaus/me4600_ao.c
@@ -175,11 +175,7 @@ static int me4600_ao_io_stream_write(me_subdevice_t * subdevice,
 
 /** Interrupt handler. Copy from buffer to FIFO.
 */
-static irqreturn_t me4600_ao_isr(int irq, void *dev_id
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
-				 , struct pt_regs *regs
-#endif
-    );
+static irqreturn_t me4600_ao_isr(int irq, void *dev_id);
 /** Copy data from circular buffer to fifo (fast) in wraparound mode.
 */
 int inline ao_write_data_wraparound(me4600_ao_subdevice_t * instance, int count,
@@ -206,13 +202,7 @@ int inline ao_stop_immediately(me4600_ao_subdevice_t * instance);
 
 /** Task for asynchronical state verifying.
 */
-static void me4600_ao_work_control_task(
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-					       void *subdevice
-#else
-					       struct work_struct *work
-#endif
-    );
+static void me4600_ao_work_control_task(struct work_struct *work);
 /* Functions
  */
 
@@ -2272,11 +2262,7 @@ static int me4600_ao_io_stream_write(me_subdevice_t * subdevice,
 
 	return err;
 }
-static irqreturn_t me4600_ao_isr(int irq, void *dev_id
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
-				 , struct pt_regs *regs
-#endif
-    )
+static irqreturn_t me4600_ao_isr(int irq, void *dev_id)
 {
 	me4600_ao_subdevice_t *instance = dev_id;
 	uint32_t irq_status;
@@ -2689,13 +2675,8 @@ me4600_ao_subdevice_t *me4600_ao_constructor(uint32_t reg_base,
 	subdevice->me4600_workqueue = me4600_wq;
 
 /* workqueue API changed in kernel 2.6.20 */
-#if ( LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20) )
-	INIT_WORK(&subdevice->ao_control_task, me4600_ao_work_control_task,
-		  (void *)subdevice);
-#else
 	INIT_DELAYED_WORK(&subdevice->ao_control_task,
 			  me4600_ao_work_control_task);
-#endif
 
 	if (subdevice->fifo) {	// Set speed for single operations.
 		outl(ME4600_AO_MIN_CHAN_TICKS - 1, subdevice->timer_reg);
@@ -2987,13 +2968,7 @@ int inline ao_get_data_from_user(me4600_ao_subdevice_t * instance, int count,
 /** @brief Checking actual hardware and logical state.
 * @param instance The subdevice instance (pointer).
 */
-static void me4600_ao_work_control_task(
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-					       void *subdevice
-#else
-					       struct work_struct *work
-#endif
-    )
+static void me4600_ao_work_control_task(struct work_struct *work)
 {
 	me4600_ao_subdevice_t *instance;
 	unsigned long cpu_flags = 0;
@@ -3003,12 +2978,8 @@ static void me4600_ao_work_control_task(
 	int reschedule = 0;
 	int signaling = 0;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	instance = (me4600_ao_subdevice_t *) subdevice;
-#else
 	instance =
 	    container_of((void *)work, me4600_ao_subdevice_t, ao_control_task);
-#endif
 	PINFO("<%s: %ld> executed. idx=%d\n", __func__, jiffies,
 	      instance->ao_idx);
 
@@ -5439,11 +5410,7 @@ static int me4600_ao_io_stream_write(me_subdevice_t * subdevice,
 	return err;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me4600_ao_isr(int irq, void *dev_id)
-#else
-static irqreturn_t me4600_ao_isr(int irq, void *dev_id, struct pt_regs *regs)
-#endif
 {
 	unsigned long tmp;
 	int value;
diff --git a/drivers/staging/meilhaus/me4600_ao.h b/drivers/staging/meilhaus/me4600_ao.h
index 6fbc4a2..7579435 100644
--- a/drivers/staging/meilhaus/me4600_ao.h
+++ b/drivers/staging/meilhaus/me4600_ao.h
@@ -225,11 +225,7 @@ typedef struct me4600_ao_subdevice {
 	wait_queue_head_t wait_queue;				/**< Wait queue to put on tasks waiting for data to arrive. */
 
 	struct workqueue_struct *me4600_workqueue;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	struct work_struct ao_control_task;
-#else
 	struct delayed_work ao_control_task;
-#endif
 
 	volatile int ao_control_task_flag;			/**< Flag controling reexecuting of control task */
 
diff --git a/drivers/staging/meilhaus/me4600_ext_irq.c b/drivers/staging/meilhaus/me4600_ext_irq.c
index adc1e1b..5f37875 100644
--- a/drivers/staging/meilhaus/me4600_ext_irq.c
+++ b/drivers/staging/meilhaus/me4600_ext_irq.c
@@ -335,12 +335,7 @@ static int me4600_ext_irq_query_subdevice_caps(me_subdevice_t * subdevice,
 	return ME_ERRNO_SUCCESS;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me4600_ext_irq_isr(int irq, void *dev_id)
-#else
-static irqreturn_t me4600_ext_irq_isr(int irq, void *dev_id,
-				      struct pt_regs *regs)
-#endif
 {
 	me4600_ext_irq_subdevice_t *instance;
 	uint32_t ctrl;
diff --git a/drivers/staging/meilhaus/me6000_ao.c b/drivers/staging/meilhaus/me6000_ao.c
index dcb3526..1cdf100 100644
--- a/drivers/staging/meilhaus/me6000_ao.c
+++ b/drivers/staging/meilhaus/me6000_ao.c
@@ -151,11 +151,7 @@ static int me6000_ao_io_stream_write(me_subdevice_t * subdevice,
 				     int *values, int *count, int flags);
 
 /** Interrupt handler. Copy from buffer to FIFO. */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me6000_ao_isr(int irq, void *dev_id);
-#else
-static irqreturn_t me6000_ao_isr(int irq, void *dev_id, struct pt_regs *regs);
-#endif
 
 /** Copy data from circular buffer to fifo (fast) in wraparound mode. */
 int inline ao_write_data_wraparound(me6000_ao_subdevice_t * instance, int count,
@@ -177,11 +173,7 @@ int inline ao_get_data_from_user(me6000_ao_subdevice_t * instance, int count,
 int inline ao_stop_immediately(me6000_ao_subdevice_t * instance);
 
 /** Function for checking timeout in non-blocking mode. */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void me6000_ao_work_control_task(void *subdevice);
-#else
 static void me6000_ao_work_control_task(struct work_struct *work);
-#endif
 
 /* Functions
  */
@@ -2324,11 +2316,7 @@ static int me6000_ao_io_stream_write(me_subdevice_t * subdevice,
 	return err;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me6000_ao_isr(int irq, void *dev_id)
-#else
-static irqreturn_t me6000_ao_isr(int irq, void *dev_id, struct pt_regs *regs)
-#endif
 {
 	me6000_ao_subdevice_t *instance = dev_id;
 	uint32_t irq_status;
@@ -2797,13 +2785,8 @@ me6000_ao_subdevice_t *me6000_ao_constructor(uint32_t reg_base,
 	subdevice->me6000_workqueue = me6000_wq;
 
 /* workqueue API changed in kernel 2.6.20 */
-#if ( LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20) )
-	INIT_WORK(&subdevice->ao_control_task, me6000_ao_work_control_task,
-		  (void *)subdevice);
-#else
 	INIT_DELAYED_WORK(&subdevice->ao_control_task,
 			  me6000_ao_work_control_task);
-#endif
 
 	if (subdevice->fifo) {	//Set speed
 		outl(ME6000_AO_MIN_CHAN_TICKS - 1, subdevice->timer_reg);
@@ -3110,13 +3093,7 @@ int inline ao_get_data_from_user(me6000_ao_subdevice_t * instance, int count,
 	return copied;
 }
 
-static void me6000_ao_work_control_task(
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-					       void *subdevice
-#else
-					       struct work_struct *work
-#endif
-    )
+static void me6000_ao_work_control_task(struct work_struct *work)
 {
 	me6000_ao_subdevice_t *instance;
 	unsigned long cpu_flags = 0;
@@ -3127,12 +3104,8 @@ static void me6000_ao_work_control_task(
 	int signaling = 0;
 	uint32_t single_mask;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	instance = (me6000_ao_subdevice_t *) subdevice;
-#else
 	instance =
 	    container_of((void *)work, me6000_ao_subdevice_t, ao_control_task);
-#endif
 	PINFO("<%s: %ld> executed. idx=%d\n", __func__, jiffies,
 	      instance->ao_idx);
 
diff --git a/drivers/staging/meilhaus/me6000_ao.h b/drivers/staging/meilhaus/me6000_ao.h
index 9629649..ef4d018 100644
--- a/drivers/staging/meilhaus/me6000_ao.h
+++ b/drivers/staging/meilhaus/me6000_ao.h
@@ -160,11 +160,7 @@ typedef struct me6000_ao_subdevice {
 	wait_queue_head_t wait_queue;			/**< Wait queue to put on tasks waiting for data to arrive. */
 
 	struct workqueue_struct *me6000_workqueue;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	struct work_struct ao_control_task;
-#else
 	struct delayed_work ao_control_task;
-#endif
 
 	volatile int ao_control_task_flag;		/**< Flag controling reexecuting of control task */
 
diff --git a/drivers/staging/meilhaus/me8100_di.c b/drivers/staging/meilhaus/me8100_di.c
index 971727c..9b5441a 100644
--- a/drivers/staging/meilhaus/me8100_di.c
+++ b/drivers/staging/meilhaus/me8100_di.c
@@ -503,11 +503,7 @@ static void me8100_di_destructor(struct me_subdevice *subdevice)
 	kfree(instance);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me8100_isr(int irq, void *dev_id)
-#else
-static irqreturn_t me8100_isr(int irq, void *dev_id, struct pt_regs *regs)
-#endif
 {
 	me8100_di_subdevice_t *instance;
 	uint32_t icsr;
diff --git a/drivers/staging/meilhaus/me8200_di.c b/drivers/staging/meilhaus/me8200_di.c
index 27525bc..6cd75ea 100644
--- a/drivers/staging/meilhaus/me8200_di.c
+++ b/drivers/staging/meilhaus/me8200_di.c
@@ -81,16 +81,8 @@ static int me8200_di_query_subdevice_type(me_subdevice_t * subdevice,
 					  int *type, int *subtype);
 static int me8200_di_query_subdevice_caps(me_subdevice_t * subdevice,
 					  int *caps);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me8200_isr(int irq, void *dev_id);
-#else
-static irqreturn_t me8200_isr(int irq, void *dev_id, struct pt_regs *regs);
-#endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me8200_isr_EX(int irq, void *dev_id);
-#else
-static irqreturn_t me8200_isr_EX(int irq, void *dev_id, struct pt_regs *regs);
-#endif
 static void me8200_di_check_version(me8200_di_subdevice_t * instance,
 				    unsigned long addr);
 
@@ -546,11 +538,7 @@ static int me8200_di_query_subdevice_caps(me_subdevice_t * subdevice, int *caps)
 	return ME_ERRNO_SUCCESS;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me8200_isr(int irq, void *dev_id)
-#else
-static irqreturn_t me8200_isr(int irq, void *dev_id, struct pt_regs *regs)
-#endif
 {
 	me8200_di_subdevice_t *instance;
 	uint8_t ctrl;
@@ -629,11 +617,7 @@ static irqreturn_t me8200_isr(int irq, void *dev_id, struct pt_regs *regs)
 	return IRQ_HANDLED;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me8200_isr_EX(int irq, void *dev_id)
-#else
-static irqreturn_t me8200_isr_EX(int irq, void *dev_id, struct pt_regs *regs)
-#endif
 {
 	me8200_di_subdevice_t *instance;
 	uint8_t irq_status = 0;
diff --git a/drivers/staging/meilhaus/me8200_do.c b/drivers/staging/meilhaus/me8200_do.c
index d2bebd1..eb04fdd 100644
--- a/drivers/staging/meilhaus/me8200_do.c
+++ b/drivers/staging/meilhaus/me8200_do.c
@@ -452,11 +452,7 @@ static void me8200_do_destructor(struct me_subdevice *subdevice)
 	kfree(instance);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static irqreturn_t me8200_do_isr(int irq, void *dev_id)
-#else
-static irqreturn_t me8200_do_isr(int irq, void *dev_id, struct pt_regs *regs)
-#endif
 {
 	me8200_do_subdevice_t *instance;
 	uint16_t ctrl;
