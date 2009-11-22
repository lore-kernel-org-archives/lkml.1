Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZKVQIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZKVQIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZKVQIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:08:15 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38360 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbZKVQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:08:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JCm1/cZW2Pi5qInfJnc8wl2uYSFWh5mtufxkuxs3P6KGjvDuUmoHzqPatdazdRlqtN
         RmI/OMSpgMq4T3FG3ez2lWx9sg3zVVe/n3KHbMvwE7BQF/ZFvaY8oOx/Awca4ZN7UYO2
         W+7d+pGpiit2Ou+a1vLfw4pRUvgSqLK9nhjb0=
Message-ID: <4B096226.4040505@gmail.com>
Date: Sun, 22 Nov 2009 08:09:10 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [Bug #14267] Disassociating atheros wlan
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>	<4B08258E.9050607@gmail.com>	<1258886823.7094.101.camel@johannes.local>	<200911221519.54284.rjw@sisk.pl> <20091122162131.0e2e60ef.kristoffer.ericson@gmail.com>
In-Reply-To: <20091122162131.0e2e60ef.kristoffer.ericson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristoffer Ericson wrote:
> On Sun, 22 Nov 2009 15:19:54 +0100
> "Rafael J. Wysocki"<rjw@sisk.pl>  wrote:
>
>    
>> On Sunday 22 November 2009, Johannes Berg wrote:
>>      
>>> On Sat, 2009-11-21 at 09:38 -0800, Justin P. Mattock wrote:
>>>
>>>        
>>>> I did a bisect yesterday on this, and the results
>>>> seemed to have worked over here by reverting:
>>>>
>>>> 75e6c3b72b3ab01c47629f3fbd0fed4e6550bf3a
>>>> cfg80211: lower dynamic PS timeout to 100ms
>>>>
>>>> if Kristoffer can try reverting this one
>>>> to see, then we can go from there.
>>>>          
>>> So that just means the driver is broken. Please run
>>>
>>> 	iwconfig wlan0 power off
>>>
>>> to fix it then. And the patch below will disable it by default since
>>> it's broken.
>>>
>>> johannes
>>>
>>> --- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-11-22 11:44:41.000000000 +0100
>>> +++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-11-22 11:45:26.000000000 +0100
>>> @@ -1893,6 +1893,8 @@ void ath_set_hw_capab(struct ath_softc *
>>>   		BIT(NL80211_IFTYPE_ADHOC) |
>>>   		BIT(NL80211_IFTYPE_MESH_POINT);
>>>
>>> +	hw->wiphy->ps_default = false;
>>> +
>>>   	hw->queues = 4;
>>>   	hw->max_rates = 4;
>>>   	hw->channel_change_time = 5000;
>>>        
>> OK, so perhaps this patch should be applied until th ath9k driver is fixed?  Luis?  John?
>>      
>
> I applied the patch from johannes and it ended my issues atleast. I ran my machine for approx
> 2 hours without seeing the disconnect issue (which I usually saw after 15-25min). Cant be 100% of course
> but so far so good.
>
> I agree with Justin that we could wait until he gets a chance to test it. It should be accepted
> after initial merge (and stable trees) after that I think. Rafael thoughts?
>
> Also, we should notify the atheros people so they could start fixing the driver (in a perfect world).
>
> Best wishes
> Kristoffer Ericson
>
>
>
>    
I can probably test it out, main problem
is where I'm headed internet connection might
not be strong enough to run any kind of media
(hotel connections are only strong enough to retrieve e-mails
streaming music/movies can be a bit much). luckily
I'm away only for a few days.

Justin P. Mattock
