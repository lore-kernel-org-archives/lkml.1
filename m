Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbXJVU3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbXJVU3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXJVU3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:29:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:41082 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbXJVU3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:29:42 -0400
Subject: Re: ARCH_FREE_PTE_NR 5350 on x86_64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Alok kataria <alokkataria1@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0710221913250.18548@blonde.wat.veritas.com>
References: <35f686220710142354k66e1b9acwf65864b138ffd26@mail.gmail.com>
	 <200710152236.24789.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0710221913250.18548@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 06:29:18 +1000
Message-Id: <1193084958.6745.99.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Agreed.  No hurry, but thanks to Alok for reminding us.
> CC'ing Ben since he's the one most active in mmu_gathering these days.
> CC'ing Thomas lest he's puzzling over it in the x86 merge.

Hrm... yes, that stuff sucks. I've had my work on mmu gather on hold
since KS due to other priorities showing up, but I'll get back to it
soon and put that on the todo list.

The main pain here is the immap_lock. I have various plans to get rid of
preemption blocking in the main mmu gather (the stuff we discussed
already basically), but the immap_lock must stay, so we need to keep
something akin to immap_lock.

With the new approach, the disconnect between ZAP_BLOCK_SIZE and
whatever we use to represent the size of a batch might still be relevant
for the cases where we aren't holding that lock.

I'll get back to that stuff soon and we can then discuss the details.

Ben.


