Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbZIXKCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbZIXKCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 06:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZIXKCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 06:02:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZIXKCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 06:02:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] HugeTLB: Fix unused variable warning
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: ebmunson@us.ibm.com, rientjes@google.com, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Date: Thu, 24 Sep 2009 11:02:32 +0100
Message-ID: <20090924100232.19291.70594.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an unused variable warning:

	mm/mmap.c: In function 'do_mmap_pgoff':
	mm/mmap.c:953: warning: unused variable 'user'

by converting the CONFIG_HUGETLBFS=n version of hugetlb_file_setup() into an
inline function instead of a macro.

Introduced by:

	commit 4e52780d41a741fb4861ae1df2413dd816ec11b1
	Author: Eric B Munson <ebmunson@us.ibm.com>
	Date:   Mon Sep 21 17:03:47 2009 -0700
	hugetlb: add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/hugetlb.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 176e7ee..c5d3111 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -3,6 +3,8 @@
 
 #include <linux/fs.h>
 
+struct user_struct;
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/mempolicy.h>
@@ -10,7 +12,6 @@
 #include <asm/tlbflush.h>
 
 struct ctl_table;
-struct user_struct;
 
 int PageHuge(struct page *page);
 
@@ -187,7 +188,13 @@ static inline void set_file_hugepages(struct file *file)
 
 #define is_file_hugepages(file)			0
 #define set_file_hugepages(file)		BUG()
-#define hugetlb_file_setup(name,size,acct,user,creat)	ERR_PTR(-ENOSYS)
+
+static inline
+struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag,
+				struct user_struct **user, int creat_flags)
+{
+ 	return ERR_PTR(-ENOSYS);
+}
 
 #endif /* !CONFIG_HUGETLBFS */
 

