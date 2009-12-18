Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbZLRAON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbZLRAON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZLRAOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:14:10 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:35351 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbZLRAOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:14:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQHABpUKkuuWOl3/2dsb2JhbACBS9R9hC0E
Date: Thu, 17 Dec 2009 19:13:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
	cleanup
Message-ID: <20091218001357.GA30450@Krystal>
References: <20091214220320.665065925@quilx.com> <20091215174302.GA3928@Krystal> <4B2830CC.7040309@kernel.org> <20091216014031.GA12282@Krystal> <4B283BFE.2040005@kernel.org> <20091217133958.GA21618@Krystal> <alpine.DEB.2.00.0912171327220.3638@router.home> <20091217202558.GA21713@Krystal> <alpine.DEB.2.00.0912171443080.5819@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912171443080.5819@router.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:12:39 up 1 day,  8:31,  3 users,  load average: 0.29, 0.16,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Thu, 17 Dec 2009, Mathieu Desnoyers wrote:
> 
> > Some quick test on my Intel Xeon E5405:
> >
> > local cmpxchg:  14 cycles
> > xchg:           18 cycles
> >
> > So yes, indeed, the non-LOCK prefixed local cmpxchg seems a bit faster
> > than the xchg, given the latter has an implied LOCK prefix.
> >
> > Code used for local cmpxchg:
> >                 old = var;
> >                 do {
> >                         ret = cmpxchg_local(&var, old, 4);
> >                         if (likely(ret == old))
> >                                 break;
> >                         old = ret;
> >                 } while (1);
> >
> 
> Great. Could you also put that into "patch-format"?
> 

Sure, can you point me to a git tree I should work on top of which
includes the per cpu infrastructure to extend ?

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
