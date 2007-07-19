Return-Path: <linux-kernel-owner+w=401wt.eu-S965956AbXGSTVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965956AbXGSTVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965812AbXGSTU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:20:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965805AbXGSTUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:20:24 -0400
Date: Thu, 19 Jul 2007 12:19:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: Re: kmalloc zero size changes break i386
In-Reply-To: <alpine.LFD.0.999.0707191107570.27353@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707191218470.27353@woody.linux-foundation.org>
References: <200707191201.35777.ak@suse.de> <84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com>
 <adamyxsfmnc.fsf@cisco.com>
 <alpine.LFD.0.999.0707191107570.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, Linus Torvalds wrote:
> 
> Does something like this fix it?
> 
> Christoph, please go over this and see if there are other cases like that.

Actually, here's a better version, I think.

Andi, does this patch fix your problem?

		Linus
---
 mm/slab.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 88bc633..c3feeaa 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3690,8 +3690,8 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 	 * functions.
 	 */
 	cachep = __find_general_cachep(size, flags);
-	if (unlikely(cachep == NULL))
-		return NULL;
+	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
+		return cachep;
 	return __cache_alloc(cachep, flags, caller);
 }
 
