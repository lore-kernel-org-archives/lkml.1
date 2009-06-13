Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbZFMPFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbZFMPFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 11:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZFMPFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 11:05:36 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:34062 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbZFMPFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 11:05:36 -0400
X-Trace: 211351576/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.31.185/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.31.185
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADZdM0pPRR+5/2dsb2JhbACBT89FhA0F
X-IronPort-AV: E=Sophos;i="4.42,214,1243810800"; 
   d="scan'208";a="211351576"
Date: Sat, 13 Jun 2009 16:04:40 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, chrisw@redhat.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] RFC - ksm api change into madvise
In-Reply-To: <20090608225756.GB8642@random.random>
Message-ID: <Pine.LNX.4.64.0906131547560.6589@sister.anvils>
References: <1242261048-4487-1-git-send-email-ieidus@redhat.com>
 <Pine.LNX.4.64.0906081555360.22943@sister.anvils> <20090608225756.GB8642@random.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

On Tue, 9 Jun 2009, Andrea Arcangeli wrote:
> 
> So let us know what you think about the rmap_item/tree_item out of
> sync, or in sync with mmu notifier. As said Izik already did a
> preliminary patch with mmu notifier registration. I doubt we want to
> invest in that direction unless there's 100% agreement that it is
> definitely the way to go, and the expectation that it will make a
> substantial difference to the KSM users. Minor optimizations that
> increase complexity a lot, can be left for later.

Thanks for your detailed mail, of which this is merely the final
paragraph.  Thought I'd better respond with a little reassurance,
though I'm not yet ready to write in detail.

I agree 100% that KSM is entitled to be as "lazy" about clearing
up pages as it is about merging them in the first place: you're
absolutely right to avoid the unnecessary overhead of keeping
strictly in synch, and I recognize the lock ordering problems
that keeping strictly in synch would be likely to entail.

My remarks about "lost" pages came from the belief that operations
upon the vmas could move pages to where they thereafter escaped
the attention of KSM's scans for an _indefinite_ period (until
the process exited or even after): that's what has worried me,
but I've yet to demonstrate such a problem, and the rework
naturally changes what happens here.

So, rest assured, I'm not wanting to impose a stricter discipline and
tighter linkage, unless it's to fix a proven indefinite discrepancy.

Hugh
