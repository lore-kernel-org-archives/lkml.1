Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbZELPyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbZELPyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZELPy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:54:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:58474 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZELPyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:54:25 -0400
Date: Wed, 13 May 2009 00:51:22 +0900
To: tj@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] swim3: use blk_end_request_all()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A099789.9080904@kernel.org>
References: <4A0994FF.1030909@kernel.org>
	<20090513003226E.fujita.tomonori@lab.ntt.co.jp>
	<4A099789.9080904@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090513005148A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 13 May 2009 00:51:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 00:36:41 +0900
Tejun Heo <tj@kernel.org> wrote:

> FUJITA Tomonori wrote:
> > On Wed, 13 May 2009 00:25:51 +0900
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> >> Hello,
> >>
> >> FUJITA Tomonori wrote:
> >>> This is against for-2.6.31 branch in the block tree.
> >>>
> >>> Tejun, don't we need to use blk_end_request_all() when we hit the
> >>> maximum retry count in swim3_interrupt? Looks like we can't handle a
> >>> request properly if we doesn't complete the request there.
> >> Ummm.... why so?  Can you elaborate the bug scenario a bit?  I was
> >> trying to keep the original behavior whereever possible.
> > 
> > If when a request hits the maximum retry count and
> > swim3_end_request_cur() doesn't complete the request there, where the
> > request will be freed?
> 
> It won't be freed.  The current segment will be failed and the next
> segment of the request will be tried on the next iteration, which was
> the original behavior.  ie. it always fails requests
> segment-by-segment and hitting max retry count doesn't fail the whole
> request.

Ah, I see. Thanks, then the current code is fine.

Well, it might be better to update some of the description of
blk_update_request, e.g., "the special helper function is only for
request stacking drivers".
