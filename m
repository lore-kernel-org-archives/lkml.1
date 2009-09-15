Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbZIOVUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbZIOVUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZIOVT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:19:59 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:27617 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbZIOVT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:19:59 -0400
X-Trace: 259141085/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYHACuhr0pPRVRK/2dsb2JhbACBU45rAc96hBcF
X-IronPort-AV: E=Sophos;i="4.44,392,1249254000"; 
   d="scan'208";a="259141085"
Date: Tue, 15 Sep 2009 22:19:07 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH] hwpoison: fix uninitialized warning
Message-ID: <Pine.LNX.4.64.0909152206220.28874@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix mmotm build warning, presumably also in linux-next:
mm/memory.c: In function `do_swap_page':
mm/memory.c:2498: warning: `pte' may be used uninitialized in this function

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
I've only noticed this warning on one machine, the powerpc: certainly it
needs CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE to see it, but I thought
I had one of those set on other machines - just musing in case it's being
masked elsewhere by some other bug...

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm/mm/memory.c	2009-09-14 16:34:37.000000000 +0100
+++ linux/mm/memory.c	2009-09-15 22:00:48.000000000 +0100
@@ -2495,7 +2495,7 @@ static int do_swap_page(struct mm_struct
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
 		} else {
-			print_bad_pte(vma, address, pte, NULL);
+			print_bad_pte(vma, address, orig_pte, NULL);
 			ret = VM_FAULT_OOM;
 		}
 		goto out;
