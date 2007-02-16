Return-Path: <linux-kernel-owner+w=401wt.eu-S1945905AbXBPPSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945905AbXBPPSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945911AbXBPPSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:18:51 -0500
Received: from spirit.analogic.com ([204.178.40.4]:1266 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945905AbXBPPSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:18:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 16 Feb 2007 15:18:40.0824 (UTC) FILETIME=[BD42C380:01C751DD]
Content-class: urn:content-classes:message
Subject: Re: cat, cp operations for tty driver (like for char one)
Date: Fri, 16 Feb 2007 10:18:40 -0500
Message-ID: <Pine.LNX.4.61.0702161011080.4199@chaos.analogic.com>
In-Reply-To: <45D5B7E7.000004.26865@webmail19.yandex.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: cat, cp operations for tty driver (like for char one)
Thread-index: AcdR3b1MhGYg8OxIShm5Un/pCY0S+A==
References: <45D47779.000006.08064@webmail16.yandex.ru> <Pine.LNX.4.61.0702151146400.2062@chaos.analogic.com> <45D5B7E7.000004.26865@webmail19.yandex.ru>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Mockern" <Mockern@yandex.ru>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Feb 2007, Mockern wrote:

> Thanx for your respond.
>
> Does it mean I have to change nothing in my tty driver
> (based on serial_core.c) to use: cat and cp? No "nonstandard " special 
> functions to implement?
>

Change nothing. It you are making your own, make sure your iocl() function
returns the same kinds of errors as the in-kernel one.

You can check out the existing in-kernel driver as:

strace cp filename /dev/ttyS0



>
>
>>
>> On Thu, 15 Feb 2007, Mockern wrote:
>>
>>> I have a question about linux tty driver
>>>
>>> how to support cp, cat operations in tty driver (like tiny_tty)?
>>> (e.g. echo "hello tty" > /dev/ttyS3, cat < ttyS10 etc)
>>>
>>> There a lot of examples with char drivers, but I could not find it for tty Linux driver.
>>>
>>
>> It works out of the box. Just keep hardware flow-control turned off
>> if there are no receivers connected to the output port. Also, you need
>> to set up the port's baud-rate and (usually) to make it transparent to
>> control characters (man tc-get/set-attr).
>>
>> Cheers,
>> Dick Johnson
>> Penguin : Linux version 2.6.16.24 on an i686 machine (5592.61 BogoMips).
>> New book: http://www.AbominableFirebug.com/
>> _
>> 
>>
>> ****************************************************************
>> The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.
>>
>> Thank you.
>
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5594.84 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
