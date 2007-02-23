Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbXBWTLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbXBWTLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 14:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933184AbXBWTLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 14:11:31 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:48341 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181AbXBWTLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 14:11:30 -0500
Message-ID: <45DF3C53.4030100@student.ltu.se>
Date: Fri, 23 Feb 2007 20:11:15 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Milind Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
References: <3b44d3fb0702222056k1d2a9b57q69a3555a09a9058e@mail.gmail.com>	 <3b44d3fb0702230014x4ee4a1dewdc624c54b3635e15@mail.gmail.com>	 <45DEAC45.7090105@student.ltu.se>	 <3b44d3fb0702230215o2fbd5a3y25729e481a447149@mail.gmail.com>	 <45DEF5EE.4030002@student.ltu.se>	 <d120d5000702230657s1860efb3o6986277901f13d03@mail.gmail.com>	 <45DF1165.2080003@student.ltu.se>	 <d120d5000702230905r6b50a1bbm3b71551f855cdf01@mail.gmail.com>	 <45DF2F57.2080309@student.ltu.se> <d120d5000702231037q511f8073n47beed320f097458@mail.gmail.com>
In-Reply-To: <d120d5000702231037q511f8073n47beed320f097458@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On 2/23/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>> Dmitry Torokhov wrote:
>> > I was not talking about name (I hate BITWRAP) but behavior.
>> Oh, my bad :)
>> >
>> >> but mainly since it only enables wrapping of the long-type.
>> >
>> > I'd provde BIT and separate LLBIT for ones who really need long long.
>> > People who intereseted in smaller than BITS_PER_LONG bitmaps shoud use
>> > your proposal - BIT(x % DESIRED_WITH) and BIT should do modulo
>> > BITS_PER_LONG internally.
>> I agree that _if_ there is a "BITWRAP" then it should be long, but I
>> don't see the reason for it to be in bitops.h when it is only input.h
>> that uses it. + I find it different with BIT since it works as well with
>> 'char' as 'long'.
>> Also, I think it would be best if the name indicated it is a 'long'.
>>
>> Am a little bit curious why you would like it in bitops.h, but won't
>> complain if you do (think you have noticed my view of it ;))
>>
>
> Hm, I thought as was clear, but apparently I messed up explaining my 
> position:
>
> 1. I don't like BITWRAP name at all and I don't want anything like
> that near input code. I think BIT is just fine.
Oh, I think I understand now. So the (in input.h):
#undef BIT
#define BIT(...
business is what you want to do? Well, that I will not object to. Your 
patch with:
+#define BIT(nr)        (1UL << (nr))
+#define LLBIT(nr) (1ULL << (nr))
+#define BITWRAP(nr)    (1UL << ((nr) % BITS_PER_LONG))
in bitops.h made me believe the #undef in input.h was just a temporarily 
thing.
>
> 2. I don't want to use BIT(x % BITS_PER_BITLONG) as it will
> significantly litter code in the input drivers. You want see whta bits
> you are actually setting behind all these "% BITS_PER_BITLONG".
As I said before, I thought it should be defined as BITSWAP (or 
whatever) in input.h and then there is no more "% BITS_PER_LONG" litter. 
But redefining BIT seems like an equally good idea;
+ eas(y/ier) to understand and simple to implement
- another definition of BIT.
>
> 3. I think most of users could use input's implementation of BIT,
> possibly using BIT(x % BM_WIDTH) format to further limit width of the
> bitmap if needed.
Agreed.
>
> 4. LLBIT should be provided to users who really want long long.
Agreed. (As in the case of "BIT(x) (0x800...00ULL >> (x)) )

Richard Knutsson

