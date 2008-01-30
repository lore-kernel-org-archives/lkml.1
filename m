Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbYA3S2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbYA3S2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYA3S2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:28:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46508 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758926AbYA3S23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:28:29 -0500
Date: Wed, 30 Jan 2008 19:28:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 5/6] powerpc: Use generic per cpu linux-2.6.git
Message-ID: <20080130182809.GA27168@elte.hu>
References: <20080130180940.022172000@sgi.com> <20080130180940.788340000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130180940.788340000@sgi.com>
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


* travis@sgi.com <travis@sgi.com> wrote:

> Powerpc has a way to determine the address of the per cpu area of the 
> currently executing processor via the paca and the array of per cpu 
> offsets is avoided by looking up the per cpu area from the remote 
> paca's (copying x86_64).

i needed the fix below to get my powerpc crosscompile build to succeed.

	Ingo

-------------->
Subject: powerpc: percpu build fix
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-powerpc/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/include/asm-powerpc/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-powerpc/percpu.h
+++ linux-x86.q/include/asm-powerpc/percpu.h
@@ -13,7 +13,7 @@
 #include <asm/paca.h>
 
 #define __per_cpu_offset(cpu) (paca[cpu].data_offset)
-#define __my_cpu_offset() get_paca()->data_offset
+#define __my_cpu_offset get_paca()->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
 #endif /* CONFIG_SMP */
