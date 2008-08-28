Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYH1Sqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYH1Sqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYH1Sqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:46:45 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42693 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYH1Sqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FptcLo/Xl3LNWnKINR9YYZXPOebuf3wkq4mLxKShCRSI9j/4y2d4F38Iktx08DDo7c
         3MHJnQWIDIocyk2H/cNRmDQZS4NBO5eTvFxwKUhO0ET4uXxz3Lva23D9SpO+sCBhGrkl
         ilPWst36Gwg12pn0ODEuoCQnZI6dqnbcPMUYU=
Message-ID: <19f34abd0808281146o7a00388eie9322ff778665961@mail.gmail.com>
Date: Thu, 28 Aug 2008 20:46:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH] bitfields API
Cc: "David Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20080828184025.GA22165@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080828183223.GA30781@localhost.localdomain>
	 <20080828184025.GA22165@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 8:40 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Thu, Aug 28, 2008 at 08:32:23PM +0200, Vegard Nossum wrote:
>> How do you feel about this patch? It's all about making kmemcheck more
>> useful... and not much else. Does it have any chance of entering the
>> kernel along with kmemcheck (when/if that happens)?
>
> DEFINE_BITFIELD is horrible.
>
>> @@ -285,11 +286,12 @@ struct sk_buff {
>>               };
>>       };
>>       __u32                   priority;
>> -     __u8                    local_df:1,
>> +     DEFINE_BITFIELD(__u8,   flags1,
>> +                             local_df:1,
>>                               cloned:1,
>>                               ip_summed:2,
>>                               nohdr:1,
>> -                             nfctinfo:3;
>> +                             nfctinfo:3);
>>       __u8                    pkt_type:3,
>>                               fclone:2,
>>                               ipvs_property:1,

Ok, that's constructive :-P

Can we skip the type and always assume that it should be __u8/uint8_t?
I read somewhere that bitfields should anyway always be 1 byte wide if
the bitfield should be "portable". Would it help (to make this less
horrible) to omit the type declaration and have just the bitfield
members as arguments to the macro?

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
