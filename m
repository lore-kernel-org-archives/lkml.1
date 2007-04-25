Return-Path: <linux-kernel-owner+w=401wt.eu-S1423369AbXDYSZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423369AbXDYSZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423377AbXDYSZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:25:15 -0400
Received: from spirit.analogic.com ([204.178.40.4]:3408 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423369AbXDYSZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:25:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 25 Apr 2007 18:24:17.0877 (UTC) FILETIME=[EF8D3050:01C78766]
Content-class: urn:content-classes:message
Subject: Re: [RFC][PATCH] fix abs() macro to work with types wider than int
Date: Wed, 25 Apr 2007 14:24:12 -0400
Message-ID: <Pine.LNX.4.61.0704251418010.26778@chaos.analogic.com>
In-Reply-To: <alpine.DEB.0.98.0704251123370.19149@sigma.j-a-k-j.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH] fix abs() macro to work with types wider than int
Thread-Index: AceHZu+WHBtBdLdWShGcb1juKZfliQ==
References: <20070419092339.GA13569@dwarf.suse.cz> <20070419084339.418dbe69.randy.dunlap@oracle.com> <4628B5B6.90303@student.ltu.se> <20070425082028.8ece3094.randy.dunlap@oracle.com> <alpine.DEB.0.98.0704251123370.19149@sigma.j-a-k-j.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Jiri Bohac" <jbohac@suse.cz>, <akpm@osdl.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Apr 2007, John Anthony Kazos Jr. wrote:

>>>> I think it's like it is just to be consistent with abs() in C,
>>>> which also contains labs() and llabs().
>>>>
>>> We actually had labs() before (few months ago), but since it was not
>>> used, and if it would it seemed better to just fix abs(), it was
>>> removed. So I think this is the appropriate way to go.
>>
>> Sounds like when someone actually needs labs() or llabs()
>> they can submit a patch for however they would like to use it.
>
> However they would like to use *abs()? What different ways are possible to
> take the arithmetic absolute value? I see record of many cases where
> dozens of authors have macros that then get collapsed to include files. So
> why not avoid that annoyance this time and -start- with it in the include
> files?
>
> Can there even be any reason beyond unnecessary pedantics to have
> [l[l]]abs?

Isn't any macro that looks for "< 0" insensitive to the word length? I think 
it's only when people try tricks with "sign-bits," that they get into trouble.
I think this works, regardless of the length of the integers:

#define abs(x) (((x)<0)?-(x):(x))



Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.62 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
