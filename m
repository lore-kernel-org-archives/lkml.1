Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbYH1TTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbYH1TTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYH1TSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:18:37 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:51542 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbYH1TSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ELZp10j77WmzcZ+/fYRueRpc+7gyy30j3MlRlFTB4QX4He64zT5ExttR/0K/ekbhCv
         IJY3HVfo9huzXJHilmw/bg9MAhFhbfDgrceQ55F/dZDQnxGaGwc2Sg2feAmYbn7aLIQ0
         CPBkhGVB2rF7Ez2o+m5wZHgJb4zmBLIC38b8k=
Message-ID: <19f34abd0808281218p725184fdrd7ac655db0a20c8d@mail.gmail.com>
Date: Thu, 28 Aug 2008 21:18:33 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH] bitfields API
Cc: "David Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20080828190533.GA22416@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080828183223.GA30781@localhost.localdomain>
	 <20080828184025.GA22165@x200.localdomain>
	 <19f34abd0808281146o7a00388eie9322ff778665961@mail.gmail.com>
	 <20080828190533.GA22416@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 9:05 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Thu, Aug 28, 2008 at 08:46:43PM +0200, Vegard Nossum wrote:
>> On Thu, Aug 28, 2008 at 8:40 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> > On Thu, Aug 28, 2008 at 08:32:23PM +0200, Vegard Nossum wrote:
>> >> How do you feel about this patch? It's all about making kmemcheck more
>> >> useful... and not much else. Does it have any chance of entering the
>> >> kernel along with kmemcheck (when/if that happens)?
>> >
>> > DEFINE_BITFIELD is horrible.
>> >
>> >> @@ -285,11 +286,12 @@ struct sk_buff {
>> >>               };
>> >>       };
>> >>       __u32                   priority;
>> >> -     __u8                    local_df:1,
>> >> +     DEFINE_BITFIELD(__u8,   flags1,
>> >> +                             local_df:1,

[...]

>> Would it help (to make this less
>> horrible) to omit the type declaration and have just the bitfield
>> members as arguments to the macro?
>
> Or you can parse instruction stream a bit more.

I think we have different opinions of what exactly constitutes "horrible" :-P

Your suggestion would have made sense if I was a company of 10
developers who could import all of valgrind source code (including
opcode decoder and instruction emulator) into the kernel. But I only
writing kmemcheck in my free time, so this will never happen. Or.. at
least I will not do it. Of course, kmemcheck, valgrind/memcheck, and
indeed the kernel itself are all open source, so anybody could do it.
And if you want to submit patches yourself, the effort will be welcome
:-)

In the mean-time, I am looking for an acceptable solution. Other
debugging features use helper annotations too. But I am pretty sure
that the immediate solution will not include parsing the instruction
stream a bit more.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
