Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbXBSL7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbXBSL7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932148AbXBSL7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:59:37 -0500
Received: from javad.com ([216.122.176.236]:1912 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbXBSL7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:59:37 -0500
From: Sergei Organov <osv@javad.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       =?utf-8?B?Si5BLiBNYWdhbGzDg8ODw4PDg8ODw4LCs24=?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	<874pprr5nn.fsf@javad.com>
	<Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	<87ps8end9b.fsf@javad.com>
	<84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
	<87bqjxooog.fsf@javad.com>
	<84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com>
	<87fy99n6mf.fsf@javad.com>
	<Pine.LNX.4.64.0702131513050.3604@woody.linux-foundation.org>
	<87hctnlfqz.fsf@javad.com>
	<Pine.LNX.4.64.0702150736360.20368@woody.linux-foundation.org>
	<87k5yjjlrj.fsf@javad.com>
	<Pine.LNX.4.64.0702151059090.20368@woody.linux-foundation.org>
	<45D5325A.2040502@gmail.com>
Date: Mon, 19 Feb 2007 14:58:54 +0300
Message-ID: <87mz3agxz5.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@gmail.com> writes:
[...]
> Given char's special nature, shouldn't the conclusion of this thread
> have long been simply that gcc needs -Wno-char-pointer-sign? (with
> whatever default, as far as I'm concerned).

I entirely agree that all the char business in C is messy enough to
justify separate warning switch(es) in GCC.

However, I still insist that the problem with the code:

   void foo(char *c);
   unsigned char *u;
   signed char *s;
   ...
   foo(u);
   foo(s);

is not (only) in signedness, as neither 'u' nor 's' has compatible type
with the "char*", no matter what is the sign of "char", so if one cares
about type safety he needs warnings on both invocations of foo().

-- Sergei.
