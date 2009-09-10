Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZIJX7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZIJX7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbZIJX7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:59:00 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16133 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZIJX5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:57:41 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       linux-parisc@vger.kernel.org
Subject: [PATCH 06/10] parisc: Convert BUG() to use unreachable()
Date: Thu, 10 Sep 2009 16:56:47 -0700
Message-Id: <1252627011-2933-6-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AA991C1.1050800@caviumnetworks.com>
References: <4AA991C1.1050800@caviumnetworks.com>
X-OriginalArrivalTime: 10 Sep 2009 23:57:04.0829 (UTC) FILETIME=[65C106D0:01CA3272]
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

