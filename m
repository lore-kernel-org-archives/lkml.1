Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab0CCArl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:47:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40139 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0CCArd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:47:33 -0500
Date: Wed, 03 Mar 2010 09:47:31 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH] rfkill bug fixed in rfkill_set_sw_state
In-reply-to: <20100302125003.f7919c53.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Reply-to: jh80.chung@samsung.com
Message-id: <4B8DB1A3.9060902@samsung.com>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ko; rv:1.9.1.8)
 Gecko/20100227 Thunderbird/3.0.3
References: <000301cab69f$ec61ad00$c5250700$%chung@samsung.com>
 <20100302125003.f7919c53.akpm@linux-foundation.org>
X-OriginalArrivalTime: 03 Mar 2010 00:47:31.0498 (UTC)
 FILETIME=[1B40D0A0:01CABA6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok Next time, i will add sutatble cc's scripts/get_maintainer.pl. thanks..
> Suitable cc's (from scripts/get_maintainer.pl) added.
>
> On Fri, 26 Feb 2010 13:55:31 +0900
> _________<jh80.chung@samsung.com>  wrote:
>
>    
>> Don___t work expected operation in __rfkill_set_sw_state.
>> when rfkill initialized. Rfkill___s blocked&  unblocked is operating on the
>> contrary.
>>
>> Signed-off-by: Jaehoon Chung<jh80.chung@samsung.com>
>>
>> ---
>>   net/rfkill/core.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
>> index c224cb2..dcc2d38 100644
>> --- a/net/rfkill/core.c
>> +++ b/net/rfkill/core.c
>> @@ -488,7 +488,7 @@ static void __rfkill_set_sw_state(struct rfkill
>> *rfkill, bool blocked)
>>   	if (rfkill->state&  RFKILL_BLOCK_SW_SETCALL)
>>   		bit = RFKILL_BLOCK_SW_PREV;
>>
>> -	if (blocked)
>> +	if (!blocked)
>>   		rfkill->state |= bit;
>>   	else
>>   		rfkill->state&= ~bit;
>>      
> Are you sure?  What problems were you observing with the existing code?
> Please fully describe your hardware and the driver's behaviour.
>
> The current code _looks_ OK to me.  If bool `blocked' is true, we set
> the RFKILL_BLOCK_SW bit?
>    
I implemented the wlan driver using rfkill.
In my source code, the wlan driver initalized to 
RFKLL_USESR_STATE_UNBLOCKED..
if that is correct, maybe do working the unblocked...but not work 
"unblocked"

below code is unblock's operation..right?
rfkill_init_sw_state(wlan, RFKILL_USER_STATE_UNBLOCKED);

but, do not operate unblocked.
please check that source code..

thanks for your comment, Andrew.

