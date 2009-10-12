Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZJLSVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZJLSVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbZJLSVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:21:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48347 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbZJLSVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:21:03 -0400
Date: Mon, 12 Oct 2009 20:19:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20091012181944.GF17138@elte.hu>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930160232.GZ22310@obsidianresearch.com>
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


* Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> On Wed, Sep 30, 2009 at 11:44:56AM +0200, Ingo Molnar wrote:
> > > > OK.  It would be nice to tie into something more general, but I 
> > > > think I agree -- perf counters are missing the filtering and the "no 
> > > > lost events" that ummunotify does have. [...]
> > 
> > Performance events filtering is being worked on and now with the 
> > proper non-DoS limit you've added you can lose events too, dont you? 
> > So it's all a question of how much buffering to add - and with perf 
> > events too you can buffer arbitrary large amount of events.
> 
> No, the ummunotify does not loose events, that is the fundamental 
> difference between it and all tracing schemes.
> 
> Every call to ibv_reg_mr is paired with a call to ummunotify to create 
> a matching watcher. Both calls allocate some kernel memory, if one 
> fails the entire operation fails and userspace can do whatever it does 
> on memory allocation failure.

We already support signal notification for perf events, and we also 
support two modi of perf ring-buffer overflow notification. Adding a 
third one that sends a signal when events are lost would be in line with 
that.

This would allow you to have the OOM semantics of requesting a SIGBUS - 
or user-space could do other things: like print a warning in the app or 
ignore the event overflow.

Which are all interesting things to do. (If you do that you might want 
to add that to 'perf top' or 'perf record' as well.)

> After that point the scheme is perfectly lossless.

Well if it can OOM it's not lossless, obviously. You just define "event 
loss" to be equivalent to "Destruction of the universe." ;-)

	Ingo
