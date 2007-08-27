Return-Path: <linux-kernel-owner+w=401wt.eu-S1762358AbXH0W10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762358AbXH0W10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXH0W1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:27:18 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:44011 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbXH0W1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:27:17 -0400
Date: Mon, 27 Aug 2007 18:27:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070827222715.GA16982@Krystal>
References: <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com> <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com> <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com> <20070827211003.GA10627@Krystal> <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com> <20070827213845.GB9748@Krystal> <Pine.LNX.4.64.0708271510020.8783@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271510020.8783@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:25:14 up 28 days, 22:44,  3 users,  load average: 0.21, 0.38, 0.86
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:
> 
> > > The slow path would require disable preemption and two interrupt disables.
> > If the slow path have to call new_slab, then yes. But it seems that not
> > every slow path must call it, so for the other slow paths, only one
> > interrupt disable would be required.
> 
> If we include new_slab then we get to 3 times:
> 
> 1. In the cmpxchg_local emulation that fails
> 
> 2. For the slow path
> 
> 3. When calling the page allocator.
> 

Hrm, I just want to certify one thing: A lot of code paths seems to go
to the slow path without requiring cmpxchg_local to execute at all. So
is the slow path more likely to be triggered by the (!object),
(!node_match) tests or by these same tests done in the redo after the
initial cmpxchg_local ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
