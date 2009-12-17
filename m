Return-Path: <linux-kernel-owner+w=401wt.eu-S935671AbZLQNkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935671AbZLQNkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935383AbZLQNkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:40:05 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:38718 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935378AbZLQNkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:40:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFAMvCKUuuWOl3/2dsb2JhbACBS9UNhC0E
Date: Thu, 17 Dec 2009 08:39:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
	cleanup
Message-ID: <20091217133958.GA21618@Krystal>
References: <20091214220320.665065925@quilx.com> <20091215174302.GA3928@Krystal> <4B2830CC.7040309@kernel.org> <20091216014031.GA12282@Krystal> <4B283BFE.2040005@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B283BFE.2040005@kernel.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:33:31 up 21:52,  4 users,  load average: 0.11, 0.19, 0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo (tj@kernel.org) wrote:
> Hello,
> 
> On 12/16/2009 10:40 AM, Mathieu Desnoyers wrote:
> > Nope, there is the same number of sub-buffers for each per-cpu buffer.
> > I just want to see if supplementary indirections are allowed after
> > dereferencing the per-cpu pointer ?
> 
> Hmmm... you can store percpu pointer to a variable.  If there are the
> same number of commit_count for each cpu, they can be allocated using
> percpu allocator and their pointers can be stored, offset and
> dereferenced.  Would that be enough?

Yes, I think I could allocate, from the channel structure perspective:

- A percpu pointer to the per-cpu buffer structures
- A percpu pointer to the per-cpu commit counters.

This should fix my problem. The main change here is that the pointer to
the commit counters would not be located in the per-cpu buffer
structures anymore.

However, I would need:

this_cpu_cmpxchg(scalar, oldv, newv)
  (maps to x86 cmpxchg)

this_cpu_add_return(scalar, value)
  (maps to x86 xadd)

too. Is that a planned addition ?

(while we are at it, we might as will add the xchg instruction,
althrough it has an implied LOCK prefix on x86).

Thanks,

Mathieu

> 
> Thanks.
> 
> -- 
> tejun

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
