Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZCPSIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZCPSIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZCPSID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:08:03 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:57360 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZCPSIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:08:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=unJR6wzI7mSOEoWP0SOz+KMzbFTyGgC04QMINqCPRquHlI0mWb1M5lv2teA69LdqZv
         cv0ZIxlVxqgDL/GxQBYsCDztz+AkV7mABX0YwddErcvdeyiXE/8fK6Qb9ybVrY/c19cn
         /5WY3pTISuI9frw0W5Xu5+Hwpcv2FDqd4o7Ho=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PATCH] block: cleanup patches, take#2
Date: Mon, 16 Mar 2009 18:53:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090311; KDE/4.2.0; i686; ; )
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903161853.14268.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009, Tejun Heo wrote:
> Hello,
> 
> This patchset is available in the following git tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cleanup
> 
> This patchset contains the following 17 cleanup patches.
> 
>  0001-ide-use-blk_run_queue-instead-of-blk_start_queuei.patch
>  0002-ide-don-t-set-REQ_SOFTBARRIER.patch
>  0003-ide-use-blk_update_request-instead-of-blk_end_req.patch
>  0004-block-merge-blk_invoke_request_fn-into-__blk_run_.patch
>  0005-block-kill-blk_start_queueing.patch
>  0006-block-don-t-set-REQ_NOMERGE-unnecessarily.patch
>  0007-block-cleanup-REQ_SOFTBARRIER-usages.patch
>  0008-block-clean-up-misc-stuff-after-block-layer-timeout.patch
>  0009-block-reorder-request-completion-functions.patch
>  0010-block-reorganize-request-fetching-functions.patch
>  0011-block-kill-blk_end_request_callback.patch
>  0012-block-clean-up-request-completion-API.patch
>  0013-block-move-rq-start_time-initialization-to-blk_rq_.patch
>  0014-block-implement-and-use-__-blk_end_request_all.patch
>  0015-block-kill-end_request.patch
>  0016-ubd-simplify-block-request-completion.patch
>  0017-block-clean-up-unnecessary-stuff-from-block-drivers.patch
> 
> It's on top of the current linux-2.6-block/for-2.6.30[1].  Changes
> from the last take[2] are.
> 
> * IDE changes separated out to 0001-0003
> * IDE end_all conversion dropped
> 
> Bartlomiej, 0001-0003 are mostly trivial and shouldn't cause too much
> merge headaches later.  Can these go through block tree?  I'll base

Patches look fine but 0002-0003 will cause pata/block merge conflicts
for linux-next once they go into block tree so no ACK from me for this
approach.

$ patch -p1 --dry-run < 0002.patch
patching file drivers/ide/ide-disk.c
Hunk #1 FAILED at 405.
1 out of 1 hunk FAILED -- saving rejects to file drivers/ide/ide-disk.c.rej
patching file drivers/ide/ide-ioctls.c

$ patch -p1 --dry-run < 0003.patch
patching file drivers/ide/ide-cd.c
Reversed (or previously applied) patch detected!  Assume -R? [n]

Thanks,
Bart
