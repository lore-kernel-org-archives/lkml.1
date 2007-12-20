Return-Path: <linux-kernel-owner+w=401wt.eu-S1764972AbXLTXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764972AbXLTXGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXLTXGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:06:11 -0500
Received: from spirit.analogic.com ([204.178.40.4]:3890 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbXLTXGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:06:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 20 Dec 2007 23:05:49.0242 (UTC) FILETIME=[DC5131A0:01C8435C]
Content-class: urn:content-classes:message
Subject: Re: Trying to convert old modules to newer kernels
Date: Thu, 20 Dec 2007 18:05:48 -0500
Message-ID: <Pine.LNX.4.61.0712201757410.9907@chaos.analogic.com>
in-reply-to: <20071220220547.GA5641@uranus.ravnborg.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Trying to convert old modules to newer kernels
thread-index: AchDXNxa0dewTCSNRWa8hIdSstpVQA==
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com> <20071220150255.GE2308@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com> <20071220182815.GA5438@uranus.ravnborg.org> <Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com> <20071220220547.GA5641@uranus.ravnborg.org>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Dec 2007, Sam Ravnborg wrote:

> On Thu, Dec 20, 2007 at 04:27:37PM -0500, linux-os (Dick Johnson) wrote:
>>
>> On Thu, 20 Dec 2007, Sam Ravnborg wrote:
>>
>>>>
>>>> It never gets to the printk(). You were right about the
>>>> compilation. Somebody changed the kernel to compile with
>>>> parameter passing in REGISTERS! This means that EVERYTHING
>>>> needs to be compiled the same way, 'C' calling conventions
>>>> were not good enough!
>>>
>>> How did you build the module. It reads like you failed to use
>>> kbuild to build your module which is why you did not pass
>>> correct options to gcc - correct?
>>>
>>> If you did not use kbuild - why not?
>>> Is there anything missing you need?
>>>
>>> 	Sam
>>>
>>
>> I need to get rid of -mregparm=3 on gcc's command line. It
>> is completely incompatible with the standard calling conventions
>> used in all our assembly-language files in our drivers. We make
>> very high-speed number-crunching drivers that munge high-speed
>> data into images. We need to do that in assembly as we have
>> always done.
> That I understand. So you need a CONFIG_ option to switch off
> -regparm=3 and pray that the kernel assembly supports it.
>
> And then I assume you avoided kbuild because it added -regparm=3
> which is why your simple module broke.
>
> As you are well aware there is not any testing of a kernel without
> -regparm=3 these days so you should strongly consider making your
> assembly module comply with -regparm=3.
>
> And no - I dunno how much work that is and what impact it has
> on your number chrunching stuff.
> But it looks like the only sane long-term solution to me.
>
> 	Sam
>

I may be able to make a file full of "adapters" if I
can figure out how to have a procedure that gets
called with parameters in registers, with it calling
conventional stuff. There used to be a macro, "asmlinkage"
that corrected the calling conventions for assembly-language
procedures. I will try to see what it did in some
older kernels. It got taken out of newer ones.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
