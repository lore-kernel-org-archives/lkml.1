Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZLNANh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZLNANh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbZLMX56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34775 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbZLMX5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:51 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       torvalds@linux-foundation.org
Subject: [PATCH 7/9] Constify struct file_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:35 +0100
Message-Id: <422d70754d540ed2b8578906e71d527bcc2e0059.1260662997.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662997.git.re.emese@gmail.com>
References: <cover.1260662997.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/staging/b3dfg/b3dfg.c                    |    2 +-
 drivers/staging/dream/pmem.c                     |    4 ++--
 drivers/staging/dream/qdsp5/adsp_driver.c        |    2 +-
 drivers/staging/dream/qdsp5/audio_aac.c          |    2 +-
 drivers/staging/dream/qdsp5/audio_amrnb.c        |    2 +-
 drivers/staging/dream/qdsp5/audio_evrc.c         |    2 +-
 drivers/staging/dream/qdsp5/audio_in.c           |    4 ++--
 drivers/staging/dream/qdsp5/audio_mp3.c          |    2 +-
 drivers/staging/dream/qdsp5/audio_out.c          |    4 ++--
 drivers/staging/dream/qdsp5/audio_qcelp.c        |    2 +-
 drivers/staging/dream/qdsp5/snd.c                |    2 +-
 drivers/staging/dream/smd/smd_qmi.c              |    2 +-
 drivers/staging/dream/smd/smd_rpcrouter_device.c |    4 ++--
 drivers/staging/panel/panel.c                    |    4 ++--
 drivers/staging/poch/poch.c                      |    2 +-
 drivers/staging/rtl8192u/ieee80211/proc.c        |    2 +-
 drivers/staging/sep/sep_driver.c                 |    2 +-
 drivers/staging/vme/devices/vme_user.c           |    2 +-
 18 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/b3dfg/b3dfg.c b/drivers/staging/b3dfg/b3dfg.c
index 4a43c51..0047afd 100644
--- a/drivers/staging/b3dfg/b3dfg.c
+++ b/drivers/staging/b3dfg/b3dfg.c
@@ -836,7 +836,7 @@ static int b3dfg_mmap(struct file *filp, struct vm_area_struct *vma)
 	return r;
 }
 
