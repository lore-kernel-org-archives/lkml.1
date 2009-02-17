Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZBQToX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZBQToX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZBQTnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:43:51 -0500
Received: from cmpxchg.org ([85.214.51.133]:38462 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbZBQTnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:43:50 -0500
Message-Id: <20090217184135.913080050@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Tue, 17 Feb 2009 19:26:18 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 3/7] s390: use kzfree()
References: <20090217182615.897042724@cmpxchg.org>
Content-Disposition: inline; filename=s390-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/crypto/prng.c             |    3 +--
 drivers/s390/crypto/zcrypt_pcixcc.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -201,8 +201,7 @@ out_free:
 static void __exit prng_exit(void)
 {
 	/* wipe me */
-	memset(p->buf, 0, prng_chunk_size);
-	kfree(p->buf);
+	kzfree(p->buf);
 	kfree(p);
 
 	misc_deregister(&prng_dev);
--- a/drivers/s390/crypto/zcrypt_pcixcc.c
+++ b/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -781,8 +781,7 @@ static long zcrypt_pcixcc_send_cprb(stru
 		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
 out_free:
-	memset(ap_msg.message, 0x0, ap_msg.length);
-	kfree(ap_msg.message);
+	kzfree(ap_msg.message);
 	return rc;
 }
 


