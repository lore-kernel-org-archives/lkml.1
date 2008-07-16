Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYGPRby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYGPRby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYGPRbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:31:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:25099 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYGPRbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WVjAMiPfL0nIsONw4KbIDcvd834rBhodC/Rw3hvgkd0YuvQe3VYZMSYLSsij9/Eq7x
         TEtXjW34+O4RBpqlK5I93qf4CQ9Mb1qpw3ZQEqRvOWR5y5ws8AOhVid1q+doOlCOtNDp
         HrLU2DJlQiGXo17ZA189zh/hbziJIVpHvvfrI=
Date: Wed, 16 Jul 2008 21:29:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: cl@linux-foundation.org, penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org
Subject: SLUB: simplify re on_each_cpu()
Message-ID: <20080716172902.GA5176@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on_each_cpu() expands to function call on UP, too.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 mm/slub.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1495,15 +1495,7 @@ static void flush_cpu_slab(void *d)
 
 static void flush_all(struct kmem_cache *s)
 {
-#ifdef CONFIG_SMP
 	on_each_cpu(flush_cpu_slab, s, 1);
-#else
-	unsigned long flags;
-
-	local_irq_save(flags);
-	flush_cpu_slab(s);
-	local_irq_restore(flags);
-#endif
 }
 
 /*

