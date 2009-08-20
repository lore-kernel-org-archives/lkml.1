Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZHTKTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZHTKTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZHTKTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:19:31 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60148 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbZHTKRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:53 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/6] crypto: use lazy workqueues
Date: Thu, 20 Aug 2009 12:17:40 +0200
Message-Id: <1250763466-24282-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1250763466-24282-5-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-5-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 crypto/crypto_wq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
index fdcf624..88cccee 100644
--- a/crypto/crypto_wq.c
+++ b/crypto/crypto_wq.c
@@ -20,7 +20,7 @@ EXPORT_SYMBOL_GPL(kcrypto_wq);
 
 static int __init crypto_wq_init(void)
 {
-	kcrypto_wq = create_workqueue("crypto");
+	kcrypto_wq = create_lazy_workqueue("crypto");
 	if (unlikely(!kcrypto_wq))
 		return -ENOMEM;
 	return 0;
-- 
1.6.4.173.g3f189

