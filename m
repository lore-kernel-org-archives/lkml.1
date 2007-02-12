Return-Path: <linux-kernel-owner+w=401wt.eu-S964844AbXBLLNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbXBLLNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 06:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964847AbXBLLNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 06:13:00 -0500
Received: from javad.com ([216.122.176.236]:1423 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964844AbXBLLM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 06:12:59 -0500
From: Sergei Organov <osv@javad.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J.A. =?utf-8?B?TWFnYWxsw4PDgsKzbg==?=" <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
	<Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	<20070208221317.5beedaeb@werewolf-wl>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
Date: Mon, 12 Feb 2007 14:12:28 +0300
Message-ID: <874pprr5nn.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Fri, 9 Feb 2007, Sergei Organov wrote:
>> 
>> As far as I can read the C99 standard, the "char", "signed char", and
>> "unsigned char", are all different types:
>
> Indeed. Search for "pseudo-unsigned", and you'll see more. There are 
> actually cases where "char" can act differently from _both_ "unsigned 
> char" and "signed char".
>
>> If so, then the code above is broken no matter what representation of
>> "char" is chosen for given arch, as strcmp() takes "char*" arguments,
>> that are not compatible with either "signed char*" or "unsigned char*".
>
> ..and my argument is that a warning which doesn't allow you to call 
> "strlen()" on a "unsigned char" array without triggering is a bogus 
> warning, and must be removed.

Why strlen() should be allowed to be called with an incompatible pointer
type? My point is that gcc should issue *different warning*, -- the same
warning it issues here:

$ cat incompat.c
void foo(int *p);
void boo(long *p) { foo(p); }
$ gcc -W -Wall -c incompat.c
incompat.c:2: warning: passing argument 1 of 'foo' from incompatible pointer type

Calling strlen(char*) with "unsigned char*" argument does pass argument
of incompatible pointer type due to the fact that in C "char" and
"unsigned char" are two incompatible types, and it has nothing to do
with signedness.

[...]

-- Sergei.
