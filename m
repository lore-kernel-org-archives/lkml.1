Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0BDCiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:38:02 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0BDCh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:37:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=IY7ybKhdFM+po9n7sHDQWWvYUTsgf1pxkxxI6SphZBUvuJ7rajBm5LNIGavvUyb7e
	eEg9Kyo289GtRujcPrZwQ==
MIME-Version: 1.0
In-Reply-To: <4B687B7C.2070406@gmail.com>
References: <4B5885F7.2020007@gmail.com> <4B679EA9.6030203@kernel.org>
	 <4B6833DD.1020001@gmail.com> <4B683581.7070708@kernel.org>
	 <4B683DEF.3000302@gmail.com>
	 <da824cf31002020844r12cada26x57f96b0aa24b59c6@mail.gmail.com>
	 <4B686B2B.2080406@gmail.com>
	 <da824cf31002021104v72efcd05ne639091042d5999d@mail.gmail.com>
	 <4B687B7C.2070406@gmail.com>
Date: Wed, 3 Feb 2010 18:37:53 -0800
Message-ID: <da824cf31002031837t1cf2357bsbb53a3b4ea5e671f@mail.gmail.com>
Subject: Re: port multiplier problem
From: Grant Grundler <grundler@google.com>
To: Chandra Shekhar Sah <edu4madh@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 11:22 AM, Chandra Shekhar Sah <edu4madh@gmail.com> wrote:
> Hi Grant,
>
> Thank for reply.
> Yes, PMP is sil3726. The backplane of the disk array has two PMP (each
> 1-to-5 as you have mentioned) and two sata direct connection without PMP.
> So, 10 disk are behind 2 PMP.

Ah ok. That explains your "5-5-1-1" comment now. I tried to find a
Data sheet for this board but only found one in Chinese:
    www.norco.com.cn/UpLoadFile/Manual/DS-12X0-CN.pdf

and I unfortunately don't speak/read chinese. Probably doesn't matter
though since...

This email thread looks like a duplicate of a previous bug report:
   http://markmail.org/message/lp3ynvfefejpiy2r

(or search for  "Ubuntu 9.04 (2.6.28-14) and eSATA Port Multiplier
(PMP) Not working")

Chandra, you might read through that thread and dmesg output (posted by Chris K)
to see what else you have in common.

I had two questions on that thread that never got answered:
   http://markmail.org/message/snpekoj4qexrslk5

| How can we find out if anyone has the SEMB properly wired up?
| Would it be hard to make libata aware of "SEMB port not responding" case?
| ie if the SEMB port times out or has no link, reduce the port count of
| the sil3726 PMP by one.
|
| Maybe add a "enable_sil24_semb" flag to libata?
| (avoid checking unless someone asks for it). I hate magic flags but also
| don't want to subject most people to the timeout delay.

I (or Gwendal) can post a patch (and lightly test) for any of the above.
Just need to get some guidance so we don't waste our time.

thanks,
grant

> Total is 12 disks. The sata host controller is
> sil3124. Picture of the backplane is attached.
>
> Thanks,
> Chandra
>
> On 2/2/10 2:04 PM, Grant Grundler wrote:
>>
>> On Tue, Feb 2, 2010 at 10:12 AM, Chandra Shekhar Sah<edu4madh@gmail.com>
>>  wrote:
>>
>>>
>>> Hi Grant,
>>>
>>> There are 6 Seagate Barracuda and 6 Hitachi DeskStar.
>>>
>>
>> I thought 0x1095/0x3726 was a Silicon Image part. Can you confirm this?
>>
>> If it is, this sounds like a broken implementation to me. Here is what
>> the Silicon Image 3726 Data Sheet says in the introduction:
>>     Silicon Image’s SiI3726 is 1-to-5 SATA Port Multiplier designed to
>> provide a high performance link between a single SATA host port and 5
>> SATA device ports.
>>
>> So I don't know where the 6th device is getting connected. Some
>> explanation/data sheet from the HW vendor would be helpful at this
>> point.
>>
>>
>>>
>>> Seagate Model: ST3750640AS
>>> Firmware: 3.AAK
>>>
>>> Hitachi Model:HDS721075KLA330
>>> Firmware: Not sure
>>>
>>
>> Both of these drives work behind Sil3726. (First hand experience).
>>
>>
>>>
>>> I have attached pictures of both labels, in case.
>>>
>>
>> Perfect - thanks for posting those.
>>
>> thanks,
>> grant
>>
>>
>
>
