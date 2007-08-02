Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbXHBVmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbXHBVmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbXHBVmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:42:35 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:3753 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXHBVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:42:33 -0400
Date: Thu, 02 Aug 2007 15:42:29 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: gcc fixed size char array initialization bug - known?
In-reply-to: <fa.cjPWb5ZShF43DhggNXkMKMadPYY@ifi.uio.no>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Message-id: <46B24FC5.8060409@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.LxMYkBaN628VuktB9CFi9SC3LTA@ifi.uio.no>
 <fa.6wYNfcIjXc+jXzdUGE5gFFOal1g@ifi.uio.no>
 <fa.cjPWb5ZShF43DhggNXkMKMadPYY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Thu, 2 Aug 2007, Andi Kleen wrote:
> 
>> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>>
>>> 	char c[4] = "0123";
>>> and - a wonder - no warning. 
>> It's required by the C standard.
>>
>> 6.7.8.14 of C99:
>> ``
>> An array of character type may be initialized by a character string literal, optionally
>> enclosed in braces. Successive characters of the character string literal (including the
>> terminating null character if there is room or if the array is of unknown size) initialize the
>> elements of the array.
>> ''
>>
>> Note the "if there is room".
>>
>> I believe the rationale is that it still allows to conveniently initialize 
>> non zero terminated strings.
> 
> Right, I accept that it will compile, but I don't understand why "01234" 
> produces a warning and "0123" doesn't? Don't think C99 says anything about 

Because 5 characters will not fit in a 4 character array, even without 
the null terminator.

> that. And, AFAIU, using structs with fixed-size char array we more or less 
> rely on the compiler warning us if anyone initializes it with too long a 
> string.
> 
> Also interesting, that with
> 
> 	char c[4] = "012345";
> 
> the compiler warns, but actually allocates a 6-byte long array...
> 
> Thanks
> Guennadi


-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

