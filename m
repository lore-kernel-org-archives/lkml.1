Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYIDVkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYIDVkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYIDVkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:40:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33751 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbYIDVkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:40:05 -0400
Date: Thu, 4 Sep 2008 23:39:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080904213945.GA18347@elte.hu>
References: <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> <20080904190728.59634020@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org> <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu> <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org> <20080904212130.GA12406@elte.hu> <alpine.LFD.1.10.0809041428520.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041432070.3117@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809041432070.3117@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 4 Sep 2008, Linus Torvalds wrote:
> > 
> > Face it, if somebody tries to make QUICK_PIT_MS be so large as to 
> > that be an issue, then the whole point of the function goes away.
> 
> Btw, the same is true of adding any random "sanity checking". The 
> point of that thing was to simply only work when the PIT works as 
> advertized, and fail immediately if it doesn't. Even *if* you were to 
> pick a big calibration delay *and* if you happened to have a PIT that 
> is broken and doesn't wrap correctly, the design of the thing would 
> mean that it would then fail the calibration already.
> 
> Exactly because it would _see_ that it's not wrapping.

yeah - pit_expect_msb() would return after 50,000 iterations with a 
failure. So i was wondering whether for such PITs we _want_ the slow and 
complicated case to run.

Probably not, because the PIT could quite likely still be counting very 
precisely as long as no wraparound was involved.

	Ingo
