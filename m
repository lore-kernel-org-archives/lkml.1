Return-Path: <linux-kernel-owner+w=401wt.eu-S1762474AbZAOHpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474AbZAOHpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZAOHpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:45:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbZAOHpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:45:00 -0500
Subject: Re: [PATCH -v11][RFC] mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20090115004645.GB32044@wotan.suse.de>
References: <1231774622.4371.96.camel@laptop>
	 <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
	 <20090114171800.GA18621@wotan.suse.de> <1231953757.14825.33.camel@laptop>
	 <20090115004645.GB32044@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 08:44:03 +0100
Message-Id: <1232005443.14825.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 01:46 +0100, Nick Piggin wrote:

> Hmm, well this is rather a slow path, I would say. I'd prefer not to
> modify schedule in this way (if we just get scheduled back on after
> being switched away, the subsequent call to schedule is going to be
> cache hot and not do too much work).
> 
> preempt_enable_noresched maybe if you really care, would close up the
> window even more. But is it really worthwhile? We'd want to see numbers
> (when in doubt, keep it  simpler).

I initially did the preempt_enable_no_resched() thing and that showed
some improvement for PREEMPT=y kernels (lost the numbers though).

When I redid all the patches I tried closing that last hole by doing
that __schedule() thing, never realizing that schedule() would then get
extra overhead,.. d'0h.

I agree that that isn't worth it. I shall revert to
preempt_enable_no_resched() and try to get some new numbers.

