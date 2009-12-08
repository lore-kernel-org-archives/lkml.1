Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZLHLcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZLHLcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZLHLcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:32:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:36052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbZLHLcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:32:00 -0500
Date: Tue, 8 Dec 2009 11:30:47 GMT
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, arnd@arndb.de, geert@linux-m68k.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, arnd@arndb.de, geert@linux-m68k.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <200912071712.58650.arnd@arndb.de>
References: <200912071712.58650.arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf events: hw_breakpoints: Don't include asm/hw_breakpoint.h in user space
Message-ID: <tip-2ff6cfd70720780234fdfea636218c2a62b31287@git.kernel.org>
Git-Commit-ID: 2ff6cfd70720780234fdfea636218c2a62b31287
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ff6cfd70720780234fdfea636218c2a62b31287
Gitweb:     http://git.kernel.org/tip/2ff6cfd70720780234fdfea636218c2a62b31287
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Mon, 7 Dec 2009 17:12:58 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Dec 2009 02:58:40 +0100

perf events: hw_breakpoints: Don't include asm/hw_breakpoint.h in user space

asm/hw_breakpoint.h is evidently a kernel internal file and
should not be included globally, not even under an #ifdef.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <200912071712.58650.arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 89098e3..bf33294 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -18,10 +18,6 @@
 #include <linux/ioctl.h>
 #include <asm/byteorder.h>
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-#include <asm/hw_breakpoint.h>
-#endif
-
 /*
  * User-space ABI bits:
  */
@@ -451,6 +447,10 @@ enum perf_callchain_context {
 # include <asm/perf_event.h>
 #endif
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#include <asm/hw_breakpoint.h>
+#endif
+
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/rculist.h>
