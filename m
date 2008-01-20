Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYATJvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYATJvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 04:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYATJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 04:51:29 -0500
Received: from ozlabs.org ([203.10.76.45]:52145 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYATJvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 04:51:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/6] typesafe: convert kthread users
Date: Sun, 20 Jan 2008 20:50:41 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
References: <200801202046.14746.rusty@rustcorp.com.au> <200801202047.22943.rusty@rustcorp.com.au> <200801202048.34796.rusty@rustcorp.com.au>
In-Reply-To: <200801202048.34796.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202050.41495.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the warnings created by the patch to make kthread typesafe.

Other than fs/dlm/recoverd.c (which use a typedef to void and now
needs a cast), the changes were trivial and obvious.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 crypto/cryptd.c                               |    6 +++---
 crypto/cryptomgr.c                            |    3 +--
 drivers/base/firmware_class.c                 |    5 ++---
 drivers/block/loop.c                          |    3 +--
 drivers/block/pktcdvd.c                       |    3 +--
 drivers/char/ipmi/ipmi_si_intf.c              |    3 +--
 drivers/ieee1394/nodemgr.c                    |    3 +--
 drivers/infiniband/core/fmr_pool.c            |    4 +---
 drivers/input/touchscreen/ucb1400_ts.c        |    3 +--
 drivers/md/md.c                               |    6 ++----
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c   |    3 +--
 drivers/media/dvb/dvb-core/dvb_frontend.c     |    3 +--
 drivers/media/video/cx88/cx88-tvaudio.c       |    3 +--
 drivers/media/video/cx88/cx88.h               |    2 +-
 drivers/media/video/msp3400-driver.c          |    2 +-
 drivers/media/video/msp3400-driver.h          |    6 +++---
 drivers/media/video/msp3400-kthreads.c        |    9 +++------
 drivers/media/video/saa7134/saa7134-tvaudio.c |    8 +++-----
 drivers/media/video/tvaudio.c                 |    3 +--
 drivers/media/video/videobuf-dvb.c            |    3 +--
 drivers/media/video/vivi.c                    |    4 +---
 drivers/mmc/card/queue.c                      |    3 +--
 drivers/mmc/core/sdio_irq.c                   |    3 +--
 drivers/mtd/mtd_blkdevs.c                     |    3 +--
 drivers/mtd/ubi/wl.c                          |    3 +--
 drivers/net/irda/stir4200.c                   |    3 +--
 drivers/net/wireless/airo.c                   |    5 ++---
 drivers/net/wireless/libertas/main.c          |    3 +--
 drivers/pcmcia/cs.c                           |    5 ++---
 drivers/scsi/aacraid/aacraid.h                |    2 +-
 drivers/scsi/aacraid/commsup.c                |    3 +--
 drivers/scsi/libsas/sas_scsi_host.c           |    4 +---
 drivers/scsi/lpfc/lpfc_crtn.h                 |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c              |    3 +--
 drivers/scsi/qla2xxx/qla_os.c                 |    7 ++-----
 drivers/scsi/scsi_error.c                     |    4 +---
 drivers/scsi/scsi_priv.h                      |    2 +-
 drivers/scsi/scsi_scan.c                      |    3 +--
 drivers/usb/atm/ueagle-atm.c                  |    3 +--
 drivers/usb/gadget/file_storage.c             |    6 ++----
 drivers/usb/storage/usb.c                     |    7 ++-----
 drivers/w1/w1.c                               |    4 +---
 drivers/w1/w1.h                               |    2 +-
 fs/dlm/recoverd.c                             |    4 ++--
 fs/gfs2/daemon.c                              |   13 ++++---------
 fs/gfs2/daemon.h                              |    8 ++++----
 fs/gfs2/locking/dlm/thread.c                  |   11 +++++------
 fs/jbd/journal.c                              |    3 +--
 fs/jbd2/journal.c                             |    3 +--
 fs/nfs/delegation.c                           |    3 +--
 fs/nfs/nfs4state.c                            |    5 ++---
 fs/nfsd/nfs4callback.c                        |    3 +--
 fs/nfsd/nfs4state.c                           |    4 +---
 fs/ocfs2/cluster/heartbeat.c                  |    3 +--
 fs/ocfs2/dlm/dlmrecovery.c                    |    5 ++---
 fs/ocfs2/dlm/dlmthread.c                      |    5 ++---
 fs/ocfs2/journal.c                            |   10 ++++------
 fs/ocfs2/vote.c                               |    3 +--
 fs/ocfs2/vote.h                               |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c                    |    5 ++---
 fs/xfs/linux-2.6/xfs_super.c                  |    3 +--
 kernel/audit.c                                |    3 +--
 kernel/audit.h                                |    2 +-
 kernel/rtmutex-tester.c                       |    3 +--
 kernel/stop_machine.c                         |    3 +--
 kernel/workqueue.c                            |    3 +--
 mm/vmscan.c                                   |    3 +--
 net/9p/mux.c                                  |    6 ++----
 net/core/pktgen.c                             |    3 +--
 sound/pci/emu10k1/emu10k1_main.c              |    3 +--
 70 files changed, 104 insertions(+), 183 deletions(-)

