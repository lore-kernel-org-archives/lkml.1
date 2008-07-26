Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbYGZJRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbYGZJRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYGZJRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:17:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYGZJRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:17:09 -0400
Date: Sat, 26 Jul 2008 11:16:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] hugetlbfs: fix build failure on 64-bit x86
Message-ID: <20080726091654.GA18341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


[resend, still relevant to -git]

>From 5215af24a20e5f448ee45cd1d97c4118b876c0f6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 25 Jul 2008 20:45:52 +0200
Subject: [PATCH] hugetlbfs: fix build failure on 64-bit x86

fix:

 arch/x86/mm/built-in.o: In function `setup_hugepagesz':
 hugetlbpage.c:(.init.text+0xb49): undefined reference to `hugetlb_add_hstate'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/hugetlbpage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 8f307d9..977d185 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -425,7 +425,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 
 #endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && defined(CONFIG_SYSCTL)
 static __init int setup_hugepagesz(char *opt)
 {
 	unsigned long ps = memparse(opt, &opt);
