Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYBNPjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYBNPjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYBNPjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:16 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49911 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752788AbYBNPjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:11 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 03/14] arch/parisc/kernel/unaligned.c: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:41 +0200
Message-Id: <1203003412-11594-4-git-send-email-caglar@pardus.org.tr>
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

Cc: linux-parisc@vger.kernel.org
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 arch/parisc/kernel/unaligned.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index aebf3c1..19b8a79 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -460,7 +460,7 @@ void handle_unaligned(struct pt_regs *regs)
 			goto force_sigbus;
 		}
 
-		if (unaligned_count > 5 && jiffies - last_time > 5*HZ) {
+		if (unaligned_count > 5 && time_after(jiffies, last_time + 5 * HZ)) {
 			unaligned_count = 0;
 			last_time = jiffies;
 		}
-- 
1.5.3.7

