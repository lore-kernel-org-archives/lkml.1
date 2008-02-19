Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbYBSGL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbYBSGL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 01:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYBSGLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 01:11:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYBSGLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 01:11:20 -0500
Date: Tue, 19 Feb 2008 07:11:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080219061107.GA23229@elte.hu>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
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


* Torsten Kaiser <just.for.lkml@googlemail.com> wrote:

> On Feb 15, 2008 10:23 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > Ok,
> >  this kernel is a winner.
> 
> Sadly not for me:
> [ 5282.056415] ------------[ cut here ]------------
> [ 5282.059757] kernel BUG at lib/list_debug.c:33!
> [ 5282.062055] invalid opcode: 0000 [1] SMP
> [ 5282.062055] CPU 3

hm. Your crashes do seem to span multiple subsystems, but it always 
seems to be around the SLUB code. Could you try the patch below? The 
SLUB code has a new optimization and i'm not 100% sure about it. [the 
hack below switches the SLUB optimization off by disabling the CPU 
feature it relies on.]

	Ingo

------------->
 arch/x86/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -59,10 +59,6 @@ config HAVE_LATENCYTOP_SUPPORT
 config SEMAPHORE_SLEEPERS
 	def_bool y
 
-config FAST_CMPXCHG_LOCAL
-	bool
-	default y
-
 config MMU
 	def_bool y
 

