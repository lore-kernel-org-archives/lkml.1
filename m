Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbXIKNdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbXIKNdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965131AbXIKNdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:33:40 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:47542 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965129AbXIKNdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:33:38 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 07/12] IB/ehca: ehca_gen_warn() should always print
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com>
In-Reply-To: <200709111518.26276.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3006
Date: Tue, 11 Sep 2007 15:32:50 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709111532.51179.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_tools.h |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index 57c77a7..f9b264b 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -98,15 +98,12 @@ extern int ehca_debug_level;
 	} while (0)
 
 #define ehca_gen_warn(format, arg...) \
-	do { \
-		if (unlikely(ehca_debug_level)) \
-			printk(KERN_INFO "PU%04x EHCA_WARN:%s " format "\n", \
-			       get_paca()->paca_index, __FUNCTION__, ## arg); \
-	} while (0)
+	printk(KERN_INFO "PU%04x EHCA_WARN:%s " format "\n", \
+	       get_paca()->paca_index, __FUNCTION__, ## arg)
 
 #define ehca_gen_err(format, arg...) \
 	printk(KERN_ERR "PU%04x EHCA_ERR:%s " format "\n", \
-		get_paca()->paca_index, __FUNCTION__, ## arg)
+	       get_paca()->paca_index, __FUNCTION__, ## arg)
 
 /**
  * ehca_dmp - printk a memory block, whose length is n*8 bytes.
-- 
1.5.2


