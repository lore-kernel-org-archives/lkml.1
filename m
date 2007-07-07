Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbXGGVMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbXGGVMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXGGVLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:11:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53837 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755898AbXGGVLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:11:16 -0400
Date: Sat, 7 Jul 2007 23:11:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
       Timothy Shimmin <tes@sgi.com>, David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com
Subject: [-mm patch] XFS: fix powerpc compat compile error
Message-ID: <20070707211147.GP3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
> +fix-xfs_ioc_fsbulkstat_single-and-xfs_ioc_fsinumbers-in-compat-mode.patch
>...
>  XFS stuff
>...


This patch fixes the following compile error on powerpc
with CONFIG_COMPAT=y:

<--  snip  -->

...
  CC [M]  fs/xfs/linux-2.6/xfs_ioctl32.o
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/fs/xfs/linux-2.6/xfs_ioctl32.c: In function 'xfs_ioc_bulkstat_compat':
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: 'xfs_inumbers_fmt_compat' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: for each function it appears in.)
make[3]: *** [fs/xfs/linux-2.6/xfs_ioctl32.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/fs/xfs/linux-2.6/xfs_ioctl32.c.old	2007-07-07 07:14:36.000000000 +0200
+++ linux-2.6.22-rc6-mm1/fs/xfs/linux-2.6/xfs_ioctl32.c	2007-07-07 07:14:49.000000000 +0200
@@ -153,7 +153,7 @@
 
 #else
 
-#define xfs_inumbers_fmt_compat(a, b, c, d) xfs_inumbers_fmt(a, b, c, d)
+#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
 #define _PACKED
 
 #endif

