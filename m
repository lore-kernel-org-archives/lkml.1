Return-Path: <linux-kernel-owner+w=401wt.eu-S932345AbZINV5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbZINV5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbZINV5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:57:08 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9422 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbZINV4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:56:02 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 11/11] Use unreachable() in asm-generic/bug.h for !CONFIG_BUG case.
Date: Mon, 14 Sep 2009 14:55:40 -0700
Message-Id: <1252965340-31735-11-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AAEBAC2.1050905@caviumnetworks.com>
References: <4AAEBAC2.1050905@caviumnetworks.com>
X-OriginalArrivalTime: 14 Sep 2009 21:56:01.0090 (UTC) FILETIME=[25E16A20:01CA3586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject says it all (most).  The only drawback here is that for a
pre-GCC-5.4 compiler, instead of expanding to nothing we now expand
BUG() to an endless loop.  Before the patch when configured with
!CONFIG_BUG() you might get some warnings, but the code would be
small.  After the patch there are no warnings, but there is an endless
loop at each BUG() site.

Of course for the GCC-4.5 case we get the best of both worlds.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Suggested-by: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/asm-generic/bug.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 4b67559..e952242 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -89,11 +89,11 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
+#define BUG() unreachable()
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
+#define BUG_ON(condition) do { if (condition) unreachable(); } while (0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
-- 
1.6.2.5

