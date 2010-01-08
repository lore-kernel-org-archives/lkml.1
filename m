Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220Ab0AHASk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0AHASk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020Ab0AHASj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:18:39 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:40919 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab0AHASi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:18:38 -0500
Subject: Re: linux-next: nfs/ceph tree build failure
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, Sage Weil <sage@newdream.net>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20100108111136.3feae8c6.sfr@canb.auug.org.au>
References: <20100108111136.3feae8c6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 19:18:33 -0500
Message-ID: <1262909913.2659.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 9 sum msgs/h 1 total rcpts 2190 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 72A8AED366B87FF2DC294C32FA2B273DB6D48B5A
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 82 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 11:11 +1100, Stephen Rothwell wrote: 
> Hi all,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> fs/ceph/addr.c: In function 'ceph_set_page_dirty':
> fs/ceph/addr.c:105: error: 'BDI_RECLAIMABLE' undeclared (first use in this function)
> 
> Commit 69f0302c4bd28846c3251e25976a2336cd6a6e6f ("VM: Split out the
> accounting of unstable writes from BDI_RECLAIMABLE") from the nfs tree
> interacts with commit 1d3576fd10f0d7a104204267b81cf84a07028dad ("ceph:
> address space operations") from the ceph tree.
> 
> I applied the following patch for today (I am not sure it is correct) and
> will keep it as a merge fixup as necessary.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 8 Jan 2010 11:04:27 +1100
> Subject: [PATCH] ceph: update for BDI_RECLAIMABLE change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/ceph/addr.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index bf53581..eab46b0 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -101,8 +101,7 @@ static int ceph_set_page_dirty(struct page *page)
>  
>  		if (mapping_cap_account_dirty(mapping)) {
>  			__inc_zone_page_state(page, NR_FILE_DIRTY);
> -			__inc_bdi_stat(mapping->backing_dev_info,
> -					BDI_RECLAIMABLE);
> +			__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
>  			task_io_account_write(PAGE_CACHE_SIZE);
>  		}
>  		radix_tree_tag_set(&mapping->page_tree,

The patch itself looks correct to me.

How would you like me to proceed? Should I revert the VM changes from
the NFS linux-next tree, or would you be OK with keeping the above patch
for now?

Cheers
  Trond

