Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZINV5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZINV5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbZINV5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:57:12 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9421 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbZINV4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:56:02 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       linux-parisc@vger.kernel.org
Subject: [PATCH 06/11] parisc: Convert BUG() to use unreachable()
Date: Mon, 14 Sep 2009 14:55:35 -0700
Message-Id: <1252965340-31735-6-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AAEBAC2.1050905@caviumnetworks.com>
References: <4AAEBAC2.1050905@caviumnetworks.com>
X-OriginalArrivalTime: 14 Sep 2009 21:56:01.0387 (UTC) FILETIME=[260EBBB0:01CA3586]
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

