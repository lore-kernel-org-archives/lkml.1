Return-Path: <linux-kernel-owner+w=401wt.eu-S1759162AbZHRO6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162AbZHRO6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZHRO6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:58:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35668 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZHRO6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:58:09 -0400
Date: Tue, 18 Aug 2009 16:58:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] Blackfin: Fix link errors with binutils 2.19 and GCC 4.3
Message-ID: <20090818145801.GA32343@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not sure whether this has been reported/fixed before.

Today I built a Blackfin tool-chain from scratch for -tip testing, 
and it triggers:

  arch/blackfin/kernel/vmlinux.lds:1238: undefined section `.data_a_l1' referenced in expression

and:

  arch/blackfin/kernel/vmlinux.lds:1238: undefined section `.text_data_l1'
referenced in expression

Now i dont have any way to test this linker script, but it now at 
least builds fine after fixing what appears to be typos in those 
assert statements.

Cc: Mike Frysinger <vapier@gentoo.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/blackfin/kernel/vmlinux.lds.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 6ac307c..77f8659 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -221,7 +221,7 @@ SECTIONS
 		. = ALIGN(4);
 		__ebss_l1 = .;
 	}
-	ASSERT (SIZEOF(.data_a_l1) <= L1_DATA_A_LENGTH, "L1 data A overflow!")
+	ASSERT (SIZEOF(.data_l1) <= L1_DATA_A_LENGTH, "L1 data A overflow!")
 
 	.data_b_l1 L1_DATA_B_START : AT(LOADADDR(.data_l1) + SIZEOF(.data_l1))
 	{
@@ -262,7 +262,7 @@ SECTIONS
 		. = ALIGN(4);
 		__ebss_l2 = .;
 	}
-	ASSERT (SIZEOF(.text_data_l1) <= L2_LENGTH, "L2 overflow!")
+	ASSERT (SIZEOF(.text_data_l2) <= L2_LENGTH, "L2 overflow!")
 
 	/* Force trailing alignment of our init section so that when we
 	 * free our init memory, we don't leave behind a partial page.
