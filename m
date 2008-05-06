Return-Path: <linux-kernel-owner+w=401wt.eu-S1765287AbYEFQDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765287AbYEFQDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764780AbYEFQCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:02:43 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:57073 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764656AbYEFQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:02:42 -0400
Message-Id: <20080506155111.984508377@de.ibm.com>
References: <20080506155027.974409738@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 May 2008 17:50:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 5/8] s390mach compile warning
Content-Disposition: inline; filename=005-cio-warning.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Fix the following compile warning:

drivers/s390/s390mach.c: In function 's390_collect_crw_info':
drivers/s390/s390mach.c:77: warning: ignoring return value of 'down_interruptibl

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/s390mach.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/s390mach.c
===================================================================
--- quilt-2.6.orig/drivers/s390/s390mach.c
+++ quilt-2.6/drivers/s390/s390mach.c
@@ -48,10 +48,11 @@ s390_collect_crw_info(void *param)
 	int ccode;
 	struct semaphore *sem;
 	unsigned int chain;
+	int ignore;
 
 	sem = (struct semaphore *)param;
 repeat:
-	down_interruptible(sem);
+	ignore = down_interruptible(sem);
 	chain = 0;
 	while (1) {
 		if (unlikely(chain > 1)) {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

