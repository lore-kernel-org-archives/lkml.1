Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYHAKuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYHAKuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 06:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbYHAKtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 06:49:43 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:42913 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbYHAKtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 06:49:42 -0400
X-BigFish: VPS7(zz1cddkzz10d3izzz32i8ah43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K4X4PZ-01-GTA-01
Message-ID: <20080801104754.303635665@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 1 Aug 2008 12:46:45 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Oruba <peter.oruba@amd.com>
Subject: [patch 1/2] [PATCH 1/2] x86: Microcode patch loader style corrections
References: <20080801104644.788786464@amd.com>
Content-Disposition: inline;
	filename="0001-x86-Microcode-patch-loader-style-corrections.patch"
X-OriginalArrivalTime: 01 Aug 2008 10:49:11.0036 (UTC) FILETIME=[3B13EBC0:01C8F3C4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style corrections to main microcode module.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 28dba1a..39961bb 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -55,8 +55,8 @@
  *		in a single CPU package.
  *	1.10	28 Feb 2002 Asit K Mallick <asit.k.mallick@intel.com> and
  *		Tigran Aivazian <tigran@veritas.com>,
- *		Serialize updates as required on HT processors due to speculative
- *		nature of implementation.
+ *		Serialize updates as required on HT processors due to
+ *		speculative nature of implementation.
  *	1.11	22 Mar 2002 Tigran Aivazian <tigran@veritas.com>
  *		Fix the panic when writing zero-length microcode chunk.
  *	1.12	29 Sep 2003 Nitin Kamble <nitin.a.kamble@intel.com>,
@@ -71,7 +71,7 @@
  *		Thanks to Stuart Swales for pointing out this bug.
  */
 
-//#define DEBUG /* pr_debug */
+/*#define DEBUG pr_debug */
 #include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -116,7 +116,7 @@ EXPORT_SYMBOL_GPL(user_buffer);
 unsigned int user_buffer_size;		/* it's size */
 EXPORT_SYMBOL_GPL(user_buffer_size);
 
-static int do_microcode_update (void)
+static int do_microcode_update(void)
 {
 	long cursor = 0;
 	int error = 0;
@@ -158,18 +158,20 @@ out:
 	return error;
 }
 
-static int microcode_open (struct inode *unused1, struct file *unused2)
+static int microcode_open(struct inode *unused1, struct file *unused2)
 {
 	cycle_kernel_lock();
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
 
-static ssize_t microcode_write (struct file *file, const char __user *buf, size_t len, loff_t *ppos)
+static ssize_t microcode_write(struct file *file, const char __user *buf,
+			       size_t len, loff_t *ppos)
 {
 	ssize_t ret;
 
 	if ((len >> PAGE_SHIFT) > num_physpages) {
-		printk(KERN_ERR "microcode: too much data (max %ld pages)\n", num_physpages);
+		printk(KERN_ERR "microcode: too much data (max %ld pages)\n",
+		       num_physpages);
 		return -EINVAL;
 	}
 
@@ -201,7 +203,7 @@ static struct miscdevice microcode_dev = {
 	.fops		= &microcode_fops,
 };
 
-static int __init microcode_dev_init (void)
+static int __init microcode_dev_init(void)
 {
 	int error;
 
@@ -216,7 +218,7 @@ static int __init microcode_dev_init (void)
 	return 0;
 }
 
-static void microcode_dev_exit (void)
+static void microcode_dev_exit(void)
 {
 	misc_deregister(&microcode_dev);
 }
@@ -224,7 +226,7 @@ static void microcode_dev_exit (void)
 MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 #else
 #define microcode_dev_init() 0
-#define microcode_dev_exit() do { } while(0)
+#define microcode_dev_exit() do { } while (0)
 #endif
 
 /* fake device for request_firmware */
@@ -451,7 +453,7 @@ int microcode_init(void *opaque, struct module *module)
 }
 EXPORT_SYMBOL_GPL(microcode_init);
 
-void __exit microcode_exit (void)
+void __exit microcode_exit(void)
 {
 	microcode_dev_exit();
 
-- 
1.5.4.5




