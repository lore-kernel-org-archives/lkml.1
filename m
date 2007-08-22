Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbXHVIyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbXHVIyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbXHVIwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:35 -0400
Received: from 1wt.eu ([62.212.114.60]:1895 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280AbXHVIwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:33 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083947.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:53 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 09/58] Sparc64 bootup assembler bug
Content-Disposition: inline; filename=0009-Sparc64-bootup-assembler-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[SPARC64]: Fix two year old bug in early bootup asm.

We try to fetch the CIF entry pointer from %o4, but that
can get clobbered by the early OBP calls.  It is saved
in %l7 already, so actually this "mov %o4, %l7" can just
be completely removed with no other changes.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/sparc64/kernel/head.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/sparc64/kernel/head.S b/arch/sparc64/kernel/head.S
index 06459ae..0e19369 100644
--- a/arch/sparc64/kernel/head.S
+++ b/arch/sparc64/kernel/head.S
@@ -458,7 +458,6 @@ tlb_fixup_done:
 	or	%g6, %lo(init_thread_union), %g6
 	ldx	[%g6 + TI_TASK], %g4
 	mov	%sp, %l6
-	mov	%o4, %l7
 
 	wr	%g0, ASI_P, %asi
 	mov	1, %g1
-- 
1.5.2.5

-- 
