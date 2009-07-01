Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZGAVVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZGAVVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZGAVVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:21:11 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:49491 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZGAVVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:21:07 -0400
From: Tilman Schmidt <tilman@imap.cc>
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
CC: Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090701-patch-02.tilman@imap.cc>
In-Reply-To: <20090701-patch-00.tilman@imap.cc>
References: <20090701-patch-00.tilman@imap.cc>
Subject: [PATCH 2/2] gigaset: drop pointless check
Date: Wed,  1 Jul 2009 23:20:57 +0200 (CEST)
X-Spam-Score: 0.1 () AWL,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop a sanity check which doesn't serve any useful purpose anymore.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/isocdata.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/gigaset/isocdata.c b/drivers/isdn/gigaset/isocdata.c
index db3a1e4..bed38fc 100644
--- a/drivers/isdn/gigaset/isocdata.c
+++ b/drivers/isdn/gigaset/isocdata.c
@@ -174,12 +174,6 @@ int gigaset_isowbuf_getbytes(struct isowbuf_t *iwb, int size)
 		pr_err("invalid size %d\n", size);
 		return -EINVAL;
 	}
-	src = iwb->read;
-	if (unlikely(limit >= BAS_OUTBUFSIZE + BAS_OUTBUFPAD ||
-		     (read < src && limit >= src))) {
-		pr_err("isoc write buffer frame reservation violated\n");
-		return -EFAULT;
-	}
 #endif
 
 	if (read < write) {
-- 
1.6.2.1.214.ge986c

