Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbZLRWF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbZLRWF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932785AbZLRWFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:05:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:45990 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZLRWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:05:24 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf tools: Prevent from BITS_PER_LONG redefinition
Date: Fri, 18 Dec 2009 23:05:20 +0100
Message-Id: <1261173920-11320-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system asm/types.h may have defined BITS_PER_LONG already,
depending on the distro.

Check that before defining it from bitops.h wrapper.

Fixes:

In file included from util/include/../../../../include/linux/bitops.h:17,
                 from util/include/linux/bitops.h:8,
                 from ../../lib/hweight.c:2:
util/include/asm/bitops.h:9:1: error: "BITS_PER_LONG" redefined
In file included from util/include/../../../../include/linux/bitops.h:3,
                 from util/include/linux/bitops.h:8,
                 from ../../lib/hweight.c:2:
/usr/include/asm/types.h:32:1: error: this is the location of the previous definition
make: *** [util/hweight.o] Erreur 1

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/include/asm/bitops.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/asm/bitops.h b/tools/perf/util/include/asm/bitops.h
index 58e9817..d945334 100644
--- a/tools/perf/util/include/asm/bitops.h
+++ b/tools/perf/util/include/asm/bitops.h
@@ -5,8 +5,10 @@
 #include "../../types.h"
 #include <linux/compiler.h>
 
+#ifndef BITS_PER_LONG
 /* CHECKME: Not sure both always match */
 #define BITS_PER_LONG	__WORDSIZE
+#endif
 
 #include "../../../../include/asm-generic/bitops/__fls.h"
 #include "../../../../include/asm-generic/bitops/fls.h"
-- 
1.6.2.3

