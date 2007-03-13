Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbXCMIJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbXCMIJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 04:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXCMIJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 04:09:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbXCMIJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 04:09:18 -0400
Date: Tue, 13 Mar 2007 09:09:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070313080904.GA22883@elte.hu>
References: <200703111457.17624.kernel@kolivas.org> <1173697024.8014.19.camel@Homer.simpson.net> <20070312110833.GA12835@elte.hu> <200703122223.07048.kernel@kolivas.org> <1173710082.6326.49.camel@Homer.simpson.net> <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > It has been said that "perfection is the enemy of good".  The two 
> > interactive tasks receiving 40% cpu while two niced background jobs 
> > receive 60% may well be perfect, but it's damn sure not good.
> 
> Well, the real problem is really "server that works on behalf of 
> somebody else".

i think Mike's testcase was even simpler than that: two plain CPU hogs 
on nice +5 stole much more CPU time with Con's new interactivity code 
than they did with the current interactivity code. I'd agree with Mike 
that a phenomenon like that needs to be fixed.

/less/ interactivity we can do easily in the current scheduler: just 
remove various bits here and there. The RSDL promise is that it gives us 
/more/ interactivity (with 'interactivity designed in', etc.), which in 
Mike's testcase does not seem to be the case.

> And the problem is that a lot of clients actually end up doing *more* 
> in the X server than they do themselves directly.

yeah. It's a hard case because X is not always a _clear_ interactive 
task - still the current interactivity code handles it quite well.

but Mike's scenario wasnt even that complex. It wasnt even a hard case 
of X being starved by _other_ interactive tasks running on the same nice 
level. Mike's test-scenario was about two plain nice +5 CPU hogs 
starving nice +0 interactive tasks more than the current scheduler does, 
and this is really not an area where we want to see any regression. Con, 
could you work on this area a bit more?

	Ingo
