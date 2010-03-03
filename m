Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0CCJgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:36:17 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:55721 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0CCJgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:36:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nxIuO9nNakQgnPOhvUh4LJu1CGr15AGrBNKzBOQum2Ihxt/SEl0DEAQ7h/UCuA6ZqV
         5yALNSt2W342q7Ac8WrDl9wqNoYhZNJchQCLem9k2S//zJNDqN84TWcnU/vb9V3ewLwF
         0yYdevMRVyMH6LeBEeaK9JdywPsZ5KdDdv5Wk=
Message-ID: <4B8E2DCD.6020308@tuffmail.co.uk>
Date: Wed, 03 Mar 2010 09:37:17 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: jh80.chung@samsung.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rfkill bug fixed in rfkill_set_sw_state
References: <000301cab69f$ec61ad00$c5250700$%chung@samsung.com> <20100302125003.f7919c53.akpm@linux-foundation.org> <4B8DB1A3.9060902@samsung.com>
In-Reply-To: <4B8DB1A3.9060902@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon Chung wrote:
> Ok Next time, i will add sutatble cc's scripts/get_maintainer.pl. 
> thanks..
>> Suitable cc's (from scripts/get_maintainer.pl) added.
>>
>> On Fri, 26 Feb 2010 13:55:31 +0900
>> _________<jh80.chung@samsung.com>  wrote:
>>
>>   
>>> Don___t work expected operation in __rfkill_set_sw_state.
>>> when rfkill initialized. Rfkill___s blocked&  unblocked is operating 
>>> on the
>>> contrary.
>>>
>>> Signed-off-by: Jaehoon Chung<jh80.chung@samsung.com>
>>>
>>> ---
>>>   net/rfkill/core.c |    2 +-
>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
>>> index c224cb2..dcc2d38 100644
>>> --- a/net/rfkill/core.c
>>> +++ b/net/rfkill/core.c
>>> @@ -488,7 +488,7 @@ static void __rfkill_set_sw_state(struct rfkill
>>> *rfkill, bool blocked)
>>>       if (rfkill->state&  RFKILL_BLOCK_SW_SETCALL)
>>>           bit = RFKILL_BLOCK_SW_PREV;
>>>
>>> -    if (blocked)
>>> +    if (!blocked)
>>>           rfkill->state |= bit;
>>>       else
>>>           rfkill->state&= ~bit;
>>>      
>> Are you sure?  What problems were you observing with the existing code?
>> Please fully describe your hardware and the driver's behaviour.
>>
>> The current code _looks_ OK to me.  If bool `blocked' is true, we set
>> the RFKILL_BLOCK_SW bit?
>>    
> I implemented the wlan driver using rfkill.
> In my source code, the wlan driver initalized to 
> RFKLL_USESR_STATE_UNBLOCKED..
> if that is correct, maybe do working the unblocked...but not work 
> "unblocked"
>
> below code is unblock's operation..right?
> rfkill_init_sw_state(wlan, RFKILL_USER_STATE_UNBLOCKED);
>
> but, do not operate unblocked.
> please check that source code..

I see the problem :).  The hint is in the _USER_ - those constants are 
not for use by drivers.  You want this instead:

rfkill_init_sw_state(wlan, false);

(assuming you really want init_sw_state().  Please do check that your 
device state is persistent, as described by the comment in rfkill.h).

Regards
Alan
