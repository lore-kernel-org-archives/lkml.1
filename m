Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbXKAPrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbXKAPrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbXKAPrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:47:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45796 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721AbXKAPrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:47:15 -0400
Date: Thu, 1 Nov 2007 16:46:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       riel <riel@redhat.com>
Subject: Re: [patch 1/4] spinlock: lockbreak cleanup
Message-ID: <20071101154636.GA11723@elte.hu>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140241.GB26879@wotan.suse.de> <1193925965.27652.284.camel@twins> <20071101142932.GB2648@wotan.suse.de> <1193931599.5300.40.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193931599.5300.40.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.2
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.2 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7-deb
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> > I guess it was done to make the "template" hacks eaiser. I don't 
> > really find that in good taste, especially for important core 
> > infrastructure. Anyway.
> 
> Actually, what I had/have is a cond_resched_rwlock() that I needed to 
> convert the i_mmap_lock() to rw for testing reclaim scalability.  
> [I've seen a large system running an Oracle OLTP load hang spitting 
> "cpu soft lockup" messages with all cpus spinning on a i_mmap_lock 
> spin lock.] One of the i_mmap_lock paths uses cond_resched_lock() for 
> spin locks. To do a straight forward conversion [and maybe that isn't 
> the right approach], I created the cond_resched_rwlock() function by 
> generalizing the cond_sched_lock() code and creating both spin and rw 
> lock wrappers. I took advantage of the fact that, currently, 
> need_lockbreak() is a macro and that both spin and rw locks have/had 
> the break_lock member. Typesafe functions would probably be 
> preferrable, if we want to keep break_lock for rw spin locks.
> 
> Here's the most recent posting:
> 
> 	http://marc.info/?l=linux-mm&m=118980356306014&w=4
> 
> See the changes to sched.[ch].  Should apply to 23-mm1 with offsets 
> and minor fixup in fs/inode.c.

yep. I'm too in favor of keeping the need-lockbreak mechanism and its 
type-insensitive data structure. We've got way too many locking 
primitives and keeping them all sorted is nontrivial already. I wouldnt 
mind seeing the need_lockbreak flag move into one of the high bits of 
spinlocks though, to compress size.

	Ingo
