Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbYCCRuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbYCCRuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYCCRuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:50:00 -0500
Received: from brick.kernel.dk ([87.55.233.238]:11934 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYCCRt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:49:59 -0500
Date: Mon, 3 Mar 2008 18:49:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request stacking
Message-ID: <20080303174953.GE6704@kernel.dk>
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com> <47CC2652.1080601@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC2652.1080601@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03 2008, Hannes Reinecke wrote:
> Hi Kiyoshi,
> 
> Kiyoshi Ueda wrote:
> > This patch adds ->complete_io() hook for request stacking.
> > Request stacking drivers (such as request-based dm) can set
> > a callback for completion.
> > (The hook is not called in blk_end_io(), since request-based dm uses
> >  it for clone completion in the following appendix patches.)
> > 
> [ .. ]
> I would rather have rq->complete_io() to be pointing to blk_end_io in the
> default case, this way rq->complete_io() would always be valid and we
> would be saving us the if() clause.

The whole point of this ->complete_io() thread is that we cannot use the
above approach, before all drivers are converted from using
__blk_end_request() to blk_end_request(). And that requires some work.

-- 
Jens Axboe

