Return-Path: <linux-kernel-owner+w=401wt.eu-S1765643AbXGPQKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765643AbXGPQKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbXGPQKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:10:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757708AbXGPQKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:10:38 -0400
Date: Mon, 16 Jul 2007 18:10:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Message-ID: <20070716161025.GA1797@elte.hu>
References: <21003.1184596954@lwn.net> <Pine.LNX.4.64.0707161654130.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707161654130.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> I know that Ingo considers everything HZ related evil, [...]

no, you are misrepresenting me, i dont consider everything HZ related 
evil - where did you get that from?
 
I explained it numerous times (remember the 'timeout' vs. 'timer event' 
discussion?) that i consider timer granularity important to scalability. 
Basically, in every case where we know with great certainty that a 
time-out will _not_ occur (where the time-out is in essence just an 
exception handling mechanism), using struct timer_list is the best 
solution. Furthermore, in cases where we know that the "granularity" of 
a timer event is coarse, we can 'cluster' related timer events together. 
(Arjan's timeout-rounding API additions do that.)

msleep() API is neither, and it's a perfect example for conversion to 
hrtimers. It is exactly the type of timer API we intended hrtimers for.

what i consider harmful on the other hand are all the HZ assumptions 
embedded into various pieces of code. The most harmful ones are design 
details that depend on HZ and kernel-internal API details that depends 
on HZ. Yes, NTP was such an example, and it was hard to fix, and you 
didnt help much with that. (perhaps that is one source of this 
increasingly testy exchange ;-) In any case we are slowly and surely 
eradicating them. (we long ago eradicated all externally visible HZ 
dependencies via the introduction of USER_HZ)

	Ingo
