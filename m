Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbXJENRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbXJENRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbXJENRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:17:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbXJENRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:17:46 -0400
Date: Fri, 5 Oct 2007 09:17:16 -0400
From: Rik van Riel <riel@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickens <hugh@veritas.com>, David Rientjes <rientjes@google.com>,
       Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
Message-ID: <20071005091716.78d30446@bree.surriel.com>
In-Reply-To: <4705BA56.5080605@goop.org>
References: <470596C4.8060804@goop.org>
	<20071004215231.42b1bc21@bree.surriel.com>
	<4705BA56.5080605@goop.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 21:15:18 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Rik van Riel wrote:
> > Either of these two would work.  Another alternative could be to
> > let test_and_clear_pte_flags have an exception table entry, where
> > we jump right to the next instruction if the instruction clearing
> > the flag fails.
> >
> > That is the essentially variant you need for Xen, except the fast
> > path is still exactly the same it is as when running on native
> > hardware.
> >   
> 
> Hm, that wouldn't end up clearing the bit. 

Big deal.  We don't care *that* much.

As long as the bit gets cleared 99.9% of the time, we're fine.
All that bit is for is determining when to swap out a page.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
