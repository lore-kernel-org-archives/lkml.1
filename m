Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYGYUzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYGYUzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYGYUzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:55:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYGYUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:55:44 -0400
Message-ID: <488A3D95.20108@zytor.com>
Date: Fri, 25 Jul 2008 16:54:45 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce lower_32_bits() macro
References: <1216998747-16896-1-git-send-email-joerg.roedel@amd.com>	<4889FA03.6010708@zytor.com> <20080725134759.ae19b883.akpm@linux-foundation.org>
In-Reply-To: <20080725134759.ae19b883.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>>   */
>>>  #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
>>>  
>>> +/**
>>> + * lower_32_bits - return bits 0-31 of a number
>>> + * @n: the number we're accessing
>>> + */
>>> +#define lower_32_bits(n) ((n) & 0xffffffffULL)
>>> +
>> NAK.  These are assymmetric with regards to type, which is the *last* 
>> thing we want.
> 
> Yes, it will convert a 32-bit expression into a 64-bit one.
> 

Sort of.  upper_32_bits() takes a 32- or 64-bit expression, and delivers 
the upper 32 bits *as a 32-bit number*.  An equivalent expression would be:

	((u32)((u64)(n) >> 32))

... which might actually produce better code, for all I know.

Logically speaking, if we have a lower_32_bits() macro, it should also 
produce a 32-bit type as result.

	-hpa

