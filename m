Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYDXXNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYDXXNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbYDXXHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:07:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36669 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbYDXXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:06:46 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 24/24] Use U64_C() instead of casts in kernel/time.c
Date: Thu, 24 Apr 2008 16:05:52 -0700
Message-Id: <1209078352-7593-46-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1209078352-7593-45-git-send-email-hpa@zytor.com>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com>
 <1209078352-7593-2-git-send-email-hpa@zytor.com>
 <1209078352-7593-3-git-send-email-hpa@zytor.com>
 <1209078352-7593-4-git-send-email-hpa@zytor.com>
 <1209078352-7593-5-git-send-email-hpa@zytor.com>
 <1209078352-7593-6-git-send-email-hpa@zytor.com>
 <1209078352-7593-7-git-send-email-hpa@zytor.com>
 <1209078352-7593-8-git-send-email-hpa@zytor.com>
 <1209078352-7593-9-git-send-email-hpa@zytor.com>
 <1209078352-7593-10-git-send-email-hpa@zytor.com>
 <1209078352-7593-11-git-send-email-hpa@zytor.com>
 <1209078352-7593-12-git-send-email-hpa@zytor.com>
 <1209078352-7593-13-git-send-email-hpa@zytor.com>
 <1209078352-7593-14-git-send-email-hpa@zytor.com>
 <1209078352-7593-15-git-send-email-hpa@zytor.com>
 <1209078352-7593-16-git-send-email-hpa@zytor.com>
 <1209078352-7593-17-git-send-email-hpa@zytor.com>
 <1209078352-7593-18-git-send-email-hpa@zytor.com>
 <1209078352-7593-19-git-send-email-hpa@zytor.com>
 <1209078352-7593-20-git-send-email-hpa@zytor.com>
 <1209078352-7593-21-git-send-email-hpa@zytor.com>
 <1209078352-7593-22-git-send-email-hpa@zytor.com>
 <1209078352-7593-23-git-send-email-hpa@zytor.com>
 <1209078352-7593-24-git-send-email-hpa@zytor.com>
 <1209078352-7593-25-git-send-email-hpa@zytor.com>
 <1209078352-7593-26-git-send-email-hpa@zytor.com>
 <1209078352-7593-27-git-send-email-hpa@zytor.com>
 <1209078352-7593-28-git-send-email-hpa@zytor.com>
 <1209078352-7593-29-git-send-email-hpa@zytor.com>
 <1209078352-7593-30-git-send-email-hpa@zytor.com>
 <1209078352-7593-31-git-send-email-hpa@zytor.com>
 <1209078352-7593-32-git-send-email-hpa@zytor.com>
 <1209078352-7593-33-git-send-email-hpa@zytor.com>
 <1209078352-7593-34-git-send-email-hpa@zytor.com>
 <1209078352-7593-35-git-send-email-hpa@zytor.com>
 <1209078352-7593-36-git-send-email-hpa@zytor.com>
 <1209078352-7593-37-git-send-email-hpa@zytor.com>
 <1209078352-7593-38-git-send-email-hpa@zytor.com>
 <1209078352-7593-39-git-send-email-hpa@zytor.com>
 <1209078352-7593-40-git-send-email-hpa@zytor.com>
 <1209078352-7593-41-git-send-email-hpa@zytor.com>
 <1209078352-7593-42-git-send-email-hpa@zytor.com>
 <1209078352-7593-43-git-send-email-hpa@zytor.com>
 <1209078352-7593-44-git-send-email-hpa@zytor.com>
 <1209078352-7593-45-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new U64_C() constructor macro instead of using casts for
constants in kernel/time.c.  This avoids warnings with some gcc
versions.

This resolves Bugzilla 10153.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 kernel/time.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 35d373a..519822b 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -244,7 +244,7 @@ unsigned int inline jiffies_to_msecs(const unsigned long j)
 	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
 #else
 # if BITS_PER_LONG == 32
-	return ((u64)HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;
+	return (U64_C(HZ_TO_MSEC_MUL32) * j) >> HZ_TO_MSEC_SHR32;
 # else
 	return (j * HZ_TO_MSEC_NUM) / HZ_TO_MSEC_DEN;
 # endif
@@ -260,7 +260,7 @@ unsigned int inline jiffies_to_usecs(const unsigned long j)
 	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
 #else
 # if BITS_PER_LONG == 32
-	return ((u64)HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
+	return (U64_C(HZ_TO_USEC_MUL32) * j) >> HZ_TO_USEC_SHR32;
 # else
 	return (j * HZ_TO_USEC_NUM) / HZ_TO_USEC_DEN;
 # endif
@@ -470,7 +470,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
 	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+	return (U64_C(MSEC_TO_HZ_MUL32) * m + MSEC_TO_HZ_ADJ32)
 		>> MSEC_TO_HZ_SHR32;
 #endif
 }
@@ -485,7 +485,7 @@ unsigned long usecs_to_jiffies(const unsigned int u)
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return u * (HZ / USEC_PER_SEC);
 #else
-	return ((u64)USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
+	return (U64_C(USEC_TO_HZ_MUL32) * u + USEC_TO_HZ_ADJ32)
 		>> USEC_TO_HZ_SHR32;
 #endif
 }
-- 
1.5.4.1

