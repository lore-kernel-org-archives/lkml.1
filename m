Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYCQJid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYCQJid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYCQJhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:37:40 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42576 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753029AbYCQJhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:37:15 -0400
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arch/alpha/kernel/traps.c: Use time_* macros
Date: Mon, 17 Mar 2008 11:36:23 +0200
Message-Id: <1205746593-24820-1-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: Richard Henderson <rth@twiddle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 arch/alpha/kernel/traps.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 2dc7f9f..aa27106 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -8,6 +8,7 @@
  * This file initializes the trap entry points
  */
 
+#include <linux/jiffies.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -781,7 +782,7 @@ do_entUnaUser(void __user * va, unsigned long opcode,
 	   with the unaliged access.  */
 
 	if (!test_thread_flag (TIF_UAC_NOPRINT)) {
-		if (cnt >= 5 && jiffies - last_time > 5*HZ) {
+		if (cnt >= 5 && time_after(jiffies, last_time + 5 * HZ)) {
 			cnt = 0;
 		}
 		if (++cnt < 5) {
-- 
1.5.4.3

