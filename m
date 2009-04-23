Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZDWM4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZDWM4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZDWM4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:56:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34731 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZDWM4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:56:13 -0400
Date: Thu, 23 Apr 2009 22:56:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] powerpc: fix for long standing bug noticed by gcc 4.4.0
Message-Id: <20090423225611.d569764c.sfr@canb.auug.org.au>
In-Reply-To: <20090423103336.GA3825@zod.rchland.ibm.com>
References: <20090423160656.fac84e3f.sfr@canb.auug.org.au>
	<20090423103336.GA3825@zod.rchland.ibm.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous gcc versions didn't notice this because one of the preceding
#ifs always evaluated to true.

gcc 4.4.0 produced this error:

arch/powerpc/mm/tlb_nohash_low.S:206:6: error: #elif with no expression

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
---
 arch/powerpc/mm/tlb_nohash_low.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

v2: fixed up commit message, added Josh'd Ack.

diff --git a/arch/powerpc/mm/tlb_nohash_low.S b/arch/powerpc/mm/tlb_nohash_low.S
index 45fed36..21e1b9a 100644
--- a/arch/powerpc/mm/tlb_nohash_low.S
+++ b/arch/powerpc/mm/tlb_nohash_low.S
@@ -203,6 +203,6 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_USE_TLBILX)
 	isync
 1:	wrtee	r10
 	blr
-#elif
+#else
 #error Unsupported processor type !
 #endif
-- 
1.6.2.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
