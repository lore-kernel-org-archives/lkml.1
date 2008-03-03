Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbYCCTE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbYCCTE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762119AbYCCTEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:04:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762103AbYCCTEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:04:36 -0500
Date: Mon, 03 Mar 2008 14:04:27 -0500 (EST)
Message-Id: <20080303.140427.39152329.k-ueda@ct.jp.nec.com>
To: hare@suse.de
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       michaelc@cs.wisc.edu, k-ueda@ct.jp.nec.com
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request
 stacking
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <47CC2652.1080601@suse.de>
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>
	<47CC2652.1080601@suse.de>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

On Mon, 03 Mar 2008 17:24:50 +0100, Hannes Reinecke wrote:
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

Thank you for the comment.

I'm thinking about an idea come from Mike and Jens after the session
at LSF'08:
  o stacking driver clones both bio and request and uses
    bio->bi_end_io and rq->end_io
  o stacking driver uses blk_complete_request() in rq->end_io
    so that stacking driver can work without queue lock
With this idea, we don't need to add the new hook to request,
and we can use request stacking on drivers using __blk_end_request().

Currently, I'm trying to convert request-based dm to use the idea above.
I'll post the new version as a RFC in the near future.

Thanks,
Kiyoshi Ueda
