Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXBNQp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXBNQp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbXBNQpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:45:55 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:24540 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbXBNQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:45:12 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: rolandd@cisco.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, hch@infradead.org
Subject: [PATCH 2.6.21-rc1 5/5] ehca: query_port() returns LINK_UP instead UNKNOWN
Date: Wed, 14 Feb 2007 17:41:44 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, h.carstens@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141741.45135.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this patch sets port phys state as a result of ehca_query_port() to LINK_UP.
On pSeries ehca actually represents a logical HCA, whose phys/link state always
is LINK_UP. 
Thanks
Nam


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_hca.c |    3 +++
 1 files changed, 3 insertions(+)


diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_hca.c infiniband_work/drivers/infiniband/hw/ehca/ehca_hca.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_hca.c       2007-02-14 13:11:45.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_hca.c       2007-02-14 12:53:52.000000000 +0100
@@ -162,6 +162,9 @@ int ehca_query_port(struct ib_device *ib
        props->active_width    = IB_WIDTH_12X;
        props->active_speed    = 0x1;

+       /* at the moment (logical) link state is always LINK_UP */
+       props->phys_state      = 0x5;
+
 query_port1:
        ehca_free_fw_ctrlblock(rblock);

