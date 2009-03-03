Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZCCKER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZCCKER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 05:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZCCKED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 05:04:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39888 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZCCKEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 05:04:00 -0500
Date: Tue, 3 Mar 2009 11:03:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090303100329.GA5050@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021633.08736.david-b@pacbell.net> <20090303004427.GA8638@elte.hu> <200903021837.08635.david-b@pacbell.net> <1236072446.18955.44.camel@twins> <20090303094743.030b2507@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303094743.030b2507@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Therefore IRQF_DISABLED _will_ be forced on everybody some 
> > day soon, and I'll provide an IRQF_ENABLED for use by broken 
> > hardware only (and make a TAINT flag for that too).
> 
> I don't think you understand how the kernel project works. If 
> everyone thinks your change is inappropriate it won't get in.

The change that people had a problem with was the immediate 
removal of IRQF_ENABLED, and that's not on the plate anymore.

I dont think anyone offered any example where IRQF_ENABLED is 
used in a healthy way - they are all legacy or special hw quirks 
where we limp along with enabling IRQs in a hacky way.

Furthermore, even these quirky cases can be supported cleanly 
_without_ IRQF_ENABLED: where an IRQ handler can take a long 
time to execute, the handler can be converted to a threaded IRQ 
handler - where it's fine to enable IRQs as there are no stack 
nesting issues.

So there's no real technical problem here.

	Ingo
