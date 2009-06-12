Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbZFLRSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbZFLRSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZFLRRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:17:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42269 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZFLRRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:17:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counters: start documenting HAVE_PERF_COUNTERS requirements
Date: Fri, 12 Jun 2009 13:17:43 -0400
Message-Id: <1244827063-24046-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Help out arch porters who want to support perf counters by listing some
basic requirements.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
i imagine more details would be good, but this is a starting point and
better than nothing

 init/Kconfig          |    2 ++
 tools/perf/design.txt |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c649657..20f85b1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -936,6 +936,8 @@ config AIO
 
 config HAVE_PERF_COUNTERS
 	bool
+	help
+	  See end of tools/perf/design.txt
 
 menu "Performance Counters"
 
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 860e116..f71e0d2 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -440,3 +440,18 @@ by this process or by another, and doesn't affect any counters that
 this process has created on other processes.  It only enables or
 disables the group leaders, not any other members in the groups.
 
+
+Arch requirements
+-----------------
+
+If your architecture does not have hardware performance metrics, you can
+still use the generic software counters based on hrtimers for sampling.
+
+So to start with, in order to add HAVE_PERF_COUNTERS to your Kconfig, you
+will need at least this:
+	- asm/perf_counter.h - a basic stub will suffice at first
+	- support for atomic64 types (and associated helper functions)
+	- set_perf_counter_pending() implemented
+
+If your architecture does have hardware capabilities, you can override the
+weak stub hw_perf_counter_init() to register hardware counters.
-- 
1.6.3.1

