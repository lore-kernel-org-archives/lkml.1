Return-Path: <linux-kernel-owner+w=401wt.eu-S1764259AbZDANRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764259AbZDANRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZDANR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:17:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbZDANR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:17:26 -0400
Message-ID: <49D36951.9000604@kernel.org>
Date: Wed, 01 Apr 2009 22:17:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       tj@kenel.org
Subject: Re: [PATCH 8/8] blk-map: reimplement blk_rq_map_user() using blk_rq_map_user_iov()
References: <49D36329.20004@kernel.org>	<20090401215933S.fujita.tomonori@lab.ntt.co.jp>	<49D3662B.3000801@kernel.org> <20090401221102O.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090401221102O.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:17:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

FUJITA Tomonori wrote:
> On Wed, 01 Apr 2009 22:03:39 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> FUJITA Tomonori wrote:
>>> No, we are not talking about blk_rq_append_bio().
>>>
>>> We are talking about the multiple bio handling in blk_rq_map_user,
>>> which is the feature that Mike added long time ago. The feature is
>>> surely necessary for some users. So you can't remote it.
>> How would someone use that without blk_rq_append_bio()?  The only
> 
> Hmm, I'm not sure what you are talking about.
> 
> Why do we need to live without blk_rq_append_bio()?
> 
> You want to remove blk_rq_append_bio()? Please make your goal clear.

Yeah, I'm writing header message for the next patchset.  It will go
out in a few minutes.  With the bogus fix part removed, this patch
(and related earlier ones) should have been part of the next set.
And, yes, the goal is removing blk_rq_append_bio() and any and all
request/bio internal meddling with further patchsets.

>> reason blk_rq_map_user() had multiple bio chaining was to work around
>> BIO_MAX_SIZE.  blk_rq_map_user_iov() doesn't support multiple bio
>> chaining, so sans blk_rq_append_bio() or playing with rq/bio internals
>> directly, there's no way to use or even know about multiple bios.
> 
> Yes, only non iovec interface of SG_IO supports large data
> transfer. Users have been lived with that.

This patch doesn't remove any feature.  You don't lose anything.  What
used to be done with multiple bios is now done with single bio.  The
implementation is simpler and shorter.  Using or not using multiple
bios doesn't (and shouldn't) make any difference to blk_map_*() users.

Thanks.

-- 
tejun
