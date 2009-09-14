Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZINV4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZINV4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbZINV4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:56:11 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9425 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbZINV4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:56:05 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 07/11] powerpc: Convert BUG() to use unreachable()
Date: Mon, 14 Sep 2009 14:55:36 -0700
Message-Id: <1252965340-31735-7-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AAEBAC2.1050905@caviumnetworks.com>
References: <4AAEBAC2.1050905@caviumnetworks.com>
X-OriginalArrivalTime: 14 Sep 2009 21:55:57.0683 (UTC) FILETIME=[23D98C30:01CA3586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of for(;;);

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: linuxppc-dev@ozlabs.org
---
 arch/powerpc/include/asm/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/bug.h b/arch/powerpc/include/asm/bug.h
index 64e1fdc..2c15212 100644
--- a/arch/powerpc/include/asm/bug.h
+++ b/arch/powerpc/include/asm/bug.h
@@ -68,7 +68,7 @@
 		_EMIT_BUG_ENTRY					\
 		: : "i" (__FILE__), "i" (__LINE__),		\
 		    "i" (0), "i"  (sizeof(struct bug_entry)));	\
-	for(;;) ;						\
+	unreachable();						\
 } while (0)
 
 #define BUG_ON(x) do {						\
-- 
1.6.2.5

