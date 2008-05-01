Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYEABlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYEABlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYEABlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:41:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbYEABlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:41:18 -0400
Date: Thu, 1 May 2008 03:40:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com, tglx@linutronix.de
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501014048.GC27574@elte.hu>
References: <20080430.142137.236846072.davem@davemloft.net> <20080430221936.GA27292@elte.hu> <20080430223509.GA31547@elte.hu> <20080430.155149.210532797.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430.155149.210532797.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> Ingo, let me know what I need to do to change your behavior in 
> situations like the one I'm about to describe, ok?
> 
> Today, you merged in this bogus "regression fix".

the motivation of that fix wasnt UML - that was just an (indeed 
incorrect) after-thought when i wrote up the commit log. The fix is 
obviously right - although it doesnt fix UML.

btw., did you see my stream of fixes about UML?

> To an arbitrary person reading the commit logs, the above looks like 
> you fixed something, when you actually didn't fix anything.

it is wrong that it "doesnt fix anything". Look at the change itself:

- * Force always-inline if the user requests it so via the .config:
+ * Force always-inline if the user requests it so via the .config,
+ * or if gcc is too old:
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
-    !defined(CONFIG_OPTIMIZE_INLINING) && (__GNUC__ >= 4)
+    !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)

before the change it was only possible to disable the optimization on 
gcc 4 and above. The intended (and now implemented) condition is to only 
change anything on gcc 4 and above. I.e. on gcc3x the config option has 
no effect at all - and that's what we want.

	Ingo
