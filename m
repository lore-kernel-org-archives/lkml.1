Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZKJUQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZKJUQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbZKJUQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:16:30 -0500
Received: from 1wt.eu ([62.212.114.60]:50902 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979AbZKJUQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:16:30 -0500
Date: Tue, 10 Nov 2009 21:16:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110201602.GA26633@1wt.eu>
References: <20091108200852.7f2cf092@lxorguk.ukuu.org.uk> <20091110052711.GA15338@1wt.eu> <4AF9020C.90108@zytor.com> <4AF9435F.2070103@redhat.com> <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9C6AB.8080006@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 12:01:47PM -0800, H. Peter Anvin wrote:
> On 11/10/2009 11:50 AM, Avi Kivity wrote:
> >>
> >> Consider SSE3, for example.  Why should the same concept not apply to
> >> SSE3 instructions as to CMOV?
> > 
> > Because then user programs would run 20x or more slower than the user 
> > expects.  Better to terminate early (and teach userspace how to choose 
> > the instruction subset correctly).
> > 
> 
> I picked the example carefully: SSE3 is a small set of instructions
> which probably aren't used very heavily.  In that sense, it has
> *exactly* the same properties as CMOV - if you have the source, you're
> better off recompiling, but it *might* help you if you happen to only
> have a binary.
> 
> What I want people to understand is that this is a *huge* rathole, and
> it doesn't have any obvious bottom that I can see.

Indeed, but there is a difference between [cmpxchg, bswap, cmov, nopl]
on one side and [sse*] on the other : distros are built assuming the
former are always available while they are not always. And the distro
which make the difference have to provide an dedicated build for earlier
systems just for compatibility. SSE*, 3dnow* etc... are only used by a
handful of media players/converters/encoders which are able to detect
themselves what to use and already have the necessary fallbacks because
these instruction sets vary too much between processors and vendors.

One could argue that cmpxchg/bswap/xadd are supported by 486 and that
implementing them for 386 is almost useless now (though it costs almost
nothing to provide them, I did a few years ago). 

CMOV/NOPL are rarely used, thus have no reason to cause a massive
performance drop, but are frequent enough (at least cmov) for almost
any program to have at least one or two inside, making it incompatible
with a given processor, and are almost obvious to implement too.

SSE*/3dnow* would be much much harder and would only serve very few
programs, and serve them badly because when they're used, it would
be intensive.

I personally am not against being able to emulate every optional
instruction, quite the opposite instead. It's just that if in order
to do this, we add cost to the other obvious ones, we lose what we
expected to win (simplicity and efficiency).

Regards,
Willy

