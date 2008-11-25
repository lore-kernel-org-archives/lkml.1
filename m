Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYKYEbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYKYEbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYKYEbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:31:03 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47039 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYKYEbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:31:02 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: make vread() and vwrite() declaration
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081125132959.26E2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 13:30:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse output following warnings.

mm/vmalloc.c:1436:6: warning: symbol 'vread' was not declared. Should it be static?
mm/vmalloc.c:1474:6: warning: symbol 'vwrite' was not declared. Should it be static?


However, it is used by /dev/kmem. fixed here.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/char/mem.c      |    3 ---
 include/linux/vmalloc.h |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: b/drivers/char/mem.c
===================================================================
--- a/drivers/char/mem.c	2008-11-05 01:10:59.000000000 +0900
+++ b/drivers/char/mem.c	2008-11-22 22:09:49.000000000 +0900
@@ -425,9 +425,6 @@ static ssize_t read_oldmem(struct file *
 }
 #endif
 
-extern long vread(char *buf, char *addr, unsigned long count);
-extern long vwrite(char *buf, char *addr, unsigned long count);
-
 #ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
Index: b/include/linux/vmalloc.h
===================================================================
--- a/include/linux/vmalloc.h	2008-11-05 01:11:55.000000000 +0900
+++ b/include/linux/vmalloc.h	2008-11-22 22:09:28.000000000 +0900
@@ -97,6 +97,10 @@ extern void unmap_kernel_range(unsigned 
 extern struct vm_struct *alloc_vm_area(size_t size);
 extern void free_vm_area(struct vm_struct *area);
 
+/* for /dev/kmem */
+extern long vread(char *buf, char *addr, unsigned long count);
+extern long vwrite(char *buf, char *addr, unsigned long count);
+
 /*
  *	Internals.  Dont't use..
  */


