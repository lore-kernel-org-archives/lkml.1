Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbXCECBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbXCECBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXCEBto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:49:44 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49945 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751964AbXCEBtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:49:31 -0500
Date: Mon, 5 Mar 2007 02:49:32 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make fb_deferred_io_mkwrite() static
Message-ID: <20070305014932.GA3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
> +fbdev-mm-deferred-io-support.patch
>...
>  fbdev updates
>...


This patch makes the needlessly global fb_deferred_io_mkwrite() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/drivers/video/fb_defio.c.old	2007-03-04 21:55:57.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/video/fb_defio.c	2007-03-04 21:56:07.000000000 +0100
@@ -48,8 +48,8 @@
 }
 
 /* vm_ops->page_mkwrite handler */
-int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
-					struct page *page)
+static int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
+				  struct page *page)
 {
 	struct fb_info *info = vma->vm_private_data;
 	struct fb_deferred_io *fbdefio = info->fbdefio;

