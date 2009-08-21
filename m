Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbZHUTDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbZHUTDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZHUTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:03:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZHUTDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:03:44 -0400
Date: Fri, 21 Aug 2009 21:02:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       catalin.marinas@arm.com, a.p.zijlstra@chello.nl, jens.axboe@oracle.com,
       fweisbec@gmail.com, stable@kernel.org, srostedt@redhat.com,
       tglx@linutronix.de
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in
	do_one_initcall()
Message-ID: <20090821190226.GA28519@elte.hu>
References: <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org> <20090821111450.GA32037@elte.hu> <20090821104820.60948082.akpm@linux-foundation.org> <alpine.LFD.2.01.0908211108000.3158@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908211108000.3158@localhost.localdomain>
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

> On Fri, 21 Aug 2009, Andrew Morton wrote:
> > 
> > We seem to have overrun an 8k stack in
> > http://bugzilla.kernel.org/show_bug.cgi?id=14029

Note that's a 32-bit 8K stack oops, so it doesnt apply.

> The thread "v2.6.31-rc6: BUG: unable to handle kernel NULL pointer 
> dereference at 0000000000000008" also has at least one oops that 
> has that "Thread overran stack, or stack corrupted" marker thing.

This is a 64-bit one, a pty related one and it's not yet clear what 
happened there - but it's certainly possible to overrun any stack.

> > My main concern would be maintenance.  Over time we'll chew more 
> > and more stack space and eventually we'll get into trouble 
> > again.  What means do we have for holding the line at 8k, and 
> > even improving things?
> 
> That's why I think the async thing could fix this - if we _force_ 
> async calls to be asynchronous, you won't have the deep callchains 
> for all the device discovery thing.

Agreed. OTOH we have deep callchains in things like execve() too 
which seem to be a lot harder to fix - and those have been around 
for the past ~10 years since i've been looking at max-stacktraces.
I think 4K doesnt cut it anymore.

	Ingo
