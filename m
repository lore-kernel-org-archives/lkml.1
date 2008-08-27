Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbYH0AHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbYH0AHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYH0AH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:07:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:47589 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbYH0AH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:07:27 -0400
Subject: Re: [PATCH] genirq: irq_chip->startup() usage in setup_irq and
	set_irq_chained handler
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Pawel MOLL <pawel.moll@st.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1219745676.16078.219.camel@bri1004.bri.st.com>
References: <1219313656.31630.89.camel@bri1004.bri.st.com>
	 <1219416584.31630.639.camel@bri1004.bri.st.com>
	 <20080823160859.GE27974@elte.hu>  <1219531395.21386.200.camel@pasglop>
	 <1219745676.16078.219.camel@bri1004.bri.st.com>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 10:06:59 +1000
Message-Id: <1219795619.13162.166.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 11:14 +0100, Pawel MOLL wrote:

> Let me briefly explain my situation. I have a main interrupt controller
> which provides startup() and unmask/mask() functions. The first one is
> rather expensive (as the controller itself is... hmmm...
> complicated ;-), the second - very cheap. And that is how I understand
> the different "levels" of interrupt access - startup() should be called
> once, somewhere during request_irq(), (un)masking may be used
> frequently.

Oh, I don't disagree. It's probably a good idea. I'm just worried of
the potential impact on existing code written around the current
behaviour.

We have 23 calls to set_irq_chained_handler in arch/powerpc, and I need
to audit them all. Luckily, we mostly don't have startup() callbacks.

 (... some time later ...)

It looks good. Of course, we'll have to test at one point, but at this
stage, I think powerpc is happy with the change.

Interestingly enough, I can see a case where we would have a problem
-without- your change :-) Not with the current code, but in conjunction
with another change that's planned for .28.

So Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.




