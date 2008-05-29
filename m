Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYE2NDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYE2NDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYE2NBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:01:15 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:38050 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYE2NBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:01:11 -0400
Message-Id: <20080529125728.027016797@de.ibm.com>
References: <20080529125501.196123527@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 14:55:02 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 01/11] fix sparsemem related compile error with allnoconfig on s390
Content-Disposition: inline; filename=001-allnoconfig.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans-Joachim Picht <hans@linux.vnet.ibm.com>

On s390 make allnoconfig fails with the following build error:

arch/s390/mm/init.c: In function 'show_mem':
arch/s390/mm/init.c:55: error: implicit declaration of function 'pfn_valid'
make[1]: *** [arch/s390/mm/init.o] Error 1
make: *** [arch/s390/mm] Error 2

This problem can by fixed ensuring that ARCH_SELECT_MEMORY_MODEL
is always turned on.

Signed-off-by: Hans-Joachim Picht <hans@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

Index: quilt-2.6/arch/s390/Kconfig
===================================================================
--- quilt-2.6.orig/arch/s390/Kconfig
+++ quilt-2.6/arch/s390/Kconfig
@@ -308,6 +308,9 @@ config ARCH_SPARSEMEM_ENABLE
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 
+config ARCH_SELECT_MEMORY_MODEL
+       def_bool y
+
 source "mm/Kconfig"
 
 comment "I/O subsystem configuration"

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

