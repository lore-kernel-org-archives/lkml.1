Return-Path: <linux-kernel-owner+w=401wt.eu-S934956AbZLQBdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934956AbZLQBdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935986AbZLQBcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:32:35 -0500
Received: from kroah.org ([198.145.64.141]:48064 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763659AbZLQBUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:42 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:05 2009
Message-Id: <20091217011605.553623715@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [58/90] sparc64: Fix definition of VMEMMAP_SIZE.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit bffbc94a4d2c1769c3826fceddd2dbb75e72c80b ]

This was the cause of various boot failures on V480, V880, etc.
systems.

Kernel image memory was being overwritten because the vmemmap[]
array was being sized to small.  So if you had physical memory
addresses past a certain point, the early bootup would spam
all over variables in the kernel data section.

The vmemmap mappings map page structs, not page struct pointers.
And that was the key thinko in the macro definition.

This was fixable thanks to the help, reports, and tireless patience
of Hermann Lauer.

Reported-by: Hermann Lauer <Hermann.Lauer@iwr.uni-heidelberg.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/mm/init_64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/mm/init_64.h
+++ b/arch/sparc/mm/init_64.h
@@ -45,7 +45,7 @@ extern void free_initmem(void);
 #define VMEMMAP_ALIGN(x)	(((x)+VMEMMAP_CHUNK-1UL)&VMEMMAP_CHUNK_MASK)
 
 #define VMEMMAP_SIZE	((((1UL << MAX_PHYSADDR_BITS) >> PAGE_SHIFT) * \
-			  sizeof(struct page *)) >> VMEMMAP_CHUNK_SHIFT)
+			  sizeof(struct page)) >> VMEMMAP_CHUNK_SHIFT)
 extern unsigned long vmemmap_table[VMEMMAP_SIZE];
 #endif
 


