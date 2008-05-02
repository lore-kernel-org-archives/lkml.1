Return-Path: <linux-kernel-owner+w=401wt.eu-S966021AbYEBTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966021AbYEBTKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965212AbYEBTFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:39016 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965197AbYEBTFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UuNRIeKsTswkgTJauH3crhAC2vATL1WgLbOY41megfrVVLnMj0u1/jQ73BaZeEbc6w072t+iIfeO9kxFg0dCp1TgP3cUJiwMUr9WdMtlWqaaa9Zf1LVkdAJbAoyilXXgEJDCSyhVz34FliBXwjhIxANhNKX33xzDA9Q3WwNx6T4=
Subject: [PATCH 08/14] irda: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:05:57 -0700
Message-Id: <1209755157.26173.74.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/irda/iriap.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/irda/iriap.c b/net/irda/iriap.c
index 9e15c82..4a105dc 100644
--- a/net/irda/iriap.c
+++ b/net/irda/iriap.c
@@ -451,12 +451,14 @@ static void iriap_getvaluebyclass_confirm(struct iriap_cb *self,
 	n = 2;
 
 	/* Get length, MSB first */
-	len = be16_to_cpu(get_unaligned((__be16 *)(fp+n))); n += 2;
+	len = get_unaligned_be16(fp + n);
+	n += 2;
 
 	IRDA_DEBUG(4, "%s(), len=%d\n", __func__, len);
 
 	/* Get object ID, MSB first */
-	obj_id = be16_to_cpu(get_unaligned((__be16 *)(fp+n))); n += 2;
+	obj_id = get_unaligned_be16(fp + n);
+	n += 2;
 
 	type = fp[n++];
 	IRDA_DEBUG(4, "%s(), Value type = %d\n", __func__, type);
@@ -506,7 +508,7 @@ static void iriap_getvaluebyclass_confirm(struct iriap_cb *self,
 		value = irias_new_string_value(fp+n);
 		break;
 	case IAS_OCT_SEQ:
-		value_len = be16_to_cpu(get_unaligned((__be16 *)(fp+n)));
+		value_len = get_unaligned_be16(fp + n);
 		n += 2;
 
 		/* Will truncate to IAS_MAX_OCTET_STRING bytes */
-- 
1.5.5.1.350.gbbbf


