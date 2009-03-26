Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZCZNjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZCZNjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbZCZNik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:38:40 -0400
Received: from mx1.emlix.com ([193.175.82.87]:38394 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201AbZCZNij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:38:39 -0400
From: Oskar Schirmer <os@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 1/3] xtensa: fix wrong extern declaration renamed in code using it
Date: Thu, 26 Mar 2009 14:39:43 +0100
Message-Id: <1238074785-24810-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable ccount_nsec has been renamed to nsec_per_ccount
in arch/xtensa/kernel/time.c in 2b8aea74 (2007-08-05),
but the fix failed to rename the variable in
arch/xtensa/include/asm/timex.h as well.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/include/asm/timex.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/include/asm/timex.h b/arch/xtensa/include/asm/timex.h
index b83a818..053bc42 100644
--- a/arch/xtensa/include/asm/timex.h
+++ b/arch/xtensa/include/asm/timex.h
@@ -39,9 +39,9 @@
 
 #ifdef CONFIG_XTENSA_CALIBRATE_CCOUNT
 extern unsigned long ccount_per_jiffy;
-extern unsigned long ccount_nsec;
+extern unsigned long nsec_per_ccount;
 #define CCOUNT_PER_JIFFY ccount_per_jiffy
-#define NSEC_PER_CCOUNT  ccount_nsec
+#define NSEC_PER_CCOUNT  nsec_per_ccount
 #else
 #define CCOUNT_PER_JIFFY (CONFIG_XTENSA_CPU_CLOCK*(1000000UL/HZ))
 #define NSEC_PER_CCOUNT (1000UL / CONFIG_XTENSA_CPU_CLOCK)
-- 
1.6.2.107.ge47ee

