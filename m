Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbZIQPtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbZIQPtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbZIQPti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:49:38 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52763 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728AbZIQPth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:49:37 -0400
Date: Thu, 17 Sep 2009 11:49:41 -0400
To: linux-kernel@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH] Actually show KiB rather than pages in "Freeing initrd
	memory:" message on m68knommu.
Message-ID: <20090917154941.GG23702@csclub.uwaterloo.ca>
References: <20090915165037.GA23702@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915165037.GA23702@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "Freeing initrd memory:" message m68knommu to show kilobytes as
claimed rather than number of pages.

Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

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
 
-- 
Len Sorensen
