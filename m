Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbYDNQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbYDNQie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761584AbYDNQiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:38:10 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:29633 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445AbYDNQiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Uv6t7puJ8NCRoqajzRv6kxFlgHJiqZEpIUC3Bu7utyev2HsnwNtgBVzxq2UKpeSzi9JOxPLePfQbMkM+q3x9Dyi+nMDrx36I8PnRXcnU73rCnOM9DAs2sTOK8117BpSJKRbIFM2SgFR4N3msLS+JqmmHd1sRf1lwVUUeVkVa7Ac=
Subject: [PATCH 02/10] hid-core:  Use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:37:54 -0700
Message-Id: <1208191074.5721.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/hid/hid-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f0b00ec..d76fec3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -606,7 +606,7 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
 		case 2:
 			if ((end - start) < 2)
 				return NULL;
-			item->data.u16 = le16_to_cpu(get_unaligned((__le16*)start));
+			item->data.u16 = get_unaligned_le16(start);
 			start = (__u8 *)((__le16 *)start + 1);
 			return start;
 
@@ -614,7 +614,7 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
 			item->size++;
 			if ((end - start) < 4)
 				return NULL;
-			item->data.u32 = le32_to_cpu(get_unaligned((__le32*)start));
+			item->data.u32 = get_unaligned_le32(start);
 			start = (__u8 *)((__le32 *)start + 1);
 			return start;
 	}
@@ -765,7 +765,7 @@ static __inline__ __u32 extract(__u8 *report, unsigned offset, unsigned n)
 
 	report += offset >> 3;  /* adjust byte index */
 	offset &= 7;            /* now only need bit offset into one byte */
-	x = le64_to_cpu(get_unaligned((__le64 *) report));
+	x = get_unaligned_le64(report);
 	x = (x >> offset) & ((1ULL << n) - 1);  /* extract bit field */
 	return (u32) x;
 }
-- 
1.5.5.144.g3e42


