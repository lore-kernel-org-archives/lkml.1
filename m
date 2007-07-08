Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbXGHUwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbXGHUwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 16:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbXGHUwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 16:52:04 -0400
Received: from [212.12.190.212] ([212.12.190.212]:34033 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756698AbXGHUwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 16:52:02 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
Date: Sun, 8 Jul 2007 23:51:56 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082351.56694.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> The biggest user-visible change in -v19 is reworked sleeper fairness:
> it's similar in behavior to -v18 but works more consistently across nice
> levels. Fork-happy workloads (like kernel builds) should behave better
> as well. There are also a handful of speedups: unsigned math, 32-bit
> speedups, O(1) task pickup, debloating and other micro-optimizations.

Thanks, these changes show an obvious improvement with heavy forklifters.  
But there is one strange artifact; fork response is not consistant over 
successive runs, i.e. sometimes it starves, sometimes it moves, and 
sometimes it flies.  It looks like it's dependent on some sched-stats to 
accumulate before it stablizes.

Also, fork/thread creation is one aspect of testing, but what about thread 
termination performance, which has to sync back to the creating thread?  How 
is that handled, and is there some code around that can test this?


Thanks!

--
Al

