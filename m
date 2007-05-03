Return-Path: <linux-kernel-owner+w=401wt.eu-S965452AbXECHqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452AbXECHqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965686AbXECHqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:46:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965452AbXECHqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:46:01 -0400
Date: Thu, 3 May 2007 09:45:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v7
Message-ID: <20070503074552.GA14960@elte.hu>
References: <200704300820.49078.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704300820.49078.a1426z@gawab.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> > i'm pleased to announce release -v7 of the CFS scheduler patchset. 
> > (The main goal of CFS is to implement "desktop scheduling" with as 
> > high quality as technically possible.)
> :
> :
> > As usual, any sort of feedback, bugreport, fix and suggestion is 
> > more than welcome,
> 
> This one seems on par with SD, [...]

excellent :-)

> [...] but there are still some nice issues.
> 
> Try running 3 chew.c's, then renicing one to -10, starves others for 
> some seconds while switching prio-level.  Now renice it back to 10, it 
> starves for up to 45sec.

ok - to make sure i understood you correctly: does this starvation only 
occur right when you renice it (when switching prio levels), and it gets 
rectified quickly once they get over a few reschedules?

> Also, nice levels are only effective on every other step; ie:
>  ... -3/-2 , -1/0 , 1/2 ... yields only 20 instead of 40 prio-levels.

yeah - this is a first-approximation thing.

Some background: in the upstream scheduler (and in SD) nice levels are 
linearly scaled, while in CFS they are exponentially scaled. I did this 
because i believe exponential is more logical: regardless of which nice 
level a task uses, if it goes +2 nice levels up then it will halve its 
"fair CPU share". So for example the CPU consumption delta between nice 
0 and nice +10 is 1/32 - and so is the delta between -5 and +5, -10 and 
-5, etc. This makes nice levels _alot_ more potent than upstream's 
linear approach.

	Ingo
