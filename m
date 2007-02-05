Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbXBEQ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbXBEQ6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXBEQ6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:58:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:25012 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbXBEQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:58:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=g+wsk8BRBU57aereW25SKDK96hP59PFfV9fpkoyZzJS2zoqnEqy4W5gc9XIqf5q30mU27Z4ssrX5VgiGttlYqKz9e+gM2G9aBI1VSsqIGyS+SM3jJjB+gig+4VlJGRmsyFXIalBTRQAOxDN2iXPGSv58VKQKmiq0V5GmOZfCISA=
Date: Mon, 5 Feb 2007 18:58:29 +0200
To: linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2.6.20] misc-wireless: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205165829.GI3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165429.GD3896@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A patch to use ARRAY_SIZE macro already defined in kernel.h for some
miscellaneous wireless drivers with no specific maintaners.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch is compile tested.

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 44a2270..4ad910b 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1623,7 +1623,7 @@ static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
 
 	crypto_cipher_setkey(tfm, pkey, 16);
 	counter = 0;
-	for (i = 0; i < (sizeof(context->coeff)/sizeof(context->coeff[0])); ) {
+	for (i = 0; i < ARRAY_SIZE(context->coeff); ) {
 		aes_counter[15] = (u8)(counter >> 0);
 		aes_counter[14] = (u8)(counter >> 8);
 		aes_counter[13] = (u8)(counter >> 16);
@@ -1632,7 +1632,7 @@ static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
 		memcpy (plain, aes_counter, 16);
 		crypto_cipher_encrypt_one(tfm, plain, plain);
 		cipher = plain;
-		for (j=0; (j<16) && (i< (sizeof(context->coeff)/sizeof(context->coeff[0]))); ) {
+		for (j = 0; (j < 16) && (i < ARRAY_SIZE(context->coeff)); ) {
 			context->coeff[i++] = ntohl(*(u32 *)&cipher[j]);
 			j += 4;
 		}
diff --git a/drivers/net/wireless/prism54/oid_mgt.c b/drivers/net/wireless/prism54/oid_mgt.c
index e6cf9df..4278032 100644
--- a/drivers/net/wireless/prism54/oid_mgt.c
+++ b/drivers/net/wireless/prism54/oid_mgt.c
@@ -16,6 +16,8 @@
  *
  */
 
+#include <linux/kernel.h>
+
 #include "prismcompat.h"
 #include "islpci_dev.h"
 #include "islpci_mgt.h"
@@ -692,7 +694,7 @@ mgt_update_addr(islpci_private *priv)
 	return ret;
 }
 
-#define VEC_SIZE(a) (sizeof(a)/sizeof(a[0]))
+#define VEC_SIZE(a) ARRAY_SIZE(a)
 
 int
 mgt_commit(islpci_private *priv)



-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
