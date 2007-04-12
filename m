Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbXDLUpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbXDLUpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXDLUpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:45:01 -0400
Received: from neon.samage.net ([85.17.153.66]:38312 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbXDLUo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:44:59 -0400
Message-ID: <2293.81.207.0.53.1176410694.squirrel@secure.samage.net>
In-Reply-To: <a781481a0704121257v19c82552gac7f60784c7bafa@mail.gmail.com>
References: <4610D25F.7080005@ceid.upatras.gr>
    <009501c77c22$2b4960f0$0864a8c0@scs1>
    <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
    <000401c77cdd$5ef79910$0864a8c0@scs1>
    <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
    <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
    <a781481a0704120720y5772cd56y75fff466551a2fda@mail.gmail.com>
    <3785.81.207.0.53.1176390072.squirrel@secure.samage.net>
    <a781481a0704121138x2ecfa5b0lb791dc5680f08515@mail.gmail.com>
    <1574.81.207.0.53.1176404759.squirrel@secure.samage.net>
    <a781481a0704121257v19c82552gac7f60784c7bafa@mail.gmail.com>
Date: Thu, 12 Apr 2007 22:44:54 +0200 (CEST)
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
From: "Indan Zupancic" <indan@nul.nu>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Tasos Parisinos" <t.parisinos@sciensis.com>,
       "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 74bd734068bee68206891dc8710ce62a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, April 12, 2007 21:57, Satyam Sharma wrote:
> Of course, I'd rather code to the PKCS#1 RSA Cryptography Standard
> than an entry-level Wikipedia page :-) Timing attacks are particularly
> problematic on smart cards (too slow, and with predictable operation
> times, if not using constant-time crypto implementations) and not
> really worthwhile in practice on any other platform where there's
> enough noise around to make accurate timing difficult

Noise can be filtered out, and combined attacks can give enough information.
(E.g. throw in power usage or other measurements.) There are ways to add
noise to the timing, but still using those optimisations. The point was
that they add extra code and complexity.

(Personally I think RSA-like asymmetric encryption has so many, often
subtle problems, with complex, hard to get secure implementations, that
it's something I'd avoid using as much as possible. Unfortunately there's
not much alternative.)


> constant-time crypto implementations do take care of
> them, though I agree the GPG code too lacks that.

That's because for side-channel attacks you need physical access to the
hardware, something for most machines means security is breached anyway.
But when this code is going to be used to sign things by embedded devices
(with a local, secret key), it can be important.

For checking signatures the key is known and all this doesn't matter, but
we're talking about a common implementation. It are things to keep in mind.


>> Not if they go the other way round and strip everything except DSA functionality.
>> The question is, is an MPI library wanted, or do people just want RSA or DSA?
>
> I do agree that only those parts of an MPI lib that are really needed
> by any users must be included. But then we don't want to end up in a
> situation where we merge such a small MPI library that code and/or
> functionality are being sadly duplicated across users who want
> different asymmetric cryptosystems (note the 2 DLMs in mainline, for
> example). When we want to support both RSA and DSA, which require a
> diverse set of MPI operations and primitives, I don't see how we can
> still continue to retain the simplistic and "spartan" RSA-only MPI lib
> that this code provides.

We won't know until those users show themselves. Until then, we can only
speculate. Right now there is only user, with another one lurking in the
background.

Greetings,

Indan


