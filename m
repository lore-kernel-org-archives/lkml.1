Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbXKMVaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbXKMVaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbXKMVaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:30:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39046 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbXKMVaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:30:20 -0500
Message-ID: <473A166E.3070708@zytor.com>
Date: Tue, 13 Nov 2007 13:26:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (update)
References: <20071113185800.436425570@polymtl.ca> <20071113190040.740103668@polymtl.ca> <4739F609.50501@zytor.com> <20071113192445.GA1463@Krystal> <4739FCA0.4040702@zytor.com> <20071113194550.GA4400@Krystal> <473A017D.2030501@zytor.com> <20071113204033.GB7450@Krystal>
In-Reply-To: <20071113204033.GB7450@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
>> Mathieu Desnoyers wrote:
>>> * H. Peter Anvin (hpa@zytor.com) wrote:
>>>> Mathieu Desnoyers wrote:
>>>>>> - Use "=g" constraint for char immediate value inline assembly.
>>>>>>
>>>>>> "=g" is the same as "=rmi" which is inherently bogus.  In your actual 
>>>>>> code you use "=r", the correct constraint is "=q".
>>>>> q
>>>>>     Any register accessible as rl. In 32-bit mode, a, b, c, and d; in 
>>>>> 64-bit mode, any integer register. I am worried that "=q" might exclude 
>>>>> the si and di registers in 32-bit mode.
>>>>> What exactly is wrong with "=r" ?
>>>> For "char" (8-bit) values, sp/bp/si/di are illegal in 32-bit mode.
>>>>
>>>> Hence "=q".
>>>>
>>> Ah! yep, I see, so we say:
>>> 1 byte : "=q"
>>> 2 bytes : "=r"
>>> 4 bytes : "=r"
>>> 8 bytes : "=r"
>>> ? (si and di appear to be legal for 2 and 4 bytes in 32-bit mode)
>> That's right.
>>
>> 	-hpa
> 

Something else to watch out for... in 64-bit mode the lengths most of 
these will depend on which register is used, since whether or not a REX 
prefix is needed will vary.

As far as I can tell, you're assuming fixed length instructions, which 
is wrong unless you manually constrain yourself to only legacy registers.

	-hpa
