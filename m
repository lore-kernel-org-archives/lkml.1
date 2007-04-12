Return-Path: <linux-kernel-owner+w=401wt.eu-S1751260AbXDLTGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbXDLTGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXDLTGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:06:11 -0400
Received: from neon.samage.net ([85.17.153.66]:60914 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXDLTGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:06:10 -0400
Message-ID: <1574.81.207.0.53.1176404759.squirrel@secure.samage.net>
In-Reply-To: <a781481a0704121138x2ecfa5b0lb791dc5680f08515@mail.gmail.com>
References: <4610D25F.7080005@ceid.upatras.gr>
    <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
    <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1>
    <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
    <000401c77cdd$5ef79910$0864a8c0@scs1>
    <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
    <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
    <a781481a0704120720y5772cd56y75fff466551a2fda@mail.gmail.com>
    <3785.81.207.0.53.1176390072.squirrel@secure.samage.net>
    <a781481a0704121138x2ecfa5b0lb791dc5680f08515@mail.gmail.com>
Date: Thu, 12 Apr 2007 21:05:59 +0200 (CEST)
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
X-Scan-Signature: 448baf4759cd3283a5930955cc61e1db
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, April 12, 2007 20:38, Satyam Sharma wrote:
> There are some other better reasons for the bloat in the GNU MP lib,
> though. Tasos' code uses the rsa_cipher() as a dual-purpose primitive.
> Feed it the plaintext (p), public exponent (e) and public modulus (n),
> and you get the ciphertext (c = p^e mod n). Feed it the ciphertext,
> private exponent (d) and public modulus, and you get the plaintext (p
> = c^d mod n) back. All modern RSA implementations, however, prefer
> preserving the prime numbers (p, q, and their other derivatives such
> as d mod (p-1), d mod (q-1) and inverse of q modulo p) generated at
> the time of key generation along with the private exponent as the
> complete "private key" (this is what is recommended by PKCS#1 too)
> which enables us to use the chinese remainder theorem to decrypt
> faster than simply do an (expensive) modulo exponentiation again.

Which, according to the Wikipedia page on RSA, is susceptible to timing
attacks, which requires measures to counter that (that might be needed in
Tasos' implementation too though).

Doing MPI well is already tricky. Doing it in such way that most side-channel
attacks don't work is challenging, and brings already code bloat and complexity
with it.  Doing all the previous with compact and simple code is hard. Speed is
the last thing I'm worried about.

I'd rather start with good and simple code, and speed it up without adding too
much complexity gradually, case by case.
(Though I'm not the one with any interests here, so my opinion isn't worth much.)


> Also, DSA signature generation and verification (which is what the
> modsign guys use) doesn't exactly utilize the same MPI operations as
> RSA does. If we really don't care about speed and DSA, we could strip
> that library down to the basic and RSA-only operations Tasos' code
> provides, and I'm quite sure we'd end up somewhere close to 1000 lines
> there too.

That's nice. But then you lose more or less all advantages of using an existing
implementation, don't you? Anyway, how much different would that code be from
Tasos'?

> Of course, that would then *force* other users such as modsign to
> re-implement their own library for their needs again, thus defeating
> the exercise of merging this bare-bones MPI library into the kernel in
> the first place, as you have mentioned.

Not if they go the other way round and strip everything except DSA functionality.
The question is, is an MPI library wanted, or do people just want RSA or DSA?

> Yes, that "common implementation" bit is definitely crucial, which is
> why merging a solid, feature-rich and fast MPI library could become
> all the more important, in my opinion.

You want feature-rich and fast, I prefer dense, clean and spartan, what would
others prefer? Perhaps deciding on a common implementation is harder than it looks.

Greetings,

Indan


