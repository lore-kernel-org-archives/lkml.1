Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbXCUNBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbXCUNBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXCUNBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:01:04 -0400
Received: from neon.samage.net ([83.149.67.130]:49790 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbXCUNBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:01:02 -0400
Message-ID: <2565.81.207.0.53.1174482054.squirrel@secure.samage.net>
In-Reply-To: <4601265F.4030907@sciensis.com>
References: <45FEB8B7.7020200@sciensis.com>
    <20070320004001.GA11601@electric-eye.fr.zoreil.com>
    <000601c76af9$a0ce3ce0$0864a8c0@scs1>
    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>
    <000e01c76b99$769cbbe0$0864a8c0@scs1>
    <4040.81.207.0.53.1174478934.squirrel@secure.samage.net>
    <4601265F.4030907@sciensis.com>
Date: Wed, 21 Mar 2007 14:00:54 +0100 (CET)
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
X-Scan-Signature: 40b81d93390a3dca3ee709c9c36a2335
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 21, 2007 13:34, Tasos Parisinos wrote:
> Indan Zupancic wrote:
>>> Protecting a TripleDES key in high security standards is not as simple as making the kernel
>>> read protected, you need a whole lot and that also means hardware (cryptomemories e.t.c)
>>> So you forget about all this overhead when you use assymetric
>>>
>>
>> You need to protect your kernel binary already, adding a key to that doesn't increase the
>> complexity or safety requirements, so all that hardware safety is already in place.
>> (And I'd use AES instead of TripleDES.)
>>
>>
> Well, lets assume you have a trapped casing that prevents a flash chip
> (which holds
> the kernel) from being tamperred. Then you have write protection of the
> bzimage

Not sure what you mean with "trapped casing", I thought we were talking about
the security from the software side, not the physical one?

> When this thing will run, and it will need to check an executable using
> AES for example
> (which is a lot better than TripleDes, i agree) then the key will be for
> a time window
> onto buses and memory. Then it can be probed and retrieved by someone.
>
> Then you need cryptomemory
>
> While with asymmetric you don't. There are no high-risk data anywhere,
> only a public
> key

Our emails crossed eachother, but if you read kernel RAM you can in general
also modify it, in which case the signature checking can be disabled.

The moment someone with advanced hardware cracking knowledge puts his hands
on your stuff you're screwed anyway. If you don't believe me, try getting
hard security guarantees from hardware vendors. ;-)

> Of course if you have other data that need to be secured, and you
> already run
> on a trusted platform, including all these crypto hardware modules, then
> you can use
> a symmetric scheme

How do you want to get the thing secure with asymmetric encryption when you
can't protect the kernel? That "other data" is your kernel binary, on flash
or in RAM. So if you can't protect that adequately, then who are you kidding
with signed modules? And the moment you've covered that, you can as well use
symmetric encryption...

Greetings,

Indan


