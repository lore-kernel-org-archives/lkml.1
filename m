Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbYDOQPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbYDOQPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYDOQPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:15:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbYDOQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:15:40 -0400
Date: Tue, 15 Apr 2008 09:09:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
In-Reply-To: <1208249088.7124.7.camel@twins>
Message-ID: <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org>
References: <20080411210022.GJ11962@parisc-linux.org>  <20080413125758.GQ11962@parisc-linux.org> <20080414153928.GA22259@elte.hu>  <adafxtoqvgh.fsf@cisco.com> <1208190749.7375.10.camel@twins>  <87d4osuy6r.fsf@basil.nowhere.org> <1208195673.7164.2.camel@twins>
  <4803AD91.5020001@firstfloor.org>  <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>  <1208242017.7053.4.camel@lappy>  <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Apr 2008, Peter Zijlstra wrote:
> 
> That sounds horrible; I really prefer targeted replacements like
> completions that make it clear what they're supposed to be used for.

I agree. I'd rather _keep_ the completions, and get rid of the semaphores, 
so I think the whole fundamental patch here under discussion is broken.

We should do:
 - continue replacing semaphores that are used purely for mutual exclusion 
   with mutexes.
 - probably add support for completions to do counting
 - and then eventually just do the _reverse_ of what the current patch 
   does, namely replace the existing counting semaphore usage with 
   completions.

Hmm?

		Linus
