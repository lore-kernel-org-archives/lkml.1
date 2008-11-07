Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbYKGRo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbYKGRo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYKGRot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:44:49 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:60934 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbYKGRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:44:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAMcLFElMQWxa/2dsb2JhbACBdsddg1Y
Date: Fri, 7 Nov 2008 12:44:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [RFC patch 17/18] MIPS : Trace clock
Message-ID: <20081107174446.GF22134@Krystal>
References: <20081107052336.652868737@polymtl.ca> <20081107053351.329744816@polymtl.ca> <1226058797.2697.19.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1226058797.2697.19.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:20:08 up 155 days, 22:00,  7 users,  load average: 0.70, 0.77,
	0.69
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Fri, 2008-11-07 at 00:23 -0500, Mathieu Desnoyers wrote:
> > Note for Peter Zijlstra :
> > You should probably have a look at lockdep.c raw_spinlock_t lockdep_lock usage.
> > I suspect it may be used with preemption enabled in graph_lock(). (not sure
> > though, but it's worth double-checking.
> 
> Are you worried about the graph_lock() instance in
> lookup_chain_cache() ?
> 
> That is the locking for validate_chain,
> 
> __lock_acquire()
>  validate_chain()
>    look_up_chain_cache()
>      graph_lock()
>    check_prevs_add()
>      check_prev_add()
>        graph_unlock()
>        graph_lock()
>    graph_unlock()
> 
> which is all done without modifying IRQ state.
> 
> However, __lock_acquire() is only called with IRQs disabled:
> 
> lock_acquire()
>   raw_local_irq_save()
>   __lock_acquire()
> 
> lock_release()
>   raw_local_irq_save()
>   __lock_release()
>     lock_release_nested()
>       __lock_acquire()
>     lock_release_non_nested()
>       __lock_acquire()
> 
> lock_set_subclass()
>   raw_local_irq_save()
>   __lock_set_subclass()
>     __lock_acquire()
> 
> So I think we're good.
> 

Yep, looks good.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
