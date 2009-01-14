Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbZANFb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbZANFb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZANFbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:31:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57321 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbZANFbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:31:17 -0500
Date: Wed, 14 Jan 2009 06:31:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Brian Rogers <brian@xyzw.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] How to get real-time priority using idle priority
Message-ID: <20090114053106.GA10410@elte.hu>
References: <4969D0D7.2060401@xyzw.org> <1231736941.6003.7.camel@marge.simson.net> <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu> <496BE8F6.1040308@xyzw.org> <1231815523.5899.7.camel@marge.simson.net> <1231910014.610.14.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231910014.610.14.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2009-01-13 at 03:58 +0100, Mike Galbraith wrote:
> > On Mon, 2009-01-12 at 17:05 -0800, Brian Rogers wrote:
> 
> > > I'll try Mike's "more complete" patch on top of 2.6.29-rc1 and see what 
> > > that does.
> > 
> > Don't bother.  I just tried a SCHED_IDLE make -j8 and had character
> > repeats while typing.  Must be another spot.
> 
> Hrmph, what an annoying problem.  The below works pretty well, but 
> _still_ has latency problems in some circumstances.
> 
> The more I look at this, the more I think these guys _really_ want to be 
> a separate class.  The problem is the incredible rate of min_vruntime 
> advancement creating absurdly huge spreads.
> 
> Hm, maybe I could advance min_vruntime at nice 0 when these guys are 
> running, only advance their vruntime at warp 512, but that seems awfully 
> hackish.  If they were a separate class, they could use the full nice 
> spectrum instead of being merely mega-nice.

A separate class has its own set of problems: starvation, etc.

What about increasing the weight of SCHED_IDLE tasks from 1 to 2 or 3? 
That still makes them mega-nice (which is more than enough), but should 
make the math a lot less borderline.

	Ingo
