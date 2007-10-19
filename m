Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbXJSEIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbXJSEIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbXJSEIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:08:09 -0400
Received: from rex.snapgear.com ([203.143.235.140]:46131 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750757AbXJSEIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:08:06 -0400
Date: Fri, 19 Oct 2007 14:07:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190407.l9J47OUU004756@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: define __clear_user macro
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Waddel <Matt.Waddel@freescale.com>

Define __clear_user macro, consistent with other architectures.
fs/signalfd.c won't compile without it.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/include/asm-m68knommu/uaccess.h linux-2.6.23-uc0/include/asm-m68knommu/uaccess.h
--- linux-2.6.23/include/asm-m68knommu/uaccess.h	2007-10-19 10:21:31.000000000 +1000
+++ linux-2.6.23-uc0/include/asm-m68knommu/uaccess.h	2007-10-19 10:32:28.000000000 +1000
@@ -170,10 +170,12 @@ static inline long strnlen_user(const ch
  */
 
 static inline unsigned long
-clear_user(void *to, unsigned long n)
+__clear_user(void *to, unsigned long n)
 {
 	memset(to, 0, n);
 	return 0;
 }
 
+#define	clear_user(to,n)	__clear_user(to,n)
+
 #endif /* _M68KNOMMU_UACCESS_H */
