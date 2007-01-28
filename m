Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbXA1PuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbXA1PuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXA1PuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:50:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47682 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbXA1PuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:50:18 -0500
Date: Sun, 28 Jan 2007 16:48:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-ID: <20070128154806.GA10615@elte.hu>
References: <1169993494.10987.23.camel@lappy> <20070128144933.GD16552@infradead.org> <20070128151700.GA7644@elte.hu> <20070128152858.GA23410@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128152858.GA23410@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Jan 28, 2007 at 04:17:00PM +0100, Ingo Molnar wrote:
> > scalability. I did lock profiling on the -rt kernel, which exposes 
> > such things nicely. Half of the lock contention events during kernel 
> > compile were due to kmap(). (The system had 2 GB of RAM, so 40% 
> > lowmem, 60% highmem.)
> 
> Numbers please, and not on -rt but on mainline.  Please show the 
> profiles.

i'm sorry, but do you realize that files_lock is a global lock, 
triggered by /every single/ file close?

   " files_lock is a global lock and we touch it for every single
     sys_close() system call that the system does. "

You really dont need to be a rocket scientist to see that it's a 
globally bouncing cacheline that has a major effect on certain 
VFS-intense workloads. Peter has worked hard to eliminate its effects 
without having to couple this to an intrusive rewrite of the TTY layer.

( really, i personally find your dismissive style apalling and i think 
  such a reception of a nice patchset must be humiliating to Peter. I
  certainly try to avoid to be involved with any VFS internals, due to
  this unwelcoming tone of discussion. Had you been around when i
  started contributing to the Linux kernel i'd probably not be hacking
  the kernel today. You are a good hacker but the simultaneous
  collateral damage you are causing is significantly reducing the net
  benefit. )

> > ps. please fix your mailer to not emit Mail-Followup-To headers. In 
> > Mutt you can do this via "set followup_to=no" in your .muttrc.
> 
> I have told you last time that this is absolutely intentional and I 
> won't change it.

( You are messing up the reply headers, everyone is listed in the 'To:'
  field for any reply to your mail, instead of being added to the Cc:
  list. )

	Ingo
