Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbZLCV6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbZLCV6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZLCV6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:58:33 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48504 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZLCV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=maL3VMdiitgVoTVZL6yYBPVin8mdJWo4fY2ljwDzvwPYny6D1VBrX9Wo6e/AiG5Cn2
         D+Dq6ywNIH9pOBH2WliZT3Q/dfo6T/Hi67R8WdWQPUwQY2n54CPGPQ8ZWL/EauhDtd0J
         9Pjl01kUbwHIeXxUP5L0s1NICdgvuVMyFxHl4=
Message-ID: <4B183491.6090602@gmail.com>
Date: Thu, 03 Dec 2009 13:58:41 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] BUG kmalloc-8192: Poison overwritten
References: <dd18b0c30912021427x4d1d952tcdd98bb9d816b67c@mail.gmail.com> 	<43e72e890912021516k736db118j217dc92496db8f19@mail.gmail.com> 	<4B182F79.7060103@gmail.com> <43e72e890912031345m3f5adb9nca754e33a858c923@mail.gmail.com>
In-Reply-To: <43e72e890912031345m3f5adb9nca754e33a858c923@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/09 13:45, Luis R. Rodriguez wrote:
> On Thu, Dec 3, 2009 at 1:36 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 12/02/09 15:16, Luis R. Rodriguez wrote:
>>>
>>> On Wed, Dec 2, 2009 at 2:27 PM, Justin Mattock<justinmattock@gmail.com>
>>>   wrote:
>>>>
>>>> I have no idea what this is:
>>>> (first time I've seen this);
>>>>
>>>>
>>>> [   13.055592]
>>>> =============================================================================
>>>> [   13.055865] BUG kmalloc-8192: Poison overwritten
>>>> [   13.056046]
>>>> -----------------------------------------------------------------------------
>>>
>>> I believe this means we write to an area in memory after we freed an skb.
>>>
>>>> [   13.056366] INFO: 0xffff88003290a100-0xffff88003290a143. First byte
>>>> 0x50 instead of 0x6b
>>>> [   13.056366] INFO: Allocated in ath_rxbuf_alloc+0x25/0x94 [ath]
>>>> age=8898 cpu=0 pid=892
>>>> [   13.056366] INFO: Freed in skb_release_data+0xc1/0xc6 age=99 cpu=0
>>>> pid=0
>>>> [   13.056366] INFO: Slab 0xffffea0000b0f9c0 objects=3 used=0
>>>> fp=0xffff88003290c090 flags=0x4000000000004082
>>>> [   13.056366] INFO: Object 0xffff88003290a048 @offset=8264
>>>> fp=0xffff880032908000
>>>> [   13.056366]
>>>> [   13.056366] Bytes b4 0xffff88003290a038:  b9 9e fb ff 00 00 00 00
>>>> 5a 5a 5a 5a 5a 5a 5a 5a ¹.ûÿ....ZZZZZZZZ
>>>
>>> Can you reproduce this? We had a similar report from Miles Lanes I
>>> have been trying to followup on for a while now. The suggested patches
>>> to try are:
>>>
>>>
>>> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009/11-19/70-mac80211-total-ampdu-tx-info.patch
>>>
>>> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009/11-19/71-ath9k-remove-tx_info_priv.patch
>>>
>>>    Luis
>>>
>>
>> as anticipated I had a feeling reproducing
>> this would be a bit of a challeng.
>>
>> so far I was taking into account the actions that
>> I did yesterday to trigger this, but nothing i.e.
>>
>> reboot 30 times(until fsck engages), and shutdown/start 30 times
>> with nothing of the sort.
>>
>> If you have any ideas on how to reproduce this it would
>> be greatly appreciated(don't want to throw in the patches, until
>> I have something to go by).
>>
>> on the other hand I could throw in the patches, and wait and see,
>> but would rather have more hard evidence that the patches do fix something.
>
> I think waiting to be able to reproduce is best, and appreciate your
> patience on this. Maybe Miles Lanes also cannot reproduce easily and
> that may explain why he hasn't replied.
>
>    Luis
>

probably.. What I'll do is tweak with this
the rest of the day, if nothing then I'll go
ahead and throw in the patches, and then go from there.

Justin P. Mattock
