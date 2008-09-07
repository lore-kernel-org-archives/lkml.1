Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYIGW0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYIGW0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYIGWYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:24:18 -0400
Received: from gw.goop.org ([64.81.55.164]:39672 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbYIGWYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:24:15 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 7] x86-64: don't check for map replacement
X-Mercurial-Node: 5c6de0fa4ee3a72a0ab5d72af1de7f13e5119be0
Message-Id: <5c6de0fa4ee3a72a0ab5.1220826077@localhost>
In-Reply-To: <patchbomb.1220826072@localhost>
Date: Sun, 07 Sep 2008 15:21:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check prevents flags on mappings from being changed, which is not
desireable.  There's no need to check for replacing a mapping, and
x86-32 does not do this check.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -195,9 +195,6 @@
 	}
 
 	pte = pte_offset_kernel(pmd, vaddr);
-	if (!pte_none(*pte) && pte_val(new_pte) &&
-	    pte_val(*pte) != (pte_val(new_pte) & __supported_pte_mask))
-		pte_ERROR(*pte);
 	set_pte(pte, new_pte);
 
 	/*


