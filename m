Return-Path: <linux-kernel-owner+w=401wt.eu-S969845AbXILOoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969845AbXILOoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbXILOoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:44:25 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:63564 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbXILOoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:44:24 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 08/12] IB/ehca: Replace get_paca()->paca_index by the more portable raw_smp_processor_id()
Date: Wed, 12 Sep 2007 16:44:11 +0200
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com> <200709111533.14333.fenkes@de.ibm.com>
In-Reply-To: <200709111533.14333.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121644.12717.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We can use raw_smp_processor_id() here because the processor ID is only used
for debug output and may therefore be preemption-unsafe.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

This is the same patch, but with smp_processor_id() replaced by
raw_smp_processor_id(), as kindly pointed out to me by Nathan. Thanks!

 drivers/infiniband/hw/ehca/ehca_tools.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index f9b264b..4a8346a 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -73,37 +73,37 @@ extern int ehca_debug_level;
 		if (unlikely(ehca_debug_level)) \
 			dev_printk(KERN_DEBUG, (ib_dev)->dma_device, \
 				   "PU%04x EHCA_DBG:%s " format "\n", \
-				   get_paca()->paca_index, __FUNCTION__, \
+				   raw_smp_processor_id(), __FUNCTION__, \
 				   ## arg); \
 	} while (0)
 
 #define ehca_info(ib_dev, format, arg...) \
 	dev_info((ib_dev)->dma_device, "PU%04x EHCA_INFO:%s " format "\n", \
-		 get_paca()->paca_index, __FUNCTION__, ## arg)
+		 raw_smp_processor_id(), __FUNCTION__, ## arg)
 
 #define ehca_warn(ib_dev, format, arg...) \
 	dev_warn((ib_dev)->dma_device, "PU%04x EHCA_WARN:%s " format "\n", \
-		 get_paca()->paca_index, __FUNCTION__, ## arg)
+		 raw_smp_processor_id(), __FUNCTION__, ## arg)
 
 #define ehca_err(ib_dev, format, arg...) \
 	dev_err((ib_dev)->dma_device, "PU%04x EHCA_ERR:%s " format "\n", \
-		get_paca()->paca_index, __FUNCTION__, ## arg)
+		raw_smp_processor_id(), __FUNCTION__, ## arg)
 
 /* use this one only if no ib_dev available */
 #define ehca_gen_dbg(format, arg...) \
 	do { \
 		if (unlikely(ehca_debug_level)) \
 			printk(KERN_DEBUG "PU%04x EHCA_DBG:%s " format "\n", \
-			       get_paca()->paca_index, __FUNCTION__, ## arg); \
+			       raw_smp_processor_id(), __FUNCTION__, ## arg); \
 	} while (0)
 
 #define ehca_gen_warn(format, arg...) \
 	printk(KERN_INFO "PU%04x EHCA_WARN:%s " format "\n", \
-	       get_paca()->paca_index, __FUNCTION__, ## arg)
+	       raw_smp_processor_id(), __FUNCTION__, ## arg)
 
 #define ehca_gen_err(format, arg...) \
 	printk(KERN_ERR "PU%04x EHCA_ERR:%s " format "\n", \
-	       get_paca()->paca_index, __FUNCTION__, ## arg)
+	       raw_smp_processor_id(), __FUNCTION__, ## arg)
 
 /**
  * ehca_dmp - printk a memory block, whose length is n*8 bytes.
-- 
1.5.2





