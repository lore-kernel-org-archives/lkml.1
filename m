Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZHXQi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZHXQi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZHXQiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:38:55 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:53363 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZHXQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:38:54 -0400
Message-ID: <4A92C1C1.4010007@gmail.com>
Date: Mon, 24 Aug 2009 18:37:21 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] cciss: memory leak in cciss_init_one()
References: <4A7961DE.1090702@gmail.com> <4A91058F.3050708@gmail.com> <20090824080115.GA12579@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A778869529DACD7@GVW0547EXC.americas.hpqcorp.net>
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778869529DACD7@GVW0547EXC.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 24 Aug 2009 18:37:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miller, Mike (OS Dev) a écrit :
>  
> 
>> -----Original Message-----
>> From: Jens Axboe [mailto:jens.axboe@oracle.com] 
>> Sent: Monday, August 24, 2009 3:01 AM
>> To: Eric Dumazet
>> Cc: Andrew Morton; Miller, Mike (OS Dev); linux kernel; 
>> stable@kernel.org; FUJITA Tomonori
>> Subject: Re: [PATCH] cciss: memory leak in cciss_init_one()
>>
>> On Sun, Aug 23 2009, Eric Dumazet wrote:
>>> Andrew, I originally sent this 18 days ago and got no reply 
>> yet, maybe 
>>> could you get the baby ?
>> I'll add it for 2.6.32.
>>
> 
> I guess I'm missing something. Where is the leak?

Well...

Problem is : In normal path, kfree(inq_buff); is not called.

It is called only if a "goto clean4;" is done (error path,
and in this case, inq_buff is NULL anyway)

So we exit from cciss_init_one() without freeing
a "InquiryData_struct" structure.

I am pretty sure kmemleak would complain on this leak :)
