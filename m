Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbZBSGyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbZBSGyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 01:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZBSGyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 01:54:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53054 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbZBSGyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 01:54:12 -0500
Message-ID: <499D0269.8080900@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 14:55:37 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCH 12/12]Update related documentations
References: <499CFDC8.1070600@cn.fujitsu.com>
In-Reply-To: <499CFDC8.1070600@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update related documentations

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>

---
 Documentation/DMA-mapping.txt                      |   18 +++++++++---------
 .../sound/alsa/DocBook/writing-an-alsa-driver.tmpl |    8 ++++----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/DMA-mapping.txt b/Documentation/DMA-mapping.txt
index b2a4d6d..01f24e9 100644
--- a/Documentation/DMA-mapping.txt
+++ b/Documentation/DMA-mapping.txt
@@ -136,7 +136,7 @@ exactly why.
 The standard 32-bit addressing PCI device would do something like
 this:
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING
 		       "mydev: No suitable DMA available.\n");
 		goto ignore_this_device;
@@ -155,9 +155,9 @@ all 64-bits when accessing streaming DMA:
 
 	int using_dac;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
-	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		using_dac = 0;
 	} else {
 		printk(KERN_WARNING
@@ -170,14 +170,14 @@ the case would look like this:
 
 	int using_dac, consistent_using_dac;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 	   	consistent_using_dac = 1;
-		pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
-	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		using_dac = 0;
 		consistent_using_dac = 0;
-		pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	} else {
 		printk(KERN_WARNING
 		       "mydev: No suitable DMA available.\n");
@@ -192,7 +192,7 @@ check the return value from pci_set_consistent_dma_mask().
 Finally, if your device can only drive the low 24-bits of
 address during PCI bus mastering you might do something like:
 
-	if (pci_set_dma_mask(pdev, DMA_24BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(24))) {
 		printk(KERN_WARNING
 		       "mydev: 24-bit DMA addressing not available.\n");
 		goto ignore_this_device;
@@ -213,7 +213,7 @@ most specific mask.
 
 Here is pseudo-code showing how this might be done:
 
-	#define PLAYBACK_ADDRESS_BITS	DMA_32BIT_MASK
+	#define PLAYBACK_ADDRESS_BITS	DMA_BIT_MASK(32)
 	#define RECORD_ADDRESS_BITS	0x00ffffff
 
 	struct my_sound_card *card;
diff --git a/Documentation/sound/alsa/DocBook/writing-an-alsa-driver.tmpl b/Documentation/sound/alsa/DocBook/writing-an-alsa-driver.tmpl
index 87a7c07..282891c 100644
--- a/Documentation/sound/alsa/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/sound/alsa/DocBook/writing-an-alsa-driver.tmpl
@@ -1133,8 +1133,8 @@
           if (err < 0)
                   return err;
           /* check PCI availability (28bit DMA) */
-          if (pci_set_dma_mask(pci, DMA_28BIT_MASK) < 0 ||
-              pci_set_consistent_dma_mask(pci, DMA_28BIT_MASK) < 0) {
+          if (pci_set_dma_mask(pci, DMA_BIT_MASK(28)) < 0 ||
+              pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(28)) < 0) {
                   printk(KERN_ERR "error to set 28bit mask DMA\n");
                   pci_disable_device(pci);
                   return -ENXIO;
@@ -1248,8 +1248,8 @@
   err = pci_enable_device(pci);
   if (err < 0)
           return err;
-  if (pci_set_dma_mask(pci, DMA_28BIT_MASK) < 0 ||
-      pci_set_consistent_dma_mask(pci, DMA_28BIT_MASK) < 0) {
+  if (pci_set_dma_mask(pci, DMA_BIT_MASK(28)) < 0 ||
+      pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(28)) < 0) {
           printk(KERN_ERR "error to set 28bit mask DMA\n");
           pci_disable_device(pci);
           return -ENXIO;
-- 
1.6.0.3


-- 
Regards
Yang Hongyang
