Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZELPce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZELPce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZELPcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:32:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:50470 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbZELPcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:32:11 -0400
Date: Wed, 13 May 2009 00:31:08 +0900
To: tj@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] swim3: use blk_end_request_all()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A0994FF.1030909@kernel.org>
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4A0994FF.1030909@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090513003226E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 13 May 2009 00:31:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 00:25:51 +0900
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> FUJITA Tomonori wrote:
> > This is against for-2.6.31 branch in the block tree.
> > 
> > Tejun, don't we need to use blk_end_request_all() when we hit the
> > maximum retry count in swim3_interrupt? Looks like we can't handle a
> > request properly if we doesn't complete the request there.
> 
> Ummm.... why so?  Can you elaborate the bug scenario a bit?  I was
> trying to keep the original behavior whereever possible.

If when a request hits the maximum retry count and
swim3_end_request_cur() doesn't complete the request there, where the
request will be freed?


> > There are some other places to use blk_end_request_all if we need to.
> 
> There are some other places where end_request_all can be used but I
> hope there isn't any place where we should but aren't.  :-)
> 
> Thanks.
> 
> -- 
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
