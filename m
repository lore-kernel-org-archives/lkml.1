Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbXCUPLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbXCUPLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbXCUPLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:11:08 -0400
Received: from neon.samage.net ([83.149.67.130]:43515 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbXCUPLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:11:06 -0400
Message-ID: <3079.81.207.0.53.1174489854.squirrel@secure.samage.net>
In-Reply-To: <460141B4.1080109@sciensis.com>
References: <45FEB8B7.7020200@sciensis.com>
    <20070320004001.GA11601@electric-eye.fr.zoreil.com>
    <000601c76af9$a0ce3ce0$0864a8c0@scs1>
    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>
    <000e01c76b99$769cbbe0$0864a8c0@scs1>
    <3118.81.207.0.53.1174480598.squirrel@secure.samage.net>
    <46012E1A.3030309@sciensis.com>
    <1860.81.207.0.53.1174485549.squirrel@secure.samage.net>
    <460141B4.1080109@sciensis.com>
Date: Wed, 21 Mar 2007 16:10:54 +0100 (CET)
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
X-Scan-Signature: efbdb1e6b7bcd6669f1cb70b651542d8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 21, 2007 15:31, Tasos Parisinos wrote:
> Indan Zupancic wrote:
>> On Wed, March 21, 2007 14:07, Tasos Parisinos wrote:
>>> How can one tamper (write) the kernel memory of a booted and running kernel
>>> without using an exploitable bug?
>>>
>>> I mean, you can't mess with the bzImage on flash, the secure bootloader
>>> boots it without
>>> letting someone alter the (non crypto-) memory while loading the bzImage
>>> on it, and then
>>> no-one can run something that will tamper the system or write anywhere
>>> on kernel memory
>>> without exploiting a bug
>>>
>>> I mean, am i missing something here?
>>>
>>
>> Depends on what you consider an exploitable bug. Does getting root access count?
>> If not, then you must make very sure that all possible ways to modify kernel
>> memory from userspace are thwarted (I don't know what those are, hopefully
>> loading modules is the only one, but maybe there are smart other ways).
>>
>> Assuming one can't write kernel memory, it's also safe to assume kernel memory
>> can be protected against reads (else the whole keys infrastructure is useless).
>>
>> But instead of only reading the bus traffic also modifying it doesn't seem so
>> far fetched to me. That modification can be reduced to swapping one bit which
>> tells whether the modules being loaded has a valid signature or not.
>> Timing it might be tricky, but that can be automated.
>>
>> When someone has the hardware in his hands and really want to exploit it, you
>> lose no matter what you do. At best you can make it harder and more expensive.
>>
>> In the end my point is that you might think that you can get away with less
>> security when using RSA, but perhaps in reality you don't. At least when using
>> symmetric key encryption you're forced to secure the whole thing more.
>>
>> So design it for symmetric keys. If it turns out that using asymmetric keys is
>> more practical for whatever reason, fine, use those. But they won't give you
>> added security.
>>
>> Greetings,
>>
>> Indan
>>
>>
>> P.S. The whole argument of secure bootloader checks the kernel can be
>> extrapolated to a secure kernel checking a user space program. Why not
>> letting the kernel check the signature of a monolithic modprobe program,
>> and let it do all the (RSA) checking. The expected hash of the modprobe
>> program can be hardcoded in the kernel.
>>
>>
>>
>>
> I agree that you have no more security that using symmetric
> but we believe you have lower costs, simpler key management
> (which is a big headache alone), tougher to break through
> (not unbreakable) and more centralization

It depends a bit on who you want to give control over what can and what
can't be loaded whether centralization is an advantage or not. It might
be a bit easier and simpler for the vendor, but if users have control
over their hardware and thus the keys, it doesn't make any difference.
Even for the vendor it isn't very hard to keep a database with all keys
and signing modules with the right key when needed.

I don't see where the lower cost or the increased toughness comes from.
Don't forget that you need to protect the stored public key against
modification as well (As well as the boot loader).

> As for modprobe u are right but we also need to check (apart
> from kernel modules) the executables and libraries in the
> usage scenario.

What about bytecode programs, self modifying software and mmap?
One exploitable bug in any program renders all this checking void.

But even then you can move all the checking to a userspace helper program.
(Which can be in initramfs, glued to the kernel binary.)

> About time:
> In my pc system running 2.6.20.3 (2.66 GHz P4, 1G mem) the computation of
> modular exponentiation of 1Kbit (with a 32bit exponent all bits set and
> a 1024 bit key)
> took almost 3ms. That's the time needed to check the signature of any
> code loaded
> in ram using this module, after having it hashed (sha1) and signature
> extracted from elf.

Time was never the problem, the extra code bloat and complexity is.
(Though if you're going to check all binaries it probably is.)

Greetings,

Indan


