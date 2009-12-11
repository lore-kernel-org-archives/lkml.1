Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZLKJkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZLKJkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZLKJkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:40:01 -0500
Received: from mail2.picochip.com ([82.111.145.34]:35864 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754927AbZLKJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:39:50 -0500
From: Jamie Iles <jamie.iles@picochip.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie.iles@picochip.com>,
       Russell King <linux@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] perf tools: allow building for ARM
Date: Fri, 11 Dec 2009 09:20:59 +0000
Message-Id: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
X-Mailer: git-send-email 1.6.5.4
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 11 Dec 2009 09:19:50 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add definitions of rmb() and cpu_relax() and include the ARM unistd.h
header. The kernel uses different definitions for rmb() depending on
the arch revision and whether the system is SMP or not. The lowest common
denominator is a compiler memory barrier so use that.

Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/perf.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 454d5d5..4b8eac6 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -59,6 +59,12 @@
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
 #endif
 
+#ifdef __arm__
+#include "../../arch/arm/include/asm/unistd.h"
+#define rmb()		asm volatile("":::"memory")
+#define cpu_relax()	asm volatile("":::"memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
-- 
1.6.5.4

