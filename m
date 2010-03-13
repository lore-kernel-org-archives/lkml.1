Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0CMCwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:52:00 -0500
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:40371 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752079Ab0CMCv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:51:58 -0500
X-Yahoo-Newman-Id: 804892.2237.bm@omp419.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
  b=UWSntfliTcRlQq3kM59WqHIcMuv9jjSgRz7QzTcPbSW+S52b7raw3JdiNATb6yntxGJtnmo51vhvxz1Pvt3P+V4IQLBrkOyPWwLwn2VjQhYhbS5dKHb6pTAB71GGzbbKvDrnE5+dng6Qkg0yvA/vACuOnQZDpyQ4hgCHTpYoAVI=  ;
X-Yahoo-SMTP: LYwhiGuswBC9DGnmQEHq6t4kOq0-
X-YMail-OSG: QbJ8zcMVM1mO88rX_iz2yzlq3I6CVOEVnoOJV2nHBa4GTL3B4Cr8gl7dNaeaCbCLm81sV_6JBTctC7b9eUJQ5I7nsoyZnqlz9VcgxaV.Pa_P3Zh7d.cw9NoBVhTXvmLGdUWajKVBv6BcQbEtTocTu5PtJdAgETo60fdoohkGUR6beDxupGA4EEnZ1e_wUPpfFsz9A3yCvvYY9QyMK_1uiK0RQDGFPKDZ0K8ImElQT1UXXh0wHHtWp6yTDHI05PPIZUJDxx4LarWsQqt4VrMswCJ6kP6Y02.w2Q--
X-Yahoo-Newman-Property: ymail-3
From: jsd_syd@yahoo.com.au
To: gregkh@suse.de, wfp5p@virginia.edu, hohndel@infradead.org, jkosina@suse.cz
Cc: jsd_syd@yahoo.com.au, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Jacob David <jacobselvin@gmail.com>
Subject: [PATCH] Staging: comedi: fixes the checkpatch error in skel.c This is a patch to the skel.c file that fixes the 80 line exceeding warning and the printk warning found by chekpatch.pl tool Signed-off-by: Jacob S David <jacobselvin@gmail.com>
Date: Sat, 13 Mar 2010 13:51:34 +1100
Message-Id: <1268448694-5588-1-git-send-email-jsd_syd@yahoo.com.au>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob David <jacobselvin@gmail.com>

---
 drivers/staging/comedi/drivers/skel.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index aba57d9..58658b0 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -130,8 +130,10 @@ MODULE_DEVICE_TABLE(pci, skel_pci_table);
 #define thisboard ((const struct skel_board *)dev->board_ptr)
 
 /* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device
+ * struct.
+ */
 struct skel_private {
 
 	int data;
@@ -211,7 +213,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: skel: ", dev->minor);
+	printk(KERN_INFO "comedi%d: skel: ", dev->minor);
 
 /*
  * If you can probe the device to determine what device in a series
@@ -297,7 +299,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  */
 static int skel_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: skel: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: skel: remove\n", dev->minor);
 
 	return 0;
 }
@@ -336,7 +338,7 @@ static int skel_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		if (i == TIMEOUT) {
 			/* printk() should be used instead of printk()
 			 * whenever the code can be called from real-time. */
-			printk("timeout\n");
+			printk(KERN_INFO "timeout\n");
 			return -ETIMEDOUT;
 		}
 
@@ -397,7 +399,9 @@ static int skel_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique and mutually
+	 * compatible
+	 */
 
 	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
@@ -529,7 +533,7 @@ static int skel_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
-	printk("skel_ao_winsn\n");
+	printk(KERN_INFO "skel_ao_winsn\n");
 	/* Writing a list of values to an AO channel is probably not
 	 * very useful, but that's how the interface is defined. */
 	for (i = 0; i < insn->n; i++) {
@@ -623,6 +627,9 @@ static int skel_dio_insn_config(struct comedi_device *dev,
  * as necessary.
  */
 COMEDI_INITCLEANUP(driver_skel);
-/* If you are writing a PCI driver you should use COMEDI_PCI_INITCLEANUP instead.
-*/
+/* If you are writing a PCI driver you should use COMEDI_PCI_INITCLEANUP
+ * instead.
+ */
+
 /* COMEDI_PCI_INITCLEANUP(driver_skel, skel_pci_table) */
+
-- 
1.6.3.3


