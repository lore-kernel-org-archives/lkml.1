Return-Path: <linux-kernel-owner+w=401wt.eu-S1763208AbYCDVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763208AbYCDVdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756923AbYCDVdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:33:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42448 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581AbYCDVdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:33:06 -0500
Date: Tue, 4 Mar 2008 22:32:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: a P4 is a P6 not an i486
Message-ID: <20080304213243.GC8944@elte.hu>
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site> <20080304210111.GB31546@elte.hu> <47CDBE09.3060000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CDBE09.3060000@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

>>> P4 has been coming out as CPU_FAMILY=4 instead of 6: fix MPENTIUM4 
>>> typo.
>>
>> thanks Hugh, applied.
>
> The patch is correct, obviously; the comment is not: the real comment 
> should be:
>
> Enable the use of P6 NOPs on Pentium 4
>
> The CPU_FAMILY field is really the minimum CPU family that can boot 
> the kernel (that's why there is no 5; we don't have any i586 family 
> dependencies not encoded by CPUID bits.)

yeah, i've updated the commit. (find it below)

	Ingo

----------->
Subject: x86: enable the use of P6 NOPs on Pentium 4
From: Hugh Dickins <hugh@veritas.com>
Date: Tue, 4 Mar 2008 19:33:24 +0000 (GMT)

fix MPENTIUM4 typo - it resulted in P4s using less optimal NOPs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/Kconfig.cpu
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig.cpu
+++ linux-x86.q/arch/x86/Kconfig.cpu
@@ -388,7 +388,7 @@ config X86_OOSTORE
 #
 config X86_P6_NOP
 	def_bool y
-	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || PENTIUM4)
+	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4)
 
 config X86_TSC
 	def_bool y
