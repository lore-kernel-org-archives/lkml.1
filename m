Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbYDVWyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbYDVWyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbYDVWy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:54:29 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:56052
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbYDVWy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:54:28 -0400
Date: Wed, 23 Apr 2008 00:54:24 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 10 of 12] Convert mm_lock to use semaphores after
	i_mmap_lock and anon_vma_lock
Message-ID: <20080422225424.GT24536@duo.random>
References: <f8210c45f1c6f8b38d15.1208872286@duo.random> <Pine.LNX.4.64.0804221325490.3640@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804221325490.3640@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:26:13PM -0700, Christoph Lameter wrote:
> Doing the right patch ordering would have avoided this patch and allow 
> better review.

I didn't actually write this patch myself. This did it instead:

s/anon_vma_lock/anon_vma_sem/
s/i_mmap_lock/i_mmap_sem/
s/locks/sems/
s/spinlock_t/struct rw_semaphore/

so it didn't look a big deal to redo it indefinitely.

The right patch ordering isn't necessarily the one that reduces the
total number of lines in the patchsets. The mmu-notifier-core is
already converged and can go in. The rest isn't converged at
all... nearly nobody commented on the other part (the few comments so
far were negative), so there's no good reason to delay indefinitely
what is already converged, given it's already feature complete for
certain users of the code. My patch ordering looks more natural to
me. What is finished goes in, the rest is orthogonal anyway.
