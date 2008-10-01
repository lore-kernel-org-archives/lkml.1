Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYJALPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYJALPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYJALPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:15:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:24583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYJALPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kBy5eKv2xc3xKW8/w0yZq62i+sFZmohB4BXXdX2IpqO82uN1Yitj/VImjl37qGvGvl
         tUAmXaxEzaF4SGN8szFCDOskgGDfT7JyBwA7TTVlcOG4zq62uxouHRqBvpS6vy+un5Ez
         pYnBkTrO8trKDIemupmaTJDDG6+a3JbpY9o+k=
Message-ID: <19f34abd0810010415s405dcd98j187e5c9c20fc2d16@mail.gmail.com>
Date: Wed, 1 Oct 2008 13:15:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
Cc: "Vegard Nossum" <vegardno@ifi.uio.no>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <48E359B4.7050708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001104717.GA7925@ben.ifi.uio.no> <48E359B4.7050708@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 1:06 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 10/01/2008 12:47 PM, Vegard Nossum wrote:
>> Hi,
>>
>> Fix for tip/x86/mm-debug (commit 59ea746337c69f6a5f1bc4d5e8544b3cbf12f801).
>> I'm not sure if choice of names/structure is entirely correct, comments are
>> appreciated.
>
>
>> From 01613a1949de51c7ab9d0acaaa9a5444722a5cfa Mon Sep 17 00:00:00 2001
>> From: Vegard Nossum <vegardno@ben.ifi.uio.no>
>> Date: Wed, 1 Oct 2008 12:36:34 +0200
>> Subject: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
>>
>> virt_addr_valid() calls __pa(), which calls __phys_addr(). With
>> CONFIG_DEBUG_VIRTUAL=y, __phys_addr() will kill the kernel if the
>> address *isn't* valid. That's clearly wrong for virt_addr_valid().
>>

...

>> --- a/include/asm-x86/page_64.h
>> +++ b/include/asm-x86/page_64.h
>> @@ -69,6 +69,7 @@ extern unsigned long max_pfn;
>>  extern unsigned long phys_base;
>>
>>  extern unsigned long __phys_addr(unsigned long);
>> +#define __phys_addr_nodebug(x) __phys_addr(x)
>>  #define __phys_reloc_hide(x) (x)
>
> x86_64 is screwed in the same way, isn't it?

Hm. I didn't see any #ifdef CONFIG_DEBUG_VIRTUAL in the x86_64 code,
so I assumed it wasn't. But it seems that you are right (because the
checks, or at least some kind of checks, are _always_ performed on
x86_64 regardless of the CONFIG_DEBUG_VIRTUAL setting). Why doesn't
the checking in x86_64 code depend on DEBUG_VIRTUAL?

I will try to make another patch, thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
