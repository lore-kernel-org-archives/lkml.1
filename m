Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbXBPOw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbXBPOw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXBPOw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:52:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56062 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbXBPOw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:52:26 -0500
Date: Fri, 16 Feb 2007 15:51:48 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Sergei Organov <osv@javad.com>
cc: 7eggert@gmx.de, Linus Torvalds <torvalds@linux-foundation.org>,
       "J.A. =?utf-8?B?TWFn?= =?utf-8?B?YWxsw4PDg8ODw4LCs24=?=" 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <874ppmjqko.fsf@javad.com>
Message-ID: <Pine.LNX.4.58.0702161505460.2481@be1.lrz>
References: <7Mj5f-3oz-21@gated-at.bofh.it> <7MktH-5EW-35@gated-at.bofh.it>
 <7Mmvy-vj-17@gated-at.bofh.it> <7MnBC-2fk-13@gated-at.bofh.it>
 <7MoQx-4p8-11@gated-at.bofh.it> <7MpjE-50z-7@gated-at.bofh.it>
 <7MpCS-5Fe-9@gated-at.bofh.it> <7MDd7-17w-1@gated-at.bofh.it>
 <7MGkB-62k-31@gated-at.bofh.it> <7NHoe-2Mb-37@gated-at.bofh.it>
 <7NMe9-1ZN-7@gated-at.bofh.it> <7Oagl-6bO-1@gated-at.bofh.it>
 <7ObvW-89N-23@gated-at.bofh.it> <7Oc8t-NS-1@gated-at.bofh.it>
 <E1HHmuB-0001lW-E1@be1.lrz> <874ppmjqko.fsf@javad.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX19OplqQGWLMa1KMk0OR4bQwLcAgUXHGcRCcOWNRYv/H1/f1sBRj1KjdukG0Wc5zt7aBhXEB0V5q6Hps4LY6nP02IG8bJ6tciCwxxGav0FPzuA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Sergei Organov wrote:
> Bodo Eggert <7eggert@gmx.de> writes:
> > Sergei Organov <osv@javad.com> wrote:
> >> Linus Torvalds <torvalds@linux-foundation.org> writes:

> [...]
> > Using signed chars for strings is wrong in most countries on earth. It was
> > wrong when the first IBM PC came out in 1981, and creating a compiler in
> > 1987 defaulting to signed char is a sure sign of originating from an
> > isolated country and knowing nothing about this planet.
> 
> Maybe I'm wrong, but wasn't it the case that C had no "signed char" type
> that time, so "char" had to be abused for the "tiny signed integer"?

Mentioning tha availability of unsigned char was a change in K&R's 
book "The C programming Language" from 1987 to 1988:

"For some time, type unsigned char has been available. The standard 
introduces the signed keyword to make signedness explicit for char and 
other integral objects."

So if there was no "signed char" before, the blame passes on to those who
didn't introduce it alongside "unsigned char".

> > Using signed chars in comparisons is especially wrong, and casting
> > each char to unsigned before comparing them is likely to be
> > forgotten.
> 
> If we start talking about the C language, my opinion is that it's C
> problem that it allows numeric comparison of "char" variables at
> all. If one actually needs to compare alphabetic characters numerically,
> he should first cast to required integer type.

Char values are indexes in a character set. Taking the difference of
indexes is legal. Other languages have ord('x'), but it's only an
expensive typecast (byte('x') does exactly the same thing).

> > Unsigned character strings are useless because there is no such thing
> > as char(-23), and if these strings weren't casted to signed inside all
> > IO functions, they wouldn't work correctly.
> 
> Didn't you swap "signed" and "unsigned" by mistake in this phrase? Or
> are you indeed think that using "unsigned char*" for strings is useless?

ACK

> > Only because many programmers don't compare chars, most programs will
> > work outside the USA.
> 
> Comparison of characters being numeric is not a very good property of
> the C language.

NACK, as above

> > I repeat: Thanks to using signed chars, the programs only
> > work /by/ /accident/! Promoting the use of signed char strings is promoting
> > bugs and endangering the stability of all our systems. You should stop this
> > bullshit now, instead of increasing the pile.
> 
> Where did you see I promoted using of "singed char strings"?!

char strings are often signed char strings, only using unsigned char 
prevents this in a portable way. If you care about ordinal values of
your strings, use unsigned.

> If you
> don't like the fact that in C language characters are "char", strings
> are "char*", and the sign of char is implementation-defined, please
> argue with the C committee, not with me.
> 
> Or use -funsigned-char to get dialect of C that fits your requirements
> better.

If you restrict yourself to a specific C compiler, you are doomed, and 
that's not a good start.
-- 
What about those red balls they have on car aerials so you can spot your car
in a park. I think all cars should have them!
	-- Homer Simpson
