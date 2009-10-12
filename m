Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbZJLUVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbZJLUVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbZJLUVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:21:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072AbZJLUVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:21:43 -0400
Date: Mon, 12 Oct 2009 22:20:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20091012202046.GA7648@elte.hu>
References: <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com> <20091012181944.GF17138@elte.hu> <20091012193048.GA20313@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012193048.GA20313@obsidianresearch.com>
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

> On Mon, Oct 12, 2009 at 08:19:44PM +0200, Ingo Molnar wrote:
> 
> > > After that point the scheme is perfectly lossless.
> > 
> > Well if it can OOM it's not lossless, obviously. You just define 
> > "event loss" to be equivalent to "Destruction of the universe." ;-)
> 
> It can't OOM once the ummunotify registration is done - when an event 
> occurs it doesn't allocate any memory and it doesn't loose events.

Well, it has built-in event loss via the UMMUNOTIFY_FLAG_HINT mechanism: 
any double events on the same range will cause an imprecise event to be 
recorded and cause the loss of information.

Is that loss of information more acceptable than the loss of information 
via the loss of events?

It might be more acceptable because the flag-hint mechanism can at most 
cause over-flushing - while with perf events we might miss to invalidate 
a range altogether.

	Ingo
