Return-Path: <linux-kernel-owner+w=401wt.eu-S936137AbYEBS7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936137AbYEBS7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933800AbYEBS7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:59:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58932 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789AbYEBS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:59:21 -0400
Date: Fri, 2 May 2008 11:58:04 -0700
Message-Id: <200805021858.m42Iw4Lj025952@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] kernel/time.c: Silence gcc warning 'integer constant to large for long type'
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Carlos R. Mafra" <crmafra@ift.unesp.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos R. Mafra <crmafra@ift.unesp.br>

This patch removes these gcc warnings:

kernel/time.c: In function msecs_to_jiffies:
kernel/time.c:479: warning: integer constant is too large for long type
kernel/time.c: In function usecs_to_jiffies:
kernel/time.c:494: warning: integer constant is too large for long type

by casting MSEC_TO_HZ_ADJ32 and USEC_TO_HZ_ADJ32 to u64.

This resolves bugzilla 10153.

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 kernel/time.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index cbe0d5a..76dcc0f 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -476,7 +476,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
 	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+	return ((u64)MSEC_TO_HZ_MUL32 * m + (u64)MSEC_TO_HZ_ADJ32)
 		>> MSEC_TO_HZ_SHR32;
 #endif
 }
@@ -491,7 +491,7 @@ unsigned long usecs_to_jiffies(const unsigned int u)
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return u * (HZ / USEC_PER_SEC);
 #else
-	return ((u64)USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
+	return ((u64)USEC_TO_HZ_MUL32 * u + (u64)USEC_TO_HZ_ADJ32)
 		>> USEC_TO_HZ_SHR32;
 #endif
 }
-- 
1.5.4.3



