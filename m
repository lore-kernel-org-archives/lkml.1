Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZCCKzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZCCKzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 05:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZCCKzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 05:55:10 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43132 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZCCKzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 05:55:09 -0500
Subject: [PATCH 1/2] x86: move __VMALLOC_RESERVE to pgtable_32.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2009 12:55:04 +0200
Message-Id: <1236077704.2675.4.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: cleanup

The __VMALLOC_RESERVE global variable is not used in init_32.c. Move that to
pgtable_32.c to reduce the diff between init_32.c and init_64.c.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c    |    2 --
 arch/x86/mm/pgtable_32.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2cef050..1a2e193 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -51,8 +51,6 @@
 #include <asm/cacheflush.h>
 #include <asm/smp.h>
 
-unsigned int __VMALLOC_RESERVE = 128 << 20;
-
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 0951db9..e4032c8 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -20,6 +20,8 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
+unsigned int __VMALLOC_RESERVE = 128 << 20;
+
 /*
  * Associate a virtual page frame with a given physical page frame 
  * and protection flags for that frame.
-- 
1.5.4.3



