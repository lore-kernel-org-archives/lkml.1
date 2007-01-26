Return-Path: <linux-kernel-owner+w=401wt.eu-S1030849AbXAZQtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030849AbXAZQtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030850AbXAZQtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:49:01 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:59307 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030849AbXAZQs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:48:59 -0500
Date: Fri, 26 Jan 2007 17:48:51 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Simplify virt_to_phys.
Message-ID: <20070126164851.GG11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Simplify virt_to_phys.

No need to use lrag in 64 bit addressing mode since lra will do the
same.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/io.h |    4 ----
 1 files changed, 4 deletions(-)

diff -urpN linux-2.6/include/asm-s390/io.h linux-2.6-patched/include/asm-s390/io.h
--- linux-2.6/include/asm-s390/io.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/io.h	2007-01-26 17:27:52.000000000 +0100
@@ -28,11 +28,7 @@ static inline unsigned long virt_to_phys
 {
 	unsigned long real_address;
 	asm volatile(
-#ifndef __s390x__
 		 "	lra	%0,0(%1)\n"
-#else /* __s390x__ */
-		 "	lrag	%0,0(%1)\n"
-#endif /* __s390x__ */
 		 "	jz	0f\n"
 		 "	la	%0,0\n"
                  "0:"
