Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXEaVg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXEaVg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXEaVgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:36:50 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:64540 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbXEaVgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:36:49 -0400
Date: Thu, 31 May 2007 17:36:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Matt Mackall <mpm@selenic.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070531213647.GC904@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca> <20070530214433.GI11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070530214433.GI11166@waste.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:17:23 up 3 days,  5:56,  4 users,  load average: 0.15, 0.22, 0.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Mackall (mpm@selenic.com) wrote:
> > -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> > +	cond_call(profile_on,
> > +		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));
> 
> I think we could do better here pretty trivially. profile hit still
> has an if (unlikely(prof_on == TYPE)). Shouldn't we just have a
> cond_call type for "sched_profiling" and cond_call profile_hits(type,
> ip, 1) directly?
> 

Yes, that's much better. I will leave the profile_hit as a simple call
to profile hits with one parameter for now, although it might be a
little bit useless. Being able to select independently which specific
site must be enabled is interesting too, therefore I will use the more
precise "sched_profiling" to replace "profile_on".

I guess we could also rework profile.c:profile_tick() in the same way,
using "cpu_profiling". It would be interesting to wrap the whole
profile_tick() call in a cond_call, but it would involve dealing with
more than one different things that are part of this function and can
have to run. The same will apply to kvm and sleep profiling.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
