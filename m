Return-Path: <linux-kernel-owner+w=401wt.eu-S1765688AbXKUAxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765688AbXKUAxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbXKUAxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:53:12 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:58413 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479AbXKUAxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:53:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAMIPQ0dMROHU/2dsb2JhbACBWw
Date: Tue, 20 Nov 2007 19:53:08 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Lameter <clameter@sgi.com>, ak@suse.de,
       akpm@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [rfc 19/45] cpu alloc: NFS statistics
Message-ID: <20071121005307.GA26793@Krystal>
References: <20071120011132.143632442@sgi.com> <20071120011336.210236732@sgi.com> <20071120130201.GE10127@Krystal> <Pine.LNX.4.64.0711201248330.26745@schroedinger.engr.sgi.com> <1195592198.7234.45.camel@heimdal.trondhjem.org> <20071120212834.GC11291@Krystal> <1195595283.7234.50.camel@heimdal.trondhjem.org> <20071120215048.GA14522@Krystal> <1195598802.7234.87.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1195598802.7234.87.camel@heimdal.trondhjem.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:48:55 up 17 days,  5:54,  4 users,  load average: 2.41, 1.98,
	1.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Trond Myklebust (trond.myklebust@fys.uio.no) wrote:
> 
> On Tue, 2007-11-20 at 16:50 -0500, Mathieu Desnoyers wrote:
> > Then my original point is valid : put_no_resched() will cause unwanted
> > scheduler latencies. It's designed only to be used from within the
> > scheduler code itself. The correct approach would be a standard
> > put_cpu().
> > 
> > Or am I missing something ?
> 
> Then someone who cares about scheduler latency had better audit the code
> and figure out which calls are made under spinlock, and which aren't:
> it's not on my personal list of high priorities. I'll be happy to review
> any patches, though.
> 

put_cpu() will work flawlessly when nested within a spinlock. the
spinlock disabled itself preemption, and a nested preemption
disable/enable/check will end up incrementing/decrementing the preempt
cours. The check at the end will just not call the scheduler when nested
within a spinlock.

If this is what you are worried about, then you shouldn't. I am a bit
surprised about your reaction though.. so I probably missed
something/don't understand correctly your fear about check_resched
within a spinlock.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
