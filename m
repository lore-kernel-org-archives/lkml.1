Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZDNH4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZDNH4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZDNH4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:56:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZDNH4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:56:22 -0400
Subject: Re: Problem with kvm on -tip
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Luis Henriques <henrix@sapo.pt>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <49E08857.2090503@redhat.com>
References: <20090409210738.GA4566@hades.domain.com>
	 <49E08857.2090503@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Apr 2009 09:58:45 +0200
Message-Id: <1239695925.21985.6738.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-11 at 15:08 +0300, Avi Kivity wrote:
> > [ 3293.134688] BUG: MAX_LOCK_DEPTH too low!
> >   
> 
> Looks like a genuine issue, need to increase MAX_LOCK_DEPTH.  Andrea?
> 
> > [ 3293.134704] turning off the locking correctness validator.
> > [ 3293.134718] Pid: 5117, comm: kvm Not tainted 2.6.30-rc1-tip-01420-g58e70a8
> > #18
> > [ 3293.134727] Call Trace:
> > [ 3293.134749]  [<ffffffff802805f6>] __lock_acquire+0x4c6/0xbf0
> > [ 3293.134764]  [<ffffffff80280e2e>] lock_acquire+0x10e/0x160
> > [ 3293.134780]  [<ffffffff802f3760>] ? mm_take_all_locks+0x110/0x150
> > [ 3293.134798]  [<ffffffff80580c3b>] _spin_lock_nest_lock+0x3b/0x50
> > [ 3293.134811]  [<ffffffff802f3760>] ? mm_take_all_locks+0x110/0x150
> > [ 3293.134823]  [<ffffffff802f3760>] mm_take_all_locks+0x110/0x150
> > [ 3293.134838]  [<ffffffff803093af>] do_mmu_notifier_register+0xdf/0x1f0
> > [ 3293.134852]  [<ffffffff803094f3>] mmu_notifier_register+0x13/0x20
> > [ 3293.134899]  [<ffffffffa02edede>] kvm_dev_ioctl+0x1ae/0x360 [kvm]
> > [ 3293.134914]  [<ffffffff80327a16>] vfs_ioctl+0x36/0xb0
> > [ 3293.134927]  [<ffffffff80327b22>] do_vfs_ioctl+0x92/0x5c0
> > [ 3293.134942]  [<ffffffff80273d9b>] ? up_read+0x2b/0x40
> > [ 3293.134955]  [<ffffffff8032809f>] sys_ioctl+0x4f/0x80
> > [ 3293.134971]  [<ffffffff8020c1f2>] system_call_fastpath+0x16/0x1b request

Thing is, its grabbing all vma locks, and we have a lock depth limit of
48. Now when we started this, the claim was that kvm would only need
this when the process was very fresh and would thus not yet have many
vma, ergo we should never run into this limit.

Has that changed?


