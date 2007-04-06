Return-Path: <linux-kernel-owner+w=401wt.eu-S1766671AbXDFKDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766671AbXDFKDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767552AbXDFKDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:03:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766665AbXDFKDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:03:45 -0400
Date: Fri, 6 Apr 2007 12:03:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Mike Galbraith <efault@gmx.de>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
Message-ID: <20070406100333.GA19855@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200704061103.34489.kernel@kolivas.org> <1175850471.22272.8.camel@Homer.simpson.net> <200704061928.39155.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704061928.39155.kernel@kolivas.org>
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


* Con Kolivas <kernel@kolivas.org> wrote:

> > I was more focused on the general case, but all I should have to do 
> > to de-claw all of these sleep exploits is account rr time (only a 
> > couple of lines, done and building now).  It's only a couple of 
> > lines.
> 
> The more you try to "de-claw" these sleep exploits the less effective 
> you make your precious interactive estimator. Feel free to keep adding 
> endless tweaks to undo the other tweaks in order to try and achieve 
> what SD has by design.

firstly, testing on various workloads Mike's tweaks work pretty well, 
while SD still doesnt handle the high-load case all that well. Note that 
it was you who raised this whole issue to begin with: everything was 
pretty quiet in scheduling interactivity land. (There was one person who 
reported wide-scale interactivity regressions against mainline but he 
didnt answer my followup posts to trace/debug the scenario.)

SD has a built-in "interactivity estimator" as well, but hardcoded into 
its design. SD has its own set of ugly-looking tweaks as well - for 
example the prio_matrix. So it all comes down on 'what interactivity 
heuristics is enough', and which one is more tweakable. So far i've yet 
to see SD address the hackbench and make -j interactivity 
problems/regression for example, while Mike has been busy addressing the 
'exploits' reported against mainline.

> You'll end up with an incresingly complex state machine design of 
> interactivity tweaks and interactivity throttlers all fighting each 
> other to the point where the intearactivity estimator doesn't do 
> anything. [...]

It comes down to defining interactivity by scheduling behavior, and 
making that definition flexible. SD's definition of interactivity is 
rigid (but it's still behavior-based, so not fundamentally different 
from an explicit 'interactivity estimator'), and currently it does not 
work well under high load. But ... i'm still entertaining the notion 
that it might be good enough, but you've got to demonstrate the design's 
flexibility.

furthermore, your description does not match my experience when using 
Mike's tweaks and comparing it to SD on the same hardware. According to 
your claim i should have seen regressions popping up in various, 
already-fixed corners, but it didnt happen in practice. But ... i'm 
awaiting further SD and Mike tweaks, the race certainly looks 
interesting ;)

	Ingo
