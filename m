Return-Path: <linux-kernel-owner+w=401wt.eu-S1765059AbYDPQCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765059AbYDPQCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbYDPQCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:02:24 -0400
Received: from smtprelay06.ispgateway.de ([80.67.18.44]:55455 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbYDPQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:02:23 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Replace completions with semaphores
Date: Wed, 16 Apr 2008 18:07:24 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
References: <4803AD91.5020001@firstfloor.org> <20080415174109.GD9191@parisc-linux.org> <alpine.LFD.1.00.0804151101590.2879@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804151101590.2879@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804161807.25582.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2008, Linus Torvalds wrote:
> Would it make sense to use completions for countable events too? Yeah. In 
> fact, we have some things that really would like to do counting, both in 
> the sense of "wait for <n> events to all complete" _and_ in the sense of 
> "allow up to <n> events to be outstanding". Both of which could be done as 
> a counting function (just make "complete" increment the counter, and then 
> make "wait for <n> events" initialize it to negative, while "allow <n>
> outstanding events" would be a positive counter, and make 
> "wait_for_completion()" basically be a "decrement and wait until it 

Hmm, why not introduce a provide_slots(), 
wait_for_slot() and free_slot() API?

provide_slots() :=  initialize a resource with N available slots
wait_for_slot() :=  wait for a slot in countable resource to be free
free_slot() :=  make a slot available

That would:
- fit the use case nicely
- could be optimized for countable resources
  with upper limits
- allow to measure slot utilization
- ...
- is not called semaphore :-)

And isn't this the same problem (called scheduling) as:
- keeping N cpus busy
- keeping N (disk) spindles busy
- keeping N nic transmit queues busy
- ...

???

But maybe I oversimplify here :-)


Best Regards

Ingo Oeser
