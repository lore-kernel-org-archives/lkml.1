Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974Ab0A1O3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0A1O3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 09:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836Ab0A1O3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 09:29:01 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62536 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0A1O3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 09:29:00 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf: Add util/include/linux/config.h for including generated autoconf.h of kernel
Date: Thu, 28 Jan 2010 23:28:48 +0900
Message-Id: <1264688928-12861-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4B6133DF.9080207@dcl.info.waseda.ac.jp>
References: <4B6133DF.9080207@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to add util/include/linux/config.h,
this header file includes autoconf.h which is generated
by build phase of kernel.

This makes building of perf depend on building of kernel.
It's a little dirty. But perf has tight relation
of its kernel, so I don't think that it is a serious problem.

My original purpose of making this patch is
knowing size of void *.
If config.h is available,
CONFIG_ARCH_PHYS_ADDR_T_64BIT will be provided for source of perf,
we can know size of void * by this config.

How do you think?

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile                    |    1 +
 tools/perf/util/include/linux/config.h |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/include/linux/config.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9b173e6..54c7e87 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -334,6 +334,7 @@ LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
 LIB_H += ../../include/linux/stringify.h
+LIB_H += ../../include/generated/autoconf.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
 LIB_H += util/include/linux/compiler.h
diff --git a/tools/perf/util/include/linux/config.h b/tools/perf/util/include/linux/config.h
new file mode 100644
index 0000000..e3f2976
--- /dev/null
+++ b/tools/perf/util/include/linux/config.h
@@ -0,0 +1,6 @@
+#ifndef PERF_CONFIG_H
+#define PERF_CONFIG_H
+
+#include "../../../../include/generated/autoconf.h"
+
+#endif
-- 
1.6.5.2

