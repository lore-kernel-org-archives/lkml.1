Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbXGHKW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbXGHKW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbXGHKWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:22:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbXGHKWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:22:48 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
References: <20070708043228.GB22397@wotan.suse.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Jul 2007 13:18:10 +0200
In-Reply-To: <20070708043228.GB22397@wotan.suse.de>
Message-ID: <p733azz16vh.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> I made some tests of the queued spinlock code using userspace test code on
> 64-bit processors. I believe the xadd based code no longer has any theoretical
> memory ordering problems.

Linus, the background of this is that on 8 socket Opteron systems
the current spinlocks can become very unfair to the point of severe 
starvation. These boxes are becomming more common.

> The threaded results also attempt to have an unfairness count, which is the
> max number of times in a row that a lock is acquired,  when all other threads
> are also executing in the loop -- the reason xadd for example is not always
> 0 there is because the other threads may not have reached the lock before
> the current thread was able to get it several times (eg. if an interrupt
> comes in, this could happen).

Interesting. I was also thinking about switching the lock types
at boot time. Since all the lock calls are out of line this would
be reasonably easy.

I would say the main drawback of switchable and queued locks 
would be also that they require a larger spinlock_t thus increasing
cache usage

e.g. it would probably hurt for the large spinlock tables used 
by TCP, but then those should be fixed anyways to be smaller.

-Andi

