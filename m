Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYJWBrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYJWBrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYJWBrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:47:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:46471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbYJWBrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:47:04 -0400
Message-ID: <48FFD726.2010600@kernel.org>
Date: Wed, 22 Oct 2008 18:45:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH] pci: show dma_mask bits in /sys
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org> <20081009213551.GC25780@parisc-linux.org> <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com> <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org> <20081012071157.GA20056@colo.lackof.org>
In-Reply-To: <20081012071157.GA20056@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant prefer to add it /sys instead of showing in bootlog

so could catch if the driver set the correct dma_mask.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci-sysfs.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -169,6 +169,21 @@ numa_node_show(struct device *dev, struc
 #endif
 
 static ssize_t
+dma_mask_bits_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sprintf (buf, "%d\n", fls64(pdev->dma_mask));
+}
+
+static ssize_t
+consistent_dma_mask_bits_show(struct device *dev, struct device_attribute *attr,
+				 char *buf)
+{
+	return sprintf (buf, "%d\n", fls64(dev->coherent_dma_mask));
+}
+
+static ssize_t
 msi_bus_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -223,6 +238,8 @@ struct device_attribute pci_dev_attrs[]
 #ifdef CONFIG_NUMA
 	__ATTR_RO(numa_node),
 #endif
+	__ATTR_RO(dma_mask_bits),
+	__ATTR_RO(consistent_dma_mask_bits),
 	__ATTR(enable, 0600, is_enabled_show, is_enabled_store),
 	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
 		broken_parity_status_show,broken_parity_status_store),

