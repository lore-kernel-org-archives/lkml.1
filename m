Return-Path: <linux-kernel-owner+w=401wt.eu-S933489AbZJHUJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbZJHUJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933407AbZJHUJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:09:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52127 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbZJHUJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:09:30 -0400
Date: Thu, 8 Oct 2009 22:08:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: eranian@gmail.com, eranian@googlemail.com, paulus@samba.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sf.net
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for
	Intel processors
Message-ID: <20091008200839.GA24354@elte.hu>
References: <1254911461.26976.239.camel@twins> <19148.30773.350036.411105@cargo.ozlabs.ibm.com> <7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com> <20091007.134626.238756485.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007.134626.238756485.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: stephane eranian <eranian@googlemail.com>
> Date: Wed, 7 Oct 2009 14:31:58 +0200
> 
> > What PPC does is probably the only way to do this given the interface between
> > generic and machine-specific code. The one advantage I see is that it works
> > inside an event group but also across event groups because that code does not
> > look at group boundary, it only looks at the events and the number of available
> > registers. The downside is that you duplicate state.
> > 
> > Did I get this right, Paul?
> 
> That's basically how his code works, yes.  I intend on duplicating it 
> to some extent on sparc64 since I'm operating in a similar problem 
> space.
> 
> So if at least some of this engine went to a generic place, there'd be 
> at least a 3rd user :-)

Yeah, i'd definitely suggest to generalize this. We've missed updating 
PowerPC lowlevel details a couple of times in perf core updates, just 
because it's in a non-obvious place. Even if it's used by just a single 
arch, generic code is much more visible.

PowerPC really has this somewhat somewhat weird track record of 
privatizing generic facilities and smugly keeping it to themselves as a 
competitive advantage ;-) Reminds me of the old semaphore code which was 
the best on PowerPC, for years. Lets not go there again :)

	Ingo
