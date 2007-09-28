Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbXI1PRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbXI1PRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbXI1PQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:16:55 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4120 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbXI1PQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:16:54 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 28 Sep 2007 15:16:52.0770 (UTC) FILETIME=[99630820:01C801E2]
Content-class: urn:content-classes:message
Subject: Re: Out of memory management in embedded systems
Date: Fri, 28 Sep 2007 11:16:52 -0400
Message-ID: <Pine.LNX.4.61.0709281105340.9420@chaos.analogic.com>
In-Reply-To: <cfd9edbf0709280714u7a03ec16pfe3cb7328dbab7ad@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Out of memory management in embedded systems
Thread-Index: AcgB4plqzDNuYqEyR4yqf92KXI2ITQ==
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com> <Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com> <cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com> <Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com> <cfd9edbf0709280714u7a03ec16pfe3cb7328dbab7ad@mail.gmail.com>
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
>>> On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>>>>
>>>> But an embedded system contains all the software that will
>>>> ever be executed on that system! If it is properly designed,
>>>> it can never run out of memory because everything it will
>>>> ever do is known at design time.
>>>
>>> Not if its input is not known beforehand. Take a browser in a mobile
>>> phone as an example, it does not know at design time how big the web
>>> pages are. On the other hand we want to use as much memory as
>>> possible, for cache etc., a method that involves the kernel would
>>> simplify this and avoids setting manual limits.
>>>
>>> Daniel
>>>
>>
>> Any networked appliance can (will) throw data away if there are
>> no resources available.
>>
>> The length of a web-page is not relevent, nor is the length
>> of any external data. Your example will buffer whatever it
>> can and not read anything more from the external source until
>> it has resources available unless it is broken.
>
> And how do you determine when no resources are availabe? We are using
> overcommit here so malloc() will always return non null.
>

A networked appliance using embedded software is not your daddy's
Chevrolet. Any task that is permanent needs to allocate all its
resources when it starts. That's how it knows how much there are,
and incidentally, it doesn't do it blindly. The system designer
must know how much memory is available in the system and how much
is allocated to the kernel.

The fact that you can give a fictitious value to malloc() is not
relevant. If you don't provide resources for malloc(), like
(ultimately) a swap file, then you can't assume that it can do
any design work for you.

An embedded system is NOT an ordinary system that happens to
boot from flash. An embedded system requires intelligent design.

It is important to understand how a virtual memory system
operates. The basics are that the kernel only "knows" that
a new page needs to be allocated when it encounters a trap
called a "page fault." If you don't have any memory resources
to free up (read no swap file to write a seldom-used task's
working set), then you are screwed --pure and simple. So,
if you don't provide any resources to actually use virtual
memory, then you need to make certain that virtual memory
and physical memory are, for all practical purposes, the same.

With embedded servers, it's usually very easy to limit the
number of connections allowed, therefore the amount of
dynamic resources that must be provided. With clients
it should be equally easy, but generic software won't
work because, for instance, Mozilla doesn't keep track
of the number of "windows" you have up and the number
of connections you have. HOWEVER, remember that malloc()
is a library call. You can substitute your own using
LD_PRELOAD, they keeps track of everything if you must
use generic software.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
