Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbYBAJ5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbYBAJ5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbYBAJxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55857 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758345AbYBAJxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:34 -0500
Date: Fri, 1 Feb 2008 10:52:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>, heiko.carstens@de.ibm.com,
       linux390@de.ibm.com
Subject: Re: x86 arch updates also broke s390
Message-ID: <20080201095252.GA30229@elte.hu>
References: <20080130011550.GA31853@elte.hu> <20080131003310.GW29368@does.not.exist> <1201772094.18221.32.camel@localhost> <20080201094839.GA29836@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201094839.GA29836@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Defining GENERIC_LOCKBREAK in arch/s390/Kconfig takes care of it. 
> > I'll cook up a patch and queue it in git390.
> 
> the one below should do the trick.

ah, i see the one you queued up (below) is even better :)

	Ingo

------------->
Subject: [PATCH] Define GENERIC_LOCKBREAK.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Fix compile error:

  CC      arch/s390/kernel/asm-offsets.s
In file included from 
arch/s390/kernel/asm-offsets.c:7:
include/linux/sched.h: In function 'spin_needbreak':
include/linux/sched.h:1931: error: implicit declaration of function '__raw_spin_is_contended'
make[2]: *** [arch/s390/kernel/asm-offsets.s] Error 1

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

diff -urpN linux-2.6/arch/s390/Kconfig linux-2.6-patched/arch/s390/Kconfig
--- linux-2.6/arch/s390/Kconfig	2008-01-31 13:57:33.000000000 +0100
+++ linux-2.6-patched/arch/s390/Kconfig	2008-01-31 13:57:42.000000000 +0100
@@ -47,6 +47,11 @@ config NO_IOMEM
 config NO_DMA
 	def_bool y
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
