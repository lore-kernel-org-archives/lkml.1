Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbYCAXK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbYCAXK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 18:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYCAXKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 18:10:46 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33554 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYCAXKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 18:10:43 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>, ubraun@linux.vnet.ibm.com,
       blaschka@linux.vnet.ibm.com
Subject: [PATCH 1/1] iucv: Fix compilation with !CONFIG_SMP
Date: Fri, 29 Feb 2008 17:30:41 -0500
Message-Id: <1204324241-2276-1-git-send-email-jeffpc@josefsipek.net>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC [M]  net/iucv/iucv.o
net/iucv/iucv.c: In function `iucv_cleanup_queue':
net/iucv/iucv.c:657: error: `__iucv_cleanup_queue' undeclared (first use in this function)

With !CONFIG_SMP the smp_call_function call turns into up_smp_call_function
call which is just a return 0. Unfortunately, since up_smp_call_function is
a static inline, the __iucv_cleanup_queue symbol is referenced.

Cc: ubraun@linux.vnet.ibm.com
Cc: blaschka@linux.vnet.ibm.com
Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
---
 net/iucv/iucv.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 2753b0c..d764f4c 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -621,7 +621,6 @@ static int iucv_sever_pathid(u16 pathid, u8 userdata[16])
 	return iucv_call_b2f0(IUCV_SEVER, parm);
 }
 
-#ifdef CONFIG_SMP
 /**
  * __iucv_cleanup_queue
  * @dummy: unused dummy argument
@@ -632,7 +631,6 @@ static int iucv_sever_pathid(u16 pathid, u8 userdata[16])
 static void __iucv_cleanup_queue(void *dummy)
 {
 }
-#endif
 
 /**
  * iucv_cleanup_queue
-- 
1.5.4.2
