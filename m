Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbYDVAdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbYDVAdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759775AbYDVAdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:33:11 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:60693 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321AbYDVAdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:33:10 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <480D3240.5050106@avtrex.com>
Date: Mon, 21 Apr 2008 17:33:04 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 5/6] Scheduler support for HARDWARE_WATCHPOINTS.
References: <480D2151.2020701@avtrex.com>
In-Reply-To: <480D2151.2020701@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 00:33:05.0654 (UTC) FILETIME=[6E458160:01C8A410]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the meat of the patch.  Here we install the watch register values when we
schedule a new thread.

The implemtation of __restore_watch() is in asm/watch.h.  In the case where there
are no watch registers to install (the normal case) the overhead is 5 machine
instructions with gcc-3.4.3.

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

