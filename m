Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYI0CJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYI0CJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYI0CJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:09:50 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48488 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYI0CJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=bugg6w2FIn7JkxSgw+i/US0yD/2T62GiMZHtU3ha0jR7jdp5yLheW2AEvSn4xE1+nk
         tvB1C6CWauABDbbywoFRrRl/+5HHpHKdk9mclHl06Z/4FKwpXK87nnRJ0e2zT4usROdU
         bFnXpJCLTtuzTytb31AWG3nHYHc4uV9H1o0p4=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Cc: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] bio.h: Remove unused conditional code
Date: Fri, 26 Sep 2008 23:09:28 -0300
Message-Id: <1222481368-15221-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.0.87.g2858d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole bio_integrity() definition is inside an #ifdef
CONFIG_BLK_DEV_INTEGRITY, there's no need for the conditional code.

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 include/linux/bio.h |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0933a14..57f9532 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -458,14 +458,7 @@ static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
 #define bip_for_each_vec(bvl, bip, i)					\
 	__bip_for_each_vec(bvl, bip, i, (bip)->bip_idx)
 
-static inline int bio_integrity(struct bio *bio)
-{
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	return bio->bi_integrity != NULL;
-#else
-	return 0;
-#endif
-}
+#define bio_integrity(bio) (bio->bi_integrity != NULL)
 
 extern struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
-- 
1.6.0.87.g2858d

