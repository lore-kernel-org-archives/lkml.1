Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbXFCOj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbXFCOj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXFCOj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:39:29 -0400
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:48077 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751931AbXFCOj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:39:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=JXgLX1mDbzY4VD4dZBeaX+dh0FfN8Ts9YDlLZGJcFbrMSF7Xz20jq9bc+JzjtxmEc/Cf2lMM6OlNlrP8A4fB8+Drjh095N+t5CUal6vFK1IZWGZWkhOMmCONiAAWHIfaOcrsnIFIKAJLbgqxuv1tLxV8pNKJeS66zlsDBgyQryI=;
X-YMail-OSG: QCEET0MVM1npunbblPA7rsg7887R1A_RoJXc2tkJaxIQKfhJwM5GQaZi1YqVOxpWd3wgoRSxVuNCfLBtA5Gcqc6A4BGaZEeeuBo6bSfsmw9w6mdNfFh9u.LlQd6gKEMAT2UP8UB7D8E-
Date: Sun, 3 Jun 2007 07:39:26 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 3/36] drivers edac make functions static
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <202185.62442.qm@web50108.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

This patch makes needlessly global code static, in the edac core

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Doug Thompson <norsk5@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/edac/edac_mc.c |   25 +++++++++++--------------
 drivers/edac/edac_mc.h |    8 --------

 2 files changed, 11 insertions(+), 22 deletions(-)
diff -puN drivers/edac/edac_mc.c~drivers-edac-make-code-static
drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-make-code-static
+++ a/drivers/edac/edac_mc.c
@@ -178,7 +178,7 @@ static struct sysfs_ops memctrlfs_ops = 
 };
 
 #define MEMCTRL_ATTR(_name,_mode,_show,_store)			\
-struct memctrl_dev_attribute attr_##_name = {			\
+static struct memctrl_dev_attribute attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.value  = &_name,					\
 	.show   = _show,					\
@@ -186,7 +186,7 @@ struct memctrl_dev_attribute attr_##_nam
 };
 
 #define MEMCTRL_STRING_ATTR(_name,_data,_mode,_show,_store)	\
-struct memctrl_dev_attribute attr_##_name = {			\
+static struct memctrl_dev_attribute attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.value  = _data,					\
 	.show   = _show,					\
@@ -343,7 +343,7 @@ static struct sysfs_ops edac_pci_sysfs_o
 };
 
 #define EDAC_PCI_ATTR(_name,_mode,_show,_store)			\
-struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
+static struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.value  = &_name,					\
 	.show   = _show,					\
@@ -351,7 +351,7 @@ struct edac_pci_dev_attribute edac_pci_a
 };
 
 #define EDAC_PCI_STRING_ATTR(_name,_data,_mode,_show,_store)	\
-struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
+static struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.value  = _data,					\
 	.show   = _show,					\
@@ -722,7 +722,7 @@ static struct sysfs_ops csrowfs_ops = {
 };
 
 #define CSROWDEV_ATTR(_name,_mode,_show,_store,_private)	\
-struct csrowdev_attribute attr_##_name = {			\
+static struct csrowdev_attribute attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show   = _show,					\
 	.store  = _store,					\
@@ -1066,7 +1066,7 @@ static struct sysfs_ops mci_ops = {
 };
 
 #define MCIDEV_ATTR(_name,_mode,_show,_store)			\
-struct mcidev_attribute mci_attr_##_name = {			\
+static struct mcidev_attribute mci_attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show   = _show,					\
 	.store  = _store,					\
@@ -1220,7 +1220,7 @@ static void edac_remove_sysfs_mci_device
 
 #ifdef CONFIG_EDAC_DEBUG
 
-void edac_mc_dump_channel(struct channel_info *chan)
+static void edac_mc_dump_channel(struct channel_info *chan)
 {
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
@@ -1228,9 +1228,8 @@ void edac_mc_dump_channel(struct channel
 	debugf4("\tchannel->label = '%s'\n", chan->label);
 	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
 }
-EXPORT_SYMBOL_GPL(edac_mc_dump_channel);
 
-void edac_mc_dump_csrow(struct csrow_info *csrow)
+static void edac_mc_dump_csrow(struct csrow_info *csrow)
 {
 	debugf4("\tcsrow = %p\n", csrow);
 	debugf4("\tcsrow->csrow_idx = %d\n", csrow->csrow_idx);
@@ -1244,9 +1243,8 @@ void edac_mc_dump_csrow(struct csrow_inf
 	debugf4("\tcsrow->channels = %p\n", csrow->channels);
 	debugf4("\tcsrow->mci = %p\n\n", csrow->mci);
 }
-EXPORT_SYMBOL_GPL(edac_mc_dump_csrow);
 
-void edac_mc_dump_mci(struct mem_ctl_info *mci)
+static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 {
 	debugf3("\tmci = %p\n", mci);
 	debugf3("\tmci->mtype_cap = %lx\n", mci->mtype_cap);
@@ -1260,7 +1258,6 @@ void edac_mc_dump_mci(struct mem_ctl_inf
 		mci->mod_name, mci->ctl_name);
 	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
 }
-EXPORT_SYMBOL_GPL(edac_mc_dump_mci);
 
 #endif  /* CONFIG_EDAC_DEBUG */
 
@@ -1576,7 +1573,8 @@ struct mem_ctl_info * edac_mc_del_mc(str
 }
 EXPORT_SYMBOL_GPL(edac_mc_del_mc);
 
-void edac_mc_scrub_block(unsigned long page, unsigned long offset, u32
size)
+static void edac_mc_scrub_block(unsigned long page, unsigned long
offset,
+				u32 size)
 {
 	struct page *pg;
 	void *virt_addr;
@@ -1605,7 +1603,6 @@ void edac_mc_scrub_block(unsigned long p
 	if (PageHighMem(pg))
 		local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(edac_mc_scrub_block);
 
 /* FIXME - should return -1 */
 int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long
page)
diff -puN drivers/edac/edac_mc.h~drivers-edac-make-code-static
drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~drivers-edac-make-code-static
+++ a/drivers/edac/edac_mc.h
@@ -424,19 +424,11 @@ static inline void pci_write_bits32(stru
 
 #endif /* CONFIG_PCI */
 
-#ifdef CONFIG_EDAC_DEBUG
-void edac_mc_dump_channel(struct channel_info *chan);
-void edac_mc_dump_mci(struct mem_ctl_info *mci);
-void edac_mc_dump_csrow(struct csrow_info *csrow);
-#endif  /* CONFIG_EDAC_DEBUG */
-
 extern struct mem_ctl_info * edac_mc_find(int idx);
 extern int edac_mc_add_mc(struct mem_ctl_info *mci,int mc_idx);
 extern struct mem_ctl_info * edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 					unsigned long page);
-extern void edac_mc_scrub_block(unsigned long page, unsigned long
offset,
-		u32 size);
 
 /*
  * The no info errors are used when error overflows are reported.

