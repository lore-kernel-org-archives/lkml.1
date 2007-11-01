Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbXKAO3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbXKAO3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXKAO3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:29:34 -0400
Received: from ns1.suse.de ([195.135.220.2]:60154 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbXKAO3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:29:34 -0400
Date: Thu, 1 Nov 2007 15:29:33 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       riel <riel@redhat.com>
Subject: Re: [patch 1/4] spinlock: lockbreak cleanup
Message-ID: <20071101142932.GB2648@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140241.GB26879@wotan.suse.de> <1193925965.27652.284.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193925965.27652.284.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 03:06:05PM +0100, Peter Zijlstra wrote:
> On Thu, 2007-11-01 at 15:02 +0100, Nick Piggin wrote:
> 
> > Rename need_lockbreak to spin_needbreak, make it use spin_is_contended to
> > decouple it from the spinlock implementation, and make it typesafe (rwlocks
> > do not have any need_lockbreak sites -- why do they even get bloated up
> > with that break_lock then?).
> 
> IIRC Lee has a few patches floating about that do introduce lockbreak
> stuff for rwlocks.

Well that would be a good reason to introduce a break_lock for them,
but previously not so much... we have rwlocks in some slightly space
critical structures (vmas, inodes, etc).

I guess it was done to make the "template" hacks eaiser. I don't really
find that in good taste, especially for important core infrastructure.
Anyway.
