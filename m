Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbXCUHv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbXCUHv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 03:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXCUHv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 03:51:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36619 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXCUHv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 03:51:26 -0400
Date: Wed, 21 Mar 2007 08:50:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <lkml@rtr.ca>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
Message-ID: <20070321075033.GA10368@elte.hu>
References: <200703172048.46267.kernel@kolivas.org> <1174125534.7734.2.camel@Homer.simpson.net> <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca> <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca> <1174322580.30876.72.camel@frg-rhel40-em64t-04> <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org> <20070320061152.GW943@1wt.eu> <1174381383.30876.86.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174381383.30876.86.camel@frg-rhel40-em64t-04>
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


* Xavier Bestel <xavier.bestel@free.fr> wrote:

> On Tue, 2007-03-20 at 07:11 +0100, Willy Tarreau wrote:
> > I don't agree with starting to renice X to get something usable
>
> [...] Why not compensate for X design by prioritizing it a bit ?

there were multiple attempts with renicing X under the vanilla 
scheduler, and they were utter failures most of the time. _More_ people 
complained about interactivity issues _after_ X has been reniced to -5 
(or -10) than people complained about "nice 0" interactivity issues to 
begin with.

The vanilla scheduler's auto-nice feature rewards _behavior_, so it gets 
X right most of the time. The fundamental issue is that sometimes X is 
very interactive - we boost it then, there's lots of scheduling but nice 
low latencies. Sometimes it's a hog - we penalize it then and things 
start to batch up more and we get out of the overload situation faster. 
That's the case even if all you care about is desktop performance.

no doubt it's hard to get the auto-nice thing right, but one thing is 
clear: currently RSDL causes problems in areas that worked well in the 
vanilla scheduler for a long time, so RSDL needs to improve. RSDL should 
not lure itself into the false promise of 'just renice X statically'. It 
wont work. (You might want to rewrite X's request scheduling - but if so 
then i'd like to see that being done _first_, because i just dont trust 
such 10-mile-distance problem analysis.)

	Ingo
