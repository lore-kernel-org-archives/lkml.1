Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbXGWWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbXGWWGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXGWWG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:06:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:31599 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbXGWWG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:06:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ivfEYQ3/AkwrjcZGFYrVwWx8KLJZE/xY4Z0vMt6o7p5+Cmmm8wa2krCAKCxCqVt6dnnskZw1uvw8zKN3x+sW686J9tTjGSPszq7FaFx5PZAWEnCZbswetZVwRj4reeYC3aumISb5DFOD7Z8AAgMuboR5BAjTTWE9sn87/cFhaMg=
Message-ID: <46A525C0.4010805@googlemail.com>
Date: Tue, 24 Jul 2007 00:03:44 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: caglar@pardus.org.tr, Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] drivers/char/hpet.c: integer constant is too large for
 "long" type
References: <200707211419.47680.caglar@pardus.org.tr> <20070723145940.a99b0324.akpm@linux-foundation.org>
In-Reply-To: <20070723145940.a99b0324.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 21 Jul 2007 14:19:44 +0300
> "S.__a__lar Onur" <caglar@pardus.org.tr> wrote:
> 
>> Following trivial patch silents
>>
>> drivers/char/hpet.c:76: warning: integer constant is too large for "long" type
>>
>> warning (with gcc-3.4.6)
>>
>> Signed-off-by: S.__a__lar Onur <caglar@pardus.org.tr>
>>  
>>  drivers/char/hpet.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
>> index ba0e74a..23fadf5 100644
>> --- a/drivers/char/hpet.c
>> +++ b/drivers/char/hpet.c
>> @@ -73,7 +73,7 @@ static struct clocksource clocksource_hpet = {
>>          .name           = "hpet",
>>          .rating         = 250,
>>          .read           = read_hpet,
>> -        .mask           = 0xffffffffffffffff,
>> +        .mask           = 0xffffffffffffffffLL,
>>          .mult           = 0, /*to be caluclated*/
>>          .shift          = 10,
>>          .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
> 
> hm, well, this does assume that cycle_t is implemented as long long (or
> unsigned long long, actually).  Which in turn assumes that u64 is
> implemented as [unsigned] long long.
> 
> Not all architectures use unsigned long long for u64: some use unsigned
> long.  They'll probably be OK with this change but I think I'll convert
> that into plain old "-1", which just works everywhere.
> 

Bob Picco fixed this already -> http://lkml.org/lkml/2007/7/23/242


Regards,

Gabriel
