Return-Path: <linux-kernel-owner+w=401wt.eu-S965616AbXBTALx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965616AbXBTALx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965600AbXBTALU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:11:20 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36154 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbXBTAIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:08:11 -0500
Date: Tue, 20 Feb 2007 01:08:10 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jsipek@cs.sunysb.edu
Cc: linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: [-mm patch] UNION_FS must depend on SLAB
Message-ID: <20070220000810.GK13958@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 09:51:46PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm1:
>...
>  git-unionfs.patch
>...
>  git trees
>...


<--  snip  -->

...
  CC      fs/unionfs/copyup.o
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c: In function 'create_parents_named':
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: error: 'malloc_sizes' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: error: for each function it appears in.)
make[3]: *** [fs/unionfs/copyup.o] Error 1

<--  snip  -->


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/fs/Kconfig.old	2007-02-19 18:19:19.000000000 +0100
+++ linux-2.6.20-mm2/fs/Kconfig	2007-02-19 18:20:28.000000000 +0100
@@ -1052,7 +1052,7 @@
 
 config UNION_FS
 	tristate "Union file system (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on SLAB && EXPERIMENTAL
 	help
 	  Unionfs is a stackable unification file system, which appears to
 	  merge the contents of several directories (branches), while keeping

