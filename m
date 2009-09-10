Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZIJKC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZIJKC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZIJKC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:02:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42470 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbZIJKC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:02:26 -0400
Date: Thu, 10 Sep 2009 12:02:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910100214.GB21314@elte.hu>
References: <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <1252565738.7205.29.camel@laptop> <20090910065856.GL18599@kernel.dk> <20090910073317.GP18599@kernel.dk> <20090910074902.GA10634@elte.hu> <20090910075357.GT18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910075357.GT18599@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> I went to try -tip btw, but it crashes on boot. Here's the 
> backtrace, typed manually, it's crashing in 
> queue_work_on+0x28/0x60.
> 
> Call Trace:
>         queue_work
>         schedule_work
>         clocksource_mark_unstable
>         mark_tsc_unstable
>         check_tsc_sync_source
>         native_cpu_up
>         relay_hotcpu_callback
>         do_forK_idle
>         _cpu_up
>         cpu_up
>         kernel_init
>         kernel_thread_helper

hm, that looks like an old bug i fixed days ago via:

  00a3273: Revert "x86: Make tsc=reliable override boot time stability checks"

Have you tested tip:master - do you still know which sha1?

	Ingo
