Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZLBX23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZLBX23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZLBX22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:28:28 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:58933 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZLBX22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:28:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AwPNU+g0wu2fxB3zXjjKFZXZTeRZkXG/vPZVGz5WvgYMBWy9lPMXDDXq3NtVBu3RPG
         gBHPAUe2dmzPezYFdhRfYUXjV7O3wKg5T0QWtDQXWXQeOBFHMl1cy6G9dQ76FR65Me0P
         dhOkPDGeNTf4VXi5tAIv99IRTIHOr5WPEstGw=
Message-ID: <4B16F822.9050807@gmail.com>
Date: Wed, 02 Dec 2009 15:28:34 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net
Subject: Re: [ath9k-devel] BUG kmalloc-8192: Poison overwritten
References: <dd18b0c30912021427x4d1d952tcdd98bb9d816b67c@mail.gmail.com> <43e72e890912021516k736db118j217dc92496db8f19@mail.gmail.com>
In-Reply-To: <43e72e890912021516k736db118j217dc92496db8f19@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/09 15:16, Luis R. Rodriguez wrote:
> On Wed, Dec 2, 2009 at 2:27 PM, Justin Mattock<justinmattock@gmail.com>  wrote:
>> I have no idea what this is:
>> (first time I've seen this);
>>
>>
>> [   13.055592] =============================================================================
>> [   13.055865] BUG kmalloc-8192: Poison overwritten
>> [   13.056046] -----------------------------------------------------------------------------
>
> I believe this means we write to an area in memory after we freed an skb.
>
>> [   13.056366] INFO: 0xffff88003290a100-0xffff88003290a143. First byte
>> 0x50 instead of 0x6b
>> [   13.056366] INFO: Allocated in ath_rxbuf_alloc+0x25/0x94 [ath]
>> age=8898 cpu=0 pid=892
>> [   13.056366] INFO: Freed in skb_release_data+0xc1/0xc6 age=99 cpu=0 pid=0
>> [   13.056366] INFO: Slab 0xffffea0000b0f9c0 objects=3 used=0
>> fp=0xffff88003290c090 flags=0x4000000000004082
>> [   13.056366] INFO: Object 0xffff88003290a048 @offset=8264
>> fp=0xffff880032908000
>> [   13.056366]
>> [   13.056366] Bytes b4 0xffff88003290a038:  b9 9e fb ff 00 00 00 00
>> 5a 5a 5a 5a 5a 5a 5a 5a ¹.ûÿ....ZZZZZZZZ
>
> Can you reproduce this? We had a similar report from Miles Lanes I
> have been trying to followup on for a while now. The suggested patches
> to try are:
>
> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009/11-19/70-mac80211-total-ampdu-tx-info.patch
> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009/11-19/71-ath9k-remove-tx_info_priv.patch
>
>    Luis
>

just noticed the other thread.
I can tryout these patches and see.

As for reproducing this, tough to say...
during my looking into udev I was rebooting
a few times(maybe 10/15) then hit this.

I'll try and reproduce this,before using these
patches so I can verify they take care of the issue.
(but could be difficult to reproduce);

Justin P. Mattock
