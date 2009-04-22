Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZDVKKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZDVKKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbZDVKKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:10:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54092 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbZDVKKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:10:39 -0400
Date: Wed, 22 Apr 2009 12:10:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [GIT PATCH linux-2.6-block] block: cleanup patches, take#3
Message-ID: <20090422101038.GA4593@kernel.dk>
References: <1240331881-28218-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240331881-28218-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Tejun Heo wrote:
> Hello,
> 
> Upon ack, please pull from the following git tree, which pulls in
> linux-2.6-ide#for-next into linux-2.6-block#for-next and applies this
> patchset on top of it.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cleanup
> 
> This is the third take of block-cleanup-patches.  Changes from the
> last take[L] are
> 
> * All ide changes including L0001-0003 are separated out and merged
>   through linux-2.6-ide#for-next and pulled into
>   linux-2.6-block#for-next.
> 
> * L0015-block-kill-end_request.patch replaced with
>   0012-block-replace-end_request-with-__-blk_end_reques.patch.
> 
> * L0016-ubd-simplify-block-request-completion.patch
>   L0017-block-clean-up-unnecessary-stuff-from-block-drivers.patch are
>   postponed to later patchset.
> 
> * 0013-0014 to kill rq->data added.
> 
> * Updated to the current #for-next.
> 
>  0001-block-merge-blk_invoke_request_fn-into-__blk_run_.patch
>  0002-block-kill-blk_start_queueing.patch
>  0003-block-don-t-set-REQ_NOMERGE-unnecessarily.patch
>  0004-block-cleanup-REQ_SOFTBARRIER-usages.patch
>  0005-block-clean-up-misc-stuff-after-block-layer-timeout.patch
>  0006-block-reorder-request-completion-functions.patch
>  0007-block-reorganize-request-fetching-functions.patch
>  0008-block-kill-blk_end_request_callback.patch
>  0009-block-clean-up-request-completion-API.patch
>  0010-block-move-rq-start_time-initialization-to-blk_rq_.patch
>  0011-block-implement-and-use-__-blk_end_request_all.patch
>  0012-block-replace-end_request-with-__-blk_end_reques.patch
>  0013-block-don-t-abuse-rq-data.patch
>  0014-block-kill-data.patch
> 
> 0001-0011 are mostly identical to L0004-0014.  L0015 incorrectly
> replaced end_request() with __blk_end_request_all().  0012 adds
> [__]blk_end_request_cur() and replaces end_request() with it.
> 
> With ide changes pulled in, omap is the only user of rq->data, 0013
> makes it use only rq->special and 0014 kills rq->data.
> 
> This patchset is on top of
> 
> linux-2.6-block#for-next(a95320f3ede3f028837a621715cd352e83ffe7c2)
> + linux-2.6-ide#for-next(2ecf0a57c60dcb588f310d94412118e15c510532)

Looks nice, the only real quibble I have is the one that hch also brings
up. Using a 'locked' argument is always ugly. Otherwise, overall the
patchset is really nice and does good cleanups. Getting rid of ->data is
great as well.

Once we get that settled, pulling into for-2.6.31 will be done.

-- 
Jens Axboe

