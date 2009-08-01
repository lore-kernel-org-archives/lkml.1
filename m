Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZHAPRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZHAPRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 11:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZHAPRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 11:17:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44318 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbZHAPRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 11:17:52 -0400
Message-ID: <4A745C9F.7000301@cs.helsinki.fi>
Date: Sat, 01 Aug 2009 18:17:51 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmemcheck: fix sparse warning
References: <1246873983.20908.0.camel@johannes.local> <1248874951.25614.0.camel@johannes.local>
In-Reply-To: <1248874951.25614.0.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Johannes Berg wrote:
> On Mon, 2009-07-06 at 11:53 +0200, Johannes Berg wrote:
>> Whether or not the sparse warning
>>
>> warning: do-while statement is not a compound statement
>>
>> is justified or not in this case, it is annoying and
>> trivial to fix.
> 
> Whatever happened to this patch? Did you decide to screw sparse
> warnings?

I thought Vegard applied the patch but I can't see it in kmemcheck.git 
either. Vegard?

			Pekka

>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> ---
>>  include/linux/kmemcheck.h |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- wireless-testing.orig/include/linux/kmemcheck.h	2009-07-06 11:41:16.000000000 +0200
>> +++ wireless-testing/include/linux/kmemcheck.h	2009-07-06 11:41:30.000000000 +0200
>> @@ -137,13 +137,13 @@ static inline void kmemcheck_mark_initia
>>  	int name##_end[0];
>>  
>>  #define kmemcheck_annotate_bitfield(ptr, name)				\
>> -	do if (ptr) {							\
>> +	do { if (ptr) {							\
>>  		int _n = (long) &((ptr)->name##_end)			\
>>  			- (long) &((ptr)->name##_begin);		\
>>  		BUILD_BUG_ON(_n < 0);					\
>>  									\
>>  		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
>> -	} while (0)
>> +	} } while (0)
>>  
>>  #define kmemcheck_annotate_variable(var)				\
>>  	do {								\
>>
> 

