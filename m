Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbXCZIqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbXCZIqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbXCZIqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:46:13 -0400
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:38556 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbXCZIqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:46:12 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, zwane@infradead.org
Subject: Re: [patch] sched: accurate user accounting
Date: Mon, 26 Mar 2007 18:45:42 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200703260811.18236.a1426z@gawab.com>
In-Reply-To: <200703260811.18236.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703261845.43358.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 15:11, Al Boldi wrote:
> Con Kolivas wrote:
> > Ok this one is heavily tested. Please try it when you find the time.
>
> It's better, but still skewed.  Try two chew.c's; they account 80% each.
>
> > ---
> > Currently we only do cpu accounting to userspace based on what is
> > actually happening precisely on each tick. The accuracy of that
> > accounting gets progressively worse the lower HZ is. As we already keep
> > accounting of nanosecond resolution we can accurately track user cpu,
> > nice cpu and idle cpu if we move the accounting to update_cpu_clock with
> > a nanosecond cpu_usage_stat entry.
>
> That's great and much needed, but this is still probed; so what's wrong
> with doing it in-lined?
>
> > This increases overhead slightly but
> > avoids the problem of tick aliasing errors making accounting unreliable.
>
> Higher scheduling accuracy may actually offset any overhead incurred, so
> it's well worth it; and if it's in-lined it should mean even less overhead.
>
> > +       /* Sanity check. It should never go backwards or ruin accounting
> > */ +       if (unlikely(now < p->last_ran))
> > +               goto out_set;
>
> If sched_clock() goes backwards, why not fix it, instead of hacking around
> it?
>
>
> Thanks!

Actually I'm going to give up this idea as not worth my effort given the 
sched_clock fsckage that seems to cause so much grief. If someone else wants 
to take up the challenge feel free to.

Andrew please drop this patch. It's still broken and I have too much on my 
plate to try and debug it sorry.

-- 
-ck
