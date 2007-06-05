Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbXFEVvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbXFEVvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933708AbXFEVu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:50:59 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54681 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933245AbXFEVu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:50:57 -0400
Date: Tue, 5 Jun 2007 23:51:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] kernel/lockdep_proc.c: make 2 functions static
Message-ID: <20070605215100.GK5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc2-mm1:
>...
> +lockstat-human-readability-tweaks.patch
>...
>  lockstat-via-lockdep
>...

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 kernel/lockdep_proc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc3-mm1/kernel/lockdep_proc.c.old	2007-06-05 22:07:30.000000000 +0200
+++ linux-2.6.22-rc3-mm1/kernel/lockdep_proc.c	2007-06-05 22:07:57.000000000 +0200
@@ -364,7 +364,7 @@
 /*
  * sort on absolute number of contentions
  */
-int lock_stat_cmp(const void *l, const void *r)
+static int lock_stat_cmp(const void *l, const void *r)
 {
 	const struct lock_stat_data *dl = l, *dr = r;
 	unsigned long nl, nr;
@@ -567,8 +567,8 @@
 	return res;
 }
 
-ssize_t lock_stat_write(struct file *file, const char __user *buf,
-		size_t count, loff_t *ppos)
+static ssize_t lock_stat_write(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
 {
 	struct lock_class *class;
 	char c;

