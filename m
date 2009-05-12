Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZELW5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZELW5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZELW5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:57:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZELW5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:57:10 -0400
Message-ID: <4A09FF0A.9030202@kernel.org>
Date: Wed, 13 May 2009 07:58:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] swim3: use blk_end_request_all()
References: <4A0994FF.1030909@kernel.org>	<20090513003226E.fujita.tomonori@lab.ntt.co.jp>	<4A099789.9080904@kernel.org> <20090513005148A.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090513005148A.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 22:57:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

FUJITA Tomonori wrote:
>> It won't be freed.  The current segment will be failed and the next
>> segment of the request will be tried on the next iteration, which was
>> the original behavior.  ie. it always fails requests
>> segment-by-segment and hitting max retry count doesn't fail the whole
>> request.
> 
> Ah, I see. Thanks, then the current code is fine.
> 
> Well, it might be better to update some of the description of
> blk_update_request, e.g., "the special helper function is only for
> request stacking drivers".

Maybe but it encapsulates request details pretty well, so I wouldn't
really mind if it's used for other purposes (e.g. delaying actual
completion to ease internal bookkeeping).

Thanks.

-- 
tejun
