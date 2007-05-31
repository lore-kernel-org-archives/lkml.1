Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbXEaWHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbXEaWHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXEaWHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:07:44 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:64005 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbXEaWHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:07:43 -0400
Date: Thu, 31 May 2007 18:07:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070531220742.GG904@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca> <p736469dsdb.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <p736469dsdb.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:56:45 up 3 days,  6:35,  4 users,  load average: 0.22, 0.12, 0.14
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> >  	}
> > -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> > +	cond_call(profile_on,
> > +		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));
> 
> Would it be possible to use a syntax like
> 
>         if (unlikely_cond_call(variable)) {     (or better name) 
>                 ...
>         } 
> 
> instead? I think that would be much nicer to read than having
> code in a macro argument
> 

I see your point, but there is a level of control on the branch I would
lack by doing so: the ability to put the call in either the if or else
branch. It is an optimization on i386.

I could do it by defining my home-made if() :

cond_if (cond_call_name) {
  code
}

The macro cond_if could then expand (this is a simplified example) in either in

if (cond)

or

if (cond)
else

Also, I live in the expectation that, someday, the gcc guys will be nice
enough to add some kind of support for a nop-based jump that would
require code patching to put a jump instead. If it ever happens, my
macro could evolve into this for newer compiler versions, which I could
not do with the if() statement you are proposing.


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
