Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbZAUJfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbZAUJfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZAUJfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:35:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46972 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZAUJfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:35:25 -0500
Date: Wed, 21 Jan 2009 10:35:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, brgerst@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHSET linux-2.6-x86:core/percpu] x86: misc clean up and
	unify x86_32/64 code paths
Message-ID: <20090121093509.GA31613@elte.hu>
References: <1232527578-1960-1-git-send-email-tj@kernel.org> <20090121092633.GA22506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090121092633.GA22506@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> -tip testing also stumbled upon a build error caused by the UV cleanups 
> - see the fix below.

another detail is fixed below.

	Ingo

--------------->
>From 3b8f6278445384836f2739462b7964f21fbaa44f Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 21 Jan 2009 10:32:44 +0100
Subject: [PATCH] x86: make x86_32 use tlb_64.c, build fix
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Fix:

  arch/x86/mm/tlb.c:47: error: ‘CONFIG_X86_INTERNODE_CACHE_BYTES’ undeclared here (not in a function)

The CONFIG_X86_INTERNODE_CACHE_BYTES symbol is only defined on 64-bit,
because vsmp support is 64-bit only. Define it on 32-bit too - where it
will always be equal to X86_L1_CACHE_BYTES.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.cpu |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8078955..3f02f66 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -300,7 +300,6 @@ config X86_INTERNODE_CACHE_BYTES
 	int
 	default "4096" if X86_VSMP
 	default X86_L1_CACHE_BYTES if !X86_VSMP
-	depends on X86_64
 
 config X86_CMPXCHG
 	def_bool X86_64 || (X86_32 && !M386)
