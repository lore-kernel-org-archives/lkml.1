Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbXEVUcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbXEVUcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbXEVUcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:32:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757099AbXEVUcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:32:17 -0400
Date: Tue, 22 May 2007 22:31:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Chang <thenewme91@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ck] Re: [PATCH] mm: swap prefetch improvements
Message-ID: <20070522203116.GA8656@elte.hu>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705222020.58474.kernel@kolivas.org> <20070522102530.GB2344@elte.hu> <200705222037.54741.kernel@kolivas.org> <20070522104648.GA10622@elte.hu> <b14e81f00705221318n43dbb53ex77a454e0eade4fb7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b14e81f00705221318n43dbb53ex77a454e0eade4fb7@mail.gmail.com>
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


* Michael Chang <thenewme91@gmail.com> wrote:

> > It clearly should not consider 'itself' as IO activity. This 
> > suggests some bug in the 'detect activity' mechanism, agreed? I'm 
> > wondering whether you are seeing the same problem, or is all 
> > swap-prefetch IO on your system continuous until it's done [or some 
> > other IO comes inbetween]?
> 
> The only "problem" I can see with this idea is in the potential case 
> that it takes up all the IO activity, and so there is never enough IO 
> activity from other progams to trigger the wait mechanism because they 
> don't get a chance to run.

i dont understand what you mean. Any 'use only idle IO capacity' 
mechanism should immediately cease to be active the moment any other app 
tries to do IO - whether the IO subsystem is saturated or not.

> That said, I don't think there are any issues with the code 
> compensating for its own activity in the "detect activity" mechanism 
> -- assuming there wasn't a major impact in e.g. maintainability or 
> something.
> 
> As for the burstyness... considering the "no negative impact" stance, 
> I can understand that. But it seems inefficient, at best...

well, it's a plain old bug (a not too serious one) in my book, i'm 
surprised that we are now at mail #7 about it :-) I reported it, and i 
guess Con will fix it eventually. There's really no need to deny that it 
exists or to try to talk it out of existence. Sheesh! :-)

	Ingo
