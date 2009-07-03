Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZGCVlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZGCVlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbZGCVlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:41:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41638 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759368AbZGCVlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:41:02 -0400
Date: Fri, 3 Jul 2009 23:40:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: atomic64: inline atomic64_read()
Message-ID: <20090703214038.GA13082@elte.hu>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org> <4A4E1AA2.30002@gmail.com> <20090703180450.GB3405@elte.hu> <alpine.LFD.2.01.0907031207030.3210@localhost.localdomain> <20090703191709.GA17057@elte.hu> <alpine.LFD.2.01.0907031221340.3210@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907031221340.3210@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Do we actually _have_ any performance-critical 64-bit counters 
> that have monotonicity guarantees? I have no idea. I'm just 
> throwing out the notion.

Due to the 'counter value flipping' we do on perfcounters for 
certain workloads (attr.inherit_stat=1 counters - inherited counters 
that neverheless provide precise per thread readouts - not just 
precise summaries), the monotonicity assumption is not generally 
true anymore.

But it would be nice if Eric could measure your suggested primitive, 
just that we see how many cycles we are talking about. I suspect the 
biggest difference would be a many-readers testcase - but that wont 
normally happen on perfcounters as the counters typically get read 
only from a single thread of executin.

	Ingo
