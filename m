Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZDPGUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZDPGUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 02:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZDPGTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 02:19:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55291 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZDPGTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:19:50 -0400
Date: Thu, 16 Apr 2009 08:19:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, petkovbb@googlemail.com
Subject: Re: [block #for-next] block: clear req->errors on bio completion
	only  for fs requests
Message-ID: <20090416061949.GQ5178@kernel.dk>
References: <49E671D8.1090002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E671D8.1090002@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16 2009, Tejun Heo wrote:
> Impact: subtle behavior change
> 
> For fs requests, rq is only carrier of bios and rq error status as a
> whole doesn't mean much.  This is the reason why rq->errors is being
> cleared on each partial completion of a request as on each partial
> completion the error status is transferred to the respective bios.
> 
> For pc requests, rq->errors is used to carry error status to the
> issuer and thus __end_that_request_first() doesn't clear it on such
> cases.
> 
> The condition was fine till now as only fs and pc requests have used
> bio and thus the bio completion path.  However, future changes will
> unify data accesses to bio and all non fs users care about rq error
> status.  Clear rq->errors on bio completion only for fs requests.
> 
> In general, the implicit clearing is a bit too subtle especially as
> the meaning of rq->errors is completely dependent on low level
> drivers.  Unifying / cleaning up rq->errors usage and letting llds
> manage it would be better.  TODO comment added.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
> Jens, can you please ack this patch?  With FUJITA's scsi_lib cleanup
> and Borislav's patch to make ide not use preallocated data structures,
> this is the only block bit which is necessary for ide cleanup
> patchets.  If you're okay with it, I'd like to push this through
> Bartlomiej's tree.

Sure, you can add my acked-by.

-- 
Jens Axboe

