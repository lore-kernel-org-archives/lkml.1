Return-Path: <linux-kernel-owner+w=401wt.eu-S1762166AbYBHVnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166AbYBHVnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761359AbYBHVmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:42:24 -0500
Received: from waste.org ([66.93.16.53]:45391 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761256AbYBHVmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:42:21 -0500
Subject: Re: [PATCH] stub out is_swap_pte for !MMU
From: Matt Mackall <mpm@selenic.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200802081625.12893.vapier@gentoo.org>
References: <1202500959-2727-1-git-send-email-vapier@gentoo.org>
	 <1202503750.17934.639.camel@cinder.waste.org>
	 <200802081625.12893.vapier@gentoo.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 15:41:42 -0600
Message-Id: <1202506903.17934.653.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 16:25 -0500, Mike Frysinger wrote:
> On Friday 08 February 2008, Matt Mackall wrote:
> > On Fri, 2008-02-08 at 15:02 -0500, Mike Frysinger wrote:
> > > With commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773, swap_pte() was
> > > moved into view of both MMU and !MMU, but uses functions only provided by
> > > MMU. Here we stub out the function for !MMU ports.
> >
> > I'm not sure if this is right compared to my original patch. Does it
> > ever make sense to ask "is this pte a swap entry?" on a machine with no
> > MMU? Presumably this also means it has no ptes too, right? In which
> > case, it's better to comment the whole function out. Then when someone
> > tries to ask the above meaningless question, they get a compile error
> > rather than a meaningless answer.
> 
> honestly, doesnt matter to me since none of the code that currently utilizes 
> this function is used in no-mmu context.  if you want to just put the whole 
> thing in CONFIG_MMU, then go for it.

Here it is again, I'll leave it up to Andrew:

Fix compile error on nommu for is_swap_pte

Does it ever make sense to ask "is this pte a swap entry?" on a machine
with no MMU? Presumably this also means it has no ptes too, right? In
which case, it's better to comment the whole function out. Then when
someone tries to ask the above meaningless question, they get a compile
error rather than a meaningless answer.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 50a6e531a9f2 include/linux/swapops.h
--- a/include/linux/swapops.h	Mon Feb 04 20:23:02 2008 -0600
+++ b/include/linux/swapops.h	Fri Feb 08 15:38:01 2008 -0600
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

