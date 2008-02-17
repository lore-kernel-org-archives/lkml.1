Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYBQM1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYBQM1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbYBQMXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:13 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38359 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 21/27] x86: fix section mismatch in srat_64.c:reserve_hotadd
Date: Sun, 17 Feb 2008 13:22:58 +0100
Message-Id: <1203250984-11285-21-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x388cc): Section mismatch in reference from the function reserve_hotadd() to the function .init.text:absent_pages_in_range()

reserve_hotadd() are only used by __init acpi_numa_memory_affinity_init().
Annotate reserve_hotadd() with __init is the trivial fix.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/srat_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index ecd91ea..70eb153 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -166,7 +166,7 @@ static inline int save_add_info(void) {return 0;}
  * Both SPARSE and RESERVE need nodes_add information.
  * This code supports one contiguous hot add area per node.
  */
-static int reserve_hotadd(int node, unsigned long start, unsigned long end)
+static int __init reserve_hotadd(int node, unsigned long start, unsigned long end)
 {
 	unsigned long s_pfn = start >> PAGE_SHIFT;
 	unsigned long e_pfn = end >> PAGE_SHIFT;
-- 
1.5.4.rc3.14.g44397

