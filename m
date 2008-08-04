Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbYHDH5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbYHDH5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYHDH50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:57:26 -0400
Received: from ozlabs.org ([203.10.76.45]:53561 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYHDH5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:57:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from down_trylock()
Date: Mon, 4 Aug 2008 17:57:04 +1000
User-Agent: KMail/1.9.9
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <200808041328.45773.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808032251050.3668@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808032251050.3668@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200808041757.05323.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008 15:53:59 Linus Torvalds wrote:
> On Mon, 4 Aug 2008, Rusty Russell wrote:
> > Someone sent me a patch documenting the illogic of down_trylock().  I
> > decided to try to fix it rather than just bitch and moan.
>
> I do agree that it is illogical. I just think your solution is worse than
> the problem - turning one illogical function into a redundant one seems
> the worse problem.

Ah, to be clear: my second patch switches down_trylock() in terms of
down_try() and deprecates it.  Then 21 replacement patches.  Then finally a
patch to remove down_trylock() altogether.

This was "minimal obviously correct" patch.

> I'm much happier telling people to "just don't use semaphores any more".
> The _legacy_ users get down_trylock() right.

It just annoys me to see a turd in the tree.  Even a little old one.

Thanks,
Rusty.

Here's the git tree if anyone feels enthused (without final removal patch):

The following changes since commit 2b12a4c524812fb3f6ee590a02e65b95c8c32229:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (24):
      Introduce down_try()
      Deprecate down_trylock()
      down_trylock -> down_try in documentation and comments.
      down_trylock -> down_try in arch/ia64/kernel/salinfo.c
      down_trylock -> down_try in drivers/char/snsc.c
      down_trylock -> down_try in drivers/char/viotape.c
      down_trylock -> down_try in drivers/infiniband/core/user_mad.c
      down_trylock -> down_try in drivers/input/serio/hil_mlc.c
      down_trylock -> down_try in drivers/input/serio/hp_sdc_mlc.c
      down_trylock -> down_try in drivers/md/dm-raid1.c
      down_trylock -> down_try in drivers/net/3c527.c
      down_trylock -> down_try in drivers/net/irda/sir_dev.c
      down_trylock -> down_try in drivers/net/wireless/airo.c
      down_trylock -> down_try in drivers/scsi/aacraid/commsup.c
      down_trylock -> down_try for usb_trylock_device()
      down_trylock -> down_try in drivers/usb/gadget/inode.c
      down_trylock -> down_try in xfs
      down_trylock -> down_try in kernel/printk.c
      down_trylock -> down_try in drivers/watchdog/ar7_wdt.c
      down_trylock -> down_try in drivers/watchdog/it8712f_wdt.c
      down_trylock -> down_try in drivers/watchdog/s3c2410_wdt.c
      down_trylock -> down_try in drivers/watchdog/sc1200wdt.c
      down_trylock -> down_try in drivers/watchdog/scx200_wdt.c
      down_trylock -> down_try in drivers/watchdog/wdt_pci.c

 arch/ia64/kernel/salinfo.c         |    4 ++--
 drivers/char/snsc.c                |    4 ++--
 drivers/char/viotape.c             |    4 ++--
 drivers/infiniband/core/user_mad.c |    2 +-
 drivers/input/serio/hil_mlc.c      |    4 ++--
 drivers/input/serio/hp_sdc_mlc.c   |   14 +++++++-------
 drivers/md/dm-raid1.c              |    2 +-
 drivers/net/3c527.c                |    2 +-
 drivers/net/irda/sir_dev.c         |    2 +-
 drivers/net/wireless/airo.c        |   12 ++++++------
 drivers/scsi/aacraid/commsup.c     |    2 +-
 drivers/usb/core/usb.c             |    2 +-
 drivers/usb/gadget/inode.c         |    2 +-
 drivers/watchdog/ar7_wdt.c         |    2 +-
 drivers/watchdog/it8712f_wdt.c     |    2 +-
 drivers/watchdog/s3c2410_wdt.c     |    2 +-
 drivers/watchdog/sc1200wdt.c       |    2 +-
 drivers/watchdog/scx200_wdt.c      |    2 +-
 drivers/watchdog/wdt_pci.c         |    2 +-
 fs/ocfs2/inode.c                   |    4 ----
 fs/xfs/linux-2.6/sema.h            |    8 +++-----
 fs/xfs/linux-2.6/xfs_buf.c         |    4 ++--
 include/linux/mutex.h              |    4 ----
 include/linux/semaphore.h          |    8 ++++++--
 include/linux/usb.h                |    2 +-
 kernel/mutex.c                     |    4 ++--
 kernel/printk.c                    |    4 ++--
 kernel/semaphore.c                 |   17 ++++++++---------
 28 files changed, 58 insertions(+), 65 deletions(-)
===
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index ecb9eb7..57c10ef 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -192,7 +192,7 @@ struct salinfo_platform_oemdata_parms {
 static void
 salinfo_work_to_do(struct salinfo_data *data)
 {
-	down_trylock(&data->mutex);
+	down_try(&data->mutex);
 	up(&data->mutex);
 }
 
@@ -309,7 +309,7 @@ salinfo_event_read(struct file *file, char __user *buffer, size_t count, loff_t
 	int i, n, cpu = -1;
 
 retry:
-	if (cpus_empty(data->cpu_event) && down_trylock(&data->mutex)) {
+	if (cpus_empty(data->cpu_event) && !down_try(&data->mutex)) {
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 		if (down_interruptible(&data->mutex))
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index 3ce60df..548161d 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -164,7 +164,7 @@ scdrv_read(struct file *file, char __user *buf, size_t count, loff_t *f_pos)
 	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
 
 	/* try to get control of the read buffer */
-	if (down_trylock(&sd->sd_rbs)) {
+	if (!down_try(&sd->sd_rbs)) {
 		/* somebody else has it now;
 		 * if we're non-blocking, then exit...
 		 */
@@ -256,7 +256,7 @@ scdrv_write(struct file *file, const char __user *buf,
 	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
 
 	/* try to get control of the write buffer */
-	if (down_trylock(&sd->sd_wbs)) {
+	if (!down_try(&sd->sd_wbs)) {
 		/* somebody else has it now;
 		 * if we're non-blocking, then exit...
 		 */
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 7a70a40..884613e 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -362,7 +362,7 @@ static ssize_t viotap_write(struct file *file, const char *buf,
 	 * semaphore
 	 */
 	if (noblock) {
-		if (down_trylock(&reqSem)) {
+		if (!down_try(&reqSem)) {
 			ret = -EWOULDBLOCK;
 			goto free_op;
 		}
@@ -452,7 +452,7 @@ static ssize_t viotap_read(struct file *file, char *buf, size_t count,
 	 * semaphore
 	 */
 	if (noblock) {
-		if (down_trylock(&reqSem)) {
+		if (!down_try(&reqSem)) {
 			ret = -EWOULDBLOCK;
 			goto free_op;
 		}
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 268a2d2..ae7a981 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -901,7 +901,7 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 		return -ENXIO;
 
 	if (filp->f_flags & O_NONBLOCK) {
-		if (down_trylock(&port->sm_sem)) {
+		if (!down_try(&port->sm_sem)) {
 			ret = -EAGAIN;
 			goto fail;
 		}
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index 37586a6..e779f3d 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -607,7 +607,7 @@ static inline void hilse_setup_input(hil_mlc *mlc, const struct hilse_node *node
 	do_gettimeofday(&(mlc->instart));
 	mlc->icount = 15;
 	memset(mlc->ipacket, 0, 16 * sizeof(hil_packet));
-	BUG_ON(down_trylock(&mlc->isem));
+	BUG_ON(!down_try(&mlc->isem));
 }
 
 #ifdef HIL_MLC_DEBUG
@@ -694,7 +694,7 @@ static int hilse_donode(hil_mlc *mlc)
 	out2:
 		write_unlock_irqrestore(&mlc->lock, flags);
 
-		if (down_trylock(&mlc->osem)) {
+		if (!down_try(&mlc->osem)) {
 			nextidx = HILSEN_DOZE;
 			break;
 		}
diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
index b587e2d..e88a352 100644
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -148,7 +148,7 @@ static int hp_sdc_mlc_in(hil_mlc *mlc, suseconds_t timeout)
 	priv = mlc->priv;
 
 	/* Try to down the semaphore */
-	if (down_trylock(&mlc->isem)) {
+	if (!down_try(&mlc->isem)) {
 		struct timeval tv;
 		if (priv->emtestmode) {
 			mlc->ipacket[0] =
@@ -186,13 +186,13 @@ static int hp_sdc_mlc_cts(hil_mlc *mlc)
 	priv = mlc->priv;
 
 	/* Try to down the semaphores -- they should be up. */
-	BUG_ON(down_trylock(&mlc->isem));
-	BUG_ON(down_trylock(&mlc->osem));
+	BUG_ON(!down_try(&mlc->isem));
+	BUG_ON(!down_try(&mlc->osem));
 
 	up(&mlc->isem);
 	up(&mlc->osem);
 
-	if (down_trylock(&mlc->csem)) {
+	if (!down_try(&mlc->csem)) {
 		if (priv->trans.act.semaphore != &mlc->csem)
 			goto poll;
 		else
@@ -229,7 +229,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
 	priv = mlc->priv;
 
 	/* Try to down the semaphore -- it should be up. */
-	BUG_ON(down_trylock(&mlc->osem));
+	BUG_ON(!down_try(&mlc->osem));
 
 	if (mlc->opacket & HIL_DO_ALTER_CTRL)
 		goto do_control;
@@ -240,7 +240,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
 		return;
 	}
 	/* Shouldn't be sending commands when loop may be busy */
-	BUG_ON(down_trylock(&mlc->csem));
+	BUG_ON(!down_try(&mlc->csem));
 	up(&mlc->csem);
 
 	priv->trans.actidx = 0;
@@ -296,7 +296,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
 	priv->tseq[3] = 0;
 	if (mlc->opacket & HIL_CTRL_APE) {
 		priv->tseq[3] |= HP_SDC_LPC_APE_IPF;
-		down_trylock(&mlc->csem);
+		down_try(&mlc->csem);
 	}
  enqueue:
 	hp_sdc_enqueue_transaction(&priv->trans);
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ff05fe8..137f024 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -587,7 +587,7 @@ static void rh_recovery_prepare(struct region_hash *rh)
 	/* Extra reference to avoid race with rh_stop_recovery */
 	atomic_inc(&rh->recovery_in_flight);
 
-	while (!down_trylock(&rh->recovery_count)) {
+	while (down_try(&rh->recovery_count)) {
 		atomic_inc(&rh->recovery_in_flight);
 		if (__rh_recovery_prepare(rh) <= 0) {
 			atomic_dec(&rh->recovery_in_flight);
diff --git a/drivers/net/3c527.c b/drivers/net/3c527.c
index 6aca0c6..9f57863 100644
--- a/drivers/net/3c527.c
+++ b/drivers/net/3c527.c
@@ -576,7 +576,7 @@ static int mc32_command_nowait(struct net_device *dev, u16 cmd, void *data, int
 	int ioaddr = dev->base_addr;
 	int ret = -1;
 
-	if (down_trylock(&lp->cmd_mutex) == 0)
+	if (down_try(&lp->cmd_mutex))
 	{
 		lp->cmd_nonblocking=1;
 		lp->exec_box->mbox=0;
diff --git a/drivers/net/irda/sir_dev.c b/drivers/net/irda/sir_dev.c
index 3f32909..8b9e26e 100644
--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -287,7 +287,7 @@ int sirdev_schedule_request(struct sir_dev *dev, int initial_state, unsigned par
 	IRDA_DEBUG(2, "%s - state=0x%04x / param=%u\n", __func__,
 			initial_state, param);
 
-	if (down_trylock(&fsm->sem)) {
+	if (!down_try(&fsm->sem)) {
 		if (in_interrupt()  ||  in_atomic()  ||  irqs_disabled()) {
 			IRDA_DEBUG(1, "%s(), state machine busy!\n", __func__);
 			return -EWOULDBLOCK;
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index b5cd850..fc36977 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2137,7 +2137,7 @@ static int airo_start_xmit(struct sk_buff *skb, struct net_device *dev) {
 	fids[i] |= (len << 16);
 	priv->xmit.skb = skb;
 	priv->xmit.fid = i;
-	if (down_trylock(&priv->sem) != 0) {
+	if (!down_try(&priv->sem)) {
 		set_bit(FLAG_PENDING_XMIT, &priv->flags);
 		netif_stop_queue(dev);
 		set_bit(JOB_XMIT, &priv->jobs);
@@ -2208,7 +2208,7 @@ static int airo_start_xmit11(struct sk_buff *skb, struct net_device *dev) {
 	fids[i] |= (len << 16);
 	priv->xmit11.skb = skb;
 	priv->xmit11.fid = i;
-	if (down_trylock(&priv->sem) != 0) {
+	if (!down_try(&priv->sem)) {
 		set_bit(FLAG_PENDING_XMIT11, &priv->flags);
 		netif_stop_queue(dev);
 		set_bit(JOB_XMIT11, &priv->jobs);
@@ -2258,7 +2258,7 @@ static struct net_device_stats *airo_get_stats(struct net_device *dev)
 
 	if (!test_bit(JOB_STATS, &local->jobs)) {
 		/* Get stats out of the card if available */
-		if (down_trylock(&local->sem) != 0) {
+		if (!down_try(&local->sem)) {
 			set_bit(JOB_STATS, &local->jobs);
 			wake_up_interruptible(&local->thr_wait);
 		} else
@@ -2285,7 +2285,7 @@ static void airo_set_multicast_list(struct net_device *dev) {
 
 	if ((dev->flags ^ ai->flags) & IFF_PROMISC) {
 		change_bit(FLAG_PROMISC, &ai->flags);
-		if (down_trylock(&ai->sem) != 0) {
+		if (!down_try(&ai->sem)) {
 			set_bit(JOB_PROMISC, &ai->jobs);
 			wake_up_interruptible(&ai->thr_wait);
 		} else
@@ -3213,7 +3213,7 @@ static irqreturn_t airo_interrupt(int irq, void *dev_id)
 				set_bit(FLAG_UPDATE_UNI, &apriv->flags);
 				set_bit(FLAG_UPDATE_MULTI, &apriv->flags);
 
-				if (down_trylock(&apriv->sem) != 0) {
+				if (!down_try(&apriv->sem)) {
 					set_bit(JOB_EVENT, &apriv->jobs);
 					wake_up_interruptible(&apriv->thr_wait);
 				} else
@@ -7659,7 +7659,7 @@ static struct iw_statistics *airo_get_wireless_stats(struct net_device *dev)
 
 	if (!test_bit(JOB_WSTATS, &local->jobs)) {
 		/* Get stats out of the card if available */
-		if (down_trylock(&local->sem) != 0) {
+		if (!down_try(&local->sem)) {
 			set_bit(JOB_WSTATS, &local->jobs);
 			wake_up_interruptible(&local->thr_wait);
 		} else
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 289304a..c011d05 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -490,7 +490,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 			 * hardware failure has occurred.
 			 */
 			unsigned long count = 36000000L; /* 3 minutes */
-			while (down_trylock(&fibptr->event_wait)) {
+			while (!down_try(&fibptr->event_wait)) {
 				int blink;
 				if (--count == 0) {
 					struct aac_queue * q = &dev->queues->queue[AdapNormCmdQueue];
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 84fcaa6..f31f0c5 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -477,7 +477,7 @@ int usb_lock_device_for_reset(struct usb_device *udev,
 		}
 	}
 
-	while (usb_trylock_device(udev) != 0) {
+	while (!usb_trylock_device(udev)) {
 
 		/* If we can't acquire the lock after waiting one second,
 		 * we're probably deadlocked */
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index f4585d3..981275b 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -297,7 +297,7 @@ get_ready_ep (unsigned f_flags, struct ep_data *epdata)
 	int	val;
 
 	if (f_flags & O_NONBLOCK) {
-		if (down_trylock (&epdata->lock) != 0)
+		if (!down_try (&epdata->lock))
 			goto nonblock;
 		if (epdata->state != STATE_EP_ENABLED) {
 			up (&epdata->lock);
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 2eb48c0..5c43dd5 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -179,7 +179,7 @@ static void ar7_wdt_disable_wdt(void)
 static int ar7_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	if (!down_try(&open_semaphore))
 		return -EBUSY;
 	ar7_wdt_enable_wdt();
 	expect_close = 0;
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 445b7e8..c9a057c 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -306,7 +306,7 @@ static int
 it8712f_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&it8712f_wdt_sem))
+	if (!down_try(&it8712f_wdt_sem))
 		return -EBUSY;
 	it8712f_wdt_enable();
 
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 98532c0..23f470a 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -211,7 +211,7 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 
 static int s3c2410wdt_open(struct inode *inode, struct file *file)
 {
-	if(down_trylock(&open_lock))
+	if(!down_try(&open_lock))
 		return -EBUSY;
 
 	if (nowayout)
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 35cddff..c080e6a 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -151,7 +151,7 @@ static inline int sc1200wdt_status(void)
 static int sc1200wdt_open(struct inode *inode, struct file *file)
 {
 	/* allow one at a time */
-	if (down_trylock(&open_sem))
+	if (!down_try(&open_sem))
 		return -EBUSY;
 
 	if (timeout > MAX_TIMEOUT)
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index d55882b..e131988 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -92,7 +92,7 @@ static void scx200_wdt_disable(void)
 static int scx200_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	if (!down_try(&open_semaphore))
 		return -EBUSY;
 	scx200_wdt_enable();
 
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 1355608..c20690d 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -426,7 +426,7 @@ static int wdtpci_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 
 static int wdtpci_open(struct inode *inode, struct file *file)
 {
-	if (down_trylock(&open_sem))
+	if (!down_try(&open_sem))
 		return -EBUSY;
 
 	if (nowayout) {
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7e9e4c7..64211fc 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1062,10 +1062,6 @@ void ocfs2_clear_inode(struct inode *inode)
 			(unsigned long long)oi->ip_blkno);
 	mutex_unlock(&oi->ip_io_mutex);
 
-	/*
-	 * down_trylock() returns 0, down_write_trylock() returns 1
-	 * kernel 1, world 0
-	 */
 	mlog_bug_on_msg(!down_write_trylock(&oi->ip_alloc_sem),
 			"Clear inode of %llu, alloc_sem is locked\n",
 			(unsigned long long)oi->ip_blkno);
diff --git a/fs/xfs/linux-2.6/sema.h b/fs/xfs/linux-2.6/sema.h
index 3abe7e9..7d20f04 100644
--- a/fs/xfs/linux-2.6/sema.h
+++ b/fs/xfs/linux-2.6/sema.h
@@ -36,17 +36,15 @@ typedef struct semaphore sema_t;
 
 static inline int issemalocked(sema_t *sp)
 {
-	return down_trylock(sp) || (up(sp), 0);
+	return !down_try(sp) || (up(sp), 0);
 }
 
 /*
- * Map cpsema (try to get the sema) to down_trylock. We need to switch
- * the return values since cpsema returns 1 (acquired) 0 (failed) and
- * down_trylock returns the reverse 0 (acquired) 1 (failed).
+ * Map cpsema (try to get the sema) to down_try.
  */
 static inline int cpsema(sema_t *sp)
 {
-	return down_trylock(sp) ? 0 : 1;
+	return down_try(sp);
 }
 
 #endif /* __XFS_SUPPORT_SEMA_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 9cc8f02..09e50cd 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -538,7 +538,7 @@ found:
 	 * if this does not work then we need to drop the
 	 * spinlock and do a hard attempt on the semaphore.
 	 */
-	if (down_trylock(&bp->b_sema)) {
+	if (!down_try(&bp->b_sema)) {
 		if (!(flags & XBF_TRYLOCK)) {
 			/* wait for buffer ownership */
 			XB_TRACE(bp, "get_lock", 0);
@@ -882,7 +882,7 @@ xfs_buf_cond_lock(
 {
 	int			locked;
 
-	locked = down_trylock(&bp->b_sema) == 0;
+	locked = down_try(&bp->b_sema);
 	if (locked) {
 		XB_SET_OWNER(bp);
 	}
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index bc6da10..c1f5b3f 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -141,10 +141,6 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
 #endif
 
-/*
- * NOTE: mutex_trylock() follows the spin_trylock() convention,
- *       not the down_trylock() convention!
- */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
 
diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 7415839..00af3c2 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -42,8 +42,12 @@ static inline void sema_init(struct semaphore *sem, int val)
 extern void down(struct semaphore *sem);
 extern int __must_check down_interruptible(struct semaphore *sem);
 extern int __must_check down_killable(struct semaphore *sem);
-extern int __must_check down_trylock(struct semaphore *sem);
+extern bool __must_check down_try(struct semaphore *sem);
+/* Old down_trylock() returned the opposite of what was expected. */
+static inline int __deprecated down_trylock(struct semaphore *sem)
+{
+	return !down_try(sem);
+}
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
 extern void up(struct semaphore *sem);
-
 #endif /* __LINUX_SEMAPHORE_H */
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 5811c5d..2664efd 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -492,7 +492,7 @@ extern void usb_put_dev(struct usb_device *dev);
 /* USB device locking */
 #define usb_lock_device(udev)		down(&(udev)->dev.sem)
 #define usb_unlock_device(udev)		up(&(udev)->dev.sem)
-#define usb_trylock_device(udev)	down_trylock(&(udev)->dev.sem)
+#define usb_trylock_device(udev)	down_try(&(udev)->dev.sem)
 extern int usb_lock_device_for_reset(struct usb_device *udev,
 				     const struct usb_interface *iface);
 
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 12c779d..38823ca 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -371,8 +371,8 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
  * Try to acquire the mutex atomically. Returns 1 if the mutex
  * has been acquired successfully, and 0 on contention.
  *
- * NOTE: this function follows the spin_trylock() convention, so
- * it is negated to the down_trylock() return values! Be careful
+ * NOTE: this function follows the spin_trylock()/down_try() convention,
+ * so it is negated to the old down_trylock() return values! Be careful
  * about this when converting semaphore users to mutexes.
  *
  * This function must not be used in interrupt context. The
diff --git a/kernel/printk.c b/kernel/printk.c
index b51b156..ab30884 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -969,7 +969,7 @@ EXPORT_SYMBOL(acquire_console_sem);
 
 int try_acquire_console_sem(void)
 {
-	if (down_trylock(&console_sem))
+	if (!down_try(&console_sem))
 		return -1;
 	console_locked = 1;
 	console_may_schedule = 0;
@@ -1068,7 +1068,7 @@ void console_unblank(void)
 	 * oops_in_progress is set to 1..
 	 */
 	if (oops_in_progress) {
-		if (down_trylock(&console_sem) != 0)
+		if (!down_try(&console_sem))
 			return;
 	} else
 		acquire_console_sem();
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index aaaeae8..e9fdc4e 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -14,7 +14,7 @@
  * Some notes on the implementation:
  *
  * The spinlock controls access to the other members of the semaphore.
- * down_trylock() and up() can be called from interrupt context, so we
+ * down_try() and up() can be called from interrupt context, so we
  * have to disable interrupts when taking the lock.  It turns out various
  * parts of the kernel expect to be able to use down() on a semaphore in
  * interrupt context when they know it will succeed, so we have to use
@@ -115,19 +115,18 @@ int down_killable(struct semaphore *sem)
 EXPORT_SYMBOL(down_killable);
 
 /**
- * down_trylock - try to acquire the semaphore, without waiting
+ * down_try - try to acquire the semaphore, without waiting
  * @sem: the semaphore to be acquired
  *
- * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
- * been acquired successfully or 1 if it it cannot be acquired.
+ * Try to acquire the semaphore atomically.  Returns true if the mutex has
+ * been acquired successfully or 0 if it it cannot be acquired.
  *
- * NOTE: This return value is inverted from both spin_trylock and
- * mutex_trylock!  Be careful about this when converting code.
+ * NOTE: This replaces down_trylock() which returned the reverse.
  *
  * Unlike mutex_trylock, this function can be used from interrupt context,
  * and the semaphore can be released by any task or interrupt.
  */
-int down_trylock(struct semaphore *sem)
+bool down_try(struct semaphore *sem)
 {
 	unsigned long flags;
 	int count;
@@ -138,9 +137,9 @@ int down_trylock(struct semaphore *sem)
 		sem->count = count;
 	spin_unlock_irqrestore(&sem->lock, flags);
 
-	return (count < 0);
+	return (count >= 0);
 }
-EXPORT_SYMBOL(down_trylock);
+EXPORT_SYMBOL(down_try);
 
 /**
  * down_timeout - acquire the semaphore within a specified time

