Return-Path: <linux-kernel-owner+w=401wt.eu-S1751509AbZIOJAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbZIOJAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZIOJA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:00:27 -0400
Received: from www.tglx.de ([62.245.132.106]:46256 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZIOJA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:00:26 -0400
Date: Tue, 15 Sep 2009 11:00:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hrtimers: Remove the "timer_stats_active" check when
 setting the start info
In-Reply-To: <20090903163253.1d846628@feng-desktop>
Message-ID: <alpine.LFD.2.00.0909151056160.8957@localhost.localdomain>
References: <20090903163253.1d846628@feng-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009, Feng Tang wrote:
> Please review this patch (generated against v2.6.31-rc8)
> 
> Thanks,
> Feng
> 
> >From 8c6b53a0ead71590a0dd5556c9ad409f0c1ad2d1 Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Thu, 3 Sep 2009 15:51:10 +0800
> Subject: [PATCH] hrtimers: Remove the "timer_stats_active" check when setting the start info
> 
> Recent hrtimer code will set the start info to a hrtimer only when that
> flag is set, then the start info of all hrtimers will always be uninitialised
> before a "echo 1 > /proc/timer_stats", thus the /proc/timer_lists will have
> something like:
> 
> active timers:
>  #0: <c27d46b0>, tick_sched_timer, S:01, <(null)>, /-1
>  # expires at 91062000000-91062000000 nsecs [in 156071 to 156071 nsecs]
>  #1: <efb81b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
>  # expires at 91062300331-91062350331 nsecs [in 456402 to 506402 nsecs]
>  #2: <efac9b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
>  # expires at 91068699811-91068749811 nsecs [in 6855882 to 6905882 nsecs]
>  #3: <efacdb6c>, hrtimer_wakeup, S:01, <(null)>, /-1
>  # expires at 91068755511-91068805511 nsecs [in 6911582 to 6961582 nsecs]
>  #4: <efa95b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
>  # expires at 91068806066-91068856066 nsecs [in 6962137 to 7012137 nsecs]
>  .....
> 
> This patch will fix it.

Well, at the same time it forces the memcpy when !timer_stats_active.
We generally want to avoid such overhead when debug facilities are
disabled.

Thanks,

	tglx
 
