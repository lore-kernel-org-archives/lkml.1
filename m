Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbZLJR3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbZLJR3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761265AbZLJR31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:29:27 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3894 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761240AbZLJR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:29:15 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       David Daney <ddaney@caviumnetworks.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       linux-parisc@vger.kernel.org
Subject: [PATCH 2/5] parisc: Convert BUG() to use unreachable()
Date: Thu, 10 Dec 2009 09:28:18 -0800
Message-Id: <1260466101-17545-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4B212EEC.3060808@caviumnetworks.com>
References: <4B212EEC.3060808@caviumnetworks.com>
X-OriginalArrivalTime: 10 Dec 2009 17:28:28.0826 (UTC) FILETIME=[2FEC8FA0:01CA79BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of for(;;);

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
CC: Kyle McMartin <kyle@mcmartin.ca>
CC: Helge Deller <deller@gmx.de>
CC: linux-parisc@vger.kernel.org
---
 arch/parisc/include/asm/bug.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/bug.h b/arch/parisc/include/asm/bug.h
index 8cfc553..75e46c5 100644
--- a/arch/parisc/include/asm/bug.h
+++ b/arch/parisc/include/asm/bug.h
@@ -32,14 +32,14 @@
 			     "\t.popsection"				\
 			     : : "i" (__FILE__), "i" (__LINE__),	\
 			     "i" (0), "i" (sizeof(struct bug_entry)) ); \
-		for(;;) ;						\
+		unreachable();						\
 	} while(0)
 
 #else
 #define BUG()								\
 	do {								\
 		asm volatile(PARISC_BUG_BREAK_ASM : : );		\
-		for(;;) ;						\
+		unreachable();						\
 	} while(0)
 #endif
 
-- 
1.6.2.5

