Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbXH0EIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbXH0EIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 00:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXH0EH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 00:07:58 -0400
Received: from [212.12.190.232] ([212.12.190.232]:32810 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750736AbXH0EH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 00:07:57 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS review
Date: Mon, 27 Aug 2007 07:06:41 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <200708261927.07040.a1426z@gawab.com> <20070826163907.GB12453@elte.hu>
In-Reply-To: <20070826163907.GB12453@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708270706.41565.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > > and could you also check 20.4 on 2.6.22.5 perhaps, or very latest
> > > -git? (Peter has experienced smaller spikes with that.)
> >
> > Ok, I tried all your suggestions, but nothing works as smooth as
> > removing __update_curr.
>
> could you send the exact patch that shows what you did?

On 2.6.22.5-v20.3 (not v20.4):

340-    curr->delta_exec += delta_exec;
341-
342-    if (unlikely(curr->delta_exec > sysctl_sched_stat_granularity)) {
343://          __update_curr(cfs_rq, curr);
344-            curr->delta_exec = 0;
345-    }
346-    curr->exec_start = rq_of(cfs_rq)->clock;

> And could you
> also please describe it exactly which aspect of the workload you call
> 'smooth'. Could it be made quantitative somehow?

The 3x gears test shows the startup problem in a really noticeable way.  With 
v20.4 they startup surging and stalling periodically for about 10sec, then 
they are smooth.  With v20.3 + above patch they startup completely smooth.


Thanks!

--
Al
