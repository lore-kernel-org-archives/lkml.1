Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYDRJ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYDRJ3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 05:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYDRJ3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 05:29:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36926 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYDRJ3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 05:29:03 -0400
Date: Fri, 18 Apr 2008 11:28:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.25-mm1: not looking good
Message-ID: <20080418092842.GB20661@elte.hu>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <20080417224908.67cec814@laptopd505.fenrus.org> <20080417231038.72363123.akpm@linux-foundation.org> <20080418071945.GA18044@elte.hu> <20080418002858.de236663.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418002858.de236663.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > A #warning sounds more appropriate.
> > 
> > this warning is telling the user that the security feature that got 
> > enabled in the .config is completely, 100% not working due to using 
> > a stack-protector-incapable GCC.
> 
> I doubt if anyone will care much.

you noticed it ;-) Distro maintainers will notice it too if it pops up 
when something breaks StackProtector. Normal user might not notice. (but 
normal user might not notice a few hundred guest roots either)

but ... the real thing that made it slip into your config was that it 
was default-enabled in x86/latest - the patch below should fix that.

we need the warning: it could have caught the toplevel Makefile change 
last October that broke StackProtector completely. So no, we wont be and 
cannot be silent about this anymore - we need and now have an end-to-end 
test about it.

	Ingo

------------------>
Subject: stackprotector: non default
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 18 11:13:17 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 file changed, 1 deletion(-)

Index: linux-x86.q/arch/x86/Kconfig
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig
+++ linux-x86.q/arch/x86/Kconfig
@@ -1146,7 +1146,6 @@ config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
 	depends on X86_64
 	select CC_STACKPROTECTOR_ALL
-	default y
 	help
           This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
