Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZELPHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZELPHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZELPH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:07:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:44812 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZELPH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:07:27 -0400
Date: Wed, 13 May 2009 00:06:21 +0900
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, k-ueda@ct.jp.nec.com, tj@kernel.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] swim3: use blk_end_request instead of
 blk_update_request
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A098B8D.10107@panasas.com>
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1242127787-29842-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4A098B8D.10107@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090513000742X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 13 May 2009 00:06:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 17:45:33 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 05/12/2009 02:29 PM, FUJITA Tomonori wrote:
> > swim3 is the only user of blk_update_request(). Let's use
> > blk_end_request instead of blk_update_request. swim3 doesn't need to
> > update a request manually. 
> 
> 
> > In addition, we can unexport
> > blk_update_request().
> > 
> 
> blk_update_request() was meant for request-based-multi-path, and not for swim3
> please see:
>     32fab448 block: add request update interface
> 
> CC: Kiyoshi Ueda<k-ueda@ct.jp.nec.com>

I see, thanks. Looks like we need to export it but I still think that
the bug fix patch for swim3 is valid and it's better for swim3 to use
blk_end_request().


> I think Tejun Heo was just using that in some recent block layer, transformation.
> Tejun?

At least, there is no users of it in Jens' for-2.6.31.
