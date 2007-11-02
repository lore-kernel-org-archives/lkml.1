Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbXKBCBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbXKBCBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbXKBCBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:01:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbXKBCBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:01:31 -0400
Date: Thu, 1 Nov 2007 22:01:07 -0400
From: Rik van Riel <riel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071101220107.1d71f4d9@bree.surriel.com>
In-Reply-To: <alpine.LFD.0.999.0711011819110.3342@woody.linux-foundation.org>
References: <20071101140146.GA26879@wotan.suse.de>
	<20071101140320.GC26879@wotan.suse.de>
	<4729E567.1050402@gmail.com>
	<alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org>
	<20071101203526.293cd7f0@bree.surriel.com>
	<alpine.LFD.0.999.0711011819110.3342@woody.linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 18:19:41 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Thu, 1 Nov 2007, Rik van Riel wrote:
> > 
> > Larry Woodman managed to wedge the VM into a state where, on his
> > 4x dual core system, only 2 cores (on the same CPU) could get the
> > zone->lru_lock overnight.  The other 6 cores on the system were
> > just spinning, without being able to get the lock.
> 
> .. and this is almost always the result of a locking *bug*, not
> unfairness per se. IOW, unfairness just ends up showing the bug in
> the first place.

No argument there.  If you have the kind of lock contention where
fairness matters, the contention is probably what needs to be fixed,
not the locking mechanism.

Having said that, making bugs like that less likely to totally wedge
a system would be a good thing for everybody who uses Linux in
production.  Exposing bugs is good for development, bad for business.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