diff -r 110aa94129d0 crypto/cryptd.c
--- a/crypto/cryptd.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/crypto/cryptd.c	Fri Jan 18 11:31:48 2008 +1100
@@ -291,7 +291,8 @@ static struct crypto_template cryptd_tmp
 };
 
 static inline int cryptd_create_thread(struct cryptd_state *state,
-				       int (*fn)(void *data), const char *name)
+				       int (*fn)(struct cryptd_state *state),
+				       const char *name)
 {
 	spin_lock_init(&state->lock);
 	mutex_init(&state->mutex);
@@ -310,9 +311,8 @@ static inline void cryptd_stop_thread(st
 	kthread_stop(state->task);
 }
 
-static int cryptd_thread(void *data)
+static int cryptd_thread(struct cryptd_state *state)
 {
-	struct cryptd_state *state = data;
 	int stop;
 
 	current->flags |= PF_NOFREEZE;
diff -r 110aa94129d0 crypto/cryptomgr.c
--- a/crypto/cryptomgr.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/crypto/cryptomgr.c	Fri Jan 18 11:31:48 2008 +1100
@@ -47,9 +47,8 @@ struct cryptomgr_param {
 	char template[CRYPTO_MAX_ALG_NAME];
 };
 
-static int cryptomgr_probe(void *data)
+static int cryptomgr_probe(struct cryptomgr_param *param)
 {
-	struct cryptomgr_param *param = data;
 	struct crypto_template *tmpl;
 	struct crypto_instance *inst;
 	int err;
diff -r 110aa94129d0 drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/base/firmware_class.c	Fri Jan 18 11:31:48 2008 +1100
@@ -488,12 +488,11 @@ struct firmware_work {
 };
 
 static int
-request_firmware_work_func(void *arg)
+request_firmware_work_func(struct firmware_work *fw_work)
 {
-	struct firmware_work *fw_work = arg;
 	const struct firmware *fw;
 	int ret;
-	if (!arg) {
+	if (!fw_work) {
 		WARN_ON(1);
 		return 0;
 	}
diff -r 110aa94129d0 drivers/block/loop.c
--- a/drivers/block/loop.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/block/loop.c	Fri Jan 18 11:31:48 2008 +1100
@@ -577,9 +577,8 @@ static inline void loop_handle_bio(struc
  * once kthread_should_stop() is true and lo_bio is NULL, we are
  * done with the loop.
  */
-static int loop_thread(void *data)
+static int loop_thread(struct loop_device *lo)
 {
-	struct loop_device *lo = data;
 	struct bio *bio;
 
 	set_user_nice(current, -20);
diff -r 110aa94129d0 drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/block/pktcdvd.c	Fri Jan 18 11:31:48 2008 +1100
@@ -1595,9 +1595,8 @@ static void pkt_count_states(struct pktc
  * kcdrwd is woken up when writes have been queued for one of our
  * registered devices
  */
-static int kcdrwd(void *foobar)
+static int kcdrwd(struct pktcdvd_device *pd)
 {
-	struct pktcdvd_device *pd = foobar;
 	struct packet_data *pkt;
 	long min_sleep_time, residue;
 
diff -r 110aa94129d0 drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/char/ipmi/ipmi_si_intf.c	Fri Jan 18 11:31:48 2008 +1100
@@ -867,9 +867,8 @@ static void set_run_to_completion(void *
 	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 }
 
-static int ipmi_thread(void *data)
+static int ipmi_thread(struct smi_info *smi_info)
 {
-	struct smi_info *smi_info = data;
 	unsigned long flags;
 	enum si_sm_result smi_result;
 
diff -r 110aa94129d0 drivers/ieee1394/nodemgr.c
--- a/drivers/ieee1394/nodemgr.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/ieee1394/nodemgr.c	Fri Jan 18 11:31:48 2008 +1100
@@ -1686,9 +1686,8 @@ static int nodemgr_check_irm_capability(
 	return 1;
 }
 
-static int nodemgr_host_thread(void *__hi)
+static int nodemgr_host_thread(struct host_info *hi)
 {
-	struct host_info *hi = (struct host_info *)__hi;
 	struct hpsb_host *host = hi->host;
 	unsigned int g, generation = 0;
 	int i, reset_cycles = 0;
diff -r 110aa94129d0 drivers/infiniband/core/fmr_pool.c
--- a/drivers/infiniband/core/fmr_pool.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/infiniband/core/fmr_pool.c	Fri Jan 18 11:31:48 2008 +1100
@@ -177,10 +177,8 @@ static void ib_fmr_batch_release(struct 
 	spin_unlock_irq(&pool->pool_lock);
 }
 
-static int ib_fmr_cleanup_thread(void *pool_ptr)
+static int ib_fmr_cleanup_thread(struct ib_fmr_pool *pool)
 {
-	struct ib_fmr_pool *pool = pool_ptr;
-
 	do {
 		if (pool->dirty_len >= pool->dirty_watermark ||
 		    atomic_read(&pool->flush_ser) - atomic_read(&pool->req_ser) < 0) {
diff -r 110aa94129d0 drivers/input/touchscreen/ucb1400_ts.c
--- a/drivers/input/touchscreen/ucb1400_ts.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/input/touchscreen/ucb1400_ts.c	Fri Jan 18 11:31:48 2008 +1100
@@ -282,9 +282,8 @@ static void ucb1400_handle_pending_irq(s
 	enable_irq(ucb->irq);
 }
 
-static int ucb1400_ts_thread(void *_ucb)
+static int ucb1400_ts_thread(struct ucb1400 *ucb)
 {
-	struct ucb1400 *ucb = _ucb;
 	struct task_struct *tsk = current;
 	int valid = 0;
 	struct sched_param param = { .sched_priority = 1 };
diff -r 110aa94129d0 drivers/md/md.c
--- a/drivers/md/md.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/md/md.c	Fri Jan 18 11:31:48 2008 +1100
@@ -4643,10 +4643,8 @@ static struct block_device_operations md
 	.revalidate_disk= md_revalidate,
 };
 
-static int md_thread(void * arg)
-{
-	mdk_thread_t *thread = arg;
-
+static int md_thread(mdk_thread_t *thread)
+{
 	/*
 	 * md_thread is a 'system-thread', it's priority should be very
 	 * high. We avoid resource deadlocks individually in each
diff -r 110aa94129d0 drivers/media/dvb/dvb-core/dvb_ca_en50221.c
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	Fri Jan 18 11:31:48 2008 +1100
@@ -955,9 +955,8 @@ static void dvb_ca_en50221_thread_update
 /**
  * Kernel thread which monitors CA slots for CAM changes, and performs data transfers.
  */
-static int dvb_ca_en50221_thread(void *data)
+static int dvb_ca_en50221_thread(struct dvb_ca_private *ca)
 {
-	struct dvb_ca_private *ca = data;
 	int slot;
 	int flags;
 	int status;
diff -r 110aa94129d0 drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c	Fri Jan 18 11:31:48 2008 +1100
@@ -503,9 +503,8 @@ static void dvb_frontend_wakeup(struct d
 	wake_up_interruptible(&fepriv->wait_queue);
 }
 
-static int dvb_frontend_thread(void *data)
+static int dvb_frontend_thread(struct dvb_frontend *fe)
 {
-	struct dvb_frontend *fe = data;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	unsigned long timeout;
 	fe_status_t s;
diff -r 110aa94129d0 drivers/media/video/cx88/cx88-tvaudio.c
--- a/drivers/media/video/cx88/cx88-tvaudio.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/video/cx88/cx88-tvaudio.c	Fri Jan 18 11:31:48 2008 +1100
@@ -907,9 +907,8 @@ void cx88_set_stereo(struct cx88_core *c
 	return;
 }
 
-int cx88_audio_thread(void *data)
+int cx88_audio_thread(struct cx88_core *core)
 {
-	struct cx88_core *core = data;
 	struct v4l2_tuner t;
 	u32 mode = 0;
 
diff -r 110aa94129d0 drivers/media/video/cx88/cx88.h
--- a/drivers/media/video/cx88/cx88.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/video/cx88/cx88.h	Fri Jan 18 11:31:48 2008 +1100
@@ -609,7 +609,7 @@ void cx88_newstation(struct cx88_core *c
 void cx88_newstation(struct cx88_core *core);
 void cx88_get_stereo(struct cx88_core *core, struct v4l2_tuner *t);
 void cx88_set_stereo(struct cx88_core *core, u32 mode, int manual);
-int cx88_audio_thread(void *data);
+int cx88_audio_thread(struct cx88_core *core);
 
 int cx8802_register_driver(struct cx8802_driver *drv);
 int cx8802_unregister_driver(struct cx8802_driver *drv);
diff -r 110aa94129d0 drivers/media/video/msp3400-driver.c
--- a/drivers/media/video/msp3400-driver.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/video/msp3400-driver.c	Fri Jan 18 11:31:48 2008 +1100
@@ -805,7 +805,7 @@ static int msp_attach(struct i2c_adapter
 {
 	struct i2c_client *client;
 	struct msp_state *state;
-	int (*thread_func)(void *data) = NULL;
+	int (*thread_func)(struct i2c_client *client) = NULL;
 	int msp_hard;
 	int msp_family;
 	int msp_revision;
diff -r 110aa94129d0 drivers/media/video/msp3400-driver.h
--- a/drivers/media/video/msp3400-driver.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/video/msp3400-driver.h	Fri Jan 18 11:31:48 2008 +1100
@@ -110,9 +110,9 @@ const char *msp_standard_std_name(int st
 const char *msp_standard_std_name(int std);
 void msp_set_audmode(struct i2c_client *client);
 int msp_detect_stereo(struct i2c_client *client);
-int msp3400c_thread(void *data);
-int msp3410d_thread(void *data);
-int msp34xxg_thread(void *data);
+int msp3400c_thread(struct i2c_client *client);
+int msp3410d_thread(struct i2c_client *client);
+int msp34xxg_thread(struct i2c_client *client);
 void msp3400c_set_mode(struct i2c_client *client, int mode);
 void msp3400c_set_carrier(struct i2c_client *client, int cdo1, int cdo2);
 
diff -r 110aa94129d0 drivers/media/video/msp3400-kthreads.c
--- a/drivers/media/video/msp3400-kthreads.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/video/msp3400-kthreads.c	Fri Jan 18 11:31:48 2008 +1100
@@ -460,9 +460,8 @@ static void watch_stereo(struct i2c_clie
 		state->watch_stereo = 0;
 }
 
-int msp3400c_thread(void *data)
+int msp3400c_thread(struct i2c_client *client)
 {
-	struct i2c_client *client = data;
 	struct msp_state *state = i2c_get_clientdata(client);
 	struct msp3400c_carrier_detect *cd;
 	int count, max1, max2, val1, val2, val, this;
@@ -641,9 +640,8 @@ int msp3400c_thread(void *data)
 }
 
 
-int msp3410d_thread(void *data)
+int msp3410d_thread(struct i2c_client *client)
 {
-	struct i2c_client *client = data;
 	struct msp_state *state = i2c_get_clientdata(client);
 	int val, i, std, count;
 
@@ -935,9 +933,8 @@ static void msp34xxg_reset(struct i2c_cl
 	msp_write_dem(client, 0x22, msp_stereo_thresh);
 }
 
-int msp34xxg_thread(void *data)
+int msp34xxg_thread(struct i2c_client *client)
 {
-	struct i2c_client *client = data;
 	struct msp_state *state = i2c_get_clientdata(client);
 	int val, i;
 
diff -r 110aa94129d0 drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c	Fri Jan 18 11:31:48 2008 +1100
@@ -496,9 +496,8 @@ static int tvaudio_setstereo(struct saa7
 	return 0;
 }
 
-static int tvaudio_thread(void *data)
+static int tvaudio_thread(struct saa7134_dev *dev)
 {
-	struct saa7134_dev *dev = data;
 	int carr_vals[ARRAY_SIZE(mainscan)];
 	unsigned int i, audio, nscan;
 	int max1,max2,carrier,rx,mode,lastmode,default_carrier;
@@ -781,9 +780,8 @@ static int mute_input_7133(struct saa713
 	return 0;
 }
 
-static int tvaudio_thread_ddep(void *data)
+static int tvaudio_thread_ddep(struct saa7134_dev *dev)
 {
-	struct saa7134_dev *dev = data;
 	u32 value, norms, clock;
 
 
@@ -980,7 +978,7 @@ int saa7134_tvaudio_getstereo(struct saa
 
 int saa7134_tvaudio_init2(struct saa7134_dev *dev)
 {
-	int (*my_thread)(void *data) = NULL;
+	int (*my_thread)(struct saa7134_dev *) = NULL;
 
 	switch (dev->pci->device) {
 	case PCI_DEVICE_ID_PHILIPS_SAA7134:
diff -r 110aa94129d0 drivers/media/video/tvaudio.c
--- a/drivers/media/video/tvaudio.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/video/tvaudio.c	Fri Jan 18 11:31:48 2008 +1100
@@ -264,9 +264,8 @@ static void chip_thread_wake(unsigned lo
 	wake_up_process(chip->thread);
 }
 
-static int chip_thread(void *data)
+static int chip_thread(struct CHIPSTATE *chip)
 {
-	struct CHIPSTATE *chip = data;
 	struct CHIPDESC  *desc = chiplist + chip->type;
 
 	v4l_dbg(1, debug, &chip->c, "%s: thread started\n", chip->c.name);
diff -r 110aa94129d0 drivers/media/video/videobuf-dvb.c
--- a/drivers/media/video/videobuf-dvb.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/video/videobuf-dvb.c	Fri Jan 18 11:31:48 2008 +1100
@@ -39,9 +39,8 @@ MODULE_PARM_DESC(debug,"enable debug mes
 
 /* ------------------------------------------------------------------ */
 
-static int videobuf_dvb_thread(void *data)
+static int videobuf_dvb_thread(struct videobuf_dvb *dvb)
 {
-	struct videobuf_dvb *dvb = data;
 	struct videobuf_buffer *buf;
 	unsigned long flags;
 	int err;
diff -r 110aa94129d0 drivers/media/video/vivi.c
--- a/drivers/media/video/vivi.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/media/video/vivi.c	Fri Jan 18 11:31:48 2008 +1100
@@ -455,10 +455,8 @@ static void vivi_sleep(struct vivi_dmaqu
 	try_to_freeze();
 }
 
-static int vivi_thread(void *data)
+static int vivi_thread(struct vivi_dmaqueue  *dma_q)
 {
-	struct vivi_dmaqueue  *dma_q=data;
-
 	dprintk(1,"thread started\n");
 
 	mod_timer(&dma_q->timeout, jiffies+BUFFER_TIMEOUT);
diff -r 110aa94129d0 drivers/mmc/card/queue.c
--- a/drivers/mmc/card/queue.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/mmc/card/queue.c	Fri Jan 18 11:31:48 2008 +1100
@@ -41,9 +41,8 @@ static int mmc_prep_request(struct reque
 	return BLKPREP_OK;
 }
 
-static int mmc_queue_thread(void *d)
+static int mmc_queue_thread(struct mmc_queue *mq)
 {
-	struct mmc_queue *mq = d;
 	struct request_queue *q = mq->queue;
 
 	current->flags |= PF_MEMALLOC;
diff -r 110aa94129d0 drivers/mmc/core/sdio_irq.c
--- a/drivers/mmc/core/sdio_irq.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/mmc/core/sdio_irq.c	Fri Jan 18 11:31:48 2008 +1100
@@ -63,9 +63,8 @@ static int process_sdio_pending_irqs(str
 	return ret;
 }
 
-static int sdio_irq_thread(void *_host)
+static int sdio_irq_thread(struct mmc_host *host)
 {
-	struct mmc_host *host = _host;
 	struct sched_param param = { .sched_priority = 1 };
 	unsigned long period, idle_period;
 	int ret;
diff -r 110aa94129d0 drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/mtd/mtd_blkdevs.c	Fri Jan 18 11:31:48 2008 +1100
@@ -74,9 +74,8 @@ static int do_blktrans_request(struct mt
 	}
 }
 
-static int mtd_blktrans_thread(void *arg)
+static int mtd_blktrans_thread(struct mtd_blktrans_ops *tr)
 {
-	struct mtd_blktrans_ops *tr = arg;
 	struct request_queue *rq = tr->blkcore_priv->rq;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
diff -r 110aa94129d0 drivers/mtd/ubi/wl.c
--- a/drivers/mtd/ubi/wl.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/mtd/ubi/wl.c	Fri Jan 18 11:31:48 2008 +1100
@@ -1303,10 +1303,9 @@ static void tree_destroy(struct rb_root 
  * ubi_thread - UBI background thread.
  * @u: the UBI device description object pointer
  */
-static int ubi_thread(void *u)
+static int ubi_thread(struct ubi_device *ubi)
 {
 	int failures = 0;
-	struct ubi_device *ubi = u;
 
 	ubi_msg("background thread \"%s\" started, PID %d",
 		ubi->bgt_name, task_pid_nr(current));
diff -r 110aa94129d0 drivers/net/irda/stir4200.c
--- a/drivers/net/irda/stir4200.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/net/irda/stir4200.c	Fri Jan 18 11:31:48 2008 +1100
@@ -732,9 +732,8 @@ static void stir_send(struct stir_cb *st
 /*
  * Transmit state machine thread
  */
-static int stir_transmit_thread(void *arg)
+static int stir_transmit_thread(struct stir_cb *stir)
 {
-	struct stir_cb *stir = arg;
 	struct net_device *dev = stir->netdev;
 	struct sk_buff *skb;
 
diff -r 110aa94129d0 drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/net/wireless/airo.c	Fri Jan 18 11:31:48 2008 +1100
@@ -1123,7 +1123,7 @@ static int waitbusy (struct airo_info *a
 static int waitbusy (struct airo_info *ai);
 
 static irqreturn_t airo_interrupt( int irq, void* dev_id);
-static int airo_thread(void *data);
+static int airo_thread(struct net_device *dev);
 static void timer_func( struct net_device *dev );
 static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static struct iw_statistics *airo_get_wireless_stats (struct net_device *dev);
@@ -3080,8 +3080,7 @@ out:
 	wireless_send_event(ai->dev, SIOCGIWSCAN, &wrqu, NULL);
 }
 
-static int airo_thread(void *data) {
-	struct net_device *dev = data;
+static int airo_thread(struct net_device *dev) {
 	struct airo_info *ai = dev->priv;
 	int locked;
 
diff -r 110aa94129d0 drivers/net/wireless/libertas/main.c
--- a/drivers/net/wireless/libertas/main.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/net/wireless/libertas/main.c	Fri Jan 18 11:31:48 2008 +1100
@@ -752,9 +752,8 @@ static void libertas_set_multicast_list(
  *  @param data    A pointer to wlan_thread structure
  *  @return 	   0
  */
-static int libertas_thread(void *data)
+static int libertas_thread(struct net_device *dev)
 {
-	struct net_device *dev = data;
 	wlan_private *priv = dev->priv;
 	wlan_adapter *adapter = priv->adapter;
 	wait_queue_t wait;
diff -r 110aa94129d0 drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/pcmcia/cs.c	Fri Jan 18 11:31:48 2008 +1100
@@ -170,7 +170,7 @@ static void pcmcia_release_socket(struct
 	complete(&socket->socket_released);
 }
 
-static int pccardd(void *__skt);
+static int pccardd(struct pcmcia_socket *skt);
 
 /**
  * pcmcia_register_socket - add a new pcmcia socket device
@@ -632,9 +632,8 @@ static void socket_detect_change(struct 
 	}
 }
 
-static int pccardd(void *__skt)
+static int pccardd(struct pcmcia_socket *skt)
 {
-	struct pcmcia_socket *skt = __skt;
 	DECLARE_WAITQUEUE(wait, current);
 	int ret;
 
diff -r 110aa94129d0 drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/scsi/aacraid/aacraid.h	Fri Jan 18 11:31:48 2008 +1100
@@ -1851,7 +1851,7 @@ unsigned int aac_intr_normal(struct aac_
 unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index);
 int aac_reset_adapter(struct aac_dev * dev, int forced);
 int aac_check_health(struct aac_dev * dev);
-int aac_command_thread(void *data);
+int aac_command_thread(struct aac_dev * dev);
 int aac_close_fib_context(struct aac_dev * dev, struct aac_fib_context *fibctx);
 int aac_fib_adapter_complete(struct fib * fibptr, unsigned short size);
 struct aac_driver_ident* aac_get_driver_ident(int devtype);
diff -r 110aa94129d0 drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/scsi/aacraid/commsup.c	Fri Jan 18 11:31:49 2008 +1100
@@ -1400,9 +1400,8 @@ out:
  *	more FIBs.
  */
  
-int aac_command_thread(void *data)
+int aac_command_thread(struct aac_dev *dev)
 {
-	struct aac_dev *dev = data;
 	struct hw_fib *hw_fib, *hw_newfib;
 	struct fib *fib, *newfib;
 	struct aac_fib_context *fibctx;
diff -r 110aa94129d0 drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/scsi/libsas/sas_scsi_host.c	Fri Jan 18 11:31:49 2008 +1100
@@ -900,10 +900,8 @@ static void sas_queue(struct sas_ha_stru
  * sas_queue_thread -- The Task Collector thread
  * @_sas_ha: pointer to struct sas_ha
  */
-static int sas_queue_thread(void *_sas_ha)
+static int sas_queue_thread(struct sas_ha_struct *sas_ha)
 {
-	struct sas_ha_struct *sas_ha = _sas_ha;
-
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
diff -r 110aa94129d0 drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	Fri Jan 18 11:31:49 2008 +1100
@@ -78,7 +78,7 @@ struct lpfc_nodelist *lpfc_findnode_rpi(
 
 void lpfc_worker_wake_up(struct lpfc_hba *);
 int lpfc_workq_post_event(struct lpfc_hba *, void *, void *, uint32_t);
-int lpfc_do_work(void *);
+int lpfc_do_work(struct lpfc_hba *phba);
 int lpfc_disc_state_machine(struct lpfc_vport *, struct lpfc_nodelist *, void *,
 			    uint32_t);
 
diff -r 110aa94129d0 drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	Fri Jan 18 11:31:49 2008 +1100
@@ -470,9 +470,8 @@ check_work_wait_done(struct lpfc_hba *ph
 
 
 int
-lpfc_do_work(void *p)
+lpfc_do_work(struct lpfc_hba *phba)
 {
-	struct lpfc_hba *phba = p;
 	int rc;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(work_waitq);
 
diff -r 110aa94129d0 drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Jan 18 11:31:49 2008 +1100
@@ -210,7 +210,7 @@ qla2x00_stop_timer(scsi_qla_host_t *ha)
 	ha->timer_active = 0;
 }
 
-static int qla2x00_do_dpc(void *data);
+static int qla2x00_do_dpc(scsi_qla_host_t *ha);
 
 static void qla2x00_rst_aen(scsi_qla_host_t *);
 
@@ -2360,15 +2360,12 @@ qla2x00_free_sp_pool( scsi_qla_host_t *h
 * bits then wake us up.
 **************************************************************************/
 static int
-qla2x00_do_dpc(void *data)
+qla2x00_do_dpc(scsi_qla_host_t *ha)
 {
 	int		rval;
-	scsi_qla_host_t *ha;
 	fc_port_t	*fcport;
 	uint8_t		status;
 	uint16_t	next_loopid;
-
-	ha = (scsi_qla_host_t *)data;
 
 	set_user_nice(current, -20);
 
diff -r 110aa94129d0 drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/scsi/scsi_error.c	Fri Jan 18 11:31:49 2008 +1100
@@ -1541,10 +1541,8 @@ static void scsi_unjam_host(struct Scsi_
  *    This is the main error handling loop.  This is run as a kernel thread
  *    for every SCSI host and handles all error handling activity.
  **/
-int scsi_error_handler(void *data)
+int scsi_error_handler(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = data;
-
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
 	 * counted against the load average as a running process.
diff -r 110aa94129d0 drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/scsi/scsi_priv.h	Fri Jan 18 11:31:49 2008 +1100
@@ -53,7 +53,7 @@ extern void scsi_add_timer(struct scsi_c
 		void (*)(struct scsi_cmnd *));
 extern int scsi_delete_timer(struct scsi_cmnd *);
 extern void scsi_times_out(struct scsi_cmnd *cmd);
-extern int scsi_error_handler(void *host);
+extern int scsi_error_handler(struct Scsi_Host *shost);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
 extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
diff -r 110aa94129d0 drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/scsi/scsi_scan.c	Fri Jan 18 11:31:49 2008 +1100
@@ -1788,9 +1788,8 @@ static void do_scsi_scan_host(struct Scs
 	}
 }
 
-static int do_scan_async(void *_data)
+static int do_scan_async(struct async_scan_data *data)
 {
-	struct async_scan_data *data = _data;
 	do_scsi_scan_host(data->shost);
 	scsi_finish_async_scan(data);
 	return 0;
diff -r 110aa94129d0 drivers/usb/atm/ueagle-atm.c
--- a/drivers/usb/atm/ueagle-atm.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/usb/atm/ueagle-atm.c	Fri Jan 18 11:31:49 2008 +1100
@@ -1868,9 +1868,8 @@ static int uea_start_reset(struct uea_so
  * Monitor the modem every 1s.
  */
 
-static int uea_kthread(void *data)
+static int uea_kthread(struct uea_softc *sc)
 {
-	struct uea_softc *sc = data;
 	int ret = -EAGAIN;
 
 	set_freezable();
diff -r 110aa94129d0 drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/usb/gadget/file_storage.c	Fri Jan 18 11:31:49 2008 +1100
@@ -3383,10 +3383,8 @@ static void handle_exception(struct fsg_
 
 /*-------------------------------------------------------------------------*/
 
-static int fsg_main_thread(void *fsg_)
-{
-	struct fsg_dev		*fsg = fsg_;
-
+static int fsg_main_thread(struct fsg_dev *fsg)
+{
 	/* Allow the thread to be killed by a signal, but set the signal mask
 	 * to block everything but INT, TERM, KILL, and USR1. */
 	allow_signal(SIGINT);
diff -r 110aa94129d0 drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/usb/storage/usb.c	Fri Jan 18 11:31:49 2008 +1100
@@ -302,9 +302,8 @@ void fill_inquiry_response(struct us_dat
 	usb_stor_set_xfer_buf(data, data_len, us->srb);
 }
 
-static int usb_stor_control_thread(void * __us)
+static int usb_stor_control_thread(struct us_data *us)
 {
-	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
 	for(;;) {
@@ -895,10 +894,8 @@ static void release_everything(struct us
 }
 
 /* Thread to carry out delayed SCSI-device scanning */
-static int usb_stor_scan_thread(void * __us)
+static int usb_stor_scan_thread(struct us_data *us)
 {
-	struct us_data *us = (struct us_data *)__us;
-
 	printk(KERN_DEBUG
 		"usb-storage: device found at %d\n", us->pusb_dev->devnum);
 
diff -r 110aa94129d0 drivers/w1/w1.c
--- a/drivers/w1/w1.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/w1/w1.c	Fri Jan 18 11:31:49 2008 +1100
@@ -879,10 +879,8 @@ void w1_search_process(struct w1_master 
 		dev->search_count--;
 }
 
-int w1_process(void *data)
+int w1_process(struct w1_master *dev)
 {
-	struct w1_master *dev = (struct w1_master *) data;
-
 	while (!kthread_should_stop() && !test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
 		try_to_freeze();
 		msleep_interruptible(w1_timeout * 1000);
diff -r 110aa94129d0 drivers/w1/w1.h
--- a/drivers/w1/w1.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/drivers/w1/w1.h	Fri Jan 18 11:31:49 2008 +1100
@@ -217,7 +217,7 @@ extern struct list_head w1_masters;
 extern struct list_head w1_masters;
 extern struct mutex w1_mlock;
 
-extern int w1_process(void *);
+extern int w1_process(struct w1_master *);
 
 #endif /* __KERNEL__ */
 
diff -r 110aa94129d0 fs/dlm/recoverd.c
--- a/fs/dlm/recoverd.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/dlm/recoverd.c	Fri Jan 18 11:31:49 2008 +1100
@@ -260,7 +260,7 @@ static void do_ls_recovery(struct dlm_ls
 	}
 }
 
-static int dlm_recoverd(void *arg)
+static int dlm_recoverd(dlm_lockspace_t *arg)
 {
 	struct dlm_ls *ls;
 
@@ -295,7 +295,7 @@ int dlm_recoverd_start(struct dlm_ls *ls
 	struct task_struct *p;
 	int error = 0;
 
-	p = kthread_run(dlm_recoverd, ls, "dlm_recoverd");
+	p = kthread_run(dlm_recoverd, (dlm_lockspace_t *)ls, "dlm_recoverd");
 	if (IS_ERR(p))
 		error = PTR_ERR(p);
 	else
diff -r 110aa94129d0 fs/gfs2/daemon.c
--- a/fs/gfs2/daemon.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/gfs2/daemon.c	Fri Jan 18 11:31:49 2008 +1100
@@ -42,10 +42,8 @@
  * Number of daemons can be set by user, with num_glockd mount option.
  */
 
-int gfs2_glockd(void *data)
+int gfs2_glockd(struct gfs2_sbd *sdp)
 {
-	struct gfs2_sbd *sdp = data;
-
 	while (!kthread_should_stop()) {
 		while (atomic_read(&sdp->sd_reclaim_count))
 			gfs2_reclaim_glock(sdp);
@@ -66,9 +64,8 @@ int gfs2_glockd(void *data)
  *
  */
 
-int gfs2_recoverd(void *data)
+int gfs2_recoverd(struct gfs2_sbd *sdp)
 {
-	struct gfs2_sbd *sdp = data;
 	unsigned long t;
 
 	while (!kthread_should_stop()) {
@@ -90,9 +87,8 @@ int gfs2_recoverd(void *data)
  * journal index.
  */
 
-int gfs2_logd(void *data)
+int gfs2_logd(struct gfs2_sbd *sdp)
 {
-	struct gfs2_sbd *sdp = data;
 	struct gfs2_holder ji_gh;
 	unsigned long t;
 	int need_flush;
@@ -138,9 +134,8 @@ int gfs2_logd(void *data)
  *
  */
 
-int gfs2_quotad(void *data)
+int gfs2_quotad(struct gfs2_sbd *sdp)
 {
-	struct gfs2_sbd *sdp = data;
 	unsigned long t;
 	int error;
 
diff -r 110aa94129d0 fs/gfs2/daemon.h
--- a/fs/gfs2/daemon.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/gfs2/daemon.h	Fri Jan 18 11:31:49 2008 +1100
@@ -10,9 +10,9 @@
 #ifndef __DAEMON_DOT_H__
 #define __DAEMON_DOT_H__
 
-int gfs2_glockd(void *data);
-int gfs2_recoverd(void *data);
-int gfs2_logd(void *data);
-int gfs2_quotad(void *data);
+int gfs2_glockd(struct gfs2_sbd *sdp);
+int gfs2_recoverd(struct gfs2_sbd *sdp);
+int gfs2_logd(struct gfs2_sbd *sdp);
+int gfs2_quotad(struct gfs2_sbd *sdp);
 
 #endif /* __DAEMON_DOT_H__ */
diff -r 110aa94129d0 fs/gfs2/locking/dlm/thread.c
--- a/fs/gfs2/locking/dlm/thread.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/gfs2/locking/dlm/thread.c	Fri Jan 18 11:31:49 2008 +1100
@@ -268,9 +268,8 @@ static inline int check_drop(struct gdlm
 	return 0;
 }
 
-static int gdlm_thread(void *data, int blist)
+static int gdlm_thread(struct gdlm_ls *ls, int blist)
 {
-	struct gdlm_ls *ls = (struct gdlm_ls *) data;
 	struct gdlm_lock *lp = NULL;
 	uint8_t complete, blocking, submit, drop;
 	DECLARE_WAITQUEUE(wait, current);
@@ -329,14 +328,14 @@ static int gdlm_thread(void *data, int b
 	return 0;
 }
 
-static int gdlm_thread1(void *data)
+static int gdlm_thread1(struct gdlm_ls *ls)
 {
-	return gdlm_thread(data, 1);
+	return gdlm_thread(ls, 1);
 }
 
-static int gdlm_thread2(void *data)
+static int gdlm_thread2(struct gdlm_ls *ls)
 {
-	return gdlm_thread(data, 0);
+	return gdlm_thread(ls, 0);
 }
 
 int gdlm_init_threads(struct gdlm_ls *ls)
diff -r 110aa94129d0 fs/jbd/journal.c
--- a/fs/jbd/journal.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/jbd/journal.c	Fri Jan 18 11:31:49 2008 +1100
@@ -112,9 +112,8 @@ static void commit_timeout(unsigned long
  *    known as checkpointing, and this thread is responsible for that job.
  */
 
-static int kjournald(void *arg)
+static int kjournald(journal_t *journal)
 {
-	journal_t *journal = arg;
 	transaction_t *transaction;
 
 	/*
diff -r 110aa94129d0 fs/jbd2/journal.c
--- a/fs/jbd2/journal.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/jbd2/journal.c	Fri Jan 18 11:31:49 2008 +1100
@@ -112,9 +112,8 @@ static void commit_timeout(unsigned long
  *    known as checkpointing, and this thread is responsible for that job.
  */
 
-static int kjournald2(void *arg)
+static int kjournald2(journal_t *journal)
 {
-	journal_t *journal = arg;
 	transaction_t *transaction;
 
 	/*
diff -r 110aa94129d0 fs/nfs/delegation.c
--- a/fs/nfs/delegation.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/nfs/delegation.c	Fri Jan 18 11:31:49 2008 +1100
@@ -275,9 +275,8 @@ restart:
 	rcu_read_unlock();
 }
 
-static int nfs_do_expire_all_delegations(void *ptr)
+static int nfs_do_expire_all_delegations(struct nfs_client *clp)
 {
-	struct nfs_client *clp = ptr;
 	struct nfs_delegation *delegation;
 	struct inode *inode;
 
diff -r 110aa94129d0 fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/nfs/nfs4state.c	Fri Jan 18 11:31:49 2008 +1100
@@ -738,7 +738,7 @@ out:
 	return status;
 }
 
-static int reclaimer(void *);
+static int reclaimer(struct nfs_client *clp);
 
 static inline void nfs4_clear_recover_bit(struct nfs_client *clp)
 {
@@ -895,9 +895,8 @@ static void nfs4_state_mark_reclaim(stru
 	}
 }
 
-static int reclaimer(void *ptr)
+static int reclaimer(struct nfs_client *clp)
 {
-	struct nfs_client *clp = ptr;
 	struct nfs4_state_owner *sp;
 	struct rb_node *pos;
 	struct nfs4_state_recovery_ops *ops;
diff -r 110aa94129d0 fs/nfsd/nfs4callback.c
--- a/fs/nfsd/nfs4callback.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/nfsd/nfs4callback.c	Fri Jan 18 11:31:49 2008 +1100
@@ -347,9 +347,8 @@ static struct rpc_version *	nfs_cb_versi
 /* Reference counting, callback cleanup, etc., all look racy as heck.
  * And why is cb_set an atomic? */
 
-static int do_probe_callback(void *data)
+static int do_probe_callback(struct nfs4_client *clp)
 {
-	struct nfs4_client *clp = data;
 	struct nfs4_callback *cb = &clp->cl_callback;
 	struct rpc_message msg = {
 		.rpc_proc       = &nfs4_cb_procedures[NFSPROC4_CLNT_CB_NULL],
diff -r 110aa94129d0 fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/nfsd/nfs4state.c	Fri Jan 18 11:31:49 2008 +1100
@@ -1312,10 +1312,8 @@ nfs4_file_downgrade(struct file *filp, u
  * Recall a delegation
  */
 static int
-do_recall(void *__dp)
+do_recall(struct nfs4_delegation *dp)
 {
-	struct nfs4_delegation *dp = __dp;
-
 	dp->dl_file->fi_had_conflict = true;
 	nfsd4_cb_recall(dp);
 	return 0;
diff -r 110aa94129d0 fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/ocfs2/cluster/heartbeat.c	Fri Jan 18 11:31:49 2008 +1100
@@ -840,10 +840,9 @@ static unsigned int o2hb_elapsed_msecs(s
  * dir is removed and drops it ref it will wait to tear down this
  * thread.
  */
-static int o2hb_thread(void *data)
+static int o2hb_thread(struct o2hb_region *reg)
 {
 	int i, ret;
-	struct o2hb_region *reg = data;
 	struct o2hb_bio_wait_ctxt write_wc;
 	struct timeval before_hb, after_hb;
 	unsigned int elapsed_msec;
diff -r 110aa94129d0 fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/ocfs2/dlm/dlmrecovery.c	Fri Jan 18 11:31:49 2008 +1100
@@ -55,7 +55,7 @@
 
 static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node);
 
-static int dlm_recovery_thread(void *data);
+static int dlm_recovery_thread(struct dlm_ctxt *dlm);
 void dlm_complete_recovery_thread(struct dlm_ctxt *dlm);
 int dlm_launch_recovery_thread(struct dlm_ctxt *dlm);
 void dlm_kick_recovery_thread(struct dlm_ctxt *dlm);
@@ -302,10 +302,9 @@ static void dlm_print_reco_node_status(s
 
 #define DLM_RECO_THREAD_TIMEOUT_MS (5 * 1000)
 
-static int dlm_recovery_thread(void *data)
+static int dlm_recovery_thread(struct dlm_ctxt *dlm)
 {
 	int status;
-	struct dlm_ctxt *dlm = data;
 	unsigned long timeout = msecs_to_jiffies(DLM_RECO_THREAD_TIMEOUT_MS);
 
 	mlog(0, "dlm thread running for %s...\n", dlm->name);
diff -r 110aa94129d0 fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/ocfs2/dlm/dlmthread.c	Fri Jan 18 11:31:49 2008 +1100
@@ -53,7 +53,7 @@
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_THREAD)
 #include "cluster/masklog.h"
 
-static int dlm_thread(void *data);
+static int dlm_thread(struct dlm_ctxt *dlm);
 static void dlm_flush_asts(struct dlm_ctxt *dlm);
 
 #define dlm_lock_is_remote(dlm, lock)     ((lock)->ml.node != (dlm)->node_num)
@@ -608,10 +608,9 @@ static void dlm_flush_asts(struct dlm_ct
 #define DLM_THREAD_MAX_DIRTY  100
 #define DLM_THREAD_MAX_ASTS   10
 
-static int dlm_thread(void *data)
+static int dlm_thread(struct dlm_ctxt *dlm)
 {
 	struct dlm_lock_resource *res;
-	struct dlm_ctxt *dlm = data;
 	unsigned long timeout = msecs_to_jiffies(DLM_THREAD_TIMEOUT_MS);
 
 	mlog(0, "dlm thread running for %s...\n", dlm->name);
diff -r 110aa94129d0 fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/ocfs2/journal.c	Fri Jan 18 11:31:49 2008 +1100
@@ -54,7 +54,7 @@ static int ocfs2_force_read_journal(stru
 static int ocfs2_force_read_journal(struct inode *inode);
 static int ocfs2_recover_node(struct ocfs2_super *osb,
 			      int node_num);
-static int __ocfs2_recovery_thread(void *arg);
+static int __ocfs2_recovery_thread(struct ocfs2_super *osb);
 static int ocfs2_commit_cache(struct ocfs2_super *osb);
 static int ocfs2_wait_on_mount(struct ocfs2_super *osb);
 static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
@@ -63,7 +63,7 @@ static int ocfs2_trylock_journal(struct 
 				 int slot_num);
 static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 				 int slot);
-static int ocfs2_commit_thread(void *arg);
+static int ocfs2_commit_thread(struct ocfs2_super *osb);
 
 static int ocfs2_commit_cache(struct ocfs2_super *osb)
 {
@@ -841,10 +841,9 @@ void ocfs2_complete_mount_recovery(struc
 	}
 }
 
-static int __ocfs2_recovery_thread(void *arg)
+static int __ocfs2_recovery_thread(struct ocfs2_super *osb)
 {
 	int status, node_num;
-	struct ocfs2_super *osb = arg;
 
 	mlog_entry_void();
 
@@ -1419,10 +1418,9 @@ static int ocfs2_wait_on_mount(struct oc
 	return 0;
 }
 
-static int ocfs2_commit_thread(void *arg)
+static int ocfs2_commit_thread(struct ocfs2_super *osb)
 {
 	int status;
-	struct ocfs2_super *osb = arg;
 	struct ocfs2_journal *journal = osb->journal;
 
 	/* we can trust j_num_trans here because _should_stop() is only set in
diff -r 110aa94129d0 fs/ocfs2/vote.c
--- a/fs/ocfs2/vote.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/ocfs2/vote.c	Fri Jan 18 11:31:49 2008 +1100
@@ -280,10 +280,9 @@ static int ocfs2_vote_thread_should_wake
 	return should_wake;
 }
 
-int ocfs2_vote_thread(void *arg)
+int ocfs2_vote_thread(struct ocfs2_super *osb)
 {
 	int status = 0;
-	struct ocfs2_super *osb = arg;
 
 	/* only quit once we've been asked to stop and there is no more
 	 * work available */
diff -r 110aa94129d0 fs/ocfs2/vote.h
--- a/fs/ocfs2/vote.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/ocfs2/vote.h	Fri Jan 18 11:31:49 2008 +1100
@@ -27,7 +27,7 @@
 #ifndef VOTE_H
 #define VOTE_H
 
-int ocfs2_vote_thread(void *arg);
+int ocfs2_vote_thread(struct ocfs2_super *osb);
 static inline void ocfs2_kick_vote_thread(struct ocfs2_super *osb)
 {
 	spin_lock(&osb->vote_task_lock);
diff -r 110aa94129d0 fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/xfs/linux-2.6/xfs_buf.c	Fri Jan 18 11:31:49 2008 +1100
@@ -35,7 +35,7 @@
 #include <linux/freezer.h>
 
 static kmem_zone_t *xfs_buf_zone;
-STATIC int xfsbufd(void *);
+STATIC int xfsbufd(xfs_buftarg_t *);
 STATIC int xfsbufd_wakeup(int, gfp_t);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
 static struct shrinker xfs_buf_shake = {
@@ -1734,10 +1734,9 @@ xfs_buf_delwri_split(
 
 STATIC int
 xfsbufd(
-	void		*data)
+	xfs_buftarg_t	*target)
 {
 	struct list_head tmp;
-	xfs_buftarg_t	*target = (xfs_buftarg_t *)data;
 	int		count;
 	xfs_buf_t	*bp;
 
diff -r 110aa94129d0 fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/fs/xfs/linux-2.6/xfs_super.c	Fri Jan 18 11:31:49 2008 +1100
@@ -549,9 +549,8 @@ xfs_sync_worker(
 
 STATIC int
 xfssyncd(
-	void			*arg)
+	struct xfs_mount	*mp)
 {
-	struct xfs_mount	*mp = arg;
 	long			timeleft;
 	bhv_vfs_sync_work_t	*work, *n;
 	LIST_HEAD		(tmp);
diff -r 110aa94129d0 kernel/audit.c
--- a/kernel/audit.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/kernel/audit.c	Fri Jan 18 11:31:49 2008 +1100
@@ -450,9 +450,8 @@ out:
 	return err;
 }
 
-int audit_send_list(void *_dest)
+int audit_send_list(struct audit_netlink_list *dest)
 {
-	struct audit_netlink_list *dest = _dest;
 	int pid = dest->pid;
 	struct sk_buff *skb;
 
diff -r 110aa94129d0 kernel/audit.h
--- a/kernel/audit.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/kernel/audit.h	Fri Jan 18 11:31:49 2008 +1100
@@ -126,7 +126,7 @@ struct audit_netlink_list {
 	struct sk_buff_head q;
 };
 
-int audit_send_list(void *);
+int audit_send_list(struct audit_netlink_list *dest);
 
 struct inotify_watch;
 extern void audit_free_parent(struct inotify_watch *);
diff -r 110aa94129d0 kernel/rtmutex-tester.c
--- a/kernel/rtmutex-tester.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/kernel/rtmutex-tester.c	Fri Jan 18 11:31:49 2008 +1100
@@ -254,9 +254,8 @@ void schedule_rt_mutex_test(struct rt_mu
 	td->opdata = dat;
 }
 
-static int test_func(void *data)
+static int test_func(struct test_thread_data *td)
 {
-	struct test_thread_data *td = data;
 	int ret;
 
 	current->flags |= PF_MUTEX_TESTER;
diff -r 110aa94129d0 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/kernel/stop_machine.c	Fri Jan 18 11:31:49 2008 +1100
@@ -143,9 +143,8 @@ struct stop_machine_data
 	struct completion done;
 };
 
-static int do_stop(void *_smdata)
+static int do_stop(struct stop_machine_data *smdata)
 {
-	struct stop_machine_data *smdata = _smdata;
 	int ret;
 
 	ret = stop_machine();
diff -r 110aa94129d0 kernel/workqueue.c
--- a/kernel/workqueue.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/kernel/workqueue.c	Fri Jan 18 11:31:49 2008 +1100
@@ -296,9 +296,8 @@ static void run_workqueue(struct cpu_wor
 	spin_unlock_irq(&cwq->lock);
 }
 
-static int worker_thread(void *__cwq)
+static int worker_thread(struct cpu_workqueue_struct *cwq)
 {
-	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
 
 	if (cwq->wq->freezeable)
diff -r 110aa94129d0 mm/vmscan.c
--- a/mm/vmscan.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/mm/vmscan.c	Fri Jan 18 11:31:50 2008 +1100
@@ -1491,10 +1491,9 @@ out:
  * If there are applications that are active memory-allocators
  * (most normal use), this basically shouldn't matter.
  */
-static int kswapd(void *p)
+static int kswapd(pg_data_t *pgdat)
 {
 	unsigned long order;
-	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 	DEFINE_WAIT(wait);
 	struct reclaim_state reclaim_state = {
diff -r 110aa94129d0 net/9p/mux.c
--- a/net/9p/mux.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/net/9p/mux.c	Fri Jan 18 11:31:50 2008 +1100
@@ -106,7 +106,7 @@ struct p9_mux_rpc {
 	wait_queue_head_t wqueue;
 };
 
-static int p9_poll_proc(void *);
+static int p9_poll_proc(struct p9_mux_poll_task *vpt);
 static void p9_read_work(struct work_struct *work);
 static void p9_write_work(struct work_struct *work);
 static void p9_pollwait(struct file *filp, wait_queue_head_t *wait_address,
@@ -442,12 +442,10 @@ static void p9_poll_mux(struct p9_conn *
  * p9_poll_proc - polls all v9fs transports for new events and queues
  * 	the appropriate work to the work queue
  */
-static int p9_poll_proc(void *a)
+static int p9_poll_proc(struct p9_mux_poll_task *vpt)
 {
 	struct p9_conn *m, *mtmp;
-	struct p9_mux_poll_task *vpt;
 
-	vpt = a;
 	P9_DPRINTK(P9_DEBUG_MUX, "start %p %p\n", current, vpt);
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
diff -r 110aa94129d0 net/core/pktgen.c
--- a/net/core/pktgen.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/net/core/pktgen.c	Fri Jan 18 11:31:50 2008 +1100
@@ -3499,10 +3499,9 @@ out:;
  * Main loop of the thread goes here
  */
 
-static int pktgen_thread_worker(void *arg)
+static int pktgen_thread_worker(struct pktgen_thread *t)
 {
 	DEFINE_WAIT(wait);
-	struct pktgen_thread *t = arg;
 	struct pktgen_dev *pkt_dev = NULL;
 	int cpu = t->cpu;
 
diff -r 110aa94129d0 sound/pci/emu10k1/emu10k1_main.c
--- a/sound/pci/emu10k1/emu10k1_main.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/sound/pci/emu10k1/emu10k1_main.c	Fri Jan 18 11:31:50 2008 +1100
@@ -704,8 +704,7 @@ static int snd_emu1010_load_firmware(str
 	return 0;
 }
 
-int emu1010_firmware_thread(void *data) {
-	struct snd_emu10k1 * emu = data;
+int emu1010_firmware_thread(struct snd_emu10k1 * emu) {
 	int tmp,tmp2;
 	int reg;
 	int err;
