Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab0BUOXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:23:38 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:63691 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0BUOXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:23:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GHEx0y2IHUapksV0J6axpHbkG9YUQlp92i54cBPyFaiwVlOKBZ2tZW7ku47Q3Gmp67
         lA6aRReEbh7Y2CgR2OOFH4jCQuYYwgnV6FzXIiie7UWz+adKanSgK3s5mHZ7ZPfp9UcQ
         PbNCquKY/svYBXjEIUH6zhWPMi92OZxnznxbs=
Date: Sun, 21 Feb 2010 22:23:25 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: [PATCH -mm 05/17] sysctl extern cleanup - mm
Message-ID: <20100221142325.GA3006@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move min_free_kbytes extern declaration to linux/mmzone.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/mmzone.h |    1 +
 kernel/sysctl.c        |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/mmzone.h	2010-02-21 09:50:34.007270577 +0800
+++ linux-2.6.32/include/linux/mmzone.h	2010-02-21 09:52:21.259760505 +0800
@@ -744,6 +744,7 @@ static inline int is_dma(struct zone *zo
 struct ctl_table;
 int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
+extern int min_free_kbytes; /* for sysctl */
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 09:48:06.843951983 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 09:52:58.139756932 +0800
@@ -72,7 +72,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-extern int min_free_kbytes;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
