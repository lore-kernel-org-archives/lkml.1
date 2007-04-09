Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXDIRsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXDIRsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXDIRsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:48:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbXDIRsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:48:14 -0400
Date: Mon, 9 Apr 2007 19:48:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ten percent test
Message-ID: <20070409174803.GA10189@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu> <461939A4.2020305@gmail.com> <1176092598.6355.22.camel@Homer.simpson.net> <461A2E39.8060106@gmail.com> <20070409141516.GB11244@elte.hu> <461A7246.60003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461A7246.60003@gmail.com>
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


* Rene Herman <rene.herman@gmail.com> wrote:

> > - the code actually has to match that stated goal. Right now it
> >   diverges from it (it is not a "fair" scheduler), and it's not 
> >   clear why.
> 
> I read most of the discussion centering around that specific point as 
> well, and frankly, I mostly came away from it thinking "so what?". 
> [...]

it's important due to what Mike mentioned in the previous mail too: SD 
seems to be quite rigid in certain aspects. So if we end up with that 
fundamental rigidity we might as well be _very_ sure that it makes 
sense. Because otherwise there might be no other way out but to "revert 
the whole thing again". Today we always have the "tweak the 
interactivity estimator" route, because that code is not rigid at the 
core of the scheduler.

> [...] one of them turn into a contrived heap of heuristics where every 
> progression on one front turns into a regression on another means that 
> one is on a dead-end road.

that's not what i found when testing Mike's latest patches - they 
visibly improved those testcases, part of which were written to 
"exploit" heuristics, without regressing others. Several people reported 
improvements with those patches.

Why was that possible without spending years on writing a new scheduler? 
Because the interactivity estimator is fundamentally _tweakable_. What 
you flag with sometimes derogative sentences as a weakness of the 
interactivity estimator is also its strength: tweakability is 
flexibility. And no, despite what you claim to be a "patchwork" it makes 
quite some sense: reward certain scheduling behavior and punish other 
type of behavior. That's what SD does too in the end. Sure, if your 
"reward" fights against the "punishment", they cancel out each other, or 
if the metrics used are just arbitrary and make no independent sense 
it's bad, but that's just plain bad engineering.

Why didnt much happen in the past year or so? Frankly, due to lack of 
demand for change - because most people were just happy about it, or 
just not upset enough. And i know the types of complaints first-hand, 
the -rt tree is a _direct answer_ to desktop-space complaints of Linux 
and it includes a fair bit of scheduler changes too. Now that we have 
actual new testcases and people with complaints and their willingness to 
try patches, we can do something about it.

> > the other one is:
> >
> > - the code has to demonstrate that it can flexibly react to various 
> >   complaints of regressions.
> 
> With one important point -- if every single _change_ in behaviour is 
> going to be defined a regression, then obviously noone will ever again 
> be able to change anything fundamental. [...]

i didnt say that, in fact my first lkml comment about RSDL on lkml was 
the exact opposite, but you SD advocates are _still_ bickering about 
(and not accepting) fundamental things like Mike's make -j5 workload and 
flagging it as unrealistic, so until there's so much reality disconnect 
there's not much chance for this issue to progress i'm afraid.

	Ingo
