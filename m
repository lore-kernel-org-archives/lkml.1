Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbXEPMjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbXEPMjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762694AbXEPMjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:39:46 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:4547 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762597AbXEPMjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:39:45 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 2.6.22] ehca: return proper error code if register_mr fails
Date: Wed, 16 May 2007 14:50:55 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161450.55848.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the return code of ehca_register_mr() to ENOMEM
if corresponding firmware call fails due to out of resources.
Some of error codes were mapped to EINVAL. They are now mapped
to default case, which already returns EINVAL anyway.


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_mrmw.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 84c5bb4..add79bd 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -2050,13 +2050,10 @@ int ehca_mrmw_map_hrc_alloc(const u64 hi
 	switch (hipz_rc) {
 	case H_SUCCESS:	             /* successful completion */
 		return 0;
-	case H_ADAPTER_PARM:         /* invalid adapter handle */
-	case H_RT_PARM:              /* invalid resource type */
 	case H_NOT_ENOUGH_RESOURCES: /* insufficient resources */
-	case H_MLENGTH_PARM:         /* invalid memory length */
-	case H_MEM_ACCESS_PARM:      /* invalid access controls */
 	case H_CONSTRAINED:          /* resource constraint */
-		return -EINVAL;
+	case H_NO_MEM:
+		return -ENOMEM;
 	case H_BUSY:                 /* long busy */
 		return -EBUSY;
 	default:

