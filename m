Return-Path: <linux-kernel-owner+w=401wt.eu-S969061AbXILOUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969061AbXILOUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968780AbXILOTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:19:51 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:40956 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965735AbXILOTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:19:50 -0400
Date: Wed, 12 Sep 2007 10:19:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Scheduler Profiling - Use Immediate Values
Message-ID: <20070912141947.GA7313@Krystal>
References: <20070906200537.GA5999@Krystal> <p73bqcd9lw4.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <p73bqcd9lw4.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:07:32 up 44 days, 14:26,  4 users,  load average: 0.03, 0.10, 0.14
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> >  
> > -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> > +	immediate_if (&sched_profiling)
> 
> I must say I really dislike immediate_if(). You complained earlier
> that something breaks coloring, but adding such macros will definitely
> break a lot of editors (especially if you use it without {} like here)
> 
> It would be much nicer and readable to just use if 
> (unlikely(immediate_read(&x)) or if you prefer to hide the unlikely
> if (immediate_bool_test(&x)) with an implicit unlikely().
> 
> -Andi

Please refer to :

http://lkml.org/lkml/2007/7/3/301

The idea is not to hide the unlikely, but to leave the opportunity to
make this primitive evolve in something that won't depend on a load
immediate and only require patching of a jump, given the appropriate gcc
support (yet to come).

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
