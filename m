Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYH1TEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYH1TEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYH1TEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:04:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:58418 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYH1TEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w1H+QV0FZwFW64pg8dXbHaUJqw4cGlVG4VwjgINYJblZMTDE1BLjntB25Jovzalv0t
         DhQNxNGXwfNcjHiaMlx2H3XUe3w8l6QTbdq0MCPnK53vtp1HBCUgZXwPa3IhrPDFPemh
         7D5xdIe52CpRwNshyog+uX/ANBBVWECU/GyFQ=
Date: Thu, 28 Aug 2008 23:05:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bitfields API
Message-ID: <20080828190533.GA22416@x200.localdomain>
References: <20080828183223.GA30781@localhost.localdomain> <20080828184025.GA22165@x200.localdomain> <19f34abd0808281146o7a00388eie9322ff778665961@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808281146o7a00388eie9322ff778665961@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 08:46:43PM +0200, Vegard Nossum wrote:
> On Thu, Aug 28, 2008 at 8:40 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > On Thu, Aug 28, 2008 at 08:32:23PM +0200, Vegard Nossum wrote:
> >> How do you feel about this patch? It's all about making kmemcheck more
> >> useful... and not much else. Does it have any chance of entering the
> >> kernel along with kmemcheck (when/if that happens)?
> >
> > DEFINE_BITFIELD is horrible.
> >
> >> @@ -285,11 +286,12 @@ struct sk_buff {
> >>               };
> >>       };
> >>       __u32                   priority;
> >> -     __u8                    local_df:1,
> >> +     DEFINE_BITFIELD(__u8,   flags1,
> >> +                             local_df:1,
> >>                               cloned:1,
> >>                               ip_summed:2,
> >>                               nohdr:1,
> >> -                             nfctinfo:3;
> >> +                             nfctinfo:3);
> >>       __u8                    pkt_type:3,
> >>                               fclone:2,
> >>                               ipvs_property:1,
> 
> Ok, that's constructive :-P
> 
> Can we skip the type and always assume that it should be __u8/uint8_t?

Of course, no.

> I read somewhere that bitfields should anyway always be 1 byte wide if
> the bitfield should be "portable".

It should be signed int or unsigned int for maximum portability.

> Would it help (to make this less
> horrible) to omit the type declaration and have just the bitfield
> members as arguments to the macro?

Or you can parse instruction stream a bit more.

