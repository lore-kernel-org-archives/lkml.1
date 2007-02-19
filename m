Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXBSL4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXBSL4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXBSL4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:56:54 -0500
Received: from javad.com ([216.122.176.236]:1846 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbXBSL4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:56:53 -0500
From: Sergei Organov <osv@javad.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?utf-8?B?Si5BLiBN?= =?utf-8?B?YWdhbGzDg8ODw4PDgsKzbg==?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <7Mj5f-3oz-21@gated-at.bofh.it> <7MktH-5EW-35@gated-at.bofh.it>
	<7Mmvy-vj-17@gated-at.bofh.it> <7MnBC-2fk-13@gated-at.bofh.it>
	<7MoQx-4p8-11@gated-at.bofh.it> <7MpjE-50z-7@gated-at.bofh.it>
	<7MpCS-5Fe-9@gated-at.bofh.it> <7MDd7-17w-1@gated-at.bofh.it>
	<7MGkB-62k-31@gated-at.bofh.it> <7NHoe-2Mb-37@gated-at.bofh.it>
	<7NMe9-1ZN-7@gated-at.bofh.it> <7Oagl-6bO-1@gated-at.bofh.it>
	<7ObvW-89N-23@gated-at.bofh.it> <7Oc8t-NS-1@gated-at.bofh.it>
	<E1HHmuB-0001lW-E1@be1.lrz> <874ppmjqko.fsf@javad.com>
	<Pine.LNX.4.58.0702161505460.2481@be1.lrz>
Date: Mon, 19 Feb 2007 14:56:26 +0300
Message-ID: <87tzxigy39.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:
> On Fri, 16 Feb 2007, Sergei Organov wrote:
>> Bodo Eggert <7eggert@gmx.de> writes:
>> > Sergei Organov <osv@javad.com> wrote:
>> >> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
[...]
>> If we start talking about the C language, my opinion is that it's C
>> problem that it allows numeric comparison of "char" variables at
>> all. If one actually needs to compare alphabetic characters numerically,
>> he should first cast to required integer type.
>
> Char values are indexes in a character set. Taking the difference of
> indexes is legal. Other languages have ord('x'), but it's only an
> expensive typecast (byte('x') does exactly the same thing).

Why this typecast should be expensive? Is

   char c1, c2;
   ...
   if((unsigned char)c1 < (unsigned char)c2)

any more expensive than if(c1 < c2)?

[...]

>> Comparison of characters being numeric is not a very good property of
>> the C language.
>
> NACK, as above

The point was not to entirely disable it or to make it any more
expensive, but to somehow force programmer to be explicit that he indeed
needs numeric comparison of characters' indexes. Well, I do realize that
the above is not in the C "spirit" that is to allow implicit conversions
almost everywhere.

>> > I repeat: Thanks to using signed chars, the programs only
>> > work /by/ /accident/! Promoting the use of signed char strings is promoting
>> > bugs and endangering the stability of all our systems. You should stop this
>> > bullshit now, instead of increasing the pile.
>> 
>> Where did you see I promoted using of "singed char strings"?!
>
> char strings are often signed char strings, only using unsigned char 
> prevents this in a portable way. If you care about ordinal values of
> your strings, use unsigned.

It means that (as I don't want to change the type of my
strings/characters in case I suddenly start to care about ordinal values
of the characters) I must always use "unsigned char" for storing
characters in practice. Right?

There are at least three problems then:

1. The type of "abc" remains "char*", so effectively I'll have two
   different representations of strings.

2. I can't mix two different representations of strings in C without
   compromising type safety. In C, the type for characters is "char",
   that by definition is different type than "unsigned char".

3. As I now represent characters by unsigned tiny integers, I loose
   distinct type for unsigned tiny integers. Effectively this brings me
   back in time to the old days when C didn't have distinct type for
   signed tiny integers.

Therefore, your "solution" to one problem creates a bunch of
others. Worse yet, you in fact don't solve initial problem of comparing
strings. Take, for example, KOI8-R encoding. Comparing characters from
this encoding using "unsigned char" representation of character indexes
makes no more sense than comparing "signed char" representations, as
both comparisons will bring meaningless results, due to the fact that
the order of (some of) the characters in the table doesn't match their
alphabetical order.

>> If you don't like the fact that in C language characters are "char",
>> strings are "char*", and the sign of char is implementation-defined,
>> please argue with the C committee, not with me.
>> 
>> Or use -funsigned-char to get dialect of C that fits your requirements
>> better.
>
> If you restrict yourself to a specific C compiler, you are doomed, and 
> that's not a good start.

Isn't it you who insists that "char" should always be unsigned? It's
your problem then to use compiler that understands those imaginary
language that meets the requirement.

-- Sergei.
