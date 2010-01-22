Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612Ab0AVQAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0AVQAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577Ab0AVP7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:59:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab0AVP7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:44 -0500
Message-Id: <20100122155535.797688466@chello.nl>
References: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:51 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/10] bitops: Provide compile time HWEIGHT{8,16,32,64}
Content-Disposition: inline; filename=generic-HWEIGHT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide compile time versions of hweight.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/bitops.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/include/linux/bitops.h
===================================================================
--- linux-2.6.orig/include/linux/bitops.h
+++ linux-2.6/include/linux/bitops.h
@@ -45,6 +45,20 @@ static inline unsigned long hweight_long
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
+#define HWEIGHT8(w) 			\
+      (	(!!((w) & (1ULL << 0))) +	\
+	(!!((w) & (1ULL << 1))) +	\
+	(!!((w) & (1ULL << 2))) +	\
+	(!!((w) & (1ULL << 3))) +	\
+	(!!((w) & (1ULL << 4))) +	\
+	(!!((w) & (1ULL << 5))) +	\
+	(!!((w) & (1ULL << 6))) +	\
+	(!!((w) & (1ULL << 7)))	)
+
+#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8(w >> 8))
+#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16(w >> 16))
+#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32(w >> 32))
+
 /**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate

-- 

