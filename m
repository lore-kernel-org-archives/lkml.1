Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbYJVR5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbYJVR5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbYJVR5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:57:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:34373 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753568AbYJVR5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:57:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/FcawN0YfFTXZMkLtv81qWtr+BFSyIstTcBoQufj
	LffGpzkwfryLRb
Subject: Re: [PATCH 0/4] pending scheduler updates
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1224697094.20069.9.camel@twins>
References: <20081017172701.047939625@chello.nl>
	 <20081020120538.GD10594@elte.hu>
	 <20081021173529.GG11679@linux.vnet.ibm.com>
	 <20081022094019.GG12453@elte.hu>
	 <1224669821.6871.16.camel@marge.simson.net>
	 <1224671528.7511.11.camel@marge.simson.net>
	 <1224697094.20069.9.camel@twins>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 19:56:55 +0200
Message-Id: <1224698215.4639.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 19:38 +0200, Peter Zijlstra wrote:
> On Wed, 2008-10-22 at 12:32 +0200, Mike Galbraith wrote:
> > On Wed, 2008-10-22 at 12:03 +0200, Mike Galbraith wrote:
> > 
> > > It has positive effects too, but IMHO, the bad outweigh the good.
> > 
> > BTW, most dramatic on the other end of the spectrum is pgsql+oltp.  With
> > preemption as is, it collapses as load climbs to heavy with preemption
> > knobs at stock.  Postgres uses user-land spinlocks and _appears_ to wake
> > others while these are still held.  For this load, there is such a thing
> > as too much short-term fairness, preempting lock holder creates nasty
> > gaggle of contended lock spinners.  It's curable with knobs, and I think
> > it's postgres's own fault, but may be wrong.
> > 
> > With that patch, pgsql+oltp scales perfectly.
> 
> Are we talking about this patch, which re-instates the vruntime based
> wakeup-preemption ?

No, if it was that one, I'd be tinkering with mysql+oltp.  Everything
else I tested (limited time, but fairly wide spectrum) with that patch
was fine, including interactivity.  Caveat: tbench/netperf test results
I'm not comfortable with, would need to backport to 26 to feel at all
confident with those.  (fwtw)

	-Mike

