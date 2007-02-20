Return-Path: <linux-kernel-owner+w=401wt.eu-S1750982AbXBTAIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982AbXBTAIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbXBTAIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:17 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36131 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965581AbXBTAHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:54 -0500
Date: Tue, 20 Feb 2007 01:07:53 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make ipc/shm.c:shm_nopage() static
Message-ID: <20070220000753.GF13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
>...
>  Misc
>...


shm_nopage() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/ipc/shm.c.old	2007-02-18 22:58:03.000000000 +0100
+++ linux-2.6.20-mm2/ipc/shm.c	2007-02-18 22:58:18.000000000 +0100
@@ -226,8 +226,8 @@
 	mutex_unlock(&shm_ids(ns).mutex);
 }
 
-struct page *shm_nopage(struct vm_area_struct *vma, unsigned long address,
-			int *type)
+static struct page *shm_nopage(struct vm_area_struct *vma,
+			       unsigned long address, int *type)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);

