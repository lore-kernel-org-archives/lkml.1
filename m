Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbXJDLiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbXJDLiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757734AbXJDL3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:29:14 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:51253 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbXJDL2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:32 -0400
Message-Id: <20071004112834.521260994@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:40 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 34/34] vmwatchdog: fix broken inline assembly.
Content-Disposition: inline; filename=034-vmwatchdog.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Constraint for err is wrong since it is preinitialized and the code
relies on it in case of an exception.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmwatchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/char/vmwatchdog.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmwatchdog.c
+++ quilt-2.6/drivers/s390/char/vmwatchdog.c
@@ -66,8 +66,8 @@ static int __diag288(enum vmwdt_func fun
 		"0:	la	%0,0\n"
 		"1:\n"
 		EX_TABLE(0b,1b)
-		: "=d" (err) : "d"(__func), "d"(__timeout),
-		  "d"(__cmdp), "d"(__cmdl), "0" (-EINVAL) : "1", "cc");
+		: "+d" (err) : "d"(__func), "d"(__timeout),
+		  "d"(__cmdp), "d"(__cmdl) : "1", "cc");
 	return err;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

