Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0BRS5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:57:23 -0500
Received: from smtp.nokia.com ([192.100.105.134]:34005 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab0BRS5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:19 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 04/12] scsi: ibmmca: use kernel native convertor
Date: Thu, 18 Feb 2010 20:55:43 +0200
Message-Id: <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:15.0551 (UTC) FILETIME=[2FD0CAF0:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

to get hex digit from a binary format we may use kernel's hex_asc_*() methods.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/scsi/ibmmca.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 9c1e6a5..52b03a6 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1002,12 +1002,11 @@ static char *ti_p(int dev)
 /* interpreter for logical device numbers (ldn) */
 static char *ti_l(int val)
 {
-	const char hex[16] = "0123456789abcdef";
 	static char answer[2];
 
 	answer[1] = (char) (0x0);
 	if (val <= MAX_LOG_DEV)
-		answer[0] = hex[val];
+		answer[0] = hex_asc_lo(val);
 	else
 		answer[0] = '-';
 	return (char *) &answer;
-- 
1.5.6.5

