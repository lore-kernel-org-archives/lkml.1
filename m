Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYGNP4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYGNP4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYGNP4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:56:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43318 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbYGNP4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:56:35 -0400
Date: Mon, 14 Jul 2008 17:56:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] core/stacktrace changes for v2.6.27
Message-ID: <20080714155617.GA3320@elte.hu>
References: <20080714144420.GA21632@elte.hu> <20080715013543.398c83d9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715013543.398c83d9.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Mon, 14 Jul 2008 16:44:20 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest core/stacktrace git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/stacktrace
> 
> This presumably needs the patch I posted today against linux-next that 
> fixes the powerpc allmodconfig build.

hm - but you sent that against the generic-ipi tree :-)

but i agree - the patch is below, Linus please apply.

	Ingo

---------------->
commit 7798ed0f57b4d137e660fbf5be1e1528e40f89ac
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Jul 14 19:55:03 2008 +1000

    generic-ipi: powerpc/generic-ipi tree build failure
    
    Today's linux-next build (powerpc allmodconfig) failed like this:
    
    ERROR: ".save_stack_trace" [tests/backtracetest.ko] undefined!
    
    But save_stack_trace is exported in arch/powerpc/kernel/stacktrace.c
    
    I couldn't figure it out until I noticed these earlier warnings:
    
    arch/powerpc/kernel/stacktrace.c:47: warning: data definition has no type or storage class
    arch/powerpc/kernel/stacktrace.c:47: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
    arch/powerpc/kernel/stacktrace.c:47: warning: parameter names (without types) in function declaration
    
    I applied the patch below.
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: <linuxppc-dev@ozlabs.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/stacktrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
index 9861f17..3cf0d94 100644
--- a/arch/powerpc/kernel/stacktrace.c
+++ b/arch/powerpc/kernel/stacktrace.c
@@ -12,6 +12,7 @@
 
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
+#include <linux/module.h>
 #include <asm/ptrace.h>
 
 /*
