Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbXIRTaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbXIRTaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXIRTaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:30:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58942 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753012AbXIRTaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:30:23 -0400
Date: Tue, 18 Sep 2007 12:30:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       eric.whitney@hp.com, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH]  2.6.23-rc6:  Fix NUMA Memory Policy Reference Counting
In-Reply-To: <200709180025.40837.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0709181212380.3513@schroedinger.engr.sgi.com>
References: <20070830185053.22619.96398.sendpatchset@localhost>
 <1190057534.5460.131.camel@localhost> <Pine.LNX.4.64.0709171235190.28178@schroedinger.engr.sgi.com>
 <200709180025.40837.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Andi Kleen wrote:

> > The patch does require concurrent increments and decrements in the main 
> > fault patch. The potential is to create another bouncing cacheline for 
> > concurrent faults. This looks like it would cause a performance issue.
> 
> While may be true correctness is always more important than performance.
> So I think this is the right thing for .23. Any performance improvements
> if needed can come later.

Is there any real issue as a result of the refcounting issues? It seems 
that performance improvements are not possible unless one would modify how 
memory policies work using RCU or so.

Ok the effect is limited. get_vma_policy() only increments refcounts 
for foreign or shared policies. So it seems that it is fine if one stays 
away from shmem.

