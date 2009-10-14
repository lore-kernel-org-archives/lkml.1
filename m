Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbZJNMRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbZJNMRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZJNMRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:17:31 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49092 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbZJNMRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:17:30 -0400
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: twl4030-power: do not allow negative or zero length script
Date: Wed, 14 Oct 2009 15:15:49 +0300
Message-Id: <1255522550-15199-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 14 Oct 2009 12:15:55.0508 (UTC) FILETIME=[14879340:01CA4CC8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The script length cannot be negative. If the length is zero, return
an error.

The patch eliminates the following compiler warning:

drivers/mfd/twl4030-power.c: In function 'twl4030_power_init':
drivers/mfd/twl4030-power.c:151: warning: 'err' may be used uninitialized in this function
drivers/mfd/twl4030-power.c:151: note: 'err' was declared here

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 drivers/mfd/twl4030-power.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index d423e0c..eae6cda 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -146,9 +146,9 @@ out:
 }
 
 static int __init twl4030_write_script(u8 address, struct twl4030_ins *script,
-				       int len)
+				       unsigned len)
 {
-	int err;
+	int err = EINVAL;
 
 	for (; len; len--, address++, script++) {
 		if (len == 1) {
-- 
1.6.0.4

