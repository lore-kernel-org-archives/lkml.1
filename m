Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYKYM6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYKYM6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 07:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYKYM6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 07:58:10 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:47407 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYKYM6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 07:58:09 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Change misleading error message
User-Agent: KMail/1.9.1
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
References: <200806061835.43802.fenkes@de.ibm.com> <48499C11.7030504@gmail.com>
In-Reply-To: <48499C11.7030504@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2361
Date: Tue, 25 Nov 2008 13:58:06 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811251358.06729.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error message printed when the eHCA driver prevents memory hotplug is
misleading -- the user might think that hot-removing the lhca, hotplugging
memory, then hot-adding the lhca again will work, but it doesn't.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index bb02a86..bec7e02 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -994,8 +994,7 @@ static int ehca_mem_notifier(struct notifier_block *nb,
 			if (printk_timed_ratelimit(&ehca_dmem_warn_time,
 						   30 * 1000))
 				ehca_gen_err("DMEM operations are not allowed"
-					     "as long as an ehca adapter is"
-					     "attached to the LPAR");
+					     "in conjunction with eHCA");
 			return NOTIFY_BAD;
 		}
 	}
-- 
1.5.5


