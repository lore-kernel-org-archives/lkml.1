Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXKAQiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXKAQiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXKAQil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:38:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbXKAQil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:38:41 -0400
Date: Thu, 1 Nov 2007 09:38:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gregory Haskins <gregory.haskins.ml@gmail.com>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
In-Reply-To: <4729E567.1050402@gmail.com>
Message-ID: <alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de>
 <4729E567.1050402@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Nov 2007, Gregory Haskins wrote:
> 
> I had observed this phenomenon on some 8-ways here as well, but I didn't
> have the bandwidth to code something up.  Thumbs up!

Can you test under interesting loads?

We're interested in:
 - is the unfairness fix really noticeable (or does it just move the 
   problem somewhere else, and there is no real change in behaviour)
 - what is the performance impact?

In particular, unfair spinlocks have the potential to perform much better. 
Not so much because the spinlock itself acts all that differently, but 
because being unfair also fundmanetally tends to keep the data structures 
that are *protected* by the spinlock on just one CPU.

So "unfair" is obviously always bad. Except when it isn't. I'd personally 
like to merge the ticket spinlocks, but I'd really like to have people who 
have real loads where they matter actually also do some performance 
testing. Because I do think it will potentially be a performance downer. 

(I obviously hope it won't be, but..)

		Linus
