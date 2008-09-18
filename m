Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYIRJ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYIRJ5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYIRJ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:57:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbYIRJ52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:57:28 -0400
Date: Thu, 18 Sep 2008 11:57:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
Message-ID: <20080918095710.GA11633@elte.hu>
References: <48D21BA3.76E4.0078.0@novell.com> <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu> <48D23BF6.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D23BF6.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> I'm really sorry for that, yet another merge oversight (not caught 
> because only re-tested on x86-64). Here's a better one.

ah, i see, the delta below. Nasty.

	Ingo

------------->
 arch/x86/mm/ioremap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 8703468..63fb796 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -22,7 +22,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pat.h>
 
-static inline int phys_addr_valid(unsigned long addr)
+static inline int phys_addr_valid(resource_size_t addr)
 {
 #ifdef CONFIG_RESOURCES_64BIT
 	return !(addr >> boot_cpu_data.x86_phys_bits);
