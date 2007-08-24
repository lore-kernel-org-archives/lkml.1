Return-Path: <linux-kernel-owner+w=401wt.eu-S934351AbXHXAmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbXHXAmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765341AbXHXAma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:42:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:29016 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764243AbXHXAm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=LvGz2Lyvi9/cHy+NEII11NnrNR2gbFqkSwVoFQF+zOYpaoou8cLSdghaPGRkRyy+3S92Yw3+w+212DO+cNNEt8E4PP6AAN8NNEwkkuzaFzWLj7vtO9wtT3ZwepMOeVmQy/RHIl9Xuvi+1HYWzv7plnhrx+13CilyvvOoXWt/UeI=
Message-Id: <7a2e58dc05b356f27313d4a116eb92fbe2bb828e.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:39:35 +0200
Subject: [PATCH 29/30] mm: No need to cast vmalloc() return value in zone_wait_table_init()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns a void pointer, so there's no need to cast its
return value in mm/page_alloc.c::zone_wait_table_init().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6427653..a8615c2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2442,7 +2442,7 @@ int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
 		 * To use this new node's memory, further consideration will be
 		 * necessary.
 		 */
-		zone->wait_table = (wait_queue_head_t *)vmalloc(alloc_size);
+		zone->wait_table = vmalloc(alloc_size);
 	}
 	if (!zone->wait_table)
 		return -ENOMEM;
-- 
1.5.2.2

