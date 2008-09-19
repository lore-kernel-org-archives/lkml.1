Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYISUdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYISUdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYISUcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:32:54 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:33896 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbYISUcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=imWNEYFGJw0xDTgsleTzzT3wP9qDvuhJihuNoLvHE6P/fUJKfgeTLHqy61yS0nUfTD
         VmeAyPmQjcqm9vH8htlqenjaxsiHvWIQ2PrSBD9/pT9K41GY+3iEe1Okw+I6aQahy6ip
         qGxOTW9pNz8XWKvFietNy0id3Y+KbkRSGAmOA=
Message-ID: <48D40C69.8040207@gmail.com>
Date: Fri, 19 Sep 2008 22:32:41 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       Marco Innocenti <m.innocenti@cineca.it>, matt@bluehost.com,
       ngupta@google.com, roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/6] introduce struct res_counter_ratelimit
References: <1221649528-8519-3-git-send-email-righi.andrea@gmail.com> <20080919100832.e188460a.randy.dunlap@oracle.com>
In-Reply-To: <20080919100832.e188460a.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 17 Sep 2008 13:05:24 +0200 Andrea Righi wrote:
> 
>> Introduce res_counter_ratelimit as a generic structure to implement
>> throttling-based cgroup subsystems.
>>
>> [ Only the interfaces needed by the IO controller are implemented right now ]
>>
>> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
>> ---
>>  include/linux/res_counter.h |   70 +++++++++++++++++++++++++
>>  kernel/res_counter.c        |  118 ++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 187 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
>> index 0ab55c4..ff677d9 100644
>> --- a/include/linux/res_counter.h
>> +++ b/include/linux/res_counter.h
>> @@ -45,6 +46,38 @@ struct res_counter {
>>  	spinlock_t lock;
>>  };
>>  
>> +/* The various policies that can be used for throttling */
>> +#define	RATELIMIT_LEAKY_BUCKET	0
>> +#define	RATELIMIT_TOKEN_BUCKET	1
>> +
>> +struct res_counter_ratelimit {
>> +	/*
>> +	 * the current resource consumption level
>> +	 */
>> +	unsigned long long usage;
>> +	/*
>> +	 * the maximal value of the usage from the counter creation
>> +	 */
>> +	unsigned long long max_usage;
>> +	/*
>> +	 * the rate limit that cannot be exceeded
>> +	 */
>> +	unsigned long long limit;
>> +	/*
>> +	 * the limiting policy / algorithm
>> +	 */
>> +	unsigned long long policy;
>> +	/*
>> +	 * timestamp of the last accounted resource request
>> +	 */
>> +	unsigned long long timestamp;
>> +	/*
>> +	 * the lock to protect all of the above.
>> +	 * the routines below consider this to be IRQ-safe
>> +	 */
>> +	spinlock_t lock;
>> +};
> 
> With such nice struct comments, it looks like you should convert them
> to kernel-doc for structs.  See Documentation/kernel-doc-nano-HOWTO.txt
> for into, or ask me if you need some help with it.
> 

Sure! I will do for the next version. Actually, I'm already using the kernel-doc
style in other parts of this patchset (i.e. to document iothrottle structures).

Thanks!
-Andrea
