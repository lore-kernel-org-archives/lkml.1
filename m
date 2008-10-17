Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYJQGYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYJQGYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYJQGXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:23:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47772 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYJQGXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:23:52 -0400
Date: Fri, 17 Oct 2008 08:23:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <becky.bruce@freescale.com>
Subject: [git pull] core kernel fixes
Message-ID: <20081017062331.GA8118@elte.hu>
References: <20081015125023.GA6702@elte.hu> <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> >       softirq, warning fix: correct a format to avoid a warning
> 
> Ingo, stop dicking around with this crap. You apparently fixed some 
> warning that I never saw by turning it into a warning that I _do_ see:

yes, sorry - i noticed the new warning too and notified you two days ago 
(see the mail below) but got held up by the ftrace stuff. I have two 
other core/urgent fixes queued up as well - see the pull request below.

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Wed, 15 Oct 2008 18:29:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] core kernel updates for v2.6.28


something i just noticed:

>    core/softirq

>       softirq, warning fix: correct a format to avoid a warning

Sorry, this warning fix was not complete and will produce a new warning 
on 64-bit x86. Will queue up a fix.

	Ingo

----- End forwarded message -----

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      m32r: fix build due to notify_cpu_starting() change

Stephen Rothwell (1):
      powerpc: fix linux-next build failure


 arch/m32r/kernel/smpboot.c      |    1 +
 arch/powerpc/include/asm/page.h |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index fc29948..39cb6da 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -40,6 +40,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index e088545..94fe513 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -10,9 +10,13 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#else
+#include <asm/types.h>
+#endif
 #include <asm/asm-compat.h>
 #include <asm/kdump.h>
-#include <asm/types.h>
 
 /*
  * On PPC32 page size is 4K. For PPC64 we support either 4K or 64K software
