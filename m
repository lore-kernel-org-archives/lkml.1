Return-Path: <linux-kernel-owner+w=401wt.eu-S1163323AbXD1RxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163323AbXD1RxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163319AbXD1Rw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:52:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:34437 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163316AbXD1Rw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:56 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [29/35] i386: Update  __copy_to_user_inatomic linuxdoc description
Message-Id: <20070428175254.DA5DF151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>
Explicity specify that the caller should pin the user memory
otherwise the function will sleep

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/uaccess.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux/include/asm-i386/uaccess.h
===================================================================
--- linux.orig/include/asm-i386/uaccess.h
+++ linux/include/asm-i386/uaccess.h
@@ -397,7 +397,19 @@ unsigned long __must_check __copy_from_u
 unsigned long __must_check __copy_from_user_ll_nocache_nozero(void *to,
 				const void __user *from, unsigned long n);
 
-/*
+/**
+ * __copy_to_user_inatomic: - Copy a block of data into user space, with less checking.
+ * @to:   Destination address, in user space.
+ * @from: Source address, in kernel space.
+ * @n:    Number of bytes to copy.
+ *
+ * Context: User context only.
+ *
+ * Copy data from kernel space to user space.  Caller must check
+ * the specified block with access_ok() before calling this function.
+ * The caller should also make sure he pins the user space address
+ * so that the we don't result in page fault and sleep.
+ *
  * Here we special-case 1, 2 and 4-byte copy_*_user invocations.  On a fault
  * we return the initial request size (1, 2 or 4), as copy_*_user should do.
  * If a store crosses a page boundary and gets a fault, the x86 will not write
