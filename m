Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZIZIRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZIZIRI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 04:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZIZIRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 04:17:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:42425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZIZIRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 04:17:07 -0400
Subject: [PATCH] infiniband: fops_get is not required for core,
 uverbs_main.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Sep 2009 13:46:01 +0530
Message-Id: <1253952962.3897.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fops_get is useless as 'uverbs_event_fops' will always be 'true'.
This also fix compilation warning :

  CC [M]  drivers/infiniband/core/uverbs_main.o
drivers/infiniband/core/uverbs_main.c: In function ‘ib_uverbs_alloc_event_file’:
drivers/infiniband/core/uverbs_main.c:522: warning: the address of ‘uverbs_event_fops’ will always evaluate as ‘true’

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
---
 drivers/infiniband/core/uverbs_main.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index d3fff9e..a59ddd1 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -513,13 +513,8 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 		goto err;
 	}
 
-	/*
-	 * fops_get() can't fail here, because we're coming from a
-	 * system call on a uverbs file, which will already have a
-	 * module reference.
-	 */
 	filp = alloc_file(uverbs_event_mnt, dget(uverbs_event_mnt->mnt_root),
-			  FMODE_READ, fops_get(&uverbs_event_fops));
+			  FMODE_READ, &uverbs_event_fops);
 	if (!filp) {
 		ret = -ENFILE;
 		goto err_fd;
-- 
1.6.0.6


