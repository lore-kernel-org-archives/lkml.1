Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbYBNPkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbYBNPkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYBNPjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:18 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49909 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752298AbYBNPjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:12 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 01/14] arch/alpha/kernel/traps.c: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:39 +0200
Message-Id: <1203003412-11594-2-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: y
References: y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: Richard Henderson <rth@twiddle.net>
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
1.5.3.7

