Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYECXrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYECXrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYECXrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:47:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34324 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbYECXrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:47:32 -0400
Date: Sun, 4 May 2008 01:47:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       elendil@planet.nl, parag.warudkar@gmail.com,
       linux-kernel@vger.kernel.org, guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
Message-ID: <20080503234715.GA3507@elte.hu>
References: <20080503.160408.238581868.davem@davemloft.net> <20080503.163600.93588714.davem@davemloft.net> <20080503233825.GB30600@elte.hu> <20080503.164024.265682957.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503.164024.265682957.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 4 May 2008 01:38:25 +0200
> 
> > ah, good! It really looks like unnecessary overhead for the "simple 
> > IPIs". But ... i'm wondering ... what about softirq processing? Do these 
> > IPIs process softirqs on the way out? In that case the non-processed 
> > jiffies might be a problem.
> > 
> > it's all a bit messy. I wish we could start turning jiffies into a 
> > function (which would just read GTOD and estimate jiffies from there), 
> > but i fear we are not there yet ...
> 
> I think Peter Z. made a good point that we probably need to keep it 
> there for smp_call_function() receivers, so that the called functions 
> can test the context they are in accurately.

hm, good point, i missed that aspect.

	Ingo
