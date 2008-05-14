Return-Path: <linux-kernel-owner+w=401wt.eu-S1763263AbYENSmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763263AbYENSmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759274AbYENSmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:42:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758454AbYENSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:42:09 -0400
Date: Wed, 14 May 2008 11:41:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
In-Reply-To: <20080514174955.GA515@elte.hu>
Message-ID: <alpine.LFD.1.10.0805141136340.3019@woody.linux-foundation.org>
References: <20080514174955.GA515@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 May 2008, Ingo Molnar wrote:
> 
> Linus, Alan: the increased visibility and debuggability of the BKL 
> already uncovered a rather serious regression in upstream -git. You 
> might want to cherry pick this single fix, it will apply just fine to 
> current -git:

Ok, so I'm obviously happy. This is exactly the kind of thing I would want 
to see.

That said, the way it is now set up, it's unreasonable to merge anything 
directly, and while I can cherry-pick obvious fixes this way, I do think 
we could do things better.

It should be possible to set things up so that it's a config option, and 
we can mark it EXPERIMENTAL but still merge it into the standard kernel, 
so that we'd have the debug stuff there. That would get a lot more 
coverage, especially if it all still *works*, even if the debug stuff then 
complains (ie it would be nicer if the lock itself didn't start breaking).

So for example, have CONFIG_DEBUG_BKL turn it into a mutex (and select 
mutex debugging), and get all the debug coverage that way, but then when 
somebody enters the scheduler with the lock held, first complain, but then 
auto-release it anyway. That way, bugs get found and complained about, but 
hopefully the machine still ends up working.

		Linus
