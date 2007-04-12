Return-Path: <linux-kernel-owner+w=401wt.eu-S2992531AbXDLPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992531AbXDLPBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbXDLPBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:01:18 -0400
Received: from neon.samage.net ([85.17.153.66]:46167 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbXDLPBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:01:17 -0400
Message-ID: <3785.81.207.0.53.1176390072.squirrel@secure.samage.net>
In-Reply-To: <a781481a0704120720y5772cd56y75fff466551a2fda@mail.gmail.com>
References: <4610D25F.7080005@ceid.upatras.gr>
    <4610EDF9.9000601@sciensis.com> <4616BC09.2080509@tmr.com>
    <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
    <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1>
    <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
    <000401c77cdd$5ef79910$0864a8c0@scs1>
    <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
    <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
    <a781481a0704120720y5772cd56y75fff466551a2fda@mail.gmail.com>
Date: Thu, 12 Apr 2007 17:01:12 +0200 (CEST)
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
X-Scan-Signature: d3d6c6694e059b137bd8e4e2c0542d46
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, April 12, 2007 16:20, Satyam Sharma wrote:
> Of course, once an infrastructure is indeed merged into the kernel, it
> better already have (or quickly develop) some users for itself. If it
> doesn't, it does end up as rot. If it does, that pretty much solves
> the maintenance problem there itself.

Yes, but currently those users are more or less hidden and working
independently.


> Getting specific to *this* particular case, I _can_ think of other
> users in the kernel that could gladly use general asymmetric crypto
> capabilities added to the cryptoapi -- encrypting file systems, module
> signing (as of now they've just implemented DSA directly for
> themselves, not through the cryptoapi) to name a few.

The potential for users is the bare minimum expected, next step is that
there are any and them agreeing on common implementations.


> Well, then *all* the users of the RSA cryptoapi code would end up
> duplicating the PKCS padding for themselves! (because if we don't care
> about padding in a "low-maintenance-bare-RSA-implementation", then we
> might as well not implement any RSA crypto at all :-) Also, padding
> schemes are careful cryptographic constructions -- much like ciphers
> themselves. Much thought has gone into PKCS#1 over the years (and it's
> later revisions). We wouldn't want users to re-invent some kind of
> insecure padding for themselves.
>
> The way I think about this is: (1) RSA without PKCS#1 makes no sense,
> and (2) PKCS#1 is *defined* only for RSA. Combine (1) and (2), and it
> makes *all* sense to encapsulate the two in just one module.
>
> Coming to padding standards, RSA has been around for ~20 years now,
> and only 3 PKCS#1 padding schemes were ever defined (at least AFAICR).
> That's not something that changes so frequently as to not implement it
> in the core RSA code itself, especially when the penalties of not
> doing so could be quite embarrassing indeed.

Very good points there, you're right.


> If RSA is slow, then optimizing it to make it fast (and thus have more
> impact on relative performance) should make *more* sense, shouldn't
> it? That MPI implementation is derived from GPG, which has been around
> for a decade now. I'd much rather prefer well-known and
> well-understood code that has been used, tested and maintained for a
> decade than some recent/unused contraption, thank you.

I prefer clear, simple code that is easily audited to be correct or at least
not cause problems, which is small enough to not add much bloat. I don't care
about "very slow" or merely "slow" code. RSA/DSA isn't used as a symmetric block
cipher, where it does make sense to optimize it to death.

>From the kernel's point of view it's all new and unused code, so it should be
judged by its quality, not by its heritage.

I know you didn't want to talk about the user versus kernel space question,
but I think it's a very important and interesting one. As you said, GPG is
there around for years and tested, why making a new implementation in the kernel?
Your argument holds for the whole as much as for parts of the infrastructure.


> Hmmm ... and again I'll excuse myself from the debate whether to
> *actually* merge MPI and asymmetric crypto capabilities into the
> mainline tree or not -- it's all about whether the potential users
> named earlier really want to be able to do all that stuff in-kernel or
> wouldn't mind writing userspace components for it.

And whether they can agree on a common implementation. If they all just want to do
their own thing, and not combine resources, then it doesn't make any sense to merge
anything at all, as it would be ignored anyway.

As for the userspace issue, I get the impression that they didn't consider it very
well, ignoring things like initramfs versus main filesystem and so on. It's also a
gradual thing, some things can be done best in the kernel, and others in user space.
Another alternative is to push it up into the boot loader. ;-)

Greetings,

Indan


