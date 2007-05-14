Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbXENO6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbXENO6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 10:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXENO54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 10:57:56 -0400
Received: from [212.12.190.165] ([212.12.190.165]:32844 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754648AbXENO5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 10:57:55 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Date: Mon, 14 May 2007 18:02:05 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705141802.05158.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> the current task is recalculated at scheduler tick time and put into the
> tree at its new position. At a million tasks the fair-clock will advance
> little (or not at all - which at these load levels is our smallest
> problem anyway) so during a scheduling tick in kernel/sched_fair.c
> update_curr() we will have a 'delta_mine' and 'delta_fair' of near zero
> and a 'delta_exec' of ~1 million, so curr->wait_runtime will be
> decreased at 'full speed': delta_exec-delta_mine, by almost a full tick.
> So preemption will occur every sched_granularity (rounded up to the next
> tick) points in time, in wall-clock time.

The only problem I have with this fairness is the server workload that 
services requests by fork/thread creation.  In such a case, this fairness is 
completely counter-productive, as running tasks unfairly inhibit the 
creation of peers.

Giving fork/thread creation special priority may alleviate this problem.


Thanks!

--
Al

