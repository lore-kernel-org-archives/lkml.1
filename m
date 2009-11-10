Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZKJUcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZKJUcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbZKJUcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:32:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbZKJUcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:32:10 -0500
Message-ID: <4AF9CC1E.2050700@zytor.com>
Date: Tue, 10 Nov 2009 12:25:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091108200852.7f2cf092@lxorguk.ukuu.org.uk> <20091110052711.GA15338@1wt.eu> <4AF9020C.90108@zytor.com> <4AF9435F.2070103@redhat.com> <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu>
In-Reply-To: <20091110201602.GA26633@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 12:16 PM, Willy Tarreau wrote:
> 
> Indeed, but there is a difference between [cmpxchg, bswap, cmov, nopl]
> on one side and [sse*] on the other : distros are built assuming the
> former are always available while they are not always. And the distro
> which make the difference have to provide an dedicated build for earlier
> systems just for compatibility. SSE*, 3dnow* etc... are only used by a
> handful of media players/converters/encoders which are able to detect
> themselves what to use and already have the necessary fallbacks because
> these instruction sets vary too much between processors and vendors.
> 

That is increasingly not true since gcc is now doing autovectorization.

> One could argue that cmpxchg/bswap/xadd are supported by 486 and that
> implementing them for 386 is almost useless now (though it costs almost
> nothing to provide them, I did a few years ago). 
> 
> CMOV/NOPL are rarely used, thus have no reason to cause a massive
> performance drop, but are frequent enough (at least cmov) for almost
> any program to have at least one or two inside, making it incompatible
> with a given processor, and are almost obvious to implement too.

I could 970 cmovs in libc out of 322660 instructions.  That is one in
333 instruction.  In other words, a trap-and-emulate of some 500 cycles
would add some two cycles *per instruction* during execution -- hardly
an insignificant number.  All in all, any of this is really only useful
as a limp.

> SSE*/3dnow* would be much much harder and would only serve very few
> programs, and serve them badly because when they're used, it would
> be intensive.
> 
> I personally am not against being able to emulate every optional
> instruction, quite the opposite instead. It's just that if in order
> to do this, we add cost to the other obvious ones, we lose what we
> expected to win (simplicity and efficiency).

I don't see any particular subset as being more obvious than the other,
with the *possible* exception of NOPL, simply because NOPL was
undocumented for so long.

	-hpa
