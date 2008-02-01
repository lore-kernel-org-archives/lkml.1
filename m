Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbYBAJtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbYBAJtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYBAJs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:48:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51660 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbYBAJs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:48:56 -0500
Date: Fri, 1 Feb 2008 10:48:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>, heiko.carstens@de.ibm.com,
       linux390@de.ibm.com
Subject: Re: x86 arch updates also broke s390
Message-ID: <20080201094839.GA29836@elte.hu>
References: <20080130011550.GA31853@elte.hu> <20080131003310.GW29368@does.not.exist> <1201772094.18221.32.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201772094.18221.32.camel@localhost>
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


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> Defining GENERIC_LOCKBREAK in arch/s390/Kconfig takes care of it. I'll 
> cook up a patch and queue it in git390.

the one below should do the trick.

	Ingo

----------------->
Subject: s390: enable GENERIC_LOCKBREAK
From: Ingo Molnar <mingo@elte.hu>

the recent need_lockbreak cleanups broke s390 build: enable
GENERIC_LOCKBREAK.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/s390/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/arch/s390/Kconfig
===================================================================
--- linux.orig/arch/s390/Kconfig
+++ linux/arch/s390/Kconfig
@@ -22,6 +22,9 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
 
+config GENERIC_LOCKBREAK
+	def_bool y
+
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
