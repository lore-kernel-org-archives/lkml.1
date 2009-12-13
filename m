Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbZLMTIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbZLMTIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZLMTIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:08:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38249 "HELO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753871AbZLMTId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:08:33 -0500
Date: Sun, 13 Dec 2009 11:07:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <1260729195.2612.7.camel@localhost>
Message-ID: <alpine.LFD.2.00.0912131052080.13952@localhost.localdomain>
References: <20091212101032.GB25286@elte.hu>  <20091212023603.93768833.akpm@linux-foundation.org>  <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>  <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>  <20091212214235.31429790@lxorguk.ukuu.org.uk>
  <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>  <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>  <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>  <20091213065844.GA20244@elte.hu>  <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain>
  <20091213181726.GA14558@elte.hu> <1260729195.2612.7.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Dec 2009, Trond Myklebust wrote:
> 
> The main remaining problem area is that of file locking (i.e. anything
> that references inode->i_flock). I've started work on that, but a couple
> of higher interrupts have prevented me from pulling it all together in
> time for this merge window...

I'm pretty sure we've had at least two trees with the file locking code 
fixed, but NFS in a status of "unknown".

If I recall correctly, the file locking code itself is not that hard: 
we've done it without the kernel lock in the past (long long ago), and the 
lock usage doesn't nest (or at least it didn't at some point back then ;). 
In fact, I think we even do the actual lock data structure allocations 
outside of the kernel lock exactly because we at one time had a patch that 
used a spinlock for protection of the lists.

(Again, not only my memory, but the code itself may have bitrotted in the 
meantime, of course).

		Linus
