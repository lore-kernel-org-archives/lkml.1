Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbXKBP3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbXKBP3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbXKBP3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:29:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50047 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755218AbXKBP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:29:40 -0400
Date: Fri, 2 Nov 2007 08:29:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <1194016836.27652.406.camel@twins>
Message-ID: <Pine.LNX.4.64.0711020826040.26717@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711011511450.22508@schroedinger.engr.sgi.com> 
 <20071101.153824.91808126.davem@davemloft.net> 
 <Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com> 
 <20071101.155805.65012933.davem@davemloft.net>  <1193999326.27652.348.camel@twins>
  <Pine.LNX.4.64.0711020734070.26635@schroedinger.engr.sgi.com>
 <1194016836.27652.406.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007, Peter Zijlstra wrote:

> On Fri, 2007-11-02 at 07:35 -0700, Christoph Lameter wrote:
> 
> > Well I wonder if I should introduce it not as a replacement but as an 
> > alternative to allocpercpu? We can then gradually switch over. The 
> > existing API does not allow the specification of gfp_masks or alignements.
> 
> I've thought about suggesting that very thing. However, I think we need
> to have a clear view of where we're going with that so that we don't end
> up with two per cpu allocators because some users could not be converted
> over or some such.

At least in my tests so far show that it can be a full replacement but 
then I have only tested on x86_64 and Ia64. Its likely much easier to go
for the full replacement rather than in steps.

If we want dynamically sized virtually mapped per cpu areas then we may 
have issues on 32 bit platforms and with !MMU. So I would think that a 
fallback to a statically sized version may be needed. On the other hand
!MMU and 32 bit do not support a large number of processors. So we may be 
able to get away on 32 bit with a small virtual memory area.