-static struct file_operations b3dfg_fops = {
+static const struct file_operations b3dfg_fops = {
 	.owner = THIS_MODULE,
 	.open = b3dfg_open,
 	.release = b3dfg_release,
diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
index def6468..1660a58 100644
--- a/drivers/staging/dream/pmem.c
+++ b/drivers/staging/dream/pmem.c
@@ -174,7 +174,7 @@ static int pmem_mmap(struct file *, struct vm_area_struct *);
 static int pmem_open(struct inode *, struct file *);
 static long pmem_ioctl(struct file *, unsigned int, unsigned long);
 
-struct file_operations pmem_fops = {
+const struct file_operations pmem_fops = {
 	.release = pmem_release,
 	.mmap = pmem_mmap,
 	.open = pmem_open,
@@ -1202,7 +1202,7 @@ static ssize_t debug_read(struct file *file, char __user *buf, size_t count,
 	return simple_read_from_buffer(buf, count, ppos, buffer, n);
 }
 
-static struct file_operations debug_fops = {
+static const struct file_operations debug_fops = {
 	.read = debug_read,
 	.open = debug_open,
 };
diff --git a/drivers/staging/dream/qdsp5/adsp_driver.c b/drivers/staging/dream/qdsp5/adsp_driver.c
index e55a0db..577b776 100644
--- a/drivers/staging/dream/qdsp5/adsp_driver.c
+++ b/drivers/staging/dream/qdsp5/adsp_driver.c
@@ -576,7 +576,7 @@ static struct adsp_device *inode_to_device(struct inode *inode)
 static dev_t adsp_devno;
 static struct class *adsp_class;
 
-static struct file_operations adsp_fops = {
+static const struct file_operations adsp_fops = {
 	.owner = THIS_MODULE,
 	.open = adsp_open,
 	.unlocked_ioctl = adsp_ioctl,
diff --git a/drivers/staging/dream/qdsp5/audio_aac.c b/drivers/staging/dream/qdsp5/audio_aac.c
index ad2390f..4116ee8 100644
--- a/drivers/staging/dream/qdsp5/audio_aac.c
+++ b/drivers/staging/dream/qdsp5/audio_aac.c
@@ -1022,7 +1022,7 @@ done:
 	return rc;
 }
 
-static struct file_operations audio_aac_fops = {
+static const struct file_operations audio_aac_fops = {
 	.owner = THIS_MODULE,
 	.open = audio_open,
 	.release = audio_release,
diff --git a/drivers/staging/dream/qdsp5/audio_amrnb.c b/drivers/staging/dream/qdsp5/audio_amrnb.c
index cd818a5..870b37b 100644
--- a/drivers/staging/dream/qdsp5/audio_amrnb.c
+++ b/drivers/staging/dream/qdsp5/audio_amrnb.c
@@ -833,7 +833,7 @@ done:
 	return rc;
 }
 
-static struct file_operations audio_amrnb_fops = {
+static const struct file_operations audio_amrnb_fops = {
 	.owner = THIS_MODULE,
 	.open = audamrnb_open,
 	.release = audamrnb_release,
diff --git a/drivers/staging/dream/qdsp5/audio_evrc.c b/drivers/staging/dream/qdsp5/audio_evrc.c
index 4b43e18..cedafda 100644
--- a/drivers/staging/dream/qdsp5/audio_evrc.c
+++ b/drivers/staging/dream/qdsp5/audio_evrc.c
@@ -805,7 +805,7 @@ dma_fail:
 	return rc;
 }
 
-static struct file_operations audio_evrc_fops = {
+static const struct file_operations audio_evrc_fops = {
 	.owner = THIS_MODULE,
 	.open = audevrc_open,
 	.release = audevrc_release,
diff --git a/drivers/staging/dream/qdsp5/audio_in.c b/drivers/staging/dream/qdsp5/audio_in.c
index 3d950a2..9431118 100644
--- a/drivers/staging/dream/qdsp5/audio_in.c
+++ b/drivers/staging/dream/qdsp5/audio_in.c
@@ -913,7 +913,7 @@ static int audpre_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations audio_fops = {
+static const struct file_operations audio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= audio_in_open,
 	.release	= audio_in_release,
@@ -922,7 +922,7 @@ static struct file_operations audio_fops = {
 	.unlocked_ioctl	= audio_in_ioctl,
 };
 
-static struct file_operations audpre_fops = {
+static const struct file_operations audpre_fops = {
 	.owner          = THIS_MODULE,
 	.open           = audpre_open,
 	.unlocked_ioctl = audpre_ioctl,
diff --git a/drivers/staging/dream/qdsp5/audio_mp3.c b/drivers/staging/dream/qdsp5/audio_mp3.c
index b95574f..286c2f4 100644
--- a/drivers/staging/dream/qdsp5/audio_mp3.c
+++ b/drivers/staging/dream/qdsp5/audio_mp3.c
@@ -941,7 +941,7 @@ done:
 	return rc;
 }
 
-static struct file_operations audio_mp3_fops = {
+static const struct file_operations audio_mp3_fops = {
 	.owner		= THIS_MODULE,
 	.open		= audio_open,
 	.release	= audio_release,
diff --git a/drivers/staging/dream/qdsp5/audio_out.c b/drivers/staging/dream/qdsp5/audio_out.c
index df87ca3..44b7799 100644
--- a/drivers/staging/dream/qdsp5/audio_out.c
+++ b/drivers/staging/dream/qdsp5/audio_out.c
@@ -806,7 +806,7 @@ static int audpp_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations audio_fops = {
+static const struct file_operations audio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= audio_open,
 	.release	= audio_release,
@@ -815,7 +815,7 @@ static struct file_operations audio_fops = {
 	.unlocked_ioctl	= audio_ioctl,
 };
 
-static struct file_operations audpp_fops = {
+static const struct file_operations audpp_fops = {
 	.owner		= THIS_MODULE,
 	.open		= audpp_open,
 	.unlocked_ioctl	= audpp_ioctl,
diff --git a/drivers/staging/dream/qdsp5/audio_qcelp.c b/drivers/staging/dream/qdsp5/audio_qcelp.c
index f0f50e3..f6b9dbc 100644
--- a/drivers/staging/dream/qdsp5/audio_qcelp.c
+++ b/drivers/staging/dream/qdsp5/audio_qcelp.c
@@ -816,7 +816,7 @@ err:
 	return rc;
 }
 
-static struct file_operations audio_qcelp_fops = {
+static const struct file_operations audio_qcelp_fops = {
 	.owner = THIS_MODULE,
 	.open = audqcelp_open,
 	.release = audqcelp_release,
diff --git a/drivers/staging/dream/qdsp5/snd.c b/drivers/staging/dream/qdsp5/snd.c
index 037d7ff..5469ec3 100644
--- a/drivers/staging/dream/qdsp5/snd.c
+++ b/drivers/staging/dream/qdsp5/snd.c
@@ -242,7 +242,7 @@ err:
 	return rc;
 }
 
-static struct file_operations snd_fops = {
+static const struct file_operations snd_fops = {
 	.owner		= THIS_MODULE,
 	.open		= snd_open,
 	.release	= snd_release,
diff --git a/drivers/staging/dream/smd/smd_qmi.c b/drivers/staging/dream/smd/smd_qmi.c
index 687db14..688623e 100644
--- a/drivers/staging/dream/smd/smd_qmi.c
+++ b/drivers/staging/dream/smd/smd_qmi.c
@@ -788,7 +788,7 @@ static int qmi_release(struct inode *ip, struct file *fp)
 	return 0;
 }
 
-static struct file_operations qmi_fops = {
+static const struct file_operations qmi_fops = {
 	.owner = THIS_MODULE,
 	.read = qmi_read,
 	.write = qmi_write,
diff --git a/drivers/staging/dream/smd/smd_rpcrouter_device.c b/drivers/staging/dream/smd/smd_rpcrouter_device.c
index cd3910b..ff053d3 100644
--- a/drivers/staging/dream/smd/smd_rpcrouter_device.c
+++ b/drivers/staging/dream/smd/smd_rpcrouter_device.c
@@ -214,7 +214,7 @@ static long rpcrouter_ioctl(struct file *filp, unsigned int cmd,
 	return rc;
 }
 
-static struct file_operations rpcrouter_server_fops = {
+static const struct file_operations rpcrouter_server_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = rpcrouter_open,
 	.release = rpcrouter_release,
@@ -224,7 +224,7 @@ static struct file_operations rpcrouter_server_fops = {
 	.unlocked_ioctl	 = rpcrouter_ioctl,
 };
 
-static struct file_operations rpcrouter_router_fops = {
+static const struct file_operations rpcrouter_router_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = rpcrouter_open,
 	.release = rpcrouter_release,
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 4ce399b..225f9bc 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1305,7 +1305,7 @@ static int lcd_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations lcd_fops = {
+static const struct file_operations lcd_fops = {
 	.write   = lcd_write,
 	.open    = lcd_open,
 	.release = lcd_release,
@@ -1565,7 +1565,7 @@ static int keypad_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations keypad_fops = {
+static const struct file_operations keypad_fops = {
 	.read    = keypad_read,		/* read */
 	.open    = keypad_open,		/* open */
 	.release = keypad_release,	/* close */
diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index 9095158..0fc63e7 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -1032,7 +1032,7 @@ static int poch_ioctl(struct inode *inode, struct file *filp,
 	return 0;
 }
 
-static struct file_operations poch_fops = {
+static const struct file_operations poch_fops = {
 	.owner = THIS_MODULE,
 	.open = poch_open,
 	.release = poch_release,
diff --git a/drivers/staging/rtl8192u/ieee80211/proc.c b/drivers/staging/rtl8192u/ieee80211/proc.c
index 6eda928..7e60f0e 100644
--- a/drivers/staging/rtl8192u/ieee80211/proc.c
+++ b/drivers/staging/rtl8192u/ieee80211/proc.c
@@ -99,7 +99,7 @@ static int crypto_info_open(struct inode *inode, struct file *file)
 	return seq_open(file, &crypto_seq_ops);
 }
 
-static struct file_operations proc_crypto_ops = {
+static const struct file_operations proc_crypto_ops = {
 	.open		= crypto_info_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index e7bc9ec..63d35a3 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2605,7 +2605,7 @@ static struct pci_driver sep_pci_driver = {
 static dev_t sep_devno;
 
 /* the files operations structure of the driver */
-static struct file_operations sep_file_operations = {
+static const struct file_operations sep_file_operations = {
 	.owner = THIS_MODULE,
 	.ioctl = sep_ioctl,
 	.poll = sep_poll,
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index e228942..ebf63a5 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -135,7 +135,7 @@ static int vme_user_ioctl(struct inode *, struct file *, unsigned int,
 static int __init vme_user_probe(struct device *, int, int);
 static int __exit vme_user_remove(struct device *, int, int);
 
-static struct file_operations vme_user_fops = {
+static const struct file_operations vme_user_fops = {
         .open = vme_user_open,
         .release = vme_user_release,
         .read = vme_user_read,
-- 
1.6.5.3

