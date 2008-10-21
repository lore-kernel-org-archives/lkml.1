Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYJUXtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYJUXtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 19:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYJUXtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 19:49:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:1559 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYJUXtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 19:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Cos81hY/6gcdQXMUAt3OtP3RA9/+8eW1rRRgsLH1DzdBRdMUWWpWhMzUGggOBg8lqJ
         FEELVrqlYYGbk6JISpZNhhSN/XaFzjk3Y0UPzcKMIv1F1KUSGl57o8J2N2Ai6mxXNs/C
         7kYwTSKTtxhLDQrivo6mXuwgqSPGKvwOQyFYM=
Message-ID: <48FE6A75.5080004@gmail.com>
Date: Tue, 21 Oct 2008 19:49:09 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Make static
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make static

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Building an allnoconfig, sparse asked whether these could be static, so I checked,
and they are only used in the file where they are declared. This means that they
can be static, am I forgetting something? This was build and checkpatch tested.

 arch/x86/boot/video-bios.c |    4 ++--
 arch/x86/boot/video-vesa.c |    4 ++--
 arch/x86/kernel/xsave.c    |    2 +-
 block/blk-softirq.c        |    2 +-
 drivers/char/pty.c         |    2 +-
 drivers/char/tty_io.c      |    2 +-
 drivers/char/vt.c          |    2 +-
 drivers/firmware/memmap.c  |    6 +++---
 kernel/irq/proc.c          |    2 +-
 kernel/printk.c            |    2 +-
 mm/page_alloc.c            |    2 +-
 11 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/boot/video-bios.c b/arch/x86/boot/video-bios.c
index 49f26aa..3fa979c 100644
--- a/arch/x86/boot/video-bios.c
+++ b/arch/x86/boot/video-bios.c
@@ -17,7 +17,7 @@
 #include "boot.h"
 #include "video.h"
 
-__videocard video_bios;
+static __videocard video_bios;
 
 /* Set a conventional BIOS mode */
 static int set_bios_mode(u8 mode);
@@ -119,7 +119,7 @@ static int bios_probe(void)
 	return nmodes;
 }
 
-__videocard video_bios =
+static __videocard video_bios =
 {
 	.card_name	= "BIOS",
 	.probe		= bios_probe,
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 99b3079..7511584 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -20,7 +20,7 @@
 static struct vesa_general_info vginfo;
 static struct vesa_mode_info vminfo;
 
-__videocard video_vesa;
+static __videocard video_vesa;
 
 #ifndef _WAKEUP
 static void vesa_store_mode_params_graphics(void);
@@ -293,7 +293,7 @@ void vesa_store_edid(void)
 
 #endif /* not _WAKEUP */
 
-__videocard video_vesa =
+static __videocard video_vesa =
 {
 	.card_name	= "VESA",
 	.probe		= vesa_probe,
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9abac8a..b13acb7 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -248,7 +248,7 @@ clear:
  * This will be saved when ever the FP and extended state context is
  * saved on the user stack during the signal handler delivery to the user.
  */
-void prepare_fx_sw_frame(void)
+static void prepare_fx_sw_frame(void)
 {
 	int size_extended = (xstate_size - sizeof(struct i387_fxsave_struct)) +
 			     FP_XSTATE_MAGIC2_SIZE;
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index e660d26..ce0efc6 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -161,7 +161,7 @@ void blk_complete_request(struct request *req)
 }
 EXPORT_SYMBOL(blk_complete_request);
 
-__init int blk_softirq_init(void)
+static __init int blk_softirq_init(void)
 {
 	int i;
 
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 6d45827..c9e890c 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -34,7 +34,7 @@
 
 /* These are global because they are accessed in tty_io.c */
 #ifdef CONFIG_UNIX98_PTYS
-struct tty_driver *ptm_driver;
+static struct tty_driver *ptm_driver;
 static struct tty_driver *pts_driver;
 #endif
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 59f4721..6fb2cbf 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1213,7 +1213,7 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
  *	be held until the 'fast-open' is also done. Will change once we
  *	have refcounting in the driver and per driver locking
  */
-struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
+static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
 		struct inode *inode, int idx)
 {
 	struct tty_struct *tty;
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index d8f83e2..9972bbf 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -971,7 +971,7 @@ int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int rows)
  *	termios_mutex and the tty ctrl_lock in that order.
  */
 
-int vt_resize(struct tty_struct *tty, struct tty_struct *real_tty,
+static int vt_resize(struct tty_struct *tty, struct tty_struct *real_tty,
 	struct winsize *ws)
 {
 	struct vc_data *vc = tty->driver_data;
diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 3bf8ee1..261b9aa 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -56,9 +56,9 @@ struct memmap_attribute {
 	ssize_t (*show)(struct firmware_map_entry *entry, char *buf);
 };
 
-struct memmap_attribute memmap_start_attr = __ATTR_RO(start);
-struct memmap_attribute memmap_end_attr   = __ATTR_RO(end);
-struct memmap_attribute memmap_type_attr  = __ATTR_RO(type);
+static struct memmap_attribute memmap_start_attr = __ATTR_RO(start);
+static struct memmap_attribute memmap_end_attr   = __ATTR_RO(end);
+static struct memmap_attribute memmap_type_attr  = __ATTR_RO(type);
 
 /*
  * These are default attributes that are added for every memmap entry.
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index fac014a..4d161c7 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -220,7 +220,7 @@ void unregister_handler_proc(unsigned int irq, struct irqaction *action)
 	}
 }
 
-void register_default_affinity_proc(void)
+static void register_default_affinity_proc(void)
 {
 #ifdef CONFIG_SMP
 	proc_create("irq/default_smp_affinity", 0600, NULL,
diff --git a/kernel/printk.c b/kernel/printk.c
index 6341af7..25bb1e7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -243,7 +243,7 @@ static int log_buf_get_len(void)
 /*
  * Copy a range of characters from the log buffer.
  */
-int log_buf_copy(char *dest, int idx, int len)
+static int log_buf_copy(char *dest, int idx, int len)
 {
 	int ret, max;
 	bool took_lock = false;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d0a240f..03e7ec2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4298,7 +4298,7 @@ void setup_per_zone_pages_min(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-void setup_per_zone_inactive_ratio(void)
+static void setup_per_zone_inactive_ratio(void)
 {
 	struct zone *zone;
 
