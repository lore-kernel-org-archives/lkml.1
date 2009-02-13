Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbZBMMhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbZBMMhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZBMMhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:37:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38662 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZBMMhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:37:35 -0500
Date: Fri, 13 Feb 2009 13:37:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 headers: protect page_32.h via __ASSEMBLY__
Message-ID: <20090213123721.GA1879@elte.hu>
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu> <20090213122724.GA2172@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213122724.GA2172@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From beb6943d8df7ce9278282101af4e0f6f7b648451 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 13 Feb 2009 13:36:47 +0100
Subject: [PATCH] x86 headers: protect page_32.h via __ASSEMBLY__

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/page_32.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index b3f0bf7..da4e762 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -3,6 +3,8 @@
 
 #include <asm/page_32_types.h>
 
+#ifndef __ASSEMBLY__
+
 #ifdef CONFIG_HUGETLB_PAGE
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
@@ -19,8 +21,6 @@ extern unsigned long __phys_addr(unsigned long);
 #define pfn_valid(pfn)		((pfn) < max_mapnr)
 #endif /* CONFIG_FLATMEM */
 
-#ifndef __ASSEMBLY__
-
 #ifdef CONFIG_X86_USE_3DNOW
 #include <asm/mmx.h>
 

