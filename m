Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZLECHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZLECHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZLECHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:07:31 -0500
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:1366 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZLECHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:07:19 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 3/5] MIPS: Convert BUG() to use unreachable()
Date: Fri,  4 Dec 2009 17:44:52 -0800
Message-Id: <1259977494-24636-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4B19BAD3.1000808@caviumnetworks.com>
References: <4B19BAD3.1000808@caviumnetworks.com>
X-OriginalArrivalTime: 05 Dec 2009 01:45:02.0146 (UTC) FILETIME=[8FA5EA20:01CA754C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of while(1);

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
CC: Ralf Baechle <ralf@linux-mips.org>
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

