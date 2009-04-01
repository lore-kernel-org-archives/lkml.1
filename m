Return-Path: <linux-kernel-owner+w=401wt.eu-S1765127AbZDANXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765127AbZDANXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZDANXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:23:33 -0400
Received: from sh.osrg.net ([192.16.179.4]:41400 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZDANXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:23:32 -0400
Date: Wed, 1 Apr 2009 22:22:10 +0900
To: tj@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, tj@kenel.org
Subject: Re: [PATCH 8/8] blk-map: reimplement blk_rq_map_user() using
 blk_rq_map_user_iov()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49D36951.9000604@kernel.org>
References: <49D3662B.3000801@kernel.org>
	<20090401221102O.fujita.tomonori@lab.ntt.co.jp>
	<49D36951.9000604@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090401222202I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 01 Apr 2009 22:22:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009 22:17:05 +0900
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> FUJITA Tomonori wrote:
> > On Wed, 01 Apr 2009 22:03:39 +0900
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> No, we are not talking about blk_rq_append_bio().
> >>>
> >>> We are talking about the multiple bio handling in blk_rq_map_user,
> >>> which is the feature that Mike added long time ago. The feature is
> >>> surely necessary for some users. So you can't remote it.
> >> How would someone use that without blk_rq_append_bio()?  The only
> > 
> > Hmm, I'm not sure what you are talking about.
> > 
> > Why do we need to live without blk_rq_append_bio()?
> > 
> > You want to remove blk_rq_append_bio()? Please make your goal clear.
> 
> Yeah, I'm writing header message for the next patchset.  It will go
> out in a few minutes.  With the bogus fix part removed, this patch
> (and related earlier ones) should have been part of the next set.
> And, yes, the goal is removing blk_rq_append_bio() and any and all
> request/bio internal meddling with further patchsets.

Sounds a good idea. But I need to review that.

But 7/8 and 8/8 patches are not bug fixes at all (as I wrote, your
descriptions about checking is untrue). It can't be for 2.6.30. So put
them to the next patchset.


> >> reason blk_rq_map_user() had multiple bio chaining was to work around
> >> BIO_MAX_SIZE.  blk_rq_map_user_iov() doesn't support multiple bio
> >> chaining, so sans blk_rq_append_bio() or playing with rq/bio internals
> >> directly, there's no way to use or even know about multiple bios.
> > 
> > Yes, only non iovec interface of SG_IO supports large data
> > transfer. Users have been lived with that.
> 
> This patch doesn't remove any feature.  You don't lose anything.  What
> used to be done with multiple bios is now done with single bio.  The
> implementation is simpler and shorter.  Using or not using multiple
> bios doesn't (and shouldn't) make any difference to blk_map_*() users.

Hmm, with your change, blk_rq_map_user can't handle larger than
BIO_MAX_SIZE, right?
