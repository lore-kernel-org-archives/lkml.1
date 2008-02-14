Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYBNPje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYBNPje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYBNPjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:12 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49912 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753003AbYBNPjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:11 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 04/14] arch/powerpc/platforms/iseries/pci.c: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:42 +0200
Message-Id: <1203003412-11594-5-git-send-email-caglar@pardus.org.tr>
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

Cc: linuxppc-dev@ozlabs.org
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 arch/powerpc/platforms/iseries/pci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/iseries/pci.c b/arch/powerpc/platforms/iseries/pci.c
index cc562e4..02a634f 100644
--- a/arch/powerpc/platforms/iseries/pci.c
+++ b/arch/powerpc/platforms/iseries/pci.c
@@ -23,6 +23,7 @@
 
 #undef DEBUG
 
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/string.h>
@@ -586,7 +587,7 @@ static inline struct device_node *xlate_iomm_address(
 		static unsigned long last_jiffies;
 		static int num_printed;
 
-		if ((jiffies - last_jiffies) > 60 * HZ) {
+		if (time_after(jiffies, last_jiffies + 60 * HZ)) {
 			last_jiffies = jiffies;
 			num_printed = 0;
 		}
-- 
1.5.3.7

