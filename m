Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYHMOPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYHMOPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYHMOPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:15:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbYHMOPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:15:31 -0400
Date: Wed, 13 Aug 2008 16:15:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] enable sparsemem without CONFIG_NUMA
Message-ID: <20080813141517.GC19397@elte.hu>
References: <Pine.LNX.4.64.0808130126250.9140@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808130126250.9140@boston.corp.fedex.com>
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


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> Linus,
>
> While testing for more than 8 cpus, I couldn't select sparsemem when 
> CONFIG_X86_GENERICARCH is selected instead of CONFIG_X86_PC.
>
> Here's a patch to enable sparsemem independent of NUMA instead of just 
> flatmem ... unless there a reason for sparsemem to depend on NUMA for 
> more than 8 CPUs?

note, i already queued this up in tip/x86/defconfig two days ago, for 
v2.6.28.

	Ingo

---------------------->
>From 99809963c99e1ed868d9ebeb4a5e7ee1cbe0309f Mon Sep 17 00:00:00 2001
From: Jeff Chua <jeff.chua.linux@gmail.com>
Date: Wed, 6 Aug 2008 19:09:53 +0800
Subject: [PATCH] x86: make sparsemem more available

With CONFIG_X86_PC, I can set CONFIG_SPARSEMEM=y.

With CONFIG_X86_GENERICARCH, CONFIG_SPARSEMEM depends on CONFIG_NUMA.

I'm using the patch below to enable sparsemem instead of flatmem.
System booted and is running.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7917962..e2305c7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1035,7 +1035,7 @@ config HAVE_ARCH_ALLOC_REMAP
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC && !NUMA
+	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && !NUMA
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
@@ -1051,7 +1051,7 @@ config ARCH_SPARSEMEM_DEFAULT
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC)
+	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC) || X86_GENERICARCH
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
