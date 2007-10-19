Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbXJSLVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbXJSLVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXJSLUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:20:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35062 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754950AbXJSLUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:20:45 -0400
Date: Fri, 19 Oct 2007 04:20:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: SLUB: Avoid atomic operation for slab_unlock
In-Reply-To: <200710190949.01019.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710190420180.29352@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0710181514310.3584@schroedinger.engr.sgi.com>
 <200710190949.01019.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Christoph Lameter <clameter@sgi.com>


Slub can use the non-atomic version to unlock because other flags will not
get modified with the lock held.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1185,7 +1185,7 @@ static __always_inline void slab_lock(st
 
 static __always_inline void slab_unlock(struct page *page)
 {
-	bit_spin_unlock(PG_locked, &page->flags);
+	__bit_spin_unlock(PG_locked, &page->flags);
 }
 
 static __always_inline int slab_trylock(struct page *page)

