Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYCQJh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYCQJh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYCQJhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:37:16 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42581 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752810AbYCQJhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:37:14 -0400
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arch/parisc/kernel/unaligned.c: Use time_* macros
Date: Mon, 17 Mar 2008 11:36:25 +0200
Message-Id: <1205746593-24820-3-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
References: <>
 <1205746593-24820-1-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-parisc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
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
1.5.4.3

