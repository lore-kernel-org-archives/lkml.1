Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbYDORbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbYDORbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYDORbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:31:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYDORbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:31:06 -0400
Date: Tue, 15 Apr 2008 10:26:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
In-Reply-To: <4804E29F.9060703@firstfloor.org>
Message-ID: <alpine.LFD.1.00.0804151023350.2879@woody.linux-foundation.org>
References: <20080411210022.GJ11962@parisc-linux.org>  <20080413125758.GQ11962@parisc-linux.org> <20080414153928.GA22259@elte.hu>  <adafxtoqvgh.fsf@cisco.com> <1208190749.7375.10.camel@twins>  <87d4osuy6r.fsf@basil.nowhere.org> <1208195673.7164.2.camel@twins>
  <4803AD91.5020001@firstfloor.org>  <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>  <1208242017.7053.4.camel@lappy>  <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins>
 <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org> <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org> <4804E29F.9060703@firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Apr 2008, Andi Kleen wrote:
> 
> For normal locks. But if you have N number of outstanding
> events you need to wait for the semaphore is the right primitive.

Right. Except if you were to just use completions instead (which could be 
trivially extended to do that).

MUCH more trivial than this complex series.

(You may think that the "Replace completions with semaphores" patch is not 
very complicated, but it *is* - it depends very intimately on the big 
patch-series that basically turns semaphores into what completions are 
now!)

In other words, what makes me not like this is hat we first turn 
semaphores into the generic code (which is largely what completions were: 
just a special case of the generic semaphores!) and then turns completions 
into these things. That just doesn't make any sense to me!

			Linus
