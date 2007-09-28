Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXI1OEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXI1OEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXI1OE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:04:26 -0400
Received: from spirit.analogic.com ([204.178.40.4]:4150 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbXI1OEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:04:25 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 28 Sep 2007 14:04:23.0974 (UTC) FILETIME=[794D6C60:01C801D8]
Content-class: urn:content-classes:message
Subject: Re: Out of memory management in embedded systems
Date: Fri, 28 Sep 2007 10:04:23 -0400
Message-ID: <Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
In-Reply-To: <cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Out of memory management in embedded systems
Thread-Index: AcgB2HlUqsTWRGWES/yjVAwVXkRK/g==
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com> <Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com> <cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: =?iso-8859-1?Q?Daniel_Sp=E5ng?= <daniel.spang@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:

> On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>>
>> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
>>
>>> Applications with dynamic input and dynamic memory usage have some
>>> issues with the current overcommitting kernel. A high memory usage
>>> situation eventually results in that a process is killed by the OOM
>>> killer. This is especially evident in swapless embedded systems with
>>> limited memory and no swap available.
>>>
>>> Some kind of notification to the application that the available memory
>>> is scarce and let the application free up some memory (e.g., by
>>> flushing caches), could be used to improve the situation and avoid the
>>> OOM killer. I am currently not aware of any general solution to this
>>> problem, but I have found some approaches that might (or might not)
>>> work:
>>>
>>> o Turn off overcommit. Results in a waste of memory.
>>>
>>> o Nokia uses a lowmem security module to signal on predetermined
>>> thresholds. Currently available in the -omap tree. But this requires
>>> manual tuning of the thresholds.
>>> http://www.linuxjournal.com/article/8502
>>>
>>> o Using madvise() with MADV_FREE to get the kernel to free mmaped
>>> memory, typically application caches, when the kernel needs the
>>> memory.
>>>
>>> o A OOM handler that the application registers with the kernel, and
>>> that the kernel executes before the OOM-killer steps in.
>>>
>>> Does it exist any other solutions to this problem?
>>>
>>> Daniel
>>> -
>>
>> But an embedded system contains all the software that will
>> ever be executed on that system! If it is properly designed,
>> it can never run out of memory because everything it will
>> ever do is known at design time.
>
> Not if its input is not known beforehand. Take a browser in a mobile
> phone as an example, it does not know at design time how big the web
> pages are. On the other hand we want to use as much memory as
> possible, for cache etc., a method that involves the kernel would
> simplify this and avoids setting manual limits.
>
> Daniel
>

Any networked appliance can (will) throw data away if there are
no resources available.

The length of a web-page is not relevent, nor is the length
of any external data. Your example will buffer whatever it
can and not read anything more from the external source until
it has resources available unless it is broken.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
