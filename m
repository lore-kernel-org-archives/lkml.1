Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYIFNVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYIFNVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 09:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYIFNUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 09:20:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:62204 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbYIFNUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 09:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KdKocXbkssSChy2+znwRLWZ6KHZ93ONZD6PRT3TNN7DXcLA4F2e6coOxUHFLEKgIKf
         KoqIB/aa1rZ2OA5P4B/biS5pqzLiwHoJGTWc/RnctTV0ZrBOy554EA0L4I88uDJGyBSo
         P3j6fgabSc6vr9eaHFnrSUo2txYAU4Vh2MQzE=
Message-ID: <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com>
Date: Sat, 6 Sep 2008 15:20:52 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <48C19415.9060108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
	 <1220642738.11202.21.camel@twins.programming.kicks-ass.net>
	 <48C19415.9060108@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 10:18 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> Peter Zijlstra wrote:
>>
>> On Fri, 2008-09-05 at 21:17 +0200, Luca Tettamanti wrote:
>>>
>>> On Thu, Sep 4, 2008 at 10:51 PM, Luca Tettamanti <kronos.it@gmail.com>
>>> wrote:
>>>>
>>>> On Thu, Sep 4, 2008 at 4:25 PM, Peter Zijlstra <peterz@infradead.org>
>>>> wrote:
>>>>>
>>>>> Sadly your config just boots, albeit not to userspace due to missing
>>>>> drivers.
>>>>
>>>> Yes, I managed to boot it with qemu... I tried kgdb - without luck -
>>>> kernel dies too early.
>>>> I also managed to get a stack trace :D
>>>>
>>>> http://img151.imageshack.us/my.php?image=tracedm1.jpg
>>>>
>>>> It seems that lockdep is an innocent bystander... the kernel died with
>>>> panic() in __reserve_early, and then took another exception while
>>>> printing the panic (I guess).
>>>> Will add further debug stuff to see wtf is going on.
>>>
>>> Hum, kernel says:
>>>
>>> http://img177.imageshack.us/my.php?image=overlappingus2.jpg
>>>
>>> Overlapping early reservations b98000-eff266 RAMDISK to 200000-d09cf7
>>> TEXT DATA BSS
>>>
>>> It would appear that the initramfs is overlapping the kernel itself,
>>> is the boot loader (LILO) doing something stupid?
>>
>> Suppose it is, lets ask hpa..
>>
>
> It definitely looks like it.

Is there anything that the kernel could to do confuse lilo?
The issue started appearing with 2.6.27 and the outcome of the boot
process varies between versions and seems sensitive to configuration
changes (though a "bad" kernel consistently fails).

Orthogonal to my problem: the panic() in reserve_early is useless for
debugging since the output won't reach the screen or the serial
console (even worse: the kernel takes an exception while trying to
execute the panic). Is it acceptable to replace it with an
early_printk + hlt?

Luca
