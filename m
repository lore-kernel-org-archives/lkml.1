Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbXJEQsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbXJEQsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbXJEQs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:48:27 -0400
Received: from gw.goop.org ([64.81.55.164]:57641 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242AbXJEQs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:48:26 -0400
Message-ID: <47066AD0.4010102@goop.org>
Date: Fri, 05 Oct 2007 09:48:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Keir Fraser <keir@xensource.com>
CC: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
References: <C32C1AD6.167B3%keir@xensource.com>
In-Reply-To: <C32C1AD6.167B3%keir@xensource.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> I didn't think that nobbling config options for particular pv_ops
> implementations was acceptable? I'm rather out of the loop though, and could
> be wrong.
>   

As a workaround it would be OK.  As a dependency, perhaps.

> The PREEMPT_BITS limitation is a good argument for at least taking the pte
> locks in small batches though (small batches is preferable to one-by-one
> since we will want to batch the make-readonly-and-pin hypercall requests to
> amortise the cost of the hypervisor trap).
>   

Hm, that's a good point.  The pagetable permissions changes are batched
more or less asynchronously from the actual loop structure; that will
complicate adding the locking.

       J
