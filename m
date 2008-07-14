Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYGNQwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYGNQwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYGNQwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:52:16 -0400
Received: from mercury.realtime.net ([205.238.132.86]:54613 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbYGNQwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:52:16 -0400
In-Reply-To: <Pine.LNX.4.64.0807101654080.6791@localhost.localdomain>
References: <Pine.LNX.4.64.0807130057490.6791@localhost.localdomain>, <7b8dd1f1421b1f52ebc76565986fd2a9@bga.com>, <Pine.LNX.4.64.0807101654080.6791@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <3ffa2cc4f7b9b3bbc2c591bd77b6297d@bga.com>
Content-Transfer-Encoding: 7bit
Cc: ppcdev <linuxppc-dev@ozlabs.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Sam Ravnborg <sam@ravnborg.org>
From: Milton Miller <miltonm@bga.com>
Subject: Re: linux-next: kbuild tree build failure
Date: Mon, 14 Jul 2008 11:53:44 -0500
To: Roman Zippel <zippel@linux-m68k.org>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman.

I saw your reply on the list archives but can not find
it in my inbox.

On Sun Jul 13 at 09:21:08 EST 2008, Roman Zippel wrote:
> On Sat, 12 Jul 2008, Milton Miller wrote:
>
>> (1) #define PAGE_OFFSET    (ASM_CONST(CONFIG_PAGE_OFFSET) << 32)
>>
>> It creates unreadable code, where two defines with almost the same
> name (the
>> only difference being
>> the CONFIG_ prefix, which is often ignored when scanning) contains
> radically
>> different values.
>>
>> (2)  #define PAGE_OFFSET    ASM_CONST(CONFIG_PAGE_OFFSET)
>
> Giving it different names is not really difficult. Any objections to
> CONFIG_PAGE_HIGH_OFFSET?

Once you remove the symmetry and add the ifdef to page.h, we need to
reevaluate its presence in Kconfig.   I can't think of a reason to
have a partial value, and therefore would instead say take out the
config variable on PPC64 as the PPC32 address split reason is moot.

>
>> On a seperate note,
>>>>>>  config PINT3_ASSIGN
>>>>>>         hex "PINT3_ASSIGN"
>>>>>>         depends on PINTx_REASSIGN
>>>>>> -       default 0x02020303
>>>>>> +       default 0x2020303
>>
>> is harder to read.   The value is a list of 4 1 byte values, but you
>> have hidden the first nibble making parsing the rest of the value 
>> hard.
>
> Sam mentioned that already, but that's a situation where the warning 
> can
> be relaxed.

The warning can be relaxed?   What are you talking about?

I was trying to make a case for leading zeros without actually stating
what I was asking for.

You changes did s/(0x)?0*/0x/, y/A-F/a-f/ -- that is you made all hex
constants conform to "0x%x".   I was arguing for 0x%8.8x, or just 
leaving
them as formatted.

>
>> If you are worried about users tring to set values that are too high,
>> then make the types be hex8, hex16, hex32, and hex64.
>
> It's not this, I value consistency as much as you and the values are
> sometimes used as integers, so a working range is needed. Using simple
> integers keeps things much simpler and as the ASM_CONST example shows 
> any
> bigger values are not necessarily directly usable anyway.

How many places want to range check hex numbers?   Is it just setting
the number of digits input?  If strtoull is to hard, can we just do
the check as strings of digits?

If we keep this new restriction on hex numbers, it needs to be in
the Documentation, even if its prefixed by "currently".

milton

