Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZEMF7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZEMF7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZEMF7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:59:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44359 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbZEMF7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:59:13 -0400
Date: Wed, 13 May 2009 07:59:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Boaz Harrosh <bharrosh@panasas.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] swim3: use blk_end_request instead of
	blk_update_request
Message-ID: <20090513055913.GZ4140@kernel.dk>
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1242127787-29842-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4A098B8D.10107@panasas.com> <4A099562.7020805@kernel.org> <4A0A1941.2010105@ct.jp.nec.com> <20090513054901.GW4140@kernel.dk> <4A0A6003.8060800@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A6003.8060800@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13 2009, Tejun Heo wrote:
> Jens Axboe wrote:
> >>> Yeah, conversion was easy that way.  I think it's sane to have
> >>> blk_update_request() exported as long as request internal tinkering is
> >>> kept in block layer proper.
> >> blk_update_request() is needed for request-based dm to keep the request
> >> completion ordering in bottom-up, although request-based dm is not
> >> in upstream yet.
> >>
> >> Jens, please keep blk_update_request() exported.
> > 
> > I did, I applied the swim3 patches yesterday as well.
> 
> I don't think the patch is correct.  If it calls
> blk_end_request_all(), it should also clear the current request which
> the patch doesn't.  Also, given that the driver doesn't support
> partially failing the request, I think it's correct to fail
> segment-by-segment to avoid merged request failure affects unrelated
> bios.
> 
> Thanks.

OK, I'll back them out for now.

-- 
Jens Axboe

