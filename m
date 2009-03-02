Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbZCBBrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbZCBBrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 20:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757256AbZCBBrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 20:47:37 -0500
Received: from khc.piap.pl ([195.187.100.11]:33239 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093AbZCBBrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 20:47:36 -0500
To: Herbert Xu <herbert@gondor.apana.org.au>,
       Christian Hohnstaedt <chohnstaedt@innominate.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Build fix for ixp4xx_crypto in 2.6.29-rc*
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 02 Mar 2009 02:47:32 +0100
Message-ID: <m33adwpuff.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is another user of IXP4xx queue manager, fix it.

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -457,10 +457,12 @@ static int init_ixp_crypto(void)
 	if (!ctx_pool) {
 		goto err;
 	}
-	ret = qmgr_request_queue(SEND_QID, NPE_QLEN_TOTAL, 0, 0);
+	ret = qmgr_request_queue(SEND_QID, NPE_QLEN_TOTAL, 0, 0,
+				 "ixp_crypto:out", NULL);
 	if (ret)
 		goto err;
-	ret = qmgr_request_queue(RECV_QID, NPE_QLEN, 0, 0);
+	ret = qmgr_request_queue(RECV_QID, NPE_QLEN, 0, 0,
+				 "ixp_crypto:in", NULL);
 	if (ret) {
 		qmgr_release_queue(SEND_QID);
 		goto err;
