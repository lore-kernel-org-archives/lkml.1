Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbZAWJqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbZAWJqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZAWJp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:45:56 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:48058 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbZAWJpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:45:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p849Aq6B1L1zBE63WMfpVbflGCQDVvAzxix8JnJtI4VnBAmXaF8/K2uZG/2rwAA0rw
         5Sd/HT/HRt3tn/SAwmMyOxUVMkDuC4pRQOoQnAKbpujWmoqd1wQhVNr+XrVai0emdD0p
         rb3s06alal7eaX0nin3pPScraOBUsk/0i+0es=
Message-ID: <497991CC.9030200@tuffmail.co.uk>
Date: Fri, 23 Jan 2009 09:45:48 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@suse.cz>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: BISECTED: 2.6.29-rc2 regression: hibernation hang on eeepc-701
References: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com> <200901221344.16178.rjw@sisk.pl> <49787339.7080900@tuffmail.co.uk> <200901222305.25824.rjw@sisk.pl>
In-Reply-To: <200901222305.25824.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 22 January 2009, Alan Jenkins wrote:
>   
>> Rafael J. Wysocki wrote:
>>     
>>> On Thursday 22 January 2009, Alan Jenkins wrote:
>>>   
>>>       
>>>> Alan Jenkins wrote:
>>>>     
>>>>         
>>>>> Hibernation hangs just after writing the image.  With s2disk I can see
>>>>> this from the console messages.  The same hang happens with kernel
>>>>> swsusp ('echo disk | sudo tee /sys/power/state'), and I can see that
>>>>> the image has been written from the HDD led.
>>>>>
>>>>> In either case, I can still hard-power-off and resume from hibernation.
>>>>>
>>>>> It doesn't hang if I use the shutdown method (either 'echo shutdown |
>>>>> sudo tee /sys/power/disk' or  's2disk -P "shutdown method=shutdown"').
>>>>>   
>>>>>       
>>>>>           
>>>> I've bisected this to commit 571ff7584bb9e05fca0eb79752ae55a46faf3a98. 
>>>> It doesn't revert cleanly from RC2.
>>>>
>>>> I think it's distinct from the other two reported suspend regressions. 
>>>> I'm not using acpi-cpufreq, and the issue doesn't affect resume.
>>>>     
>>>>         
>>> It looks distinct.
>>>
>>> Do you suspend this box to RAM and does it work?
>>>   
>>>       
>> Yes, I do use STR on it occasionally, and it still works in RC2.
>>
>>     
>>> Please retest with the appended patch applied.
>>>   
>>>       
>> That fixes it.
>>     
>
> OK, it won't hurt to apply it.
>
> Still, the hardware or the BIOS in your box seems to be broken, or both, so I'd
> like to debug it a bit more if you don't mind.
>
> Can you please test the patch below instead of the previous one?
>   

It hangs at the same point as the unpatched RC2.  As before, it doesn't
hang if I use "shutdown" instead of "platform".

Going by sysfs, I have 4 PCI devices without a kernel driver.

8086:2592   Mobile 915 Express Graphics Controller
8086:2792   Mobile 915 Express Graphics Controller (driven by X)
8086:2448   82801 Mobile PCI Bridge
8086:2641   82801FBM (ICH6M) LPC Interface Bridge

Thanks
Alan

