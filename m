Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbYBAJ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbYBAJ6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759331AbYBAJyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:54:16 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:41860 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759295AbYBAJyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:54:15 -0500
Subject: Re: x86 arch updates also broke s390
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>, heiko.carstens@de.ibm.com,
       linux390@de.ibm.com
In-Reply-To: <20080201094839.GA29836@elte.hu>
References: <20080130011550.GA31853@elte.hu>
	 <20080131003310.GW29368@does.not.exist>
	 <1201772094.18221.32.camel@localhost>  <20080201094839.GA29836@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 01 Feb 2008 10:54:13 +0100
Message-Id: <1201859653.27899.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-01 at 10:48 +0100, Ingo Molnar wrote:
> > Defining GENERIC_LOCKBREAK in arch/s390/Kconfig takes care of it.
> I'll 
> > cook up a patch and queue it in git390.
> 
> the one below should do the trick.

Thanks but I already queued a different one (see below). The other
architectures that define GENERIC_LOCKBREAK have the "depends on SMP &&
PREEMPT" line as well. The line does make sense if you look at the way
how spin_is_contended is used, no ?

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

---
Subject: [PATCH] Define GENERIC_LOCKBREAK.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Fix compile error:

  CC      arch/s390/kernel/asm-offsets.s
In file included from 
arch/s390/kernel/asm-offsets.c:7:
include/linux/sched.h: In function 'spin_needbreak':
include/linux/sched.h:1931: error: implicit declaration of function
'__raw_spin_is_contended'
make[2]: *** [arch/s390/kernel/asm-offsets.s] Error 1

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

diff -urpN linux-2.6/arch/s390/Kconfig
linux-2.6-patched/arch/s390/Kconfig
--- linux-2.6/arch/s390/Kconfig	2008-01-31 13:57:33.000000000 +0100
+++ linux-2.6-patched/arch/s390/Kconfig	2008-01-31 13:57:42.000000000
+0100
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


