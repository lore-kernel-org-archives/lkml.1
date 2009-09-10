Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZIJX5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZIJX5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZIJX5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:57:36 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16092 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZIJX5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:57:33 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>,
       ralf@linux-mips.org, linux-mips@linux-mips.org
Subject: [PATCH 03/10] MIPS: Convert BUG() to use unreachable()
Date: Thu, 10 Sep 2009 16:56:44 -0700
Message-Id: <1252627011-2933-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AA991C1.1050800@caviumnetworks.com>
References: <4AA991C1.1050800@caviumnetworks.com>
X-OriginalArrivalTime: 10 Sep 2009 23:57:04.0813 (UTC) FILETIME=[65BE95D0:01CA3272]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of while(1);

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
CC: ralf@linux-mips.org
CC: linux-mips@linux-mips.org
---
 arch/mips/include/asm/bug.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/bug.h b/arch/mips/include/asm/bug.h
index 6cf29c2..540c98a 100644
--- a/arch/mips/include/asm/bug.h
+++ b/arch/mips/include/asm/bug.h
@@ -11,9 +11,7 @@
 static inline void __noreturn BUG(void)
 {
 	__asm__ __volatile__("break %0" : : "i" (BRK_BUG));
-	/* Fool GCC into thinking the function doesn't return. */
-	while (1)
-		;
+	unreachable();
 }
 
 #define HAVE_ARCH_BUG
-- 
1.6.2.5

