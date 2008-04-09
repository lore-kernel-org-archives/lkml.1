Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbYDINRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbYDINRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYDINRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:17:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47372 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751673AbYDINRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:17:12 -0400
Date: Wed, 9 Apr 2008 08:17:09 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 0 of 9] mmu notifier #v12
Message-ID: <20080409131709.GR11364@sgi.com>
References: <patchbomb.1207669443@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1207669443@duo.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I applied this patch set with the xpmem version I am working up for
submission and the basic level-1 and level-2 tests passed.  The full mpi
regression test still tends to hang, but that appears to be a common
problem failure affecting either emm or mmu notifiers and therefore, I
am certain is a problem in my code.

Please note this is not an endorsement of one method over the other,
merely that under conditions where we would expect xpmem to pass the
regression tests, it does pass those tests.

Thanks,
Robin

On Tue, Apr 08, 2008 at 05:44:03PM +0200, Andrea Arcangeli wrote:
> The difference with #v11 is a different implementation of mm_lock that
> guarantees handling signals in O(N). It's also more lowlatency friendly. 
> 
> Note that mmu_notifier_unregister may also fail with -EINTR if there are
> signal pending or the system runs out of vmalloc space or physical memory,
> only exit_mmap guarantees that any kernel module can be unloaded in presence
> of an oom condition.
> 
> Either #v11 or the first three #v12 1,2,3 patches are suitable for inclusion
> in -mm, pick what you prefer looking at the mmu_notifier_register retval and
> mm_lock retval difference, I implemented and slighty tested both. GRU and KVM
> only needs 1,2,3, XPMEM needs the rest of the patchset too (4, ...) but all
> patches from 4 to the end can be deffered to a second merge window.
