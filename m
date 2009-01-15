Return-Path: <linux-kernel-owner+w=401wt.eu-S1762855AbZAOI5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855AbZAOI5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757774AbZAOI52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:57:28 -0500
Received: from cmpxchg.org ([85.214.51.133]:58656 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbZAOI51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:57:27 -0500
X-Greylist: delayed 950 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 03:57:26 EST
Date: Thu, 15 Jan 2009 09:56:25 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] mutex: set owner only once on acquisition
Message-ID: <20090115085625.GA15038@cmpxchg.org>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <20090115083951.GA13930@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115083951.GA13930@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 09:41:01AM +0100, Johannes Weiner wrote:
> mutex_lock() sets the lock owner, no need to set it upfront in
> __mutex_lock_common().
> 
> Inside __mutex_lock_common() we can cope with the case where the
> successful acquirer got preempted by us before setting the owner
> field: there is an explicit check in the spinning code and the
> sleeping part doesn't rely on it.
> 
> The debug code does owner checks only on unlock where the field is
> garuanteed to be set.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  kernel/mutex.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Just a small observation.  Peter said it wouldn't matter much as the
> write is to a hot cache line.  But otoh, why keep it if it's not
> necessary. :)

Damn, I'm really async here, sorry Peter.  Just noticed you already
picked it up.

	Hannes
