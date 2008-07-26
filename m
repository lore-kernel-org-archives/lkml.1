Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYGZVXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYGZVXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 17:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbYGZVWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 17:22:53 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54982 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758068AbYGZVWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 17:22:52 -0400
Date: Sun, 27 Jul 2008 00:22:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Righi <righi.andrea@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [-mm patch] mm/util.c must #include <linux/sched.h>
Message-ID: <20080726212219.GH9301@cs181140183.pp.htv.fi>
References: <20080725083943.GC19310@cs181140183.pp.htv.fi> <20080725015537.564e3397.akpm@linux-foundation.org> <20080725091455.GD19310@cs181140183.pp.htv.fi> <20080725092748.GF19310@cs181140183.pp.htv.fi> <20080725023455.dde3eb27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080725023455.dde3eb27.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 02:34:55AM -0700, Andrew Morton wrote:
> On Fri, 25 Jul 2008 12:27:48 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Further testing revealed that you should choose a file that also gets 
> > compiled on MMU-less architectures:
> 
> We don't have one :(
> 
> I guess util.c will have to do.
>...

Requires the fix below.

cu
Adrian


<--  snip  -->


This patch fixes the following build error:

<--  snip  -->

...
  CC      mm/util.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c: In function 'arch_pick_mmap_layout':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:144: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:145: error: 'arch_get_unmapped_area' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:145: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:145: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:146: error: 'arch_unmap_area' undeclared (first use in this function)
make[2]: *** [mm/util.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f003405997b99d300c99f7b1eae408fe42c07126 
diff --git a/mm/util.c b/mm/util.c
index 0efd830..d8d0221 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -3,6 +3,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 /**

