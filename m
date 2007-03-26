Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbXCZFHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbXCZFHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933575AbXCZFHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:07:48 -0400
Received: from [212.12.190.57] ([212.12.190.57]:32825 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753080AbXCZFHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:07:47 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: accurate user accounting
Date: Mon, 26 Mar 2007 08:11:18 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703260811.18236.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
>
> Ok this one is heavily tested. Please try it when you find the time.

It's better, but still skewed.  Try two chew.c's; they account 80% each.

> ---
> Currently we only do cpu accounting to userspace based on what is
> actually happening precisely on each tick. The accuracy of that
> accounting gets progressively worse the lower HZ is. As we already keep
> accounting of nanosecond resolution we can accurately track user cpu,
> nice cpu and idle cpu if we move the accounting to update_cpu_clock with
> a nanosecond cpu_usage_stat entry.

That's great and much needed, but this is still probed; so what's wrong with 
doing it in-lined?

> This increases overhead slightly but
> avoids the problem of tick aliasing errors making accounting unreliable.

Higher scheduling accuracy may actually offset any overhead incurred, so it's 
well worth it; and if it's in-lined it should mean even less overhead.

> +       /* Sanity check. It should never go backwards or ruin accounting
> */ +       if (unlikely(now < p->last_ran))
> +               goto out_set;

If sched_clock() goes backwards, why not fix it, instead of hacking around 
it?


Thanks!

--
Al

