Return-Path: <linux-kernel-owner+w=401wt.eu-S1030840AbXDTF1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030840AbXDTF1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030851AbXDTF1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:27:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55962 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030840AbXDTF1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:27:36 -0400
Date: Thu, 19 Apr 2007 22:27:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
In-Reply-To: <20070420044718.GV2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704192220510.16360@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070420044718.GV2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, William Lee Irwin III wrote:

> Oh dear. Per-file pagesizes are foul. Better to fix up the pagecache's
> radix tree than to restrict it like this. There are other attacks on the
> multiple horizontal internal tree node allocation problem beyond
> outright B+ trees that allow radix trees to continue to be used.

per-file pagesizes are just the granularity that is available. The order
value is then readily available for all page cache operations. In practice 
it is likely that filesystems will have one consistent page size. If you 
look at the ramfs implementation then you will see that is exactly the
approach taken here. I want to avoid any modifications to key data 
structures or locking. If possible straight code transformation.

> I've always wanted the awareness to be pervasive, so it's good to hear
> there's someone with a common interest. If this effort takes off, I'd be
> happy to contribute to it. I do wonder what ever happened with the gelato
> codebase, though.

The superpages? I do not think that we should be getting that complicated 
here. Maybe we can pick up some ideas at some point.

> > since we are always operating on a single page struct. Reclaim is fooled to
> > think that it is touching page sized objects (there are likely issues to be
> > fixed there if we want to go down this road).
> 
> I'm afraid this may be approaching an underappreciated research topic.
> Most sponsors of such research seem to have an active disinterest in
> getting page replacement to properly interoperate with all this.

Well that is the difference between academia where one gets his Ph.D. for
superpages, publishes a couple of papers and then its over and real 
kernel work where this actually will have to work consistently with the 
rest of the system. Let us thus do small steps towards the goal 
while keeping things as simple and straightforward as possible.

