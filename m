Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbXJEBxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbXJEBxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 21:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbXJEBxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 21:53:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758446AbXJEBxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 21:53:09 -0400
Date: Thu, 4 Oct 2007 21:52:31 -0400
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
Message-ID: <20071004215231.42b1bc21@bree.surriel.com>
In-Reply-To: <470596C4.8060804@goop.org>
References: <470596C4.8060804@goop.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 18:43:32 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> It seems to me that there are a few ways to fix this:
> 
>    1. Use asm-generic/pgtable.h when CONFIG_PARAVIRT is enabled.  This
>       will clearly work, but is pretty blunt.
>    2. Make test_and_clear_pte_flags a new paravirt-op, which can be
>       implemented in Xen as a hypercall, and as a raw
> test_and_clear_bit for everyone else.  The downside is adding yet
> another pv-op.

Either of these two would work.  Another alternative could be to
let test_and_clear_pte_flags have an exception table entry, where
we jump right to the next instruction if the instruction clearing
the flag fails.

That is the essentially variant you need for Xen, except the fast
path is still exactly the same it is as when running on native
hardware.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
