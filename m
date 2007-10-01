Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbXJAFCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbXJAFCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXJAFBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:01:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXJAFBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:01:53 -0400
Date: Mon, 1 Oct 2007 07:01:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] MTD: fix cfi_interleave() build errors
Message-ID: <20071001050145.GA12925@elte.hu>
References: <20071001045037.GA10564@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001045037.GA10564@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, the attached .config fails with the build errors below. Kernel is 
> latest 2.6.23-git. Found via make randconfig.

the quick fix below resolves these build failures. (i guess it might be 
cleaner/safer to solve this via excluding this .config combination via 
Kconfig rules, but that looks too involved for now.)

	Ingo

---------------->
Subject: MTD: fix cfi_interleave() build errors
From: Ingo Molnar <mingo@elte.hu>

if the .config specifies no cfi_interleave() then generate a
run-time bug. This makes 'make randconfig' build tests work again.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mtd/cfi.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/include/linux/mtd/cfi.h
===================================================================
--- linux.orig/include/linux/mtd/cfi.h
+++ linux/include/linux/mtd/cfi.h
@@ -57,6 +57,10 @@
 #define cfi_interleave_is_8(cfi) (0)
 #endif
 
+#ifndef cfi_interleave
+# define cfi_interleave(cfi) ({ BUG_ON(1); 0; })
+#endif
+
 static inline int cfi_interleave_supported(int i)
 {
 	switch (i) {
