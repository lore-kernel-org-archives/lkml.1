Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbXKMUAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbXKMUAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbXKMUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:00:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37414 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXKMUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:00:26 -0500
Message-ID: <473A017D.2030501@zytor.com>
Date: Tue, 13 Nov 2007 11:56:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization
References: <20071113185800.436425570@polymtl.ca> <20071113190040.740103668@polymtl.ca> <4739F609.50501@zytor.com> <20071113192445.GA1463@Krystal> <4739FCA0.4040702@zytor.com> <20071113194550.GA4400@Krystal>
In-Reply-To: <20071113194550.GA4400@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
>> Mathieu Desnoyers wrote:
>>>> - Use "=g" constraint for char immediate value inline assembly.
>>>>
>>>> "=g" is the same as "=rmi" which is inherently bogus.  In your actual 
>>>> code you use "=r", the correct constraint is "=q".
>>> q
>>>     Any register accessible as rl. In 32-bit mode, a, b, c, and d; in 
>>> 64-bit mode, any integer register. I am worried that "=q" might exclude 
>>> the si and di registers in 32-bit mode.
>>> What exactly is wrong with "=r" ?
>> For "char" (8-bit) values, sp/bp/si/di are illegal in 32-bit mode.
>>
>> Hence "=q".
>>
> 
> Ah! yep, I see, so we say:
> 
> 1 byte : "=q"
> 2 bytes : "=r"
> 4 bytes : "=r"
> 8 bytes : "=r"
> 
> ? (si and di appear to be legal for 2 and 4 bytes in 32-bit mode)
> 

That's right.

	-hpa
