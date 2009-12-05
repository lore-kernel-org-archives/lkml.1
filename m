Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZLECHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZLECHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZLECHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:07:19 -0500
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:1361 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZLECHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:07:17 -0500
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Dec 2009 21:07:17 EST
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: [PATCH 2/5] x86: Convert BUG() to use unreachable()
Date: Fri,  4 Dec 2009 17:44:51 -0800
Message-Id: <1259977494-24636-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4B19BAD3.1000808@caviumnetworks.com>
References: <4B19BAD3.1000808@caviumnetworks.com>
X-OriginalArrivalTime: 05 Dec 2009 01:45:01.0943 (UTC) FILETIME=[8F86F070:01CA754C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of for(;;);.  When
allyesconfig is built with a GCC-4.5 snapshot on i686 the size of the
text segment is reduced by 3987 bytes (from 6827019 to 6823032).

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org
---
 arch/x86/include/asm/bug.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index d9cf1cd..f654d1b 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -22,14 +22,14 @@ do {								\
 		     ".popsection"				\
 		     : : "i" (__FILE__), "i" (__LINE__),	\
 		     "i" (sizeof(struct bug_entry)));		\
-	for (;;) ;						\
+	unreachable();						\
 } while (0)
 
 #else
 #define BUG()							\
 do {								\
 	asm volatile("ud2");					\
-	for (;;) ;						\
+	unreachable();						\
 } while (0)
 #endif
 
-- 
1.6.2.5

