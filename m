Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXHFScy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXHFScy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXHFScn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:32:43 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39291 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbXHFScm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:32:42 -0400
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Phillips <phillips@phunq.net>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
In-Reply-To: <200708061121.50351.phillips@phunq.net>
References: <20070806102922.907530000@chello.nl>
	 <20070806103658.107883000@chello.nl>
	 <Pine.LNX.4.64.0708061108430.25069@schroedinger.engr.sgi.com>
	 <200708061121.50351.phillips@phunq.net>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 20:31:02 +0200
Message-Id: <1186425063.11797.80.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 11:21 -0700, Daniel Phillips wrote:
> On Monday 06 August 2007 11:11, Christoph Lameter wrote:
> > On Mon, 6 Aug 2007, Peter Zijlstra wrote:
> > > Change ALLOC_NO_WATERMARK page allocation such that dipping into
> > > the reserves becomes a system wide event.
> >
> > Shudder. That can just be a desaster for NUMA. Both performance wise
> > and logic wise. One cpuset being low on memory should not affect
> > applications in other cpusets.

Do note that these are only PF_MEMALLOC allocations that will break the
cpuset. And one can argue that these are not application allocation but
system allocations.

> Currently your system likely would have died here, so ending up with a 
> reserve page temporarily on the wrong node is already an improvement. 
> 
> I agree that the reserve pool should be per-node in the end, but I do 
> not think that serves the interest of simplifying the initial patch 
> set.  How about a numa performance patch that adds onto the end of 
> Peter's series?

Trouble with keeping this per node is that all the code dealing with the
reserve needs to keep per-cpu state, which given that the system is
really crawling at that moment, seems excessive.

