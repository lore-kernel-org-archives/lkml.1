Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYHKW40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYHKW40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYHKW4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:56:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53466 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYHKW4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:56:18 -0400
Date: Tue, 12 Aug 2008 00:55:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lkml <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Message-ID: <20080811225557.GA2068@elte.hu>
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com> <200808082303.41068.rjw@sisk.pl> <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com> <20080811123020.GB10082@elte.hu> <alpine.LFD.1.10.0808111500330.3462@nehalem.linux-foundation.org> <48A0B9AC.6020901@qualcomm.com> <20080811224636.GA25577@elte.hu> <48A0C213.4090305@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A0C213.4090305@qualcomm.com>
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


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> 
> 
> Ingo Molnar wrote:
> > * Max Krasnyansky <maxk@qualcomm.com> wrote:
> > 
> >>> And I was hoping to do -rc3 today. Can I please have pull-requests for the 
> >>> appropriate urgent scheduler/x86 fixes? Or should I just take these as 
> >>> patches?
> >> It'd be nice if -rc3 included my cpuset patch so that we could put circular
> >> locking issues in the cpu hotplug path to the rest.
> >> Ingo, I'm talking about this:
> >> 	[PATCH] cpuset: Rework sched domains and CPU hotplug handling (take 4)
> > 
> > the latest (-v4) version of the patch was submitted just half an hour 
> > ago and it's rather large/complex, with a few unrelated changes 
> > (whitespace, etc.) mixed in as well. I'd like to wait for Paul's final 
> > ack for -v4 (he has already agreed with the approach in general), and 
> > wanted to have it tested myself as well, at least minimally.
> 
> Fair enough.
> 
> btw Whitespace and other cosmetic changes were requested by reviewers.

yeah - it just makes it a tiny bit harder decision whether to queue up a 
patch in the urgent path.

It's better to keep cleanups separate - that way any typos and 
unintended bugs in cleanups are more obvious as well. (because later on 
a person debugging a breakage does not have to wonder about whether a 
change's side-effects were intended or not.)

But your patch certainly looks OK standalone as well, just IMO not as a 
very-last-minute patch. (No strong feelings though, your patch should 
not break anything in the normal !CPUSETS or the CPUSETS+no-cpuset-used 
usecases.)

	Ingo
