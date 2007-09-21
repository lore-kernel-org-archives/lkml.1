Return-Path: <linux-kernel-owner+w=401wt.eu-S1760244AbXIUQRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244AbXIUQRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXIUQRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:17:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbXIUQRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:17:47 -0400
Message-ID: <46F3EE62.9010907@redhat.com>
Date: Fri, 21 Sep 2007 12:16:34 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
References: <46B10BB7.60900@redhat.com> <20070803113407.0b04d44e.akpm@linux-foundation.org> <20070804084426.GA20464@kobayashi-maru.wspse.de> <20070809095943.GA7763@kobayashi-maru.wspse.de> <20070809095534.25ae1c42.akpm@linux-foundation.org> <46F2E103.8000907@redhat.com> <20070920142927.d87ab5af.akpm@linux-foundation.org> <20070921093914.GB4750@shadowen.org> <Pine.LNX.4.64.0709211623190.16442@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0709211623190.16442@blonde.wat.veritas.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2007 11:58 AM, Hugh Dickins wrote:
> Looking at the 2.6.18-2.6.23 code, I'm uncertain what to try instead.
> There is a refresh_vm_stats function which we could call (then retest
> the break condition) just before resorting to congestion_wait.  But
> the big NUMA people might get very upset with me calling that too
> often: causing a thundering herd of bouncing cachelines which that
> was all designed to avoid.  And it's not obvious to me what condition
> to test for dirty_thresh "too low".
> 
> I believe Peter gave all this quite a lot of thought when he was
> making the rc6-mm1 changes, and I'd rather defer to him for a
> suggestion of what best to do in earlier releases.  Or maybe he'll
> just point out how this couldn't have been a problem before.
> 
> Or there is is Richard's patch, which I haven't considered, but
> Andrew was not quite satisfied with it - partly because he'd like
> to understand how the situation could come about first, perhaps
> we have now got an explanation.
> 

My patch is just Richard's with the added requirement that we loop
some minimum number of times before exiting balance_dirty_pages()
with unfinished work.

