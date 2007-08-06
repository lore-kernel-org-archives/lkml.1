Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbXHFSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbXHFSWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXHFSV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:21:56 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:53997
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932202AbXHFSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:21:55 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Date: Mon, 6 Aug 2007 11:21:50 -0700
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
References: <20070806102922.907530000@chello.nl> <20070806103658.107883000@chello.nl> <Pine.LNX.4.64.0708061108430.25069@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708061108430.25069@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061121.50351.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 11:11, Christoph Lameter wrote:
> On Mon, 6 Aug 2007, Peter Zijlstra wrote:
> > Change ALLOC_NO_WATERMARK page allocation such that dipping into
> > the reserves becomes a system wide event.
>
> Shudder. That can just be a desaster for NUMA. Both performance wise
> and logic wise. One cpuset being low on memory should not affect
> applications in other cpusets.

Currently your system likely would have died here, so ending up with a 
reserve page temporarily on the wrong node is already an improvement. 

I agree that the reserve pool should be per-node in the end, but I do 
not think that serves the interest of simplifying the initial patch 
set.  How about a numa performance patch that adds onto the end of 
Peter's series?

Regards,

Daniel
