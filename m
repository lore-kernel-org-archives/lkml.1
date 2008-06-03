Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbYFCSTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbYFCSTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYFCST0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:19:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:47829 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbYFCSTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y1Hiyw44NJEp5WDa0ykUtqT3fU/sUXMlTnHcCfA9XVUimtdp1iG8/ogY7LdMPnirxe6bWg+g5dcB8qRVqLhWQ6sG3DO3X16m+5AG0naVgkIe6EeinfFtFazo2KcVSXzBuzX/axtTrcvtk8ZBd6QdcwA2UpI6zKTJFJcyjj4V8bY=
Subject: [PATCH 1/2] lib: export bitrev16
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 11:19:20 -0700
Message-Id: <1212517160.11008.59.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bluetooth will be able to use this.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/bitrev.h |    1 +
 lib/bitrev.c           |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/bitrev.h b/include/linux/bitrev.h
index 05e540d..7ffe03f 100644
--- a/include/linux/bitrev.h
+++ b/include/linux/bitrev.h
@@ -10,6 +10,7 @@ static inline u8 bitrev8(u8 byte)
 	return byte_rev_table[byte];
 }
 
+extern u16 bitrev16(u16 in);
 extern u32 bitrev32(u32 in);
 
 #endif /* _LINUX_BITREV_H */
diff --git a/lib/bitrev.c b/lib/bitrev.c
index 989aff7..3956203 100644
--- a/lib/bitrev.c
+++ b/lib/bitrev.c
@@ -42,10 +42,11 @@ const u8 byte_rev_table[256] = {
 };
 EXPORT_SYMBOL_GPL(byte_rev_table);
 
-static __always_inline u16 bitrev16(u16 x)
+u16 bitrev16(u16 x)
 {
 	return (bitrev8(x & 0xff) << 8) | bitrev8(x >> 8);
 }
+EXPORT_SYMBOL(bitrev16);
 
 /**
  * bitrev32 - reverse the order of bits in a u32 value
-- 
1.5.6.rc0.336.ge5422


