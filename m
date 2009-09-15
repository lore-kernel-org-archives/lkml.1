Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZIOQuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZIOQuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZIOQue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:50:34 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:51427 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbZIOQue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:50:34 -0400
Date: Tue, 15 Sep 2009 12:50:37 -0400
To: linux-kernel@vger.kernel.org
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg Ungerer <gerg@uclinux.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH] Actually show KiB rather than pages in "Freeing initrd
	memory:" message on h3800, m68knommu and microblaze.
Message-ID: <20090915165037.GA23702@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "Freeing initrd memory:" message on h3800, m68knommu and microblaze
to show kilobytes as claimed rather than number of pages.

Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/arch/h8300/mm/init.c b/arch/h8300/mm/init.c
index 9942f24..3342f49 100644
--- a/arch/h8300/mm/init.c
+++ b/arch/h8300/mm/init.c
@@ -170,7 +170,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 		totalram_pages++;
 		pages++;
 	}
-	printk ("Freeing initrd memory: %dk freed\n", pages);
+	printk ("Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
 }
 #endif
 
diff --git a/arch/m68knommu/mm/init.c b/arch/m68knommu/mm/init.c
index b1703c6..f3236d0 100644
--- a/arch/m68knommu/mm/init.c
+++ b/arch/m68knommu/mm/init.c
@@ -162,7 +162,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 		totalram_pages++;
 		pages++;
 	}
-	printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
+	printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
 }
 #endif
 
diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index f207f1a..ed5f96b 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -180,7 +180,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 		totalram_pages++;
 		pages++;
 	}
-	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
+	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
 }
 #endif
 
