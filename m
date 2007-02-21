Return-Path: <linux-kernel-owner+w=401wt.eu-S1161202AbXBUKww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161202AbXBUKww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161210AbXBUKww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:52:52 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38452 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161202AbXBUKwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:52:51 -0500
Date: Wed, 21 Feb 2007 11:52:46 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, dedekind@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [-mm patch] MTD_UBI_DEBUG must depend on SYSFS
Message-ID: <20070221105246.GB13958@stusta.de>
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
>  git-ubi.patch
>...
>  git trees
>...


If you select an option, you have to ensure that the dependencies of all 
options you are select'ing are fulfilled.

This patch fixes the following compile error:

<--  snip  -->

...
  LD      .tmp_vmlinux1
fs/built-in.o: In function `debugfs_init':
inode.c:(.init.text+0x3621): undefined reference to `kernel_subsys'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

I've also removed the superfluous "default n".

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/drivers/mtd/ubi/Kconfig.debug.old	2007-02-20 19:57:23.000000000 +0100
+++ linux-2.6.20-mm2/drivers/mtd/ubi/Kconfig.debug	2007-02-20 19:57:51.000000000 +0100
@@ -5,7 +5,7 @@
 
 config MTD_UBI_DEBUG
 	bool "UBI debugging"
-	default n
+	depends on SYSFS
 	depends on MTD_UBI
 	select DEBUG_FS
 	select KALLSYMS_ALL

