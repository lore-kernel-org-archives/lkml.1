Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbXIDOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbXIDOyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 10:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXIDOyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 10:54:08 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:3296 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbXIDOyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 10:54:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 04 Sep 2007 14:53:37.0235 (UTC) FILETIME=[5FAB4A30:01C7EF03]
Content-class: urn:content-classes:message
Subject: Re: Forbid deletion of memory mappings
Date: Tue, 4 Sep 2007 10:53:53 -0400
Message-ID: <Pine.LNX.4.61.0709041050410.7968@chaos.analogic.com>
In-Reply-To: <200708310005.53587.clemens.kol@gmx.at>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Forbid deletion of memory mappings
Thread-Index: AcfvA1+0s8RmjPB0TqWBe1368Dev1w==
References: <200708301844.10532.clemens.kol@gmx.at> <200708302341.09459.clemens.kol@gmx.at> <30071.1188510621@turing-police.cc.vt.edu> <200708310005.53587.clemens.kol@gmx.at>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Clemens Kolbitsch" <clemens.kol@gmx.at>
Cc: <Valdis.Kletnieks@vt.edu>, <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:

> On Thursday 30 August 2007 23:50:21 Valdis.Kletnieks@vt.edu wrote:
>> On Thu, 30 Aug 2007 23:41:09 +0200, Clemens Kolbitsch said:
>>> On Thursday 30 August 2007 23:34:52 you wrote:
>>>> On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:
>>>>> is there no way to tell the kernel, that a certain mapping must not
>>>>> be removed, no matter what (except of course an explicit call to
>>>>> sys_unmap, of course)?
>>>>
>>>> I don't seem to get what is the issue here. Your mapping is not
>>>> removed, only the VMAs are merged together into one larger VMA if they
>>>> have neighbouring address ranges and compatible protection bits. See
>>>> vma_merge().
>>>
>>> the thing is that they are not. the kernel chooses to REPLACE my mapping.
>>>
>>> consider the user-space code:
>>>
>>> mmap(0xaaaa0000, 0x3000, MAP_FIXED, ...);
>>> mmap(0xaaaa1000, 0x4000, MAP_FIXED, ...);
>>>
>>> here, the second call to mmap will shorten the first mapping to 0x1000
>>> bytes and create one big vma with size 0x5000 bytes.
>>>
>>> is there a way to tell it that the second mmap MUST fail?
>>
>> There's an LSM exit point for mmap, you could perhaps do something there.
>>
>> What are you trying to achieve by forcing the second one to fail?
>
> puh... that is a good question :-)
>
> I'm writing my master's thesis on a new model of memory protection and need to
> have every memory mapping in userspace duplicated. I also have kind of a
> second PGD/PTD that allows finding this mirrored mapping.
>
> However, as the number of original mappings grows, I suddenly have the problem
> that the kernel tries to allocate a new mapping and picks the address of a
> mirrored memory page, which it shouldn't.
>
> Honestly, I don't understand why it does so, but it simply does... so
> basically I want these second mappings to stay in memory as long as the
> original page.
>
> What do you mean exactly with
>
>> There's an LSM exit point for mmap, you could perhaps do something there.
>
> ??
>
> By the way / @Jiri Kosina:
>
>> Which is exactly in compliance with what POSIX says about MAP_FIXED mmaps
>> - see http://opengroup.org/onlinepubs/007908799/xsh/mmap.html
>
> I know... I'm not even saying that this is a bug... I just wonder if there is
> some way to avoid this problem :-)
>
> Thanks for your help - i really appreciate that!!

You might need to keep track of your memory mappings and
not remap something that will overlap. You can mmap
a single page in which you write the addresses. If you
map it shared, all your processes can access it and
call a common memory-mapping procedure (that you write)
which keeps track of its kernel allocations for you.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
