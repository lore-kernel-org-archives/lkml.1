Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYJPPx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYJPPx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYJPPxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:53:34 -0400
Received: from ozlabs.org ([203.10.76.45]:44919 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYJPPxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:53:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] CONFIG_KMOD removal: drivers/ and fs/ (now implied by CONFIG_MODULES)
Date: Fri, 17 Oct 2008 02:49:47 +1100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810170249.48388.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 04ab591808565f968d4406f6435090ad671ebdab:
  Linus Torvalds (1):
        Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Johannes Berg (2):
      remove CONFIG_KMOD from drivers
      remove CONFIG_KMOD from fs

Rusty Russell (1):
      module: remove CONFIG_KMOD in comment after #endif

 drivers/md/md.c                                 |    7 -------
 drivers/media/video/cpia.c                      |    4 ----
 drivers/media/video/usbvision/usbvision-core.c  |    4 ----
 drivers/media/video/usbvision/usbvision-video.c |    4 ----
 drivers/media/video/v4l1-compat.c               |    4 ----
 drivers/media/video/v4l2-common.c               |    4 ----
 drivers/media/video/vino.c                      |    5 +----
 drivers/media/video/w9968cf.c                   |    4 ++--
 drivers/mtd/mtdpart.c                           |    2 --
 drivers/net/irda/sir_dongle.c                   |    2 --
 drivers/net/ppp_generic.c                       |   10 +++-------
 drivers/net/pppox.c                             |    9 ++-------
 drivers/video/fbmem.c                           |   17 ++---------------
 fs/char_dev.c                                   |    3 ---
 fs/exec.c                                       |    9 +++------
 fs/nls/nls_base.c                               |   21 +--------------------
 kernel/kmod.c                                   |    2 +-
 17 files changed, 15 insertions(+), 96 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0a3a4bd..3323d76 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -44,14 +44,9 @@
 #include <linux/mutex.h>
 #include <linux/ctype.h>
 #include <linux/freezer.h>
-
 #include <linux/init.h>
-
 #include <linux/file.h>
-
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 
 #include <asm/unaligned.h>
 
@@ -3555,12 +3550,10 @@ static int do_md_run(mddev_t * mddev)
 		}
 	}
 
-#ifdef CONFIG_KMOD
 	if (mddev->level != LEVEL_NONE)
 		request_module("md-level-%d", mddev->level);
 	else if (mddev->clevel[0])
 		request_module("md-%s", mddev->clevel);
-#endif
 
 	/*
 	 * Drop all container device buffers, from now on
diff --git a/drivers/media/video/cpia.c b/drivers/media/video/cpia.c
index c325e92..1798b77 100644
--- a/drivers/media/video/cpia.c
+++ b/drivers/media/video/cpia.c
@@ -39,10 +39,6 @@
 #include <asm/io.h>
 #include <linux/mutex.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #include "cpia.h"
 
 static int video_nr = -1;
diff --git a/drivers/media/video/usbvision/usbvision-core.c b/drivers/media/video/usbvision/usbvision-core.c
index b26b563..9e4f506 100644
--- a/drivers/media/video/usbvision/usbvision-core.c
+++ b/drivers/media/video/usbvision/usbvision-core.c
@@ -45,10 +45,6 @@
 
 #include <linux/workqueue.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #include "usbvision.h"
 
 static unsigned int core_debug;
diff --git a/drivers/media/video/usbvision/usbvision-video.c 
b/drivers/media/video/usbvision/usbvision-video.c
index e10b256..77aeb39 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -69,10 +69,6 @@
 
 #include <linux/workqueue.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #include "usbvision.h"
 #include "usbvision-cards.h"
 
diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index 79937d1..928cb40 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -36,10 +36,6 @@
 #include <asm/system.h>
 #include <asm/pgtable.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 20c3be8..846763d 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -60,10 +60,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #include <linux/videodev2.h>
 
 MODULE_AUTHOR("Bill Dirks, Justin Schoeman, Gerd Knorr");
diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
index 8ec57df..1efc5f3 100644
--- a/drivers/media/video/vino.c
+++ b/drivers/media/video/vino.c
@@ -30,10 +30,7 @@
 #include <linux/mm.h>
 #include <linux/time.h>
 #include <linux/version.h>
-
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 
 #include <linux/i2c.h>
 #include <linux/i2c-algo-sgi.h>
@@ -4634,7 +4631,7 @@ static int __init vino_module_init(void)
 	}
 	vino_init_stage++;
 
-#if defined(CONFIG_KMOD) && defined(MODULE)
+#ifdef MODULE
 	request_module("saa7191");
 	request_module("indycam");
 #endif
diff --git a/drivers/media/video/w9968cf.c b/drivers/media/video/w9968cf.c
index 11edf79..dcd45db 100644
--- a/drivers/media/video/w9968cf.c
+++ b/drivers/media/video/w9968cf.c
@@ -111,7 +111,7 @@ static int specific_debug = W9968CF_SPECIFIC_DEBUG;
 
 static unsigned int param_nv[24]; /* number of values per parameter */
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 module_param(ovmod_load, bool, 0644);
 #endif
 module_param(simcams, ushort, 0644);
