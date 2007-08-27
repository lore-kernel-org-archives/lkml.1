Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbXH0UWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbXH0UWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758565AbXH0UWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:22:07 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:59397 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756340AbXH0UWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:22:06 -0400
Date: Mon, 27 Aug 2007 16:22:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070827202203.GB5653@Krystal>
References: <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com> <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:20:14 up 28 days, 20:39,  4 users,  load average: 0.13, 0.25, 0.27
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 27 Aug 2007, Peter Zijlstra wrote:
> 
> > So, if the fast path can be done with a preempt off, it might be doable
> > to suffer the slow path with a per cpu lock like that.
> 
> Sadly the cmpxchg_local requires local per cpu data access. Isnt there 
> some way to make this less expensive on RT? Acessing cpu local memory is 
> really good for performance on NUMA since the data is optimally placed and 
> one can avoid/reduce locking if the process stays tied to the processor.
> 

On the slow path, in slab_new, we already have to reenable interrupts
because we can sleep. If we make sure that whenever we return to an irq
disable code path we take the current per-cpu data structure again, can
we make the preempt-disable/irq-disabled code paths O(1) ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
