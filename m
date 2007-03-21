Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbXCUN7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbXCUN7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXCUN7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:59:19 -0400
Received: from neon.samage.net ([83.149.67.130]:41768 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXCUN7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:59:18 -0400
Message-ID: <1860.81.207.0.53.1174485549.squirrel@secure.samage.net>
In-Reply-To: <46012E1A.3030309@sciensis.com>
References: <45FEB8B7.7020200@sciensis.com>
    <20070320004001.GA11601@electric-eye.fr.zoreil.com>
    <000601c76af9$a0ce3ce0$0864a8c0@scs1>
    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>
    <000e01c76b99$769cbbe0$0864a8c0@scs1>
    <3118.81.207.0.53.1174480598.squirrel@secure.samage.net>
    <46012E1A.3030309@sciensis.com>
Date: Wed, 21 Mar 2007 14:59:09 +0100 (CET)
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel     
           version 2.6.20.1)
From: "Indan Zupancic" <indan@nul.nu>
To: "Tasos Parisinos" <t.parisinos@sciensis.com>
Cc: "Francois Romieu" <romieu@fr.zoreil.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.3
X-Scan-Signature: 3ced5df4177ef3a93a84b902ce7c160e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 21, 2007 14:07, Tasos Parisinos wrote:
>
>> On Wed, March 21, 2007 10:15, Tasos Parisinos wrote:
>>
>>> Protecting a TripleDES key in high security standards is not as
>>> simple as making the kernel read
>>> protected, you need a whole lot and
>>> that also means hardware (cryptomemories e.t.c)
>>> So you forget about all this overhead when you use assymetric
>>>
>>
>> Ah, you're talking about fishing the key out of RAM here, right?
>> My point stays the same for that: If you can't read protect the
>> kernel RAM, small chance you can write protect it. And then they
>> can just bypass all signature checking you put in it anyway.
>>
>
> How can one tamper (write) the kernel memory of a booted and running kernel
> without using an exploitable bug?
>
> I mean, you can't mess with the bzImage on flash, the secure bootloader
> boots it without
> letting someone alter the (non crypto-) memory while loading the bzImage
> on it, and then
> no-one can run something that will tamper the system or write anywhere
> on kernel memory
> without exploiting a bug
>
> I mean, am i missing something here?

Depends on what you consider an exploitable bug. Does getting root access count?
If not, then you must make very sure that all possible ways to modify kernel
memory from userspace are thwarted (I don't know what those are, hopefully
loading modules is the only one, but maybe there are smart other ways).

Assuming one can't write kernel memory, it's also safe to assume kernel memory
can be protected against reads (else the whole keys infrastructure is useless).

But instead of only reading the bus traffic also modifying it doesn't seem so
far fetched to me. That modification can be reduced to swapping one bit which
tells whether the modules being loaded has a valid signature or not.
Timing it might be tricky, but that can be automated.

When someone has the hardware in his hands and really want to exploit it, you
lose no matter what you do. At best you can make it harder and more expensive.

In the end my point is that you might think that you can get away with less
security when using RSA, but perhaps in reality you don't. At least when using
symmetric key encryption you're forced to secure the whole thing more.

So design it for symmetric keys. If it turns out that using asymmetric keys is
more practical for whatever reason, fine, use those. But they won't give you
added security.

Greetings,

Indan


P.S. The whole argument of secure bootloader checks the kernel can be
extrapolated to a secure kernel checking a user space program. Why not
letting the kernel check the signature of a monolithic modprobe program,
and let it do all the (RSA) checking. The expected hash of the modprobe
program can be hardcoded in the kernel.


