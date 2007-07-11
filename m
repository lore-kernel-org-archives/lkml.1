Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbXGKVr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbXGKVr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760804AbXGKVrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:47:18 -0400
Received: from ns.suse.de ([195.135.220.2]:55726 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXGKVrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:47:18 -0400
Date: Wed, 11 Jul 2007 23:46:49 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711214649.GK14435@v2.random>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711211638.GE18767@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed, Jul 11, 2007 at 11:16:38PM +0200, Andi Kleen wrote:
> I thought it was clear that rip everything out is rarely a good idea
> in Linux land?  That's really not something I should need to harp on 
> repeatedly.

I'm going to change topic big time because your sentence above
perfectly applies to the O(1) scheduler too. It's not like process
schedulers are sacred and there shall be only one, while I/O
schedulers and packet schedulers are profane and there can be many of
them. FWIW IMHO the right way would have been to make the new
scheduler pluggable and switchable at runtime, too bad it was ripped
off instead. The difficulty of making the scheduler pluggable isn't
really enormous, there have been patches floating around to achieve
it, some I even deal with them myself once.

The only positive side of being forced to CFS I can imagine, is that
more testing will make it more stable and more tuned more quickly. But
I'm fairly certain Ingo's good enough to achieve without it, perhaps
with a few more weeks.

Personally I very much like the unfariness of O(1), I'm afraid CFS
will overschedule under a certain number of workloads in its attempt
to provide a complete fair queieing at all costs, and it won't deal
with the X server as nicely as O(1), but I may as well be wrong. The
only thing I'm more sure about is that the computational complexity is
higher, and that reason alone is a good technical reason to provide
both and let the java folks stick with O(1) if they want.
