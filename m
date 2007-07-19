Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbXGSUQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbXGSUQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761325AbXGSUQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:16:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760576AbXGSUPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:19 -0400
Date: Thu, 19 Jul 2007 13:09:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] slub crashes with recent -git
In-Reply-To: <20070719194234.GA27917@elte.hu>
Message-ID: <alpine.LFD.0.999.0707191307220.27249@woody.linux-foundation.org>
References: <20070719194234.GA27917@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, Ingo Molnar wrote:
> 
> i had to apply the patch below to make the kernel boot again.

A better patch should be the appended. Does that work for you too?

		Linus
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 52a4f44..322f3a5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2394,7 +2394,7 @@ size_t ksize(const void *object)
 	struct page *page;
 	struct kmem_cache *s;
 
-	if (object == ZERO_SIZE_PTR)
+	if (ZERO_OR_NULL_PTR(object))
 		return 0;
 
 	page = get_object_page(object);
