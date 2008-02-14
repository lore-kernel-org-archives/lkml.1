Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbYBNPlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbYBNPlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYBNPjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:24 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49921 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753004AbYBNPjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:17 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 05/14] arch/sparc64/kernel/unaligned.c: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:43 +0200
Message-Id: <1203003412-11594-6-git-send-email-caglar@pardus.org.tr>
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

Cc: sparclinux@vger.kernel.org
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 arch/sparc64/kernel/unaligned.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/sparc64/kernel/unaligned.c b/arch/sparc64/kernel/unaligned.c
index dc7bf1b..1a511e9 100644
--- a/arch/sparc64/kernel/unaligned.c
+++ b/arch/sparc64/kernel/unaligned.c
@@ -7,6 +7,7 @@
  */
 
 
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
@@ -283,7 +284,7 @@ static void log_unaligned(struct pt_regs *regs)
 {
 	static unsigned long count, last_time;
 
-	if (jiffies - last_time > 5 * HZ)
+	if (time_after(jiffies, last_time + 5 * HZ))
 		count = 0;
 	if (count < 5) {
 		last_time = jiffies;
-- 
1.5.3.7

