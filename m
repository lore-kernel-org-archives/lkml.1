Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbXKKA45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbXKKA45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXKKA4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:56:50 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39834 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbXKKA4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:56:49 -0500
Date: Sat, 10 Nov 2007 19:54:51 -0500
Message-Id: <200711110054.lAB0spwl017395@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Adam Litke <agl@us.ibm.com>, Ken Chen <kenchen@google.com>,
       David Gibson <hermes@gibson.dropbear.id.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm/memory.c follow_hugetlb_page compiler error (MMOTM)
Cc: linux-kernel@vger.kernel.org
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Using http://userweb.kernel.org/~akpm/mmotm/ timestamped "10-Nov-2007
22:46". CONFIG_HUGETLB_PAGE not set.

$ make
  CC      mm/memory.o
mm/memory.c:1040:29: error: macro "follow_hugetlb_page" passed 8 arguments, but takes just 7
mm/memory.c: In function 'get_user_pages':
mm/memory.c:1039: error: 'follow_hugetlb_page' undeclared (first use in this function)
mm/memory.c:1039: error: (Each undeclared identifier is reported only once
mm/memory.c:1039: error: for each function it appears in.)
make[1]: *** [mm/memory.o] Error 1
make: *** [mm] Error 2

Small patch below fixes compile error.

Erez.


Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index bb03660..2496879 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -106,7 +106,7 @@ static inline unsigned long hugetlb_total_pages(void)
 	return 0;
 }
 
-#define follow_hugetlb_page(m,v,p,vs,a,b,i)	({ BUG(); 0; })
+#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
 #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
 #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
