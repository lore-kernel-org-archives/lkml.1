Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYFNHHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYFNHHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 03:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYFNHHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 03:07:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:53383 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYFNHHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 03:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nmxoknv0pV5tWxyikjShLw9bId6MUEvCqUxh8lGpVwuDJG8OOsy1ht/CB0tjbZmG7f
         b0HYEqgEkS5vtJKJzvsPoS4loS56O+a9vc/cUXjFVXXK+bpOrE9kWdMTfY5iJ5wxxd0X
         d576zd90H26HeC6D/U1gHLJamD7nNjj29bWkw=
Message-ID: <48536E3B.4000703@gmail.com>
Date: Sat, 14 Jun 2008 11:07:39 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: webmaster@dragonslave.de
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: linux-next Regression: Unable to locate IOAPIC
References: <200806051100.12885.dex@dragonslave.de> <200806102229.10512.dex@dragonslave.de> <4851AA24.7060906@gmail.com> <200806131307.39807.dex@dragonslave.de>
In-Reply-To: <200806131307.39807.dex@dragonslave.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Yinghai,

It looks like the code introduced by 
2944e16b25e7fb8b5ee0dd9dc7197a0f9e523cfd
is causing this problem. At least it is new between -rc5 (working) and 
linux-next (not working).

Regards,
Alex.


Daniel Exner wrote:
> Hi all,
>
> Alexey Starikovskiy wrote:
>   
>> Hi Daniel,
>>
>> Could you please provide full dmesg and acpidump outputs?
>>     
> I attached dmesg and config , both from working 2.6.26-rc5 with git-acpi patch 
> below and from linux-next snapshot 20080604.
> I also attached acpidump that was done while using stock 2.6.25-fw5 from my 
> distro. (But I think that doesnt matter, at least it shouldn't ;)
>
>   
>> Daniel Exner wrote:
>>     
>>> Andrew Morton wrote:
>>>       
>>>> On Fri, 6 Jun 2008 19:30:28 +0200 Daniel Exner <dex@dragonslave.de> 
>>>>         
> wrote:
>   
>>>>> Andrew Morton wrote:
>>>>>           
>>>>>> (cc linux-acpi)
>>>>>>
>>>>>> On Thu, 5 Jun 2008 11:00:12 +0200 Daniel Exner <dex@dragonslave.de>
>>>>>>             
>>> wrote:
>>>       
>>>>>>> Hi!
>>>>>>>
>>>>>>> (Added myself to CC, because I'm not subscribed)
>>>>>>>
>>>>>>> with linux-next snapshot 20080604 my Laptop morphes into sitting duck
>>>>>>> and I think this is due to this:
>>>>>>>               
>>>>>> I assume 2.6.26-rc5 is OK?
>>>>>>             
>>>>> Indeed.. just tried it with (nearly) the same config: no unable to
>>>>> locate IOAPIC
>>>>>
>>>>> Will try todays next snapshot above -rc5 now.
>>>>>           
>>>> OK, thanks.
>>>>
>>>> It would be great if you could test 2.6.26-rc5 plus
>>>> http://userweb.kernel.org/~akpm/git-acpi.patch.  That'll allow us to
>>>> confirm that the regression is due to changes in the acpi tree.
>>>>         
>>> Sorry for the delay.. real-life you know ;)
>>>
>>> I guess you'd expect me to confirm the behavior on rc5 with this patch
>>> aplied, but .. well this Kernel works!
>>>       
> To clarify myself:
> 2.6.25.5:  --> relatively fast no IOAPIC Errors in dmesg
> 2.6.26-rc5:   --> relatively  no IOAPIC Errors in dmesg
> 2.6.26-rc5 + git-acpi Patch:   --> relatively  no IOAPIC Errors in dmesg
> 2.6.26-rc5 +  linux-next snapshot 20080604 --> even slower than before my ide 
> Patch many "unable to locate IOAPIC" Errors
>
>
> So I think the problem lies not in the acpi tree but somewhre else.
>
> Is it possible to tell git to explicitly _exclude_ a specific tree while 
> bisecting?
>
> --
> Greetings
> Daniel Exner
>   

