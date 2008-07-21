Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYGULRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYGULRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbYGULQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:16:41 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:52534 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYGULQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:16:40 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 2/2] IB/ehca: Default value for Local CA ACK Delay
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
References: <200807211313.23648.fenkes@de.ibm.com>
In-Reply-To: <200807211313.23648.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3080
Date: Mon, 21 Jul 2008 13:16:36 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807211316.37224.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some firmware versions report a Local CA ACK Delay of 0. In that case,
return a more sensible default value of 12 (-> 16 msec) instead.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_hca.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index bc3b37d..4628822 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -114,7 +114,9 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	}
 
 	props->max_pkeys           = 16;
-	props->local_ca_ack_delay  = min_t(u8, rblock->local_ca_ack_delay, 255);
+	/* Some FW versions say 0 here; insert sensible value in that case */
+	props->local_ca_ack_delay  = rblock->local_ca_ack_delay ?
+		min_t(u8, rblock->local_ca_ack_delay, 255) : 12;
 	props->max_raw_ipv6_qp     = limit_uint(rblock->max_raw_ipv6_qp);
 	props->max_raw_ethy_qp     = limit_uint(rblock->max_raw_ethy_qp);
 	props->max_mcast_grp       = limit_uint(rblock->max_mcast_grp);
-- 
1.5.5


