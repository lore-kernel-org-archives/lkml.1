Return-Path: <linux-kernel-owner+w=401wt.eu-S1762580AbXEJN66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762580AbXEJN66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbXEJN4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:56:31 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:55417 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760299AbXEJN4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:56:21 -0400
Message-Id: <20070510135644.668728319@de.ibm.com>
References: <20070510135152.178104939@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 15:52:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 08/15] Avoid compile warning.
Content-Disposition: inline; filename=008-warning.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

arch/s390/mm/fault.c: In function `signal_return': 
arch/s390/mm/fault.c:256: warning: unused variable `compat' 

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/mm/fault.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/mm/fault.c
===================================================================
--- quilt-2.6.orig/arch/s390/mm/fault.c
+++ quilt-2.6/arch/s390/mm/fault.c
@@ -253,7 +253,10 @@ static int signal_return(struct mm_struc
 			 unsigned long address, unsigned long error_code)
 {
 	u16 instruction;
-	int rc, compat;
+	int rc;
+#ifdef CONFIG_COMPAT
+	int compat;
+#endif
 
 	pagefault_disable();
 	rc = __get_user(instruction, (u16 __user *) regs->psw.addr);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

