Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXGCTmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXGCTmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbXGCTmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:42:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbXGCTmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:42:03 -0400
Date: Tue, 3 Jul 2007 21:41:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Stable Team <stable@kernel.org>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Subject: Re: [PATCH] NTP: remove clock_was_set() call to prevent deadlock
Message-ID: <20070703194106.GA493@elte.hu>
References: <1183485920.3291.28.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183485920.3291.28.camel@chaos>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The clock_was_set() call in seconds_overflow() which happens only when 
> leap seconds are inserted / deleted is wrong in two aspects:
> 
> 1. it results in a call to on_each_cpu() with interrupts disabled
> 2. it is potential deadlock source vs. call_lock in smp_call_function()
> 
> The only possible side effect of the removal might be, that an 
> absolute CLOCK_REALTIME timer fires 1 second too late, in the rare 
> case of leap second deletion and an absolute CLOCK_REALTIME timer 
> which expires in the affected time frame. It will never fire too 
> early.
> 
> This was probably observed by the reporter of a June 30th -> July 1st 
> hang: http://lkml.org/lkml/2007/7/3/
> 
> A similar problem was observed by Dave Jones, who provided a screen 
> shot with a lockdep back trace, which allowed to analyse the problem.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

looks good to me.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
