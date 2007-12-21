Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXLULMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXLULMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXLULMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:12:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45984 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbXLULMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:12:42 -0500
Date: Fri, 21 Dec 2007 12:12:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-ID: <20071221111207.GC29047@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org> <20071220145415.f737e7f3.akpm@linux-foundation.org> <20071220234759.GA29776@elte.hu> <20071220161934.0f55029a.akpm@linux-foundation.org> <20071221003035.GA10123@elte.hu> <20071220164000.58c43b42.akpm@linux-foundation.org> <20071221102727.GB22452@elte.hu> <20071221024211.f4207136.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221024211.f4207136.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I'd suggest that we add a local_read_flags() along with 
> local_save_flags(). Then I can merge the parts of the patch which 
> don't get destroyed by ongoing churn and then we can come in and clean 
> up the stragglers later.

ah, indeed.

like the patch below? (Only local_save_flags() should be used by drivers 
- but i stuck in the other variants as well for completeness.)

	Ingo

-------------------->
Subject: migration helpers for local_save_flags => local_read_flags rename
From: Ingo Molnar <mingo@elte.hu>

prepare for renaming of all local_save_flags variants to local_read_flags,
via migration helpers, as suggested by Andrew Morton.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irqflags.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-x86.q/include/linux/irqflags.h
===================================================================
--- linux-x86.q.orig/include/linux/irqflags.h
+++ linux-x86.q/include/linux/irqflags.h
@@ -93,4 +93,13 @@
 #define irqs_disabled_flags(flags)	raw_irqs_disabled_flags(flags)
 #endif		/* CONFIG_X86 */
 
+/*
+ * Migration helpers - the proper API is the local_read_flags API.
+ * Will go away in v2.6.26.
+ */
+#define local_save_flags		local_read_flags
+#define __local_save_flags		__local_read_flags
+#define raw_local_save_flags		raw_local_read_flags
+#define __raw_local_save_flags		__raw_local_read_flags
+
 #endif
