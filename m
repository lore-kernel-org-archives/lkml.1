Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbXCUPui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbXCUPui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932529AbXCUPui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:50:38 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:10040 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbXCUPuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:50:37 -0400
Message-ID: <46015442.9020008@sciensis.com>
Date: Wed, 21 Mar 2007 17:50:26 +0200
From: Tasos Parisinos <t.parisinos@sciensis.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
Cc: Francois Romieu <romieu@fr.zoreil.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel  
                   version 2.6.20.1)
References: <45FEB8B7.7020200@sciensis.com>    <20070320004001.GA11601@electric-eye.fr.zoreil.com>    <000601c76af9$a0ce3ce0$0864a8c0@scs1>    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>    <000e01c76b99$769cbbe0$0864a8c0@scs1>    <3118.81.207.0.53.1174480598.squirrel@secure.samage.net>    <46012E1A.3030309@sciensis.com>    <1860.81.207.0.53.1174485549.squirrel@secure.samage.net>    <460141B4.1080109@sciensis.com> <3079.81.207.0.53.1174489854.squirrel@secure.samage.net>
In-Reply-To: <3079.81.207.0.53.1174489854.squirrel@secure.samage.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> I agree that you have no more security that using symmetric
>> but we believe you have lower costs, simpler key management
>> (which is a big headache alone), tougher to break through
>> (not unbreakable) and more centralization
>>     
>
> It depends a bit on who you want to give control over what can and what
> can't be loaded whether centralization is an advantage or not. It might
> be a bit easier and simpler for the vendor, but if users have control
> over their hardware and thus the keys, it doesn't make any difference.
> Even for the vendor it isn't very hard to keep a database with all keys
> and signing modules with the right key when needed.
>
> I don't see where the lower cost or the increased toughness comes from.
> Don't forget that you need to protect the stored public key against
> modification as well (As well as the boot loader).
>
>   
We developed this for an embedded device that runs Linux in which
it is crucial to reach the highest point of security possible
having in mind previous experience on signed executable code
developing under WindowsCE. The end user has nothing to do with the 
system, no logons

A malicious person may want to alter code on the detachable (and unsafe) 
file system.
Lots of stuff including the kernel will be in a trapped casing (opening, 
probing it, power
analyzing it, heating it etc will result in system suicide and erasure)

If one alters one device then he can go on and play with it at home
But if one finds the key that authenticates the executable code it will 
be possible to
attack and tamper the non-system software on some of the networked devices

That is why we can't use symmetric, the risk is a lot greater there. And 
of course
we cant have one key per device (maybe thousands)
>> As for modprobe u are right but we also need to check (apart
>> from kernel modules) the executables and libraries in the
>> usage scenario.
>>     
>
> What about bytecode programs, self modifying software and mmap?
> One exploitable bug in any program renders all this checking void.
>
> But even then you can move all the checking to a userspace helper program.
> (Which can be in initramfs, glued to the kernel binary.)
>
>   
Of course we are talking about a restricted execution enviroment, no 
user logons
the system runs what it is supposed to run, and only that

If we where to use a userland program then we would propably have to 
physically
secure the whole filesystem, and that is difficult, costs more, and it 
is cumbersome
(difficult to update)
>> About time:
>> In my pc system running 2.6.20.3 (2.66 GHz P4, 1G mem) the computation of
>> modular exponentiation of 1Kbit (with a 32bit exponent all bits set and
>> a 1024 bit key)
>> took almost 3ms. That's the time needed to check the signature of any
>> code loaded
>> in ram using this module, after having it hashed (sha1) and signature
>> extracted from elf.
>>     
>
> Time was never the problem, the extra code bloat and complexity is.
> (Though if you're going to check all binaries it probably is.)
>
> Greetings,
>
> Indan
>
>
>   
You are not going to check all at once but only on load. I tell you 
again this is
not going to be running as a web server, but in a restricted environment

As for the code bloat and complexity... well you know its up to u to use 
it or leave it
dont include where you don't need it.
I mean we created for our specific use, other may want to use it to 
(maybe for
the same reasons, who knows) why not make it available? Isn't that what 
open source
is about?

And on the bottom line, why not have a module and functionality that Linux
competitors provide and advertise?

Best Regards
Tasos Parisinos
-


