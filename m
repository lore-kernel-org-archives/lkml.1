Return-Path: <linux-kernel-owner+w=401wt.eu-S1762638AbYJJVWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638AbYJJVWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759310AbYJJVWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:22:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbYJJVWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:22:17 -0400
Message-ID: <48EFC775.9090900@zytor.com>
Date: Fri, 10 Oct 2008 14:21:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #1
References: <20081009234705.GA20540@elte.hu>  <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org>  <20081010152631.GB26231@elte.hu> <20081010155830.GA4767@elte.hu> <19f34abd0810101339x66afc6d3mb6efa1a52e186816@mail.gmail.com> <48EFBE65.60505@zytor.com> <alpine.LFD.2.00.0810101358480.3503@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810101358480.3503@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Yeah. If I recall the namespace rules correctly, you have to have a 
> underscore followed by another underscore or an upper-case letter. Those 
> cannot even be used for local variables by a conforming program.
> 
> Single-underscore + lower-case letter is only reserved as an external 
> identifier. I _think_.

Strictly speaking, they are "reserved for identifiers with file scope in 
both identifier and tag space" (POSIX.1-2004, xsi § 2.2.2, lines 718-).

> So a conforming program could still do
> 
> 	int main(int argc, char **argv)
> 	{
> 		int _asm_x86_types_h = 1;
> 		return _asm_x86_types_h;
> 	}
> 
> and I _think_ it should be ok.

Correct.

> So a system macro definition that could mess with something (admittedly 
> crazy as that) has to be either double underscores or underscore + 
> uppercase, so as long as the prefix is "_ASM" (or _LINUX), we're ok.
> 
> Double underscores in the _middle_ of the identifiers are a non-issue, and 
> are just ugly.

Double underscores when used in external identifiers (not an issue here) 
can conflict with some C++ mangling schemes, in particular the old 
Cfront scheme (which had to be compatible with a standard C compiler.) 
gcc seems to use another scheme, but it doesn't either appear to include 
any non-C characters, which means it's at least theoretically possible 
to step on its toes.

>> That being said, I don't personally like the double underscores.
> 
> I agree, inside the identifier in particular they do seem pointless. At 
> the beginning, they are useful for things like __i386__ or __x86, where 
> you need the double underscore because 'i' is lower-case.
> 
> Or maybe I mis-remember the name space rules.

No, you're right on track.

There is an additional rule, which is _de_facto_ since it is out of 
scope for the standards: identifiers of the form __foo__ (double 
underscores at the start *and* end) are often considered reserved for 
the *compiler*.

	-hpa
