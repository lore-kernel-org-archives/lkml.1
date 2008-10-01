Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbYJANsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbYJANsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 09:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYJANsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 09:48:39 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:51795 "EHLO netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYJANsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 09:48:38 -0400
Message-ID: <41e201c923cb$e06cf4e0$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: "Andrey Borzenkov" <arvidjaar@mail.ru>, "Milton Miller" <miltonm@bga.com>
Cc: <linux-kernel@vger.kernel.org>
References: <200809301450.m8UEo5wT027331@sullivan.realtime.net> <409101c923af$c8092020$0400a8c0@dcccs> <11424badd1aca3f1ec752f97c47f589b@bga.com> <20081001114428.DCCEB1723EF@smtp11.mtu.ru>
Subject: Re: How can i read really 512 byte?
Date: Wed, 1 Oct 2008 15:44:41 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "Andrey Borzenkov" <arvidjaar@mail.ru>
To: "Milton Miller" <miltonm@bga.com>; <janos.haar@netcenter.hu>; "Linux 
Kernel Mailing List" <linux-kernel@vger.kernel.org>
Sent: Wednesday, October 01, 2008 2:36 PM
Subject: Re: How can i read really 512 byte?


> Milton Miller wrote:
>
>>
>> On Oct 1, 2008, at 5:23 AM, Janos Haar wrote:
>>
>>>> On Tue, 30 Sep 2008 at 08:29:15 -0400 (EDT), Janos Haar wrote:
>>>>> Now i am working on recover some data from one defective drive.  I
>>>>> am using dd_rescue, and dd, but both ready only 4K, i think, because
>>>>> the kernel's block size is 4K.
>>>>> I have tried to google for the solution, but only found this trick:
>>>>> losetup /dev/loop0 /dev/hdc
>>>>> blockdev --setbsz 512 /dev/hdc
>>>>> and after this set, trying to read the hdc...
>>>>> It looks like working on the first look, but not really. :-( The
>>>>> 512 size bad sectors still have 4K sizes, but the reading attempt
>>>>> takes more (8x ?) longer.
>>>>> Somebody can help me to set the reading block size to 512 byte?
>>>> You need to add O_DIRECT to the open call in the flags parameter
>>>> (the second argument).   (My brother tested this a year or so ago,
>>>> and it worked for him).
>>>> milton
>>>
>>> Hello,
>>>
>>> Thank you for the information.
>>> Can you help me a little bit more?
>>> Where need to add this parameter?
>>> In the kernel, in the blocked's source, or in the dd_rescue's source?
>>
>> dd_rescue ... there is a call to open, add O_DIRECT to the second
>> argument and recompile.  If it says unknown identifier, just copy the
>> #define from the kernel header into the dd_rescue source.
>>
>
> C'mon, really.
>
> {pts/0}% dd_rescue -h
>
> dd_rescue Version 1.14, garloff@suse.de, GNU GPL
> [...]
>         -b softbs  block size for copy operation (def=65536),
>         -B hardbs  fallback block size in case of errs (def=512),
> [...]
>         -d/D       use O_DIRECT for input/output (def=no),

YES! 8-)
It works! :-)

Thank you wery much for you, and Milton!

Thanks
Janos Haar

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/ 

