Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbXCUQgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbXCUQgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932987AbXCUQgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:36:50 -0400
Received: from neon.samage.net ([83.149.67.130]:36482 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017AbXCUQgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:36:49 -0400
Message-ID: <3564.81.207.0.53.1174495003.squirrel@secure.samage.net>
In-Reply-To: <46015442.9020008@sciensis.com>
References: <45FEB8B7.7020200@sciensis.com>
    <20070320004001.GA11601@electric-eye.fr.zoreil.com>
    <000601c76af9$a0ce3ce0$0864a8c0@scs1>
    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>
    <000e01c76b99$769cbbe0$0864a8c0@scs1>
    <3118.81.207.0.53.1174480598.squirrel@secure.samage.net>
    <46012E1A.3030309@sciensis.com>
    <1860.81.207.0.53.1174485549.squirrel@secure.samage.net>
    <460141B4.1080109@sciensis.com>
    <3079.81.207.0.53.1174489854.squirrel@secure.samage.net>
    <46015442.9020008@sciensis.com>
Date: Wed, 21 Mar 2007 17:36:43 +0100 (CET)
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
X-Scan-Signature: ee739817b6cd2655ac6326818c89325b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 21, 2007 16:50, Tasos Parisinos wrote:
> A malicious person may want to alter code on the detachable (and unsafe)
> file system.
> Lots of stuff including the kernel will be in a trapped casing (opening,
> probing it, power
> analyzing it, heating it etc will result in system suicide and erasure)

What happens ift he whole thing is cooled so much that it stops functioning?

What if the part that is supposed to do the system suicide is shot away?

There are all kind of interesting ways of bypassing such protections, I
wouldn't count on covering all of them (which doesn't mean you shouldn't try).


> If one alters one device then he can go on and play with it at home
> But if one finds the key that authenticates the executable code it will
> be possible to
> attack and tamper the non-system software on some of the networked devices
>
> That is why we can't use symmetric, the risk is a lot greater there. And
> of course
> we cant have one key per device (maybe thousands)

How many devices there are doesn't matter, a RSA key is ten times as big
as an AES key anyway. But maybe you've a more complex system where having
multiple keys indeed isn't possible (e.g. the filesystem is shared between
multiple devices).


>>> As for modprobe u are right but we also need to check (apart
>>> from kernel modules) the executables and libraries in the
>>> usage scenario.
>>>
>>
>> What about bytecode programs, self modifying software and mmap?
>> One exploitable bug in any program renders all this checking void.
>>
>> But even then you can move all the checking to a userspace helper program.
>> (Which can be in initramfs, glued to the kernel binary.)
>>
>>
> Of course we are talking about a restricted execution enviroment, no
> user logons
> the system runs what it is supposed to run, and only that
>
> If we where to use a userland program then we would propably have to
> physically
> secure the whole filesystem, and that is difficult, costs more, and it
> is cumbersome
> (difficult to update)

Not if you put it in initramfs included in the kernel binary.
Depending on how much room you have on the secured flash area,
you'd want to put as much as possible there anyway.


> You are not going to check all at once but only on load. I tell you
> again this is
> not going to be running as a web server, but in a restricted environment

Well, as the filesystem isn't restricted you should be prepared for anything.

Is the RAM in restricted area or not? Because if it isn't and they have
access to the bus then it can be tampered with.

> As for the code bloat and complexity... well you know its up to u to use
> it or leave it
> dont include where you don't need it.
> I mean we created for our specific use, other may want to use it to
> (maybe for
> the same reasons, who knows) why not make it available? Isn't that what
> open source
> is about?
>
> And on the bottom line, why not have a module and functionality that Linux
> competitors provide and advertise?

I've nothing against your RSA implementation, it's one of the cleaner and
smaller ones. Merging it is probably a good idea to stop others and to have
a minimalistic reference implementation.

I've problems with the assumed security it brings to many uses of it though.

Depending on the expected lifetime of your product I'd also consider using
something that can't be broken by quantum computers in the (near?) future. ;-)

Good luck,

Indan


