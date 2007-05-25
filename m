Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbXEYLFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbXEYLFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXEYLFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:05:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50201 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbXEYLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:05:46 -0400
Date: Fri, 25 May 2007 13:05:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, rusty@rustcorp.com.au
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525110543.GM8094@one.firstfloor.org>
References: <20070525075446.GA20140@elte.hu> <20070525080209.GE8094@one.firstfloor.org> <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu> <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525090315.GK8094@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 11:03:15AM +0200, Andi Kleen wrote:
> > This?    I sent it to you earlier this week:
> 
> Sorry haven't processed those yet.
> 
> Ah. The correct fix here is to clear the tsc flag in boot_cpu_data
> when the option is set. Will do that.

Hmm I double checked this now; tsc_disable indeed clears
X86_FEATURE_TSC in identify_cpu and that should be always
called before anything sched_clock related runs on a CPU.

Also the only possibly faulting division is protected
by a cpu_has_tsc which even checks boot_cpu_data. this means
even if the resync frequency code was called for
some reason before the identify_cpu of a AP it should
still work. For the BP this definitely cannot happen.

I also tried it with qemu myself (both one and two cpus) and it worked

Rusty, was this really on a standard kernel? Was it with multiple
CPUs? 

-Andi
