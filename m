Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753365AbYLRVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYLRVMT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 16:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYLRVMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:12:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbYLRVMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:12:03 -0500
Date: Thu, 18 Dec 2008 22:11:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: process.c declare c1e_remove_cpu before they get
	used
Message-ID: <20081218211141.GD24271@elte.hu>
References: <1229536205.23068.6.camel@jaswinder.satnam> <20081218123613.GE25715@elte.hu> <1229625459.3197.5.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229625459.3197.5.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> On Thu, 2008-12-18 at 13:36 +0100, Ingo Molnar wrote:
> 
> > hm, why is this needed? Have you seen a compiler warning?
> > 
> 
> I was getting :
> 
>   CHECK   arch/x86/kernel/process.c
> arch/x86/kernel/process.c:284:6: warning: symbol 'c1e_remove_cpu' was not declared. Should it be static?
> 
> Thank you,

ah, good. Feel free to include such information in future patches. I've 
applied your patch to tip/x86/cleanups, thanks! See below how the final 
commit looks like - added the sparse warning as well.

	Ingo

--------------->
>From f0bc2202e0373eb8e9b1ddbec930e2e681357db8 Mon Sep 17 00:00:00 2001
From: Jaswinder Singh <jaswinder@infradead.org>
Date: Wed, 17 Dec 2008 23:20:05 +0530
Subject: [PATCH] x86: process.c declare c1e_remove_cpu before they get used

Impact: cleanup, avoid sparse warning

Included asm/idle.h for c1e_remove_cpu() declaration. Fixes this
sparse warning:

  CHECK   arch/x86/kernel/process.c
  arch/x86/kernel/process.c:284:6: warning: symbol 'c1e_remove_cpu' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c622772..b06100f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -1,6 +1,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <asm/idle.h>
 #include <linux/smp.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
