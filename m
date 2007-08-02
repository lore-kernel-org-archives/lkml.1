Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbXHBSdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbXHBSdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759011AbXHBSdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:33:42 -0400
Received: from dvhart.com ([64.146.134.43]:46027 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323AbXHBSdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:33:41 -0400
Message-ID: <46B22383.5020109@mbligh.org>
Date: Thu, 02 Aug 2007 11:33:39 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [rfc] balance-on-fork NUMA placement
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de> <20070801002313.GC31006@wotan.suse.de> <46B0C8A3.8090506@mbligh.org> <1185993169.5059.79.camel@localhost> <46B10E9B.2030907@mbligh.org> <20070802013631.GA15595@wotan.suse.de>
In-Reply-To: <20070802013631.GA15595@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wed, Aug 01, 2007 at 03:52:11PM -0700, Martin Bligh wrote:
>>> And so forth.  Initial forks will balance.  If the children refuse to
>>> die, forks will continue to balance.  If the parent starts seeing short
>>> lived children, fork()s will eventually start to stay local.  
>> Fork without exec is much more rare than without. Optimising for
>> the uncommon case is the Wrong Thing to Do (tm). What we decided
> 
> It's only the wrong thing to do if it hurts the common case too
> much. Considering we _already_ balance on exec, then adding another
> balance on fork is not going to introduce some order of magnitude
> problem -- at worst it would be 2x but it really isn't too slow
> anyway (at least nobody complained when we added it).
> 
> One place where we found it helps is clone for threads.
> 
> If we didn't do such a bad job at keeping tasks together with their
> local memory, then we might indeed reduce some of the balance-on-crap
> and increase the aggressiveness of periodic balancing.
> 
> Considering we _already_ balance on fork/clone, I don't know what
> your argument is against this patch is? Doing the balance earlier
> and allocating more stuff on the local node is surely not a bad
> idea.

I don't know who turned that on ;-( I suspect nobody bothered
actually measuring it at the time though, or used some crap
benchmark like stream to do so. It should get reverted.

