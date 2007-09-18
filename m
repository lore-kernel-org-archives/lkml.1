Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbXIRGlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbXIRGlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXIRGky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:40:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbXIRGkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:40:53 -0400
Date: Tue, 18 Sep 2007 08:40:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: Scheduler benchmarks - a follow-up
Message-ID: <20070918064046.GD5138@elte.hu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com> <20070917130524.GA10707@elte.hu> <20070917203607.GA20564@elte.hu> <6b8cef970709172130v317a6c48h814ef5a1488f798e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b8cef970709172130v317a6c48h814ef5a1488f798e@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rob Hussey <robjhussey@gmail.com> wrote:

> A cursory glance suggests that performance wrt lat_ctx and hackbench 
> has increased (lower numbers), but degraded quite a lot for pipe-test. 
> The numbers for pipe-test are extremely stable though, while the 
> numbers for hackbench are more erratic (which isn't saying much since 
> the original numbers gave nearly a straight line). I'm still willing 
> to try out any more ideas.

pipe-test is a very stable workload, and is thus quite sensitive to the 
associativity of the CPU cache. Even killing the task and repeating the 
same test isnt enough to get rid of the systematic skew that this can 
cause. I've seen divergence of up to 10% in pipe-test. One way to test 
it is to run pipe-test, then to stop it, then to "ssh localhost" (this 
in itself uses up a couple of pipe objects and file objects and changes 
the cache layout picture), then run pipe-test again, then again "ssh 
localhost", etc. Via this trick one can often see cache-layout 
artifacts. How much 'skew' does pipe-test have on your system if you try 
this manually?

	Ingo
