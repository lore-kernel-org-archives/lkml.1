Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbYFDRdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbYFDRdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbYFDRc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:32:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:28627 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbYFDRc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Dk4ZqSUEdiTVtaa3hj8eBxeDRq+Zmcq2mFIbANPamZjdJ3Cuc29nv7w3Ceg/JbYLpm
         qGKW9CgyzJoVhwPpBjhgK7IdEz07eh8sR7hLOdfxSx5W7NTF+NOfbsQqp0zshcr497Mg
         N4CzyEiqZDOScmV+rN+9LdUf+S4DMhGSR+JvY=
Subject: [PATCHv2 1/2] lib: expose bitrev16 as an inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "akinobu.mita" <akinobu.mita@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 10:32:55 -0700
Message-Id: <1212600775.6340.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bluetooth will be able to use this.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Marcel, I have changed the patch somewhat so haven't added your ack to it
or to patch 2/2

 include/linux/bitrev.h |    5 +++++
 lib/bitrev.c           |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/bitrev.h b/include/linux/bitrev.h
index 05e540d..5c21f62 100644
--- a/include/linux/bitrev.h
+++ b/include/linux/bitrev.h
@@ -10,6 +10,11 @@ static inline u8 bitrev8(u8 byte)
 	return byte_rev_table[byte];
 }
 
+static inline u16 bitrev16(u16 x)
+{
+	return (bitrev8(x & 0xff) << 8) | bitrev8(x >> 8);
+}
+
 extern u32 bitrev32(u32 in);
 
 #endif /* _LINUX_BITREV_H */
diff --git a/lib/bitrev.c b/lib/bitrev.c
index 989aff7..88bdbee 100644
--- a/lib/bitrev.c
+++ b/lib/bitrev.c
@@ -42,11 +42,6 @@ const u8 byte_rev_table[256] = {
 };
 EXPORT_SYMBOL_GPL(byte_rev_table);
 
-static __always_inline u16 bitrev16(u16 x)
-{
-	return (bitrev8(x & 0xff) << 8) | bitrev8(x >> 8);
-}
-
 /**
  * bitrev32 - reverse the order of bits in a u32 value
  * @x: value to be bit-reversed
-- 
1.5.6.rc1.257.gba91d


