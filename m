Return-Path: <linux-kernel-owner+w=401wt.eu-S1765988AbYEBDzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765988AbYEBDzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbYEBDw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:52:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48822 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885AbYEBDwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FacASK2RBsIMmxrMQwHKS1Quh4vZZkcWx/FY+qvzx/NGui4ifUfXEMGGEiFPCftqs392Qog7E23ssL2jH7kUAGreo0VhSpYcCCxke/UAfdYuzTsz+PC6F38XMxVnL5K1Kx/exxr0/1X8IZRSX4/VcQxbHg3PiVgaVXg/Kqg+i/g=
Subject: [PATCH 8/8] irda: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 20:52:58 -0700
Message-Id: <1209700378.22362.25.camel@brick>
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

