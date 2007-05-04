Return-Path: <linux-kernel-owner+w=401wt.eu-S1031421AbXEDQx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031421AbXEDQx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031406AbXEDQwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:52:23 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:13439 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbXEDQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:52:17 -0400
Message-Id: <20070504165241.625532687@de.ibm.com>
References: <20070504165016.908033855@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 May 2007 18:50:19 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 3/9] Export uaccess as non-gpl symbol.
Content-Disposition: inline; filename=003-uaccess-export.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Commit c1821c2e9711adc3cd298a16b7237c92a2cee78d introduced the
uaccess structure that is used to select the correct set of user
copy functions for the different execution modes (standard vs.
noexec vs. z9 optimized user copy). The uaccess symbol is exported
with EXPORT_SYMBOL_GPL. This breaks all non-gpl modules that use
user copy. To make them work again change the export to
EXPORT_SYMBOL.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/setup.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/setup.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/setup.c	2007-05-04 18:48:36.000000000 +0200
+++ quilt-2.6/arch/s390/kernel/setup.c	2007-05-04 18:50:14.000000000 +0200
@@ -65,7 +65,7 @@
  * User copy operations.
  */
 struct uaccess_ops uaccess;
-EXPORT_SYMBOL_GPL(uaccess);
+EXPORT_SYMBOL(uaccess);
 
 /*
  * Machine setup..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

