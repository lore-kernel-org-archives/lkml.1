Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbXIJTl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbXIJTl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbXIJTlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:41:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46874 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755564AbXIJTlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:41:45 -0400
Date: Mon, 10 Sep 2007 12:41:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <npiggin@suse.de>, Daniel Phillips <phillips@phunq.net>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
In-Reply-To: <1189453031.21778.28.camel@twins>
Message-ID: <Pine.LNX.4.64.0709101238510.24941@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com>  <200709050220.53801.phillips@phunq.net>
  <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com> 
 <20070905114242.GA19938@wotan.suse.de>  <Pine.LNX.4.64.0709050507050.9141@schroedinger.engr.sgi.com>
  <20070905121937.GA9246@wotan.suse.de>  <Pine.LNX.4.64.0709101225350.24735@schroedinger.engr.sgi.com>
 <1189453031.21778.28.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007, Peter Zijlstra wrote:

> >  Peter's approach establishes the 
> > limit by failing PF_MEMALLOC allocations. 
> 
> I'm not failing PF_MEMALLOC allocations. I'm more stringent in failing !
> PF_MEMALLOC allocations.

Right you are failing other allocations.

> > If that occurs then other 
> > subsystems (like the disk, or even fork/exec or memory management 
> > allocation) will no longer operate since their allocations no longer 
> > succeed which will make the system even more fragile and may lead to 
> > subsequent failures.
> 
> Failing allocations should never be a stability problem, we have the
> fault-injection framework which allows allocations to fail randomly -
> this should never crash the kernel - if it does its a BUG.

Allright maybe you can get the kernel to be stable in the face of having 
no memory and debug all the fallback paths in the kernel when an OOM 
condition occurs.

But system calls will fail? Like fork/exec? etc? There may be daemons 
running that are essential for the system to survive and that cannot 
easily take an OOM condition? Various reclaim paths also need memory and 
if the allocation fails then reclaim cannot continue.

