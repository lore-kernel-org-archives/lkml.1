Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0BJUDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 15:03:12 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:43856 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab0BJUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 15:03:07 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMSfckurR7Hu/2dsb2JhbACaZXSnHZdnhFUE
X-IronPort-AV: E=Sophos;i="4.49,446,1262563200"; 
   d="scan'208";a="481222217"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 10 Feb 2010 12:03:02 -0800
Message-ID: <adak4ukhn9l.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get one partial revert needed to fix a regression due to a
behavior change introduced in 2.6.33-rc1 that breaks some existing apps:

Sean Hefty (1):
      RDMA/cm: Revert association of an RDMA device when binding to loopback

 drivers/infiniband/core/cma.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)


diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cc9b594..875e34e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2115,9 +2115,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (ret)
 		goto err1;
 
-	if (cma_loopback_addr(addr)) {
-		ret = cma_bind_loopback(id_priv);
-	} else if (!cma_zero_addr(addr)) {
+	if (!cma_any_addr(addr)) {
 		ret = rdma_translate_ip(addr, &id->route.addr.dev_addr);
 		if (ret)
 			goto err1;

-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
