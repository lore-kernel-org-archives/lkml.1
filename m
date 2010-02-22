Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0BVSLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:11:25 -0500
Received: from smtp.nokia.com ([192.100.122.233]:26267 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab0BVSLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:11:14 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/11] sysctl: don't use own implementation of hex_to_bin()
Date: Mon, 22 Feb 2010 20:09:06 +0200
Message-Id: <5c02662a55439f65791e24b8282d4face566955e.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <8470deda388af7015db44e96fa69560dd6e30126.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <939cb3c63fbf6639b5d301ddc79c64d5642a6b81.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8efe17f827514a0c470191dccaf00afd09c2854.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <8470deda388af7015db44e96fa69560dd6e30126.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:35.0595 (UTC) FILETIME=[549069B0:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Get rid of own implementation of hex_to_bin(). It requires to have hex_to_bin()
introduced by starter patch in the series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@linux.intel.com>
---
 kernel/sysctl_binary.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 8f5d16e..e09c852 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/ctype.h>
 #include <linux/netdevice.h>
+#include <linux/kernel.h>
 
 #ifdef CONFIG_SYSCTL_SYSCALL
 
@@ -1124,11 +1125,6 @@ out:
 	return result;
 }
 
-static unsigned hex_value(int ch)
-{
-	return isdigit(ch) ? ch - '0' : ((ch | 0x20) - 'a') + 10;
-}
-
 static ssize_t bin_uuid(struct file *file,
 	void __user *oldval, size_t oldlen, void __user *newval, size_t newlen)
 {
@@ -1156,7 +1152,8 @@ static ssize_t bin_uuid(struct file *file,
 			if (!isxdigit(str[0]) || !isxdigit(str[1]))
 				goto out;
 
-			uuid[i] = (hex_value(str[0]) << 4) | hex_value(str[1]);
+			uuid[i] = (hex_to_bin(str[0]) << 4) |
+					hex_to_bin(str[1]);
 			str += 2;
 			if (*str == '-')
 				str++;
-- 
1.5.6.5

