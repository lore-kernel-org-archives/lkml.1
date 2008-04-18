Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYDRNhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYDRNhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYDRNhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:37:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42714 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbYDRNhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:37:04 -0400
Date: Fri, 18 Apr 2008 15:36:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Reuben Farrelly <reuben-linuxkernel@reub.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: StackProtector Oopses - Re: 2.6.25-mm1
Message-ID: <20080418133645.GF31797@elte.hu>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <48089BDE.6040100@reub.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48089BDE.6040100@reub.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:

> is enough to prevent my system booting, viz:

hm, does it boot up fine with the attached patch and stackprotector 
enabled? It appears that your system got to the self-test so 
stackprotector is working mostly - it's just that the self-test went 
wrong.

	Ingo

----------------->
Subject: x86: disable stackprotector selftest
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 18 15:21:49 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/kernel/panic.c
===================================================================
--- linux-x86.q.orig/kernel/panic.c
+++ linux-x86.q/kernel/panic.c
@@ -394,5 +394,5 @@ void __stack_chk_fail(void)
 }
 EXPORT_SYMBOL(__stack_chk_fail);
 
-late_initcall(__stack_chk_test);
+/* late_initcall(__stack_chk_test); */
 #endif
