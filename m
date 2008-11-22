Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYKVMba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYKVMba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbYKVMbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:31:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:32113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbYKVMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=bxwOFe94mnVxnuwnCNRGTVk6o9C8NXVQVNkgp8f8kCX5BviIvkjjrbyAgfvTBhKHmF
         IfEsayNaErkojVZDc4Ia6lKECHf7wPcC5Ow3vP42/7nT+M3UsvVJJVHFh8MNXtc86Ql3
         7p4zNqnz4LGWngDGuKqMLwwXGRtM3AjB+xRcI=
Date: Sat, 22 Nov 2008 13:32:31 +0100
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] SLUB: use page allocator for PAGE_SIZE requests
Message-ID: <20081122123230.GA27189@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4d526db4781aaab86cb79ff8135bb0e2bc560598 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 22 Nov 2008 13:27:54 +0100
Subject: [PATCH] SLUB: use page allocator for PAGE_SIZE requests

It seems strange that we should use the page allocator for
requests of (PAGE_SIZE + 1) bytes or more, and not for requests
that are exactly PAGE_SIZE.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/slub_def.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 2f5c16b..62ce0dc 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -212,7 +212,7 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
-		if (size > PAGE_SIZE)
+		if (size >= PAGE_SIZE)
 			return kmalloc_large(size, flags);
 
 		if (!(flags & SLUB_DMA)) {
-- 
1.5.6.5

