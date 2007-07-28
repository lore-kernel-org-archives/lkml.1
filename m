Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbXG1VGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbXG1VGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbXG1VGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 17:06:10 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:51674
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXG1VGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 17:06:09 -0400
Date: Sat, 28 Jul 2007 14:03:01 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Rene Herman <rene.herman@gmail.com>, Daniel Hazelton <dhazelton@enter.net>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
In-Reply-To: <20070728122139.3c7f4290@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0707281400580.32476@asgard.lang.hm>
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
 <20070727030040.0ea97ff7.akpm@linux-foundation.org> <1185531918.8799.17.camel@Homer.simpson.net>
 <200707271345.55187.dhazelton@enter.net> <46AA3680.4010508@gmail.com>
 <Pine.LNX.4.64.0707271239300.26221@asgard.lang.hm> <46AAEDEB.7040003@gmail.com>
 <Pine.LNX.4.64.0707280138370.32476@asgard.lang.hm> <46AB166A.2000300@gmail.com>
 <20070728122139.3c7f4290@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007, Alan Cox wrote:

>> It is. Prefetched pages can be dropped on the floor without additional I/O.
>
> Which is essentially free for most cases. In addition your disk access
> may well have been in idle time (and should be for this sort of stuff)
> and if it was in the same chunk as something nearby was effectively free
> anyway.

as I understand it the swap-prefetch only kicks in if the device is idle

> Actual physical disk ops are precious resource and anything that mostly
> reduces the number will be a win - not to stay swap prefetch is the right
> answer but accidentally or otherwise there are good reasons it may happen
> to help.
>
> Bigger more linear chunks of writeout/readin is much more important I
> suspect than swap prefetching.

I'm sure this is true while you are doing the swapout or swapin and the 
system is waiting for it. but with prefetch you may be able to avoid doing 
the swapin at a time when the system is waiting for it by doing it at a 
time when the system is otherwise idle.

David Lang
