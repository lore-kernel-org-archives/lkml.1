Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYD2BjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYD2BjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYD2BjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:39:06 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:50680 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYD2BjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:39:04 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48167C34.8080409@avtrex.com>
Date: Mon, 28 Apr 2008 18:39:00 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] Scheduler support for HARDWARE_WATCHPOINTS.
References: <48167832.3090103@avtrex.com>
In-Reply-To: <48167832.3090103@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Apr 2008 01:39:01.0837 (UTC) FILETIME=[CD3B5FD0:01C8A999]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scheduler support for HARDWARE_WATCHPOINTS.

Here we hook up the scheduler.  Whenever we switch to a new process,
we check to see if the watch registers should be installed, and do it
if needed.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 include/asm-mips/system.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-mips/system.h b/include/asm-mips/system.h
index a944eda..cd30f83 100644
--- a/include/asm-mips/system.h
+++ b/include/asm-mips/system.h
@@ -20,6 +20,7 @@
 #include <asm/cmpxchg.h>
 #include <asm/cpu-features.h>
 #include <asm/dsp.h>
+#include <asm/watch.h>
 #include <asm/war.h>
 
 
@@ -76,6 +77,7 @@ do {									\
 		__restore_dsp(current);					\
 	if (cpu_has_userlocal)						\
 		write_c0_userlocal(current_thread_info()->tp_value);	\
+	__restore_watch();						\
 } while (0)
 
 static inline unsigned long __xchg_u32(volatile int * m, unsigned int val)
-- 
1.5.5

