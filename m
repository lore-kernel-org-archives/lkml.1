Return-Path: <linux-kernel-owner+w=401wt.eu-S1765607AbYDORAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765607AbYDORAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYDORAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:00:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250AbYDORAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:00:24 -0400
Date: Tue, 15 Apr 2008 09:57:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
In-Reply-To: <4804D779.6070907@firstfloor.org>
Message-ID: <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org>
References: <20080411210022.GJ11962@parisc-linux.org>  <20080413125758.GQ11962@parisc-linux.org> <20080414153928.GA22259@elte.hu>  <adafxtoqvgh.fsf@cisco.com> <1208190749.7375.10.camel@twins>  <87d4osuy6r.fsf@basil.nowhere.org> <1208195673.7164.2.camel@twins>
  <4803AD91.5020001@firstfloor.org>  <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>  <1208242017.7053.4.camel@lappy>  <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins>
 <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Apr 2008, Andi Kleen wrote:
> 
> >  - probably add support for completions to do counting
> 
> But that's just a semaphore, isn't it?

Exactly. But the point here is:

 - nobody should use semaphores anyway (use mutexes)
 - making *more* code use semaphores is wrong
 - completions have a different _mental_ model

IOW, this is not about implementation issues. It's about how you think 
about the operations.

We should _not_ implement completions as semaphores, simply because we 
want to get *rid* of semaphores some day. 

So rather than this long and involved patch series that first makes 
semaphores generic, and then makes them be used as completions, I'd much 
rather just skip this whole pointless exercise entirely. 

Why have "generic semaphores" at all, if we want to get rid of them? 

		Linus
