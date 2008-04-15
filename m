Return-Path: <linux-kernel-owner+w=401wt.eu-S1764291AbYDORP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764291AbYDORP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYDORPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:15:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35994 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbYDORPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:15:16 -0400
Message-ID: <4804E29F.9060703@firstfloor.org>
Date: Tue, 15 Apr 2008 19:15:11 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
References: <20080411210022.GJ11962@parisc-linux.org>  <20080413125758.GQ11962@parisc-linux.org> <20080414153928.GA22259@elte.hu>  <adafxtoqvgh.fsf@cisco.com> <1208190749.7375.10.camel@twins>  <87d4osuy6r.fsf@basil.nowhere.org> <1208195673.7164.2.camel@twins>  <4803AD91.5020001@firstfloor.org>  <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>  <1208242017.7053.4.camel@lappy>  <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins> <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org> <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 15 Apr 2008, Andi Kleen wrote:
>>>  - probably add support for completions to do counting
>> But that's just a semaphore, isn't it?
> 
> Exactly. But the point here is:
> 
>  - nobody should use semaphores anyway (use mutexes)

For normal locks. But if you have N number of outstanding
events you need to wait for the semaphore is the right primitive.

And it seems there is a not high but non trivial number
of places in the kernel who have a legitimate need for this.

>  - making *more* code use semaphores is wrong
>  - completions have a different _mental_ model
>
> IOW, this is not about implementation issues. It's about how you think 
> about the operations.

Ok so you just want to rename it.

Fine for me. I always found up() and down() unintuitive anyways
(but it's admittedly better than "P" and "V" which some other systems use)

> We should _not_ implement completions as semaphores, simply because we 
> want to get *rid* of semaphores some day. 
> 
> So rather than this long and involved patch series that first makes 
> semaphores generic, and then makes them be used as completions, I'd much 
> rather just skip this whole pointless exercise entirely. 
> 
> Why have "generic semaphores" at all, if we want to get rid of them? 

Because we still "counted completions" for some things and that's the
same code?

Rather i suspect the real problem is not the name, but just not sure
it gets abused. That is largely more a review problem and as far as I
can figure out basically all the usual reviewers take care of that
anyways. But renaming it also probably wouldn't hurt.

[IMHO I always thought we should have a maintained single "list of
things for reviewers to watch out for" list somewhere]

-Andi

