Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0BPI75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:59:57 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:41629 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab0BPI7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:59:55 -0500
Date: Tue, 16 Feb 2010 09:59:50 +0100
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, Linux RDMA <linux-rdma@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>, of-ewg <ewg@openfabrics.org>
Subject: [PATCH] ib/ehca: fix in_wc handling in process_mad()
Message-ID: <20100216095950.15c6eb9d@alex-laptop>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the caller does not pass a valid in_wc to process_mad(),
return MAD failure as it is not possible to generate a valid
MAD redirect response.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---

Hi Roland,

this is another patch we would like to get in your next tree for
2.6.34.

 drivers/infiniband/hw/ehca/ehca_sqp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -222,7 +222,7 @@ int ehca_process_mad(struct ib_device *i
 {
 	int ret;
 
-	if (!port_num || port_num > ibdev->phys_port_cnt)
+	if (!port_num || port_num > ibdev->phys_port_cnt || !in_wc)
 		return IB_MAD_RESULT_FAILURE;
 
 	/* accept only pma request */
