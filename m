Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbZLMTRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbZLMTRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZLMTRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:17:53 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:39286 "HELO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753962AbZLMTRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:17:52 -0500
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0912131052080.13952@localhost.localdomain>
References: <20091212101032.GB25286@elte.hu>
	 <20091212023603.93768833.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
	 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
	 <20091212214235.31429790@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>
	 <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
	 <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>
	 <20091213065844.GA20244@elte.hu>
	 <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain>
	 <20091213181726.GA14558@elte.hu> <1260729195.2612.7.camel@localhost>
	 <alpine.LFD.2.00.0912131052080.13952@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Dec 2009 14:17:15 -0500
Message-Id: <1260731835.2612.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 17 msgs/h 2 sum rcpts/h 22 sum msgs/h 2 total rcpts 2031 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 7BE470456589CD8B61048B318D2309ACFB87EE6A
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 40 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 11:07 -0800, Linus Torvalds wrote: 
> 
> On Sun, 13 Dec 2009, Trond Myklebust wrote:
> > 
> > The main remaining problem area is that of file locking (i.e. anything
> > that references inode->i_flock). I've started work on that, but a couple
> > of higher interrupts have prevented me from pulling it all together in
> > time for this merge window...
> 
> I'm pretty sure we've had at least two trees with the file locking code 
> fixed, but NFS in a status of "unknown".
> 
> If I recall correctly, the file locking code itself is not that hard: 
> we've done it without the kernel lock in the past (long long ago), and the 
> lock usage doesn't nest (or at least it didn't at some point back then ;). 
> In fact, I think we even do the actual lock data structure allocations 
> outside of the kernel lock exactly because we at one time had a patch that 
> used a spinlock for protection of the lists.

After the current set of patches, have been merged by you, the only
stuff that will continue to rely on nested BKL will be lockd. I can fix
that up in the next cycle.

> (Again, not only my memory, but the code itself may have bitrotted in the 
> meantime, of course).

Agreed. I'm not saying that it's hard. I'm just saying that I ran out of
time due to other commitments.

Cheers
  Trond

