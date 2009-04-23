Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbZDWGHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbZDWGHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZDWGHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:07:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44740 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbZDWGHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:07:07 -0400
Date: Thu, 23 Apr 2009 16:06:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: linux-next@vger.kernel.org, <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: upstream tree build failure
Message-Id: <20090423160656.fac84e3f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

[I am now using gcc version 4.4.0 ...]

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

arch/powerpc/mm/tlb_nohash_low.S:206:6: error: #elif with no expression

Previous gcc versions didn't notice this because one of the preceding
#ifs always evaluated to true.  I have applied the following patch for today.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 23 Apr 2009 16:00:47 +1000
Subject: [PATCH] powerpc: fix for long standing bug noticed by gcc 4.4.0

Previous gcc versions didn't notice this because one of the preceding

gcc 4.4.0 produced this error:

arch/powerpc/mm/tlb_nohash_low.S:206:6: error: #elif with no expression

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/mm/tlb_nohash_low.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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

