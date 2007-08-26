Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbXHZQ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbXHZQ2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXHZQ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:28:10 -0400
Received: from [212.12.190.157] ([212.12.190.157]:32818 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753410AbXHZQ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:28:09 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS review
Date: Sun, 26 Aug 2007 19:27:07 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <200708260127.32238.a1426z@gawab.com> <20070825231525.GA334@elte.hu>
In-Reply-To: <20070825231525.GA334@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708261927.07040.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > > ok. I think i might finally have found the bug causing this. Could
> > > you try the fix below, does your webserver thread-startup test work
> > > any better?
> >
> > It seems to help somewhat, but the problem is still visible.  Even
> > v20.3 on 2.6.22.5 didn't help.
> >
> > It does look related to ia-boosting, so I turned off __update_curr
> > like Roman mentioned, which had an enormous smoothing effect, but then
> > nice levels completely break down and lockup the system.
>
> you can turn sleeper-fairness off via:
>
>    echo 28 > /proc/sys/kernel/sched_features
>
> another thing to try would be:
>
>    echo 12 > /proc/sys/kernel/sched_features
>
> (that's the new-task penalty turned off.)
>
> Another thing to try would be to edit this:
>
>         if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
>                 p->se.wait_runtime = -(sched_granularity(cfs_rq) / 2);
>
> to:
>
>         if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
>                 p->se.wait_runtime = -(sched_granularity(cfs_rq);
>
> and could you also check 20.4 on 2.6.22.5 perhaps, or very latest -git?
> (Peter has experienced smaller spikes with that.)

Ok, I tried all your suggestions, but nothing works as smooth as removing 
__update_curr.

Does the problem show on your machine with the 3x gears under X-vesa test?


Thanks!

--
Al

