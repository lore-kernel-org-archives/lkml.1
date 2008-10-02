Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYJBGSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYJBGSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYJBGSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:18:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:55761 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYJBGSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hSZ2xWBe+tXF0BlGLA+orm4qaHSLGbWAYEI5ddEgoYyq2TLKMm42JYU0uBcTQa1uaP
         3WkyzrVfyT8Ypq562atBFvCGX+YQzDIi7xrmdTkO1P3/7ciuVaXCtHtBuFSp+GK0VUjE
         WKOcCw9VkIG54MwRBtEiB3006sKWMMa5Sx7/s=
Message-ID: <19f34abd0810012318p75bd3773s97b999b9f1ffcae9@mail.gmail.com>
Date: Thu, 2 Oct 2008 08:18:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
Cc: "Andi Kleen" <andi@firstfloor.org>, "Vegard Nossum" <vegardno@ifi.uio.no>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <48E3D6FC.7070709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001104717.GA7925@ben.ifi.uio.no> <48E359B4.7050708@gmail.com>
	 <19f34abd0810010415s405dcd98j187e5c9c20fc2d16@mail.gmail.com>
	 <48E35E83.9040101@gmail.com>
	 <19f34abd0810010942ifef42efv6c45831789aa1293@mail.gmail.com>
	 <20081001165246.GY25711@one.firstfloor.org>
	 <48E3D03C.5010808@gmail.com>
	 <20081001194655.GZ25711@one.firstfloor.org>
	 <48E3D6FC.7070709@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 10:01 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 10/01/2008 09:46 PM, Andi Kleen wrote:
>>> Anyway virt_addr_valid() is IMHO wrong. E.g. first modules VM address
>>> 0xffffffffa0000000 is after __pa() 200M which is valid pfn after the shift even
>>> on the flatmem model with enough memory.
>>>
>>> Am I missing something? What's the exact purpose of the virt_addr_valid()?
>>
>> I think it's supposed to be only used on direct mapping anyways (judging
>> from a quick look a the users)
>
> Then kmemcheck assumes something else. Citing:
>  * We need to be extremely careful not to follow any invalid pointers,
>  * because this function can be called for *any* possible address.
> and the very first check is !virt_addr_valid(address).

The purpose of this call was to make sure that the page behind the
virtual address has an associated struct page. That is the assumption:
virt_to_page() will return something meaningful if and only if
virt_addr_valid().

>
>> So not handling text mapping is ok, but don't panic on it.
>
> It doesn't handle properly anything but text and direct mapping. Now it
> oopses/causes BUG on that wrong cases.
>
> I think we should set it down there that it was intended to be used only on
> text/direct mapping and only for checking if there is a physical memory page
> behind this kind of virtual address.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
