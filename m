Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZEMFwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZEMFwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZEMFwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:52:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:49954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139AbZEMFwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:52:17 -0400
Message-ID: <4A0A6003.8060800@kernel.org>
Date: Wed, 13 May 2009 14:52:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Boaz Harrosh <bharrosh@panasas.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] swim3: use blk_end_request instead of	blk_update_request
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1242127787-29842-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4A098B8D.10107@panasas.com> <4A099562.7020805@kernel.org> <4A0A1941.2010105@ct.jp.nec.com> <20090513054901.GW4140@kernel.dk>
In-Reply-To: <20090513054901.GW4140@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 13 May 2009 05:52:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>>> Yeah, conversion was easy that way.  I think it's sane to have
>>> blk_update_request() exported as long as request internal tinkering is
>>> kept in block layer proper.
>> blk_update_request() is needed for request-based dm to keep the request
>> completion ordering in bottom-up, although request-based dm is not
>> in upstream yet.
>>
>> Jens, please keep blk_update_request() exported.
> 
> I did, I applied the swim3 patches yesterday as well.

I don't think the patch is correct.  If it calls
blk_end_request_all(), it should also clear the current request which
the patch doesn't.  Also, given that the driver doesn't support
partially failing the request, I think it's correct to fail
segment-by-segment to avoid merged request failure affects unrelated
bios.

Thanks.

-- 
tejun
