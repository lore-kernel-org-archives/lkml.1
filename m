Return-Path: <linux-kernel-owner+w=401wt.eu-S1762182AbXIUT0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182AbXIUT0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbXIUT0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:26:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39587 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752183AbXIUT0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:26:23 -0400
Date: Fri, 21 Sep 2007 12:26:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709211221560.17698@schroedinger.engr.sgi.com>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Linus Torvalds wrote:

> Yeah, and the whole thing seems totally bogus. It totally depends on 
> mmu_gather doing everything right (which very much includes the dependency 
> on mmu gathering disabling preempt).

The quicklists have been existing for a long time in this relationship 
and were actually developed initially (by Dave Miller I believe) to work 
this way. The generic TLB flushing thing may have developed in parallel on 
other platforms that did not use quicklists.

> For exmaple, if we were to go back to the original small tlb_gather with a 
> simple quicklist on the stack, rather than the per-cpu datastructure, the 
> quicklists would immediately break horribly - simply because they are 
> incorrectly now depending on the internal semantics of that tlb-gather.

Hmmmm.. Right the integration of the approaches that have now diverged on 
various platforms could be better.
 
> As it is, the quicklists try to be something separate, but by virtue of 
> being separate, they will always be buggy.

I guess we need to re-join what was separated by developments on different 
platforms.

> The only way to fix it would be to integrate the quicklist stuff *with* 
> the mmu_gather stuff, so that these kinds of implementation issues are 
> explicitly shown in the relationship, instead of havign two "independent" 
> pieces of code where one piece very subtly depends on the exact 
> implementation of the other.

Right. But will that not mean that quicklists would have to be used on all 
platforms in a generic way?
