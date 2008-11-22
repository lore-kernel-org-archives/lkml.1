Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYKVTH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYKVTH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 14:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYKVTHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 14:07:50 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:36010 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYKVTHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 14:07:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wwwkGGLuJgWT0OcgFHQOxVyERnp0DGEZV++dzgHa73fOG1tPK4FO844PLjPPxpluLs
         5dxZ4lIp5R6n/k1RuSPq/vkVkkxZ9p1OPvgeUdd2qpY+5vcfZp/Nc761SI2oq2+jNatc
         DIBcNM+Wrn+vhdBpbMx6ySodnn/guVw42gpe4=
Message-ID: <492856C2.8000707@gmail.com>
Date: Sat, 22 Nov 2008 21:00:18 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
References: <s5h3ai11dpt.wl%tiwai@suse.de> <20081109151323.GA18705@rhlx01.hs-esslingen.de> <s5h7i7c916e.wl%tiwai@suse.de> <20081109200929.GA29333@rhlx01.hs-esslingen.de> <s5hiqqtkxqr.wl%tiwai@suse.de> <491B0D38.1050207@gmail.com> <20081112180519.GA21919@rhlx01.hs-esslingen.de> <491DBDEA.9010104@gmail.com>
In-Reply-To: <491DBDEA.9010104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> Andreas Mohr wrote:
>> Hi,
>>
>> On Wed, Nov 12, 2008 at 07:07:04PM +0200, Maxim Levitsky wrote:
>>> I pretty much studied the datasheet and driver, and this is what I 
>>> found:
>>> btw, my acer 5720 and aspire one share same ALC268.
>>> Some stuff is trivially fixable, some seems to be unfixable at all:
>>
>> Wow, what an extremely in-depth analysis!
>> I just intended to dive into getting mic routing corrected myself,
>> thus you saved me a lot of time!
>>
>>> model=acer is used on my regular laptop.
>>> model-acer-aspire is used on aspire one laptop, and it needs to be 
>>> renamed, as both are aspire.
>>
>> +1 (your analysis of both being rather different - as already pondered -
>> confirms this necessity)
>>
>>> And now for unfixable problems:
>>>
>>> 1) There is strong DC offset on all inputs.
>>> it is even different on left/right and depends on capture volume.
>>> I tried to change the VREF only param that could help, but it doesn't.
>>> I feel that this is hardware flaw.
>>> (It is possible that voltage on inputs is created by circuit made by 
>>> acer, and then ALC268 amplifies it.)
>>
>> Sounds like really bad circuit design then.
>> One would think that the Intel HDA architecture might have builtin
>> measures to compensate for this if needed? DC offset issues on
>> soundcards aren't exactly a new phenomenon after all...
>>
>>> Lastly I noticed that datasheet mentions so called 'coefficients':
>>> the codecs exposes lots of internal and undocumented registers using 
>>> set address/ get/set value scheme.
>>> maybe some of above bugs are fixable there, but ether realtek has to 
>>> provide data for that or reverse engineering of
>>> windows driver is required.
>>
>> I've actually had a peek at the .inf files since I thought that it would
>> already contain register values in those registry keys that it creates on
>> install, but yeah, that's all in-driver it seems.
>> Probably time to ask Acer about specifics, especially since I didn't spot
>> any hda-intel changes in their linux-2.6.23.9lw source.
>>
>> Thank you very much,
>>
>> Andreas Mohr
> 
> Small update:
> 
> 1) The dc offset isn't present on aspire one, really is a circuit design 
> bug I guess 2) Internal mic works perfectly on aspire one, can reproduce 
> the strange behaver at all,
> Probably this was mixer bug.
Finally, I found how to reproduce that bug,
I mean to get normal volume on internal mic, I have to increase volume
only on left or right channel.

So, this happens always, and _only_ when recording _mono_ sound from internal
mic.

Since hardware doesn't support hardware mono input, tested with -D hw:0
I suspect this to be alsa-lib bug, any ideas?
Happens with arecord -D plughw:0 -c1 .

Best regards,
	Maxim Levitsky





> 
> So aspire one support is almost, only need to add support to restore 
> beep volume
> after resume.
> 
> 
> Best regards,
>     Maxim Levitsky
> 
> 

