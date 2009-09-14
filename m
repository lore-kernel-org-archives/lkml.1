Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbZINULs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbZINULs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932538AbZINUJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54158 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933643AbZINUI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 56/72] Blackfin: Fix link errors with binutils 2.19 and GCC 4.3
Date: Mon, 14 Sep 2009 16:08:00 -0400
Message-Id: <1252958896-25150-57-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

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

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
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
-- 
1.6.4.2

