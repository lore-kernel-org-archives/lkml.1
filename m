Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbZI0WFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbZI0WFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 18:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZI0WFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 18:05:01 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:34831 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZI0WE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 18:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xmTQUCGNcKjKiymB7DQG/lQ3X5mTQQRVwtArw0dbrKlGGhxqLYM01de/yIwByG+nnH
         jpLOCB7X+sZ0nx9J3ilyR37Ln10/jCqsBLswcCNfU1FM6I2qA0KezTc4OvLQtftOB3fI
         bii9bUn9mdBSkHAdXQhQj5RCdQPZDbMvS6wrw=
Date: Mon, 28 Sep 2009 02:04:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] const: constify remaining file_operations
Message-ID: <20090927220459.GA13116@x200>
References: <20090927184201.GA12402@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927184201.GA12402@x200>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/mach-ns9xxx/clock.c               |    2 -
 arch/blackfin/mach-bf561/coreb.c           |    2 -
 arch/cris/arch-v10/drivers/sync_serial.c   |    2 -
 arch/cris/arch-v32/drivers/mach-fs/gpio.c  |    2 -
 arch/powerpc/kvm/timing.c                  |    2 -
 arch/powerpc/platforms/cell/spufs/file.c   |    2 -
 arch/powerpc/platforms/pseries/dtl.c       |    2 -
 arch/x86/xen/debugfs.c                     |    2 -
 drivers/acpi/video.c                       |    2 -
 drivers/block/cciss.c                      |    2 -
 drivers/char/apm-emulation.c               |    2 -
 drivers/char/bfin-otp.c                    |    2 -
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    2 -
 drivers/gpio/gpiolib.c                     |    2 -
 drivers/hwmon/fschmd.c                     |    2 -
 drivers/lguest/lguest_user.c               |    2 -
 drivers/media/dvb/dvb-core/dmxdev.c        |    2 -
 drivers/media/dvb/firewire/firedtv-ci.c    |    2 -
 drivers/misc/phantom.c                     |    2 -
 drivers/misc/sgi-gru/grufile.c             |    3 --
 drivers/mmc/core/debugfs.c                 |    2 -
 drivers/s390/cio/qdio_debug.c              |    2 -
 drivers/s390/cio/qdio_perf.c               |    2 -
 drivers/scsi/sg.c                          |   43 ++++++++++++++++++++---------
 drivers/spi/spidev.c                       |    2 -
 drivers/usb/class/usbtmc.c                 |    2 -
 drivers/usb/gadget/printer.c               |    2 -
 drivers/usb/host/whci/debug.c              |    6 ++--
 drivers/usb/misc/rio500.c                  |    3 --
 drivers/uwb/uwb-debug.c                    |    6 ++--
 fs/btrfs/ctree.h                           |    2 -
 fs/btrfs/file.c                            |    2 -
 fs/btrfs/inode.c                           |    4 +-
 fs/jbd2/journal.c                          |    4 +-
 fs/nfsd/nfsctl.c                           |    2 -
 fs/nilfs2/dir.c                            |    2 -
 fs/nilfs2/file.c                           |    2 -
 fs/nilfs2/mdt.c                            |    2 -
 fs/nilfs2/nilfs.h                          |    4 +-
 fs/ocfs2/cluster/heartbeat.c               |    2 -
 fs/ocfs2/cluster/netdebug.c                |    4 +-
 fs/ocfs2/dlm/dlmdebug.c                    |    8 ++---
 fs/ocfs2/super.c                           |    2 -
 fs/omfs/dir.c                              |    2 -
 fs/omfs/file.c                             |    2 -
 fs/omfs/omfs.h                             |    4 +-
 include/linux/cgroup.h                     |    2 -
 include/linux/fs.h                         |    2 -
 kernel/cgroup.c                            |   10 +++---
 kernel/kprobes.c                           |    4 +-
 kernel/rcutree_trace.c                     |   10 +++---
 kernel/sched.c                             |    2 -
 kernel/time/timer_list.c                   |    2 -
 kernel/time/timer_stats.c                  |    2 -
 samples/tracepoints/tracepoint-sample.c    |    2 -
 security/integrity/ima/ima_fs.c            |   10 +++---
 56 files changed, 110 insertions(+), 95 deletions(-)

--- a/arch/arm/mach-ns9xxx/clock.c
+++ b/arch/arm/mach-ns9xxx/clock.c
@@ -195,7 +195,7 @@ static int clk_debugfs_open(struct inode *inode, struct file *file)
 	return single_open(file, clk_debugfs_show, NULL);
 }
 
