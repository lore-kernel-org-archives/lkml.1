Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306Ab0AaL6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0AaL6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 06:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132Ab0AaL55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 06:57:57 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:64335 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0AaL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 06:57:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eSkOQvFSYBJgw+kAwzrSdVd3j9ajkch7k4sHg7CX8YuGyhSAEbYBH7kWFfn2r+VwYO
         OBo0F2Rp+8W3CfoJ3tSaabzP4D7+6qSX36u2W5wIdvnlpGhc5KK4PHQvtKqJZhagOVCQ
         0YSnCgpJoUHawzOs1W3N39DqGWK+KltJh6Cas=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 5/7] infiniband: Use for_each_bit
Date: Sun, 31 Jan 2010 20:53:28 +0900
Message-Id: <1264938810-4173-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/core/mad.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 7522008..a0b00ba 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1193,10 +1193,7 @@ static int method_in_use(struct ib_mad_mgmt_method_table **method,
 {
 	int i;
 
-	for (i = find_first_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS) {
 		if ((*method)->agent[i]) {
 			printk(KERN_ERR PFX "Method %d already in use\n", i);
 			return -EINVAL;
@@ -1330,13 +1327,9 @@ static int add_nonoui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 		goto error3;
 
 	/* Finally, add in methods being registered */
-	for (i = find_first_bit(mad_reg_req->method_mask,
-				IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS)
 		(*method)->agent[i] = agent_priv;
-	}
+
 	return 0;
 
 error3:
@@ -1429,13 +1422,9 @@ check_in_use:
 		goto error4;
 
 	/* Finally, add in methods being registered */
-	for (i = find_first_bit(mad_reg_req->method_mask,
-				IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS)
 		(*method)->agent[i] = agent_priv;
-	}
+
 	return 0;
 
 error4:
-- 
1.6.0.6

