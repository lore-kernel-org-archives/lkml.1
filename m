Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbYG0BZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbYG0BZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbYG0BZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:25:10 -0400
Received: from mo30.po.2iij.net ([210.128.50.53]:8611 "EHLO mo30.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820AbYG0BZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:25:09 -0400
Date: Sun, 27 Jul 2008 10:24:33 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix arch_pick_mmap_layout() build error
Message-Id: <20080727102433.e28d858b.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uninline arch_pick_mmap_layout()[16d69265b930f7e2fa9eea381715696f780718f4]
has forgotten to add #include <linux/sched.h>.

mm/util.c: In function 'arch_pick_mmap_layout':
mm/util.c:145: error: 'arch_get_unmapped_area' undeclared (first use in this function)
mm/util.c:145: error: (Each undeclared identifier is reported only once
mm/util.c:145: error: for each function it appears in.)
mm/util.c:146: error: 'arch_unmap_area' undeclared (first use in this function)
make[1]: *** [mm/util.o] Error 1

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/mm/util.c linux/mm/util.c
--- linux-orig/mm/util.c	2008-07-27 09:58:16.643441756 +0900
+++ linux/mm/util.c	2008-07-27 10:02:26.069593850 +0900
@@ -1,4 +1,5 @@
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/module.h>

