Return-Path: <linux-kernel-owner+w=401wt.eu-S934121AbXLMWLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbXLMWLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762566AbXLMWL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:11:26 -0500
Received: from relay2.sgi.com ([192.48.171.30]:43533 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759047AbXLMWLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:11:25 -0500
Date: Thu, 13 Dec 2007 14:11:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB
In-Reply-To: <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712131410190.25120@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712070957070.7274@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007, Linus Torvalds wrote:

> The biggest cost of __slab_alloc() in my profile is the "slab_lock()", but 
> that may not be the one that causes problems in a 64-cpu setup, so it 
> would be good to have that verified.

Hmmmm.. This would indicate lock contention on a slab.

> [ The whole node match thing is likely totally bogus. I suspect we pay 
>   *more* in trying to match nodes than we'd ever likely pay in just 
>   returning the wrong node for an allocation, but that's neither here nor 
>   there ]

Node match is necessary in order to make the allocator able to get memory 
for the node that the caller requested.
