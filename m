Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYBFQY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYBFQY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYBFQYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:24:47 -0500
Received: from waste.org ([66.93.16.53]:53883 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbYBFQYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:24:47 -0500
Subject: Re: blackfin compile error
From: Matt Mackall <mpm@selenic.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: bryan.wu@analog.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080206151830.GI505@cs181133002.pp.htv.fi>
References: <20080206151830.GI505@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 10:23:35 -0600
Message-Id: <1202315015.17934.242.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-06 at 17:18 +0200, Adrian Bunk wrote:
> Commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773 broke blackfin:
> 
> <--  snip  -->
> 
> ...
>   CC      mm/vmscan.o
> In file included from 
> /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/vmscan.c:44:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h: In function 'is_swap_pte':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_none'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_present'
> make[2]: *** [mm/vmscan.o] Error 1

This suggests that no one's tried to compile -mm on Blackfin since
before September, I think.

Is there somewhere more appropriate to move it? I can't find one.
Failing that, we can wrap it in CONFIG_MMU, I suppose.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 50a6e531a9f2 include/linux/swapops.h
--- a/include/linux/swapops.h	Mon Feb 04 20:23:02 2008 -0600
+++ b/include/linux/swapops.h	Wed Feb 06 10:21:32 2008 -0600
@@ -42,11 +42,13 @@
 	return entry.val & SWP_OFFSET_MASK(entry);
 }
 
+#ifdef CONFIG_MMU
 /* check whether a pte points to a swap entry */
 static inline int is_swap_pte(pte_t pte)
 {
 	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
 }
+#endif
 
 /*
  * Convert the arch-dependent pte representation of a swp_entry_t into an

-- 
Mathematics is the supreme nostalgia of our time.

