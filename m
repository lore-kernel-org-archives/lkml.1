Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbZBJWvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbZBJWvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZBJWvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:51:33 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:51173 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754749AbZBJWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:51:33 -0500
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][BUILDERR] mm: Fix build error with !CONFIG_HUGETLBFS
Date: Tue, 10 Feb 2009 23:51:29 +0100
User-Agent: KMail/1.9.9
Cc: Mel Gorman <mel@csn.ul.ie>, Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902102351.30418.elendil@planet.nl>
X-OriginalArrivalTime: 10 Feb 2009 22:51:31.0165 (UTC) FILETIME=[1D8888D0:01C98BD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 5a6fe1259506 an extra parameter was added to hugetlb_file_setup(),
but the header file was not updated for the !CONFIG_HUGETLBFS case, which
results in:
    
ipc/shm.c:371:49: error: macro "hugetlb_file_setup" passed 3 arguments,
    but takes just 2
    
Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Mel Gorman <mel@csn.ul.ie>

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index af09660..03de70f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -159,9 +159,9 @@ static inline void set_file_hugepages(struct file *file)
 }
 #else /* !CONFIG_HUGETLBFS */
 
-#define is_file_hugepages(file)		0
-#define set_file_hugepages(file)	BUG()
-#define hugetlb_file_setup(name,size)	ERR_PTR(-ENOSYS)
+#define is_file_hugepages(file)			0
+#define set_file_hugepages(file)		BUG()
+#define hugetlb_file_setup(name,size,int)	ERR_PTR(-ENOSYS)
 
 #endif /* !CONFIG_HUGETLBFS */
 
