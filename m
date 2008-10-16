Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYJPJGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYJPJGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYJPJGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:06:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34280 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYJPJGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:06:01 -0400
Message-ID: <48F70321.8060208@zytor.com>
Date: Thu, 16 Oct 2008 02:02:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <48F409E9.3030501@zytor.com>	<20081013.223811.174710738.davem@davemloft.net>	<Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be> <20081016.013850.85183428.davem@davemloft.net>
In-Reply-To: <20081016.013850.85183428.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Date: Thu, 16 Oct 2008 10:30:52 +0200 (CEST)
> 
>> On Mon, 13 Oct 2008, David Miller wrote:
>>> From: "H. Peter Anvin" <hpa@zytor.com>
>>> Date: Mon, 13 Oct 2008 19:54:33 -0700
>>>
>>>> I pointed out that we should use the flags to determine formatting
>>>> options, e.g. I/O space is only 16 bits on x86.
>>> It's 64-bit on sparc64 :-)
>>>
>>> There's also the bit where we use a 32-bit resource_t on sparc32
>>> but encode the top 4-bits of the 36 bit physical I/O address in
>>> the resource flags member.
>> So wouldn't it be better to switch those sparc32 configs to a 64-bit
>> resource_t? I think all other platforms with 36-bit physical addresses went
>> that way.
> 
> Absolutely, this is what should happen.
> 
> I'll try to make this happen in 2.6.29, it's a moderately invasive
> change because it effects how ioremap() and friends are implemented.

Either way, it totally underscores how desirable it is to centralize 
this particular class of formatting.

	-hpa
