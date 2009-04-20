Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZDTTun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZDTTun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbZDTTuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:50:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44061 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZDTTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:50:07 -0400
Date: Mon, 20 Apr 2009 21:53:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #13058] First hibernation attempt fails
Message-ID: <20090420195306.GA3299@elf.ucw.cz>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090417063007.GB4593@kernel.dk> <49E83DC4.8040207@tuffmail.co.uk> <20090417091321.GP4593@kernel.dk> <alpine.LFD.2.00.0904170813550.4042@localhost.localdomain> <20090407080632.GG1408@ucw.cz> <20090420122044.7ea6cc15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420122044.7ea6cc15.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > And the thing is, that "swsusp_shrink_memory()" is just full of 
> > > heuristics. There's no hard numbers there. It doesn't seem to wait for 
> > > writeout, it just does the equivalent of "shrink_list()" and 
> > > "shrink_slab()", but it seems to have been basically cribbed half-way 
> > > from the regular "try to free memory", without really doing it all.
> > 
> > akpm designed shrink_memory(). Long time ago it was just while (1)
> > kmalloc() loop. It should be waiting. Andrew?
> 
> I always wanted the thing to just allocate all the memory which it
> needed and then to either return it all to the caller or free it all
> again for the caller to reallocate (preferably the former).

We need half of memory free for swsusp to work. If we "just allocate"
it, we will trigger OOM killer; we'd prefer to fail suspend than to
OOM kill.

> But for some reason which I don't recall (Pavel provided it, iirc)
> that

Alas, I do not remember that clearly.

> doesn't work.  So the current (and subsequently tweaked) scheme was put
> in there instead.  It turned out to be surprisingly difficult and ugly
> to graft it in top of the existing page reclaim code, and various
> changes were subsequently made to make it sort-of-work.
> 
> Remind me: why can't we just allocate N pages at suspend-time?

We need half of memory free. The reason we can't "just allocate" is
probably OOM killer; but my memories are quite weak :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