@@ -144,7 +144,7 @@ module_param(debug, ushort, 0644);
 module_param(specific_debug, bool, 0644);
 #endif
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 MODULE_PARM_DESC(ovmod_load,
 		 "\n<0|1> Automatic 'ovcamchip' module loading."
 		 "\n0 disabled, 1 enabled."
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index edb90b5..9a06dc9 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -564,10 +564,8 @@ int parse_mtd_partitions(struct mtd_info *master, const char **types,
 
 	for ( ; ret <= 0 && *types; types++) {
 		parser = get_partition_parser(*types);
-#ifdef CONFIG_KMOD
 		if (!parser && !request_module("%s", *types))
 				parser = get_partition_parser(*types);
-#endif
 		if (!parser) {
 			printk(KERN_NOTICE "%s partition parsing not available\n",
 			       *types);
diff --git a/drivers/net/irda/sir_dongle.c b/drivers/net/irda/sir_dongle.c
index 3603024..2a9930e 100644
--- a/drivers/net/irda/sir_dongle.c
+++ b/drivers/net/irda/sir_dongle.c
@@ -67,9 +67,7 @@ int sirdev_get_dongle(struct sir_dev *dev, IRDA_DONGLE type)
 	const struct dongle_driver *drv = NULL;
 	int err = -EINVAL;
 
-#ifdef CONFIG_KMOD
 	request_module("irda-dongle-%d", type);
-#endif
 
 	if (dev->dongle_drv != NULL)
 		return -EBUSY;
diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 0ca0fcb..94818ee 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -2127,13 +2127,9 @@ ppp_set_compress(struct ppp *ppp, unsigned long arg)
 	    || ccp_option[1] < 2 || ccp_option[1] > data.length)
 		goto out;
 
-	cp = find_compressor(ccp_option[0]);
-#ifdef CONFIG_KMOD
-	if (!cp) {
-		request_module("ppp-compress-%d", ccp_option[0]);
-		cp = find_compressor(ccp_option[0]);
-	}
-#endif /* CONFIG_KMOD */
+	cp = try_then_request_module(
+		find_compressor(ccp_option[0]),
+		"ppp-compress-%d", ccp_option[0]);
 	if (!cp)
 		goto out;
 
diff --git a/drivers/net/pppox.c b/drivers/net/pppox.c
index c6898c1..03aecc9 100644
--- a/drivers/net/pppox.c
+++ b/drivers/net/pppox.c
@@ -115,13 +115,8 @@ static int pppox_create(struct net *net, struct socket *sock, int protocol)
 		goto out;
 
 	rc = -EPROTONOSUPPORT;
-#ifdef CONFIG_KMOD
-	if (!pppox_protos[protocol]) {
-		char buffer[32];
-		sprintf(buffer, "pppox-proto-%d", protocol);
-		request_module(buffer);
-	}
-#endif
+	if (!pppox_protos[protocol])
+		request_module("pppox-proto-%d", protocol);
 	if (!pppox_protos[protocol] ||
 	    !try_module_get(pppox_protos[protocol]->owner))
 		goto out;
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 0737570..3f18bb9 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -28,9 +28,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/console.h>
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/efi.h>
@@ -837,13 +835,6 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	return (cnt) ? cnt : err;
 }
 
-#ifdef CONFIG_KMOD
-static void try_to_load(int fb)
-{
-	request_module("fb%d", fb);
-}
-#endif /* CONFIG_KMOD */
-
 int
 fb_pan_display(struct fb_info *info, struct fb_var_screeninfo *var)
 {
@@ -1086,10 +1077,8 @@ fb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		    return -EINVAL;
 		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
 		    return -EINVAL;
-#ifdef CONFIG_KMOD
 		if (!registered_fb[con2fb.framebuffer])
-		    try_to_load(con2fb.framebuffer);
-#endif /* CONFIG_KMOD */
+		    request_module("fb%d", con2fb.framebuffer);
 		if (!registered_fb[con2fb.framebuffer])
 		    return -EINVAL;
 		event.info = info;
@@ -1327,10 +1316,8 @@ fb_open(struct inode *inode, struct file *file)
 	if (fbidx >= FB_MAX)
 		return -ENODEV;
 	lock_kernel();
-#ifdef CONFIG_KMOD
 	if (!(info = registered_fb[fbidx]))
-		try_to_load(fbidx);
-#endif /* CONFIG_KMOD */
+		request_module("fb%d", fbidx);
 	if (!(info = registered_fb[fbidx])) {
 		res = -ENODEV;
 		goto out;
diff --git a/fs/char_dev.c b/fs/char_dev.c
index 3cb7cda..262fa10 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -22,9 +22,6 @@
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
 #include "internal.h"
 
 /*
diff --git a/fs/exec.c b/fs/exec.c
index cecee50..9811679 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -50,15 +50,12 @@
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
 #include <linux/tracehook.h>
+#include <linux/kmod.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #ifdef __alpha__
 /* for /sbin/loader handling in search_binary_handler() */
 #include <linux/a.out.h>
@@ -1247,8 +1244,8 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 		read_unlock(&binfmt_lock);
 		if (retval != -ENOEXEC || bprm->mm == NULL) {
 			break;
-#ifdef CONFIG_KMOD
-		}else{
+#ifdef CONFIG_MODULES
+		} else {
 #define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
 			if (printable(bprm->buf[0]) &&
 			    printable(bprm->buf[1]) &&
diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 64965e1..9b0efda 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -13,9 +13,7 @@
 #include <linux/nls.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 #include <linux/spinlock.h>
 
 static struct nls_table default_table;
@@ -215,24 +213,7 @@ static struct nls_table *find_nls(char *charset)
 
 struct nls_table *load_nls(char *charset)
 {
-	struct nls_table *nls;
-#ifdef CONFIG_KMOD
-	int ret;
-#endif
-
-	nls = find_nls(charset);
-	if (nls)
-		return nls;
-
-#ifdef CONFIG_KMOD
-	ret = request_module("nls_%s", charset);
-	if (ret != 0) {
-		printk("Unable to load NLS charset %s\n", charset);
-		return NULL;
-	}
-	nls = find_nls(charset);
-#endif
-	return nls;
+	return try_then_request_module(find_nls(charset), "nls_%s", charset);
 }
 
 void unload_nls(struct nls_table *nls)
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 2456d1a..58f9c2e 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -113,7 +113,7 @@ int request_module(const char *fmt, ...)
 	return ret;
 }
 EXPORT_SYMBOL(request_module);
-#endif /* CONFIG_KMOD */
+#endif /* CONFIG_MODULES */
 
 struct subprocess_info {
 	struct work_struct work;
