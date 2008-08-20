Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYHTCqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYHTCqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYHTCqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:46:25 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41937 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbYHTCqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:46:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: zippel@linux-m68k.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] linux/timex.h: cleanup for userspace
Date: Tue, 19 Aug 2008 22:46:23 -0400
Message-Id: <1219200383-19556-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAXFREQ_SCALED was tweaked recently to contain a (s64) cast.  Assuming this
is meant for userspace, change it to (__s64) and pull in linux/types.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/timex.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index fc6035d..07ed536 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -55,6 +55,7 @@
 
 #include <linux/compiler.h>
 #include <linux/time.h>
+#include <linux/types.h>
 
 #include <asm/param.h>
 
@@ -88,7 +89,7 @@
 
 #define MAXPHASE 500000000l	/* max phase error (ns) */
 #define MAXFREQ 500000		/* max frequency error (ns/s) */
-#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
+#define MAXFREQ_SCALED ((__s64)MAXFREQ << NTP_SCALE_SHIFT)
 #define MINSEC 256		/* min interval between updates (s) */
 #define MAXSEC 2048		/* max interval between updates (s) */
 #define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
-- 
1.5.6.1

