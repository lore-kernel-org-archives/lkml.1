Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYLDAU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYLDAU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYLDAUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:20:07 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:26848 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYLDAUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:20:06 -0500
Message-ID: <493721E7.3010603@oracle.com>
Date: Wed, 03 Dec 2008 16:18:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: randy.dunlap@oracle.com, rusty@rustcorp.com.au, akpm@linux-foundation.org,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: Re: Yet more ARM breakage in linux-next
References: <20081203124109.79f8f15b.akpm@linux-foundation.org>	<200812040952.44957.rusty@rustcorp.com.au>	<49371848.2080804@oracle.com> <20081203.160144.215210763.davem@davemloft.net>
In-Reply-To: <20081203.160144.215210763.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.493721EB.00A1:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Wed, 03 Dec 2008 15:37:44 -0800
> 
>> Rusty Russell wrote:
>>> On Thursday 04 December 2008 07:11:09 Andrew Morton wrote:
>>>> On Wed, 3 Dec 2008 19:29:05 +0000
>>>>
>>>> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
>>>>> This seems to be causing lots of ARM breakage:
>>>>>
>>>>> lib/find_next_bit.c:183: error: implicit declaration of function '__fls'
>>>>>
>>>>> Whoever's responsible,
>>>> git-blame?
>>> It's me.  Turns out sparc, avr32 and arm all don't define __fls in their
>>> asm/bitops.h, and I'm the first one to use it in generic code.
>>>
>>> But as I prepared this patch, I note that the armv5 __fls/fls is wrong:
>>>
>>>   /* Implement fls() in C so that 64-bit args are suitably truncated */
>>>   static inline int fls(int x)
>>>   {
>>>       return __fls(x);
>>>   }
>>>
>>> __fls(x) returns a bit number (0-31).  fls() returns 0 or bitnumber+1.
>>>
>>> (Yes, classic useless kerneldoc documentation doesn't actually *say* 
>>> this clearly).
>>  
>> oh fud.  That's not a fault of kernel-doc, just of whoever wrote it.
>> It's only as good as someone makes it.
> 
> That's true, but it is not fud to say that kerneldoc is only any good
> if people keep it accurate and up to date, and this is what I think
> Rusty is upset about.
> 
> I personally don't like kerneldoc at all, because the truth is that
> people will work on fixing bugs and other userful things before
> keeping kerneldoc up to date.
> 
> And that's the basic fact which cannot be denied.
> 
> I wish it could work, but it doesn't across the board.  So unless
> we have dedicated monkeys scouring over every single patch that
> goes into the tree and doing the necessary kerneldoc updates,
> kerneldoc will be chronically wrong somewhere.
> 
> That leads to confusion and lost developer time.  Because if the
> kerneldoc bits are wrong, it's worthless.

That's all independent of kernel-doc.  I.e., if someone just used
plain comments and they still were not being updated (typical),
then it's the same problem.  And yes, I agree, the wrong documentation
is bad and a time sink.

~Randy