-static struct file_operations clk_debugfs_operations = {
+static const struct file_operations clk_debugfs_operations = {
 	.open = clk_debugfs_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
--- a/arch/blackfin/mach-bf561/coreb.c
+++ b/arch/blackfin/mach-bf561/coreb.c
@@ -48,7 +48,7 @@ coreb_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned l
 	return ret;
 }
 
-static struct file_operations coreb_fops = {
+static const struct file_operations coreb_fops = {
 	.owner   = THIS_MODULE,
 	.ioctl   = coreb_ioctl,
 };
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -244,7 +244,7 @@ static unsigned sync_serial_prescale_shadow;
 
 #define NUMBER_OF_PORTS 2
 
-static struct file_operations sync_serial_fops = {
+static const struct file_operations sync_serial_fops = {
 	.owner   = THIS_MODULE,
 	.write   = sync_serial_write,
 	.read    = sync_serial_read,
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -855,7 +855,7 @@ gpio_leds_ioctl(unsigned int cmd, unsigned long arg)
 	return 0;
 }
 
-struct file_operations gpio_fops = {
+static const struct file_operations gpio_fops = {
 	.owner       = THIS_MODULE,
 	.poll        = gpio_poll,
 	.ioctl       = gpio_ioctl,
--- a/arch/powerpc/kvm/timing.c
+++ b/arch/powerpc/kvm/timing.c
@@ -201,7 +201,7 @@ static int kvmppc_exit_timing_open(struct inode *inode, struct file *file)
 	return single_open(file, kvmppc_exit_timing_show, inode->i_private);
 }
 
-static struct file_operations kvmppc_exit_timing_fops = {
+static const struct file_operations kvmppc_exit_timing_fops = {
 	.owner   = THIS_MODULE,
 	.open    = kvmppc_exit_timing_open,
 	.read    = seq_read,
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -147,7 +147,7 @@ static int __fops ## _open(struct inode *inode, struct file *file)	\
 	__simple_attr_check_format(__fmt, 0ull);			\
 	return spufs_attr_open(inode, file, __get, __set, __fmt);	\
 }									\
-static struct file_operations __fops = {				\
+static const struct file_operations __fops = {				\
 	.owner	 = THIS_MODULE,						\
 	.open	 = __fops ## _open,					\
 	.release = spufs_attr_release,					\
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -209,7 +209,7 @@ static ssize_t dtl_file_read(struct file *filp, char __user *buf, size_t len,
 	return n_read * sizeof(struct dtl_entry);
 }
 
-static struct file_operations dtl_fops = {
+static const struct file_operations dtl_fops = {
 	.open		= dtl_file_open,
 	.release	= dtl_file_release,
 	.read		= dtl_file_read,
--- a/arch/x86/xen/debugfs.c
+++ b/arch/x86/xen/debugfs.c
@@ -100,7 +100,7 @@ static int xen_array_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations u32_array_fops = {
+static const struct file_operations u32_array_fops = {
 	.owner	= THIS_MODULE,
 	.open	= u32_array_open,
 	.release= xen_array_release,
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -285,7 +285,7 @@ static int acpi_video_device_brightness_open_fs(struct inode *inode,
 						struct file *file);
 static ssize_t acpi_video_device_write_brightness(struct file *file,
 	const char __user *buffer, size_t count, loff_t *data);
-static struct file_operations acpi_video_device_brightness_fops = {
+static const struct file_operations acpi_video_device_brightness_fops = {
 	.owner = THIS_MODULE,
 	.open = acpi_video_device_brightness_open_fs,
 	.read = seq_read,
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -426,7 +426,7 @@ out:
 	return err;
 }
 
-static struct file_operations cciss_proc_fops = {
+static const struct file_operations cciss_proc_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = cciss_seq_open,
 	.read    = seq_read,
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -393,7 +393,7 @@ static int apm_open(struct inode * inode, struct file * filp)
 	return as ? 0 : -ENOMEM;
 }
 
-static struct file_operations apm_bios_fops = {
+static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= apm_read,
 	.poll		= apm_poll,
--- a/drivers/char/bfin-otp.c
+++ b/drivers/char/bfin-otp.c
@@ -217,7 +217,7 @@ static long bfin_otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
 # define bfin_otp_ioctl NULL
 #endif
 
-static struct file_operations bfin_otp_fops = {
+static const struct file_operations bfin_otp_fops = {
 	.owner          = THIS_MODULE,
 	.unlocked_ioctl = bfin_otp_ioctl,
 	.read           = bfin_otp_read,
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -559,7 +559,7 @@ static int hwicap_release(struct inode *inode, struct file *file)
 	return status;
 }
 
-static struct file_operations hwicap_fops = {
+static const struct file_operations hwicap_fops = {
 	.owner = THIS_MODULE,
 	.write = hwicap_write,
 	.read = hwicap_read,
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1487,7 +1487,7 @@ static int gpiolib_open(struct inode *inode, struct file *file)
 	return single_open(file, gpiolib_show, NULL);
 }
 
-static struct file_operations gpiolib_operations = {
+static const struct file_operations gpiolib_operations = {
 	.open		= gpiolib_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -915,7 +915,7 @@ static int watchdog_ioctl(struct inode *inode, struct file *filp,
 	return ret;
 }
 
-static struct file_operations watchdog_fops = {
+static const struct file_operations watchdog_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.open = watchdog_open,
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -508,7 +508,7 @@ static int close(struct inode *inode, struct file *file)
  * uses: reading and writing a character device called /dev/lguest.  All the
  * work happens in the read(), write() and close() routines:
  */
-static struct file_operations lguest_fops = {
+static const struct file_operations lguest_fops = {
 	.owner	 = THIS_MODULE,
 	.release = close,
 	.write	 = write,
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -1203,7 +1203,7 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static struct file_operations dvb_dvr_fops = {
+static const struct file_operations dvb_dvr_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_dvr_read,
 	.write = dvb_dvr_write,
--- a/drivers/media/dvb/firewire/firedtv-ci.c
+++ b/drivers/media/dvb/firewire/firedtv-ci.c
@@ -215,7 +215,7 @@ static unsigned int fdtv_ca_io_poll(struct file *file, poll_table *wait)
 	return POLLIN;
 }
 
-static struct file_operations fdtv_ca_fops = {
+static const struct file_operations fdtv_ca_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= dvb_generic_ioctl,
 	.open		= dvb_generic_open,
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -271,7 +271,7 @@ static unsigned int phantom_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static struct file_operations phantom_file_ops = {
+static const struct file_operations phantom_file_ops = {
 	.open = phantom_open,
 	.release = phantom_release,
 	.unlocked_ioctl = phantom_ioctl,
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -53,7 +53,6 @@ struct gru_stats_s gru_stats;
 /* Guaranteed user available resources on each node */
 static int max_user_cbrs, max_user_dsr_bytes;
 
-static struct file_operations gru_fops;
 static struct miscdevice gru_miscdev;
 
 
@@ -426,7 +425,7 @@ static void __exit gru_exit(void)
 	gru_proc_exit();
 }
 
-static struct file_operations gru_fops = {
+static const struct file_operations gru_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= gru_file_unlocked_ioctl,
 	.mmap		= gru_file_mmap,
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -240,7 +240,7 @@ static int mmc_ext_csd_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations mmc_dbg_ext_csd_fops = {
+static const struct file_operations mmc_dbg_ext_csd_fops = {
 	.open		= mmc_ext_csd_open,
 	.read		= mmc_ext_csd_read,
 	.release	= mmc_ext_csd_release,
--- a/drivers/s390/cio/qdio_debug.c
+++ b/drivers/s390/cio/qdio_debug.c
@@ -125,7 +125,7 @@ static int qstat_seq_open(struct inode *inode, struct file *filp)
 			   filp->f_path.dentry->d_inode->i_private);
 }
 
-static struct file_operations debugfs_fops = {
+static const struct file_operations debugfs_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = qstat_seq_open,
 	.read	 = seq_read,
--- a/drivers/s390/cio/qdio_perf.c
+++ b/drivers/s390/cio/qdio_perf.c
@@ -84,7 +84,7 @@ static int qdio_perf_seq_open(struct inode *inode, struct file *filp)
 	return single_open(filp, qdio_perf_proc_show, NULL);
 }
 
-static struct file_operations qdio_perf_proc_fops = {
+static const struct file_operations qdio_perf_proc_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = qdio_perf_seq_open,
 	.read	 = seq_read,
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1317,7 +1317,7 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 	}
 }
 
-static struct file_operations sg_fops = {
+static const struct file_operations sg_fops = {
 	.owner = THIS_MODULE,
 	.read = sg_read,
 	.write = sg_write,
@@ -2194,9 +2194,11 @@ static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
 			          size_t count, loff_t *off);
-static struct file_operations adio_fops = {
-	/* .owner, .read and .llseek added in sg_proc_init() */
+static const struct file_operations adio_fops = {
+	.owner = THIS_MODULE,
 	.open = sg_proc_single_open_adio,
+	.read = seq_read,
+	.llseek = seq_lseek,
 	.write = sg_proc_write_adio,
 	.release = single_release,
 };
@@ -2204,23 +2206,32 @@ static struct file_operations adio_fops = {
 static int sg_proc_single_open_dressz(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_dressz(struct file *filp, 
 		const char __user *buffer, size_t count, loff_t *off);
-static struct file_operations dressz_fops = {
+static const struct file_operations dressz_fops = {
+	.owner = THIS_MODULE,
 	.open = sg_proc_single_open_dressz,
+	.read = seq_read,
+	.llseek = seq_lseek,
 	.write = sg_proc_write_dressz,
 	.release = single_release,
 };
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
 static int sg_proc_single_open_version(struct inode *inode, struct file *file);
-static struct file_operations version_fops = {
+static const struct file_operations version_fops = {
+	.owner = THIS_MODULE,
 	.open = sg_proc_single_open_version,
+	.read = seq_read,
+	.llseek = seq_lseek,
 	.release = single_release,
 };
 
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v);
 static int sg_proc_single_open_devhdr(struct inode *inode, struct file *file);
-static struct file_operations devhdr_fops = {
+static const struct file_operations devhdr_fops = {
+	.owner = THIS_MODULE,
 	.open = sg_proc_single_open_devhdr,
+	.read = seq_read,
+	.llseek = seq_lseek,
 	.release = single_release,
 };
 
@@ -2229,8 +2240,11 @@ static int sg_proc_open_dev(struct inode *inode, struct file *file);
 static void * dev_seq_start(struct seq_file *s, loff_t *pos);
 static void * dev_seq_next(struct seq_file *s, void *v, loff_t *pos);
 static void dev_seq_stop(struct seq_file *s, void *v);
-static struct file_operations dev_fops = {
+static const struct file_operations dev_fops = {
+	.owner = THIS_MODULE,
 	.open = sg_proc_open_dev,
+	.read = seq_read,
+	.llseek = seq_lseek,
 	.release = seq_release,
 };
 static const struct seq_operations dev_seq_ops = {
@@ -2242,8 +2256,11 @@ static const struct seq_operations dev_seq_ops = {
 
 static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v);
 static int sg_proc_open_devstrs(struct inode *inode, struct file *file);
-static struct file_operations devstrs_fops = {
+static const struct file_operations devstrs_fops = {
+	.owner = THIS_MODULE,
 	.open = sg_proc_open_devstrs,
+	.read = seq_read,
+	.llseek = seq_lseek,
 	.release = seq_release,
 };
 static const struct seq_operations devstrs_seq_ops = {
@@ -2255,8 +2272,11 @@ static const struct seq_operations devstrs_seq_ops = {
 
 static int sg_proc_seq_show_debug(struct seq_file *s, void *v);
 static int sg_proc_open_debug(struct inode *inode, struct file *file);
-static struct file_operations debug_fops = {
+static const struct file_operations debug_fops = {
+	.owner = THIS_MODULE,
 	.open = sg_proc_open_debug,
+	.read = seq_read,
+	.llseek = seq_lseek,
 	.release = seq_release,
 };
 static const struct seq_operations debug_seq_ops = {
@@ -2269,7 +2289,7 @@ static const struct seq_operations debug_seq_ops = {
 
 struct sg_proc_leaf {
 	const char * name;
-	struct file_operations * fops;
+	const struct file_operations * fops;
 };
 
 static struct sg_proc_leaf sg_proc_leaf_arr[] = {
@@ -2295,9 +2315,6 @@ sg_proc_init(void)
 	for (k = 0; k < num_leaves; ++k) {
 		leaf = &sg_proc_leaf_arr[k];
 		mask = leaf->fops->write ? S_IRUGO | S_IWUSR : S_IRUGO;
-		leaf->fops->owner = THIS_MODULE;
-		leaf->fops->read = seq_read;
-		leaf->fops->llseek = seq_lseek;
 		proc_create(leaf->name, mask, sg_proc_sgp, leaf->fops);
 	}
 	return 0;
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -537,7 +537,7 @@ static int spidev_release(struct inode *inode, struct file *filp)
 	return status;
 }
 
-static struct file_operations spidev_fops = {
+static const struct file_operations spidev_fops = {
 	.owner =	THIS_MODULE,
 	/* REVISIT switch to aio primitives, so that userspace
 	 * gets more complete API coverage.  It'll simplify things
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -993,7 +993,7 @@ skip_io_on_zombie:
 	return retval;
 }
 
-static struct file_operations fops = {
+static const struct file_operations fops = {
 	.owner		= THIS_MODULE,
 	.read		= usbtmc_read,
 	.write		= usbtmc_write,
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -875,7 +875,7 @@ printer_ioctl(struct file *fd, unsigned int code, unsigned long arg)
 }
 
 /* used after endpoint configuration */
-static struct file_operations printer_io_operations = {
+static const struct file_operations printer_io_operations = {
 	.owner =	THIS_MODULE,
 	.open =		printer_open,
 	.read =		printer_read,
--- a/drivers/usb/host/whci/debug.c
+++ b/drivers/usb/host/whci/debug.c
@@ -134,7 +134,7 @@ static int pzl_open(struct inode *inode, struct file *file)
 	return single_open(file, pzl_print, inode->i_private);
 }
 
-static struct file_operations di_fops = {
+static const struct file_operations di_fops = {
 	.open    = di_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -142,7 +142,7 @@ static struct file_operations di_fops = {
 	.owner   = THIS_MODULE,
 };
 
-static struct file_operations asl_fops = {
+static const struct file_operations asl_fops = {
 	.open    = asl_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -150,7 +150,7 @@ static struct file_operations asl_fops = {
 	.owner   = THIS_MODULE,
 };
 
-static struct file_operations pzl_fops = {
+static const struct file_operations pzl_fops = {
 	.open    = pzl_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -429,8 +429,7 @@ read_rio(struct file *file, char __user *buffer, size_t count, loff_t * ppos)
 	return read_count;
 }
 
-static struct
-file_operations usb_rio_fops = {
+static const struct file_operations usb_rio_fops = {
 	.owner =	THIS_MODULE,
 	.read =		read_rio,
 	.write =	write_rio,
--- a/drivers/uwb/uwb-debug.c
+++ b/drivers/uwb/uwb-debug.c
@@ -205,7 +205,7 @@ static ssize_t command_write(struct file *file, const char __user *buf,
 	return ret < 0 ? ret : len;
 }
 
-static struct file_operations command_fops = {
+static const struct file_operations command_fops = {
 	.open   = command_open,
 	.write  = command_write,
 	.read   = NULL,
@@ -255,7 +255,7 @@ static int reservations_open(struct inode *inode, struct file *file)
 	return single_open(file, reservations_print, inode->i_private);
 }
 
-static struct file_operations reservations_fops = {
+static const struct file_operations reservations_fops = {
 	.open    = reservations_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -283,7 +283,7 @@ static int drp_avail_open(struct inode *inode, struct file *file)
 	return single_open(file, drp_avail_print, inode->i_private);
 }
 
-static struct file_operations drp_avail_fops = {
+static const struct file_operations drp_avail_fops = {
 	.open    = drp_avail_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2326,7 +2326,7 @@ int btrfs_sync_file(struct file *file, struct dentry *dentry, int datasync);
 int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			    int skip_pinned);
 int btrfs_check_file(struct btrfs_root *root, struct inode *inode);
-extern struct file_operations btrfs_file_operations;
+extern const struct file_operations btrfs_file_operations;
 int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct inode *inode,
 		       u64 start, u64 end, u64 locked_end,
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1196,7 +1196,7 @@ static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 	return 0;
 }
 
-struct file_operations btrfs_file_operations = {
+const struct file_operations btrfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.aio_read       = generic_file_aio_read,
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -62,7 +62,7 @@ static const struct inode_operations btrfs_special_inode_operations;
 static const struct inode_operations btrfs_file_inode_operations;
 static const struct address_space_operations btrfs_aops;
 static const struct address_space_operations btrfs_symlink_aops;
-static struct file_operations btrfs_dir_file_operations;
+static const struct file_operations btrfs_dir_file_operations;
 static struct extent_io_ops btrfs_extent_io_ops;
 
 static struct kmem_cache *btrfs_inode_cachep;
@@ -5544,7 +5544,7 @@ static const struct inode_operations btrfs_dir_ro_inode_operations = {
 	.permission	= btrfs_permission,
 };
 
-static struct file_operations btrfs_dir_file_operations = {
+static const struct file_operations btrfs_dir_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= btrfs_real_readdir,
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -818,7 +818,7 @@ static int jbd2_seq_history_release(struct inode *inode, struct file *file)
 	return seq_release(inode, file);
 }
 
-static struct file_operations jbd2_seq_history_fops = {
+static const struct file_operations jbd2_seq_history_fops = {
 	.owner		= THIS_MODULE,
 	.open           = jbd2_seq_history_open,
 	.read           = seq_read,
@@ -920,7 +920,7 @@ static int jbd2_seq_info_release(struct inode *inode, struct file *file)
 	return seq_release(inode, file);
 }
 
-static struct file_operations jbd2_seq_info_fops = {
+static const struct file_operations jbd2_seq_info_fops = {
 	.owner		= THIS_MODULE,
 	.open           = jbd2_seq_info_open,
 	.read           = seq_read,
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -176,7 +176,7 @@ static const struct file_operations exports_operations = {
 extern int nfsd_pool_stats_open(struct inode *inode, struct file *file);
 extern int nfsd_pool_stats_release(struct inode *inode, struct file *file);
 
-static struct file_operations pool_stats_operations = {
+static const struct file_operations pool_stats_operations = {
 	.open		= nfsd_pool_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -697,7 +697,7 @@ not_empty:
 	return 0;
 }
 
-struct file_operations nilfs_dir_operations = {
+const struct file_operations nilfs_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= nilfs_readdir,
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -134,7 +134,7 @@ static int nilfs_file_mmap(struct file *file, struct vm_area_struct *vma)
  * We have mostly NULL's here: the current defaults are ok for
  * the nilfs filesystem.
  */
-struct file_operations nilfs_file_operations = {
+const struct file_operations nilfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -433,7 +433,7 @@ static const struct address_space_operations def_mdt_aops = {
 };
 
 static const struct inode_operations def_mdt_iops;
-static struct file_operations def_mdt_fops;
+static const struct file_operations def_mdt_fops;
 
 /*
  * NILFS2 uses pseudo inodes for meta data files such as DAT, cpfile, sufile,
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -294,9 +294,9 @@ void nilfs_clear_gcdat_inode(struct the_nilfs *);
 /*
  * Inodes and files operations
  */
-extern struct file_operations nilfs_dir_operations;
+extern const struct file_operations nilfs_dir_operations;
 extern const struct inode_operations nilfs_file_inode_operations;
-extern struct file_operations nilfs_file_operations;
+extern const struct file_operations nilfs_file_operations;
 extern const struct address_space_operations nilfs_aops;
 extern const struct inode_operations nilfs_dir_inode_operations;
 extern const struct inode_operations nilfs_special_inode_operations;
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -966,7 +966,7 @@ static ssize_t o2hb_debug_read(struct file *file, char __user *buf,
 }
 #endif  /* CONFIG_DEBUG_FS */
 
-static struct file_operations o2hb_debug_fops = {
+static const struct file_operations o2hb_debug_fops = {
 	.open =		o2hb_debug_open,
 	.release =	o2hb_debug_release,
 	.read =		o2hb_debug_read,
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -207,7 +207,7 @@ static int nst_fop_release(struct inode *inode, struct file *file)
 	return seq_release_private(inode, file);
 }
 
-static struct file_operations nst_seq_fops = {
+static const struct file_operations nst_seq_fops = {
 	.open = nst_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -388,7 +388,7 @@ static int sc_fop_release(struct inode *inode, struct file *file)
 	return seq_release_private(inode, file);
 }
 
-static struct file_operations sc_seq_fops = {
+static const struct file_operations sc_seq_fops = {
 	.open = sc_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -478,7 +478,7 @@ bail:
 	return -ENOMEM;
 }
 
-static struct file_operations debug_purgelist_fops = {
+static const struct file_operations debug_purgelist_fops = {
 	.open =		debug_purgelist_open,
 	.release =	debug_buffer_release,
 	.read =		debug_buffer_read,
@@ -538,7 +538,7 @@ bail:
 	return -ENOMEM;
 }
 
-static struct file_operations debug_mle_fops = {
+static const struct file_operations debug_mle_fops = {
 	.open =		debug_mle_open,
 	.release =	debug_buffer_release,
 	.read =		debug_buffer_read,
@@ -741,7 +741,7 @@ static int debug_lockres_release(struct inode *inode, struct file *file)
 	return seq_release_private(inode, file);
 }
 
-static struct file_operations debug_lockres_fops = {
+static const struct file_operations debug_lockres_fops = {
 	.open =		debug_lockres_open,
 	.release =	debug_lockres_release,
 	.read =		seq_read,
@@ -925,7 +925,7 @@ bail:
 	return -ENOMEM;
 }
 
-static struct file_operations debug_state_fops = {
+static const struct file_operations debug_state_fops = {
 	.open =		debug_state_open,
 	.release =	debug_buffer_release,
 	.read =		debug_buffer_read,
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -373,7 +373,7 @@ static ssize_t ocfs2_debug_read(struct file *file, char __user *buf,
 }
 #endif	/* CONFIG_DEBUG_FS */
 
-static struct file_operations ocfs2_osb_debug_fops = {
+static const struct file_operations ocfs2_osb_debug_fops = {
 	.open =		ocfs2_osb_debug_open,
 	.release =	ocfs2_debug_release,
 	.read =		ocfs2_debug_read,
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -498,7 +498,7 @@ const struct inode_operations omfs_dir_inops = {
 	.rmdir = omfs_rmdir,
 };
 
-struct file_operations omfs_dir_operations = {
+const struct file_operations omfs_dir_operations = {
 	.read = generic_read_dir,
 	.readdir = omfs_readdir,
 	.llseek = generic_file_llseek,
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -322,7 +322,7 @@ static sector_t omfs_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, omfs_get_block);
 }
 
-struct file_operations omfs_file_operations = {
+const struct file_operations omfs_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.write = do_sync_write,
--- a/fs/omfs/omfs.h
+++ b/fs/omfs/omfs.h
@@ -44,14 +44,14 @@ extern int omfs_allocate_range(struct super_block *sb, int min_request,
 extern int omfs_clear_range(struct super_block *sb, u64 block, int count);
 
 /* dir.c */
-extern struct file_operations omfs_dir_operations;
+extern const struct file_operations omfs_dir_operations;
 extern const struct inode_operations omfs_dir_inops;
 extern int omfs_make_empty(struct inode *inode, struct super_block *sb);
 extern int omfs_is_bad(struct omfs_sb_info *sbi, struct omfs_header *header,
 			u64 fsblock);
 
 /* file.c */
-extern struct file_operations omfs_file_operations;
+extern const struct file_operations omfs_file_operations;
 extern const struct inode_operations omfs_file_inops;
 extern const struct address_space_operations omfs_aops;
 extern void omfs_make_empty_table(struct buffer_head *bh, int offset);
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -37,7 +37,7 @@ extern void cgroup_exit(struct task_struct *p, int run_callbacks);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 
-extern struct file_operations proc_cgroup_operations;
+extern const struct file_operations proc_cgroup_operations;
 
 /* Define the enumeration of all cgroup subsystems */
 #define SUBSYS(_x) _x ## _subsys_id,
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2446,7 +2446,7 @@ static int __fops ## _open(struct inode *inode, struct file *file)	\
 	__simple_attr_check_format(__fmt, 0ull);			\
 	return simple_attr_open(inode, file, __get, __set, __fmt);	\
 }									\
-static struct file_operations __fops = {				\
+static const struct file_operations __fops = {				\
 	.owner	 = THIS_MODULE,						\
 	.open	 = __fops ## _open,					\
 	.release = simple_attr_release,					\
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -703,7 +703,7 @@ static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, int mode);
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
 static int cgroup_populate_dir(struct cgroup *cgrp);
 static const struct inode_operations cgroup_dir_inode_operations;
-static struct file_operations proc_cgroupstats_operations;
+static const struct file_operations proc_cgroupstats_operations;
 
 static struct backing_dev_info cgroup_backing_dev_info = {
 	.name		= "cgroup",
@@ -1863,7 +1863,7 @@ static int cgroup_seqfile_release(struct inode *inode, struct file *file)
 	return single_release(inode, file);
 }
 
-static struct file_operations cgroup_seqfile_operations = {
+static const struct file_operations cgroup_seqfile_operations = {
 	.read = seq_read,
 	.write = cgroup_file_write,
 	.llseek = seq_lseek,
@@ -1922,7 +1922,7 @@ static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return simple_rename(old_dir, old_dentry, new_dir, new_dentry);
 }
 
-static struct file_operations cgroup_file_operations = {
+static const struct file_operations cgroup_file_operations = {
 	.read = cgroup_file_read,
 	.write = cgroup_file_write,
 	.llseek = generic_file_llseek,
@@ -3369,7 +3369,7 @@ static int cgroup_open(struct inode *inode, struct file *file)
 	return single_open(file, proc_cgroup_show, pid);
 }
 
-struct file_operations proc_cgroup_operations = {
+const struct file_operations proc_cgroup_operations = {
 	.open		= cgroup_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -3398,7 +3398,7 @@ static int cgroupstats_open(struct inode *inode, struct file *file)
 	return single_open(file, proc_cgroupstats_show, NULL);
 }
 
-static struct file_operations proc_cgroupstats_operations = {
+static const struct file_operations proc_cgroupstats_operations = {
 	.open = cgroupstats_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1333,7 +1333,7 @@ static int __kprobes kprobes_open(struct inode *inode, struct file *filp)
 	return seq_open(filp, &kprobes_seq_ops);
 }
 
-static struct file_operations debugfs_kprobes_operations = {
+static const struct file_operations debugfs_kprobes_operations = {
 	.open           = kprobes_open,
 	.read           = seq_read,
 	.llseek         = seq_lseek,
@@ -1515,7 +1515,7 @@ static ssize_t write_enabled_file_bool(struct file *file,
 	return count;
 }
 
-static struct file_operations fops_kp = {
+static const struct file_operations fops_kp = {
 	.read =         read_enabled_file_bool,
 	.write =        write_enabled_file_bool,
 };
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -93,7 +93,7 @@ static int rcudata_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcudata, NULL);
 }
 
-static struct file_operations rcudata_fops = {
+static const struct file_operations rcudata_fops = {
 	.owner = THIS_MODULE,
 	.open = rcudata_open,
 	.read = seq_read,
@@ -145,7 +145,7 @@ static int rcudata_csv_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcudata_csv, NULL);
 }
 
-static struct file_operations rcudata_csv_fops = {
+static const struct file_operations rcudata_csv_fops = {
 	.owner = THIS_MODULE,
 	.open = rcudata_csv_open,
 	.read = seq_read,
@@ -196,7 +196,7 @@ static int rcuhier_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcuhier, NULL);
 }
 
-static struct file_operations rcuhier_fops = {
+static const struct file_operations rcuhier_fops = {
 	.owner = THIS_MODULE,
 	.open = rcuhier_open,
 	.read = seq_read,
@@ -222,7 +222,7 @@ static int rcugp_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcugp, NULL);
 }
 
-static struct file_operations rcugp_fops = {
+static const struct file_operations rcugp_fops = {
 	.owner = THIS_MODULE,
 	.open = rcugp_open,
 	.read = seq_read,
@@ -276,7 +276,7 @@ static int rcu_pending_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcu_pending, NULL);
 }
 
-static struct file_operations rcu_pending_fops = {
+static const struct file_operations rcu_pending_fops = {
 	.owner = THIS_MODULE,
 	.open = rcu_pending_open,
 	.read = seq_read,
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -780,7 +780,7 @@ static int sched_feat_open(struct inode *inode, struct file *filp)
 	return single_open(filp, sched_feat_show, NULL);
 }
 
-static struct file_operations sched_feat_fops = {
+static const struct file_operations sched_feat_fops = {
 	.open		= sched_feat_open,
 	.write		= sched_feat_write,
 	.read		= seq_read,
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -275,7 +275,7 @@ static int timer_list_open(struct inode *inode, struct file *filp)
 	return single_open(filp, timer_list_show, NULL);
 }
 
-static struct file_operations timer_list_fops = {
+static const struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -395,7 +395,7 @@ static int tstats_open(struct inode *inode, struct file *filp)
 	return single_open(filp, tstats_show, NULL);
 }
 
-static struct file_operations tstats_fops = {
+static const struct file_operations tstats_fops = {
 	.open		= tstats_open,
 	.read		= seq_read,
 	.write		= tstats_write,
--- a/samples/tracepoints/tracepoint-sample.c
+++ b/samples/tracepoints/tracepoint-sample.c
@@ -28,7 +28,7 @@ static int my_open(struct inode *inode, struct file *file)
 	return -EPERM;
 }
 
-static struct file_operations mark_ops = {
+static const struct file_operations mark_ops = {
 	.open = my_open,
 };
 
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -43,7 +43,7 @@ static ssize_t ima_show_htable_violations(struct file *filp,
 	return ima_show_htable_value(buf, count, ppos, &ima_htable.violations);
 }
 
-static struct file_operations ima_htable_violations_ops = {
+static const struct file_operations ima_htable_violations_ops = {
 	.read = ima_show_htable_violations
 };
 
@@ -55,7 +55,7 @@ static ssize_t ima_show_measurements_count(struct file *filp,
 
 }
 
-static struct file_operations ima_measurements_count_ops = {
+static const struct file_operations ima_measurements_count_ops = {
 	.read = ima_show_measurements_count
 };
 
@@ -158,7 +158,7 @@ static int ima_measurements_open(struct inode *inode, struct file *file)
 	return seq_open(file, &ima_measurments_seqops);
 }
 
-static struct file_operations ima_measurements_ops = {
+static const struct file_operations ima_measurements_ops = {
 	.open = ima_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -233,7 +233,7 @@ static int ima_ascii_measurements_open(struct inode *inode, struct file *file)
 	return seq_open(file, &ima_ascii_measurements_seqops);
 }
 
-static struct file_operations ima_ascii_measurements_ops = {
+static const struct file_operations ima_ascii_measurements_ops = {
 	.open = ima_ascii_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -313,7 +313,7 @@ static int ima_release_policy(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations ima_measure_policy_ops = {
+static const struct file_operations ima_measure_policy_ops = {
 	.open = ima_open_policy,
 	.write = ima_write_policy,
 	.release = ima_release_policy
