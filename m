Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbZBESNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbZBESNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZBESNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:13:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41770 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbZBESNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:13:38 -0500
Date: Thu, 5 Feb 2009 19:13:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] softlockup: convert read_lock in hung_task to
	rcu_read_lock
Message-ID: <20090205181329.GA5661@elte.hu>
References: <20090205143453.GG28443@elte.hu> <20090205175608.GA10819@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205175608.GA10819@google.com>
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


* Mandeep Singh Baines <msb@google.com> wrote:

> Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > I've applied your patch to tip:core/softlockup, thanks Mandeep!
> > 
> 
> Oops, I put the conversion to rcu_read_lock in a seperate patch. I
> understand now the convention is to use a patch series only when the
> patches can be applied independently.

What you did is in fact the preferred approach: keep independent stuff 
independent and make patches as gradual and split-up as possible. (as long 
as the interim state is a working kernel too)

> ---
> Since the tasklist is protected by rcu list operations, it is safe
> to convert the read_lock()s to rcu_read_lock().
> 
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Mandeep Singh Baines <msb@google.com>
> ---
>  kernel/hung_task.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied to tip:core/softlockup, thanks!

	Ingo
