Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbYGDRYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbYGDRYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYGDRYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:24:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:13172 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbYGDRYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DhZgbsxa6nIkqDNtbLn9HU5OLgvahEvSiHJi61y9LfioIC1ciywrg+75O25m4DkPm8
         cWsMIJWEPyXQm0z06LYU/KyX9MypMvljDb1FOELBoWnkqSm7KU1KI/+VpLXSlZlxg5yz
         Ed3GmQ9rSt7ei4i1dfUy00XoUOoVG8onD+iQI=
Subject: Re: [PATCH 3/5] byteorder: wire up arches to use new headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1215144733.16647.69.camel@brick>
References: <1215144733.16647.69.camel@brick>
Content-Type: text/plain; charset=utf-8
Date: Fri, 04 Jul 2008 10:23:59 -0700
Message-Id: <1215192239.16647.84.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
rebasing to today's next, noticed a conflict in m68knommu, here's a revised part
of the arch hook-up.

diff --git a/include/asm-m68knommu/byteorder.h b/include/asm-m68knommu/byteorder.h
index 20bb442..8a68b3c 100644
--- a/include/asm-m68knommu/byteorder.h
+++ b/include/asm-m68knommu/byteorder.h
@@ -3,13 +3,11 @@
 
 #include <linux/types.h>
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
 #if defined (__mcfisaaplus__) || defined (__mcfisac__)
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 val)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 	asm(
 			"byterev %0"
@@ -18,10 +16,9 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 val)
 	   );
 	return val;
 }
-
-#define __arch__swab32(x) ___arch__swab32(x)
+#define HAVE_ARCH_SWAB32
 #endif
 
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _M68KNOMMU_BYTEORDER_H */


