Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYKHTFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYKHTFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYKHTF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:05:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58294 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYKHTF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:05:27 -0500
Date: Sat, 8 Nov 2008 20:05:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081108190517.GA9806@elte.hu>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108104116.48bd26e6@infradead.org> <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Doing it in get_cycles() and "forgetting about it" may sound like a 
> simple solution, but it's likely wrong. For example, one of the few 
> cases where we realy care about time going backwards is 
> gettimeofday() - which uses tsc, but which also has tons of 
> serializing instructions on its own. EXCEPT WHEN IT IS a vsyscall!
> 
> But in that case, we don't even have the barrier, because we put it 
> in the wrong function and 'forgot about it'. Of course, we may not 
> need it (rdtscp maybe always serializes, I didn't check), but the 
> point is, an explicit barrier is actually better than one that is 
> hidden.

no, we really had it in the vsyscall case: which uses vread, which 
uses __native_read_tsc(), which had the barriers.

And i think that's the _only_ valid place to have it.

So that's why my change moves it from the __native_read_tsc() over to 
_only_ the vget_cycles().

am i missing something on such a nice Saturday evening? :)

	Ingo
