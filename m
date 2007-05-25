Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbXEYIWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbXEYIWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXEYIVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:21:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50734 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXEYIVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:21:51 -0400
Date: Fri, 25 May 2007 10:21:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Satyam Sharma <satyam.sharma@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] sched_clock(): cleanups
Message-ID: <20070525082150.GG8094@one.firstfloor.org>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525072512.GA12683@elte.hu> <20070525072641.GA13025@elte.hu> <a781481a0705250035q2173234dp4f6cc4d103fced5c@mail.gmail.com> <1180078773.7348.31.camel@twins> <20070525075824.GD8094@one.firstfloor.org> <1180081000.7348.39.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180081000.7348.39.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:16:39AM +0200, Peter Zijlstra wrote:
> On Fri, 2007-05-25 at 09:58 +0200, Andi Kleen wrote:
> > On Fri, May 25, 2007 at 09:39:33AM +0200, Peter Zijlstra wrote:
> > > On Fri, 2007-05-25 at 13:05 +0530, Satyam Sharma wrote:
> > > > On 5/25/07, Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > > call_r_s_f() still needs an urgent rerenaming though =B-)
> > > > 
> > > > So does "call_r_s_f_here()" :-)
> > > 
> > > That name makes me think of INTERCAL's 'DO COME FROM' statement.
> > > And any code that makes one think of INTERCAL is say,.. special.. :-)
> > 
> > Propose a better way to code this then? It's not my fault that dealing with 
> > callbacks in C is so messy. _here just massages one callback
> > prototype (smp_call_function's) into another (cpufreq's) because
> > both callbacks do the same in this case.
> 
> I see you point; however a function called:
> call_<some_other_function>_here() just doesn't make sense. It says as
> much as: we should call some_other_function() but for some reason we
> dont.

It's just different semantics between cpufreq and smp_call_functions.
cpufreq doesn't execute on that CPU but gives you the cpu number,
smp_call_* executes on that CPU but doesn't give you a cpu number.
_here means call cpufreq callback on the current CPU.

-Andi
