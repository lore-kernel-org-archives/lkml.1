Return-Path: <linux-kernel-owner+w=401wt.eu-S1751697AbZIUQmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbZIUQmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZIUQmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:42:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34613 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZIUQms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:42:48 -0400
Date: Mon, 21 Sep 2009 18:42:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jack@suse.cz,
       fengguang.wu@intel.com
Subject: Re: [GIT PULL] a few writeback fixes
Message-ID: <20090921164236.GA4398@elte.hu>
References: <20090921125620.GV23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921125620.GV23126@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> Hi Linus,
> 
> This fixes a problem with NFS killing its bdi without being 
> initialized, and also contains a fix for a busy loop (where we forgot 
> to set the task state before sleeping). Since these are a bit critical 
> for -rc1, I'm pushing them out before leaving for Portland.
> 
> Jan, since we're not really sure on the inode wait yet, I dropped that 
> patch. It's definitely something to look into, as are the congestion 
> bits.
> 
> I plan on adding some writeback tracing code while on the plane for 
> further analysis when I get back.
> 
>   git://git.kernel.dk/linux-2.6-block.git writeback
> 
> Jens Axboe (4):
>       nfs: nfs_kill_super() should call bdi_unregister() after killing super
>       writeback: don't use schedule_timeout() without setting runstate
>       writeback: make balance_dirty_pages() gradually back more off
>       nfs: initialize the backing_dev_info when creating the server
> 
>  fs/nfs/client.c     |   10 ++++++----
>  fs/nfs/super.c      |    2 +-
>  mm/page-writeback.c |   11 ++++++++++-
>  3 files changed, 17 insertions(+), 6 deletions(-)

just an update about the BDI slab corruption bugs i reported in this 
thread on lkml:

   [origin tree SLAB corruption] BUG kmalloc-64: Poison overwritten,
        INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514

They have gone away entirely with your earlier BDI fixes/updates, on all 
-tip testsystems that triggered it. So that bug can be closed for good.

Thanks,

	Ingo
