Return-Path: <linux-kernel-owner+w=401wt.eu-S934041AbXC2GzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041AbXC2GzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 02:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934037AbXC2GzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 02:55:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:38264 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934029AbXC2GzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 02:55:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/PWiUMvi/PQnjecuBLaPPmqQLR1KQBUWYPDt6Ket
	4SSjEir9k2PQUr
Subject: Re: [PATCH] sched: staircase deadline misc fixes
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <1175149750.6430.110.camel@Homer.simpson.net>
References: <200703290237.38777.kernel@kolivas.org>
	 <20070328184843.GA17420@elte.hu>  <200703290944.45888.kernel@kolivas.org>
	 <1175147455.6430.91.camel@Homer.simpson.net>
	 <1175149750.6430.110.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 08:54:55 +0200
Message-Id: <1175151295.6430.131.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh my, I'm on a roll here... somebody stop me ;-)

Some emphasis:

On Thu, 2007-03-29 at 08:29 +0200, Mike Galbraith wrote:
> On Thu, 2007-03-29 at 07:50 +0200, Mike Galbraith wrote:
> 
> > Opinion polls are nice, but I'm more interested in gathering numbers
> > which either validate or invalidate the claims of the design documents.
> 
> Suggestion: try the testcase that Satoru Takeuch posted.  The numbers I
> got with latest SD were no better than the numbers I got with the patch
> I posted to try to solve it.  Seems to me the numbers with SD should
> have been much better, but they in fact were not.
> 
> Running that thing, mainline's GUI was not usable, even with my patch,
> but neither was it usable with SD.  What's the difference between
> horrible with mainline and merely terrible with SD?  In both, the GUI
> ends up doing round-robin with a slew of hogs.  In mainline, this
> happens because the history logic can and does get it wrong sometimes,
> which this exploit deliberately triggers.  With SD, it's by design.

The much maligned history mechanism in mainline didn't start it's life
as an interactivity estimator, that's a name it acquired later.  What it
was first put there for was to ensure fairness for sleeping tasks.

I found it most ironic that the numbers I posted showed that mechanism
working perfectly, with an exploit that was designed specifically to
expose it's weakness, despite the deliberate tweaks that have gone in
tweaking it very heavily in the unfair direction, and this went
uncommented.  If I had run more of them, it would have shown that
weakness very well.  We all know that weakness exists.

What the numbers clearly showed was that sleeping tasks did not get the
fairness RSDL advertised with the particular test I ran, yet it went
uncommented/uncontested.  Anyone could have tested with the trivial
proggy of their choice... but nobody did.

The history mechanism is not only about interactivity, and never was. 

	-Mike

I'm gonna go piddle around with code now, much more fun than yacking :)

