Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbXCEHdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbXCEHdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXCEHds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:33:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbXCEHdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:33:47 -0500
Date: Mon, 5 Mar 2007 08:25:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@debian.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] highres: Do not run the TIMER_SOFTIRQ after switching to	highres mode
Message-ID: <20070305072518.GB14993@elte.hu>
References: <45E8E2F8.1030102@debian.org> <1172912540.24738.108.camel@localhost.localdomain> <45EAAA21.4040803@debian.org> <1173013794.24738.130.camel@localhost.localdomain> <45EAC5B1.2060306@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EAC5B1.2060306@debian.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andres Salomon <dilinger@debian.org> wrote:

> Thomas Gleixner wrote:
> >>> The question is, how the tick timer gets enqueued in the softirq queue.
> >>> Can you isolate the codepath, where this happens ?
> > 
> > The TIMER_SOFTIRQ runs the hrtimers during bootup until a usable
> > clocksource and clock event sources are registered. The switch to high
> > resolution mode happens inside of the TIMER_SOFTIRQ, but runs the
> > softirq afterwards. That way the tick emulation timer, which was set up
> > in the switch to highres might be executed in the softirq context, which
> > is a BUG. The rbtree has not to be touched by the softirq after the
> > highres switch.
> > 
> 
> And an additional request, just to make it explicit that we should not 
> have any NO_SOFTIRQ callbacks in the tree; BUG out if we encounter 
> such a thing.

please change it to WARN_ON_ONCE()...

'bug out' might mean: 'dead box'/'no resume'/'no bootup'.

	Ingo
