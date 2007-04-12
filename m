Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbXDLXbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbXDLXbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbXDLXbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:31:20 -0400
Received: from neon.samage.net ([85.17.153.66]:47939 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbXDLXbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:31:18 -0400
Message-ID: <4264.81.207.0.53.1176420676.squirrel@secure.samage.net>
In-Reply-To: <evm8am$h12$2@taverner.cs.berkeley.edu>
References: <4610D25F.7080005@ceid.upatras.gr>
    <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
    <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
    <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
    <evm8am$h12$2@taverner.cs.berkeley.edu>
Date: Fri, 13 Apr 2007 01:31:16 +0200 (CEST)
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
From: "Indan Zupancic" <indan@nul.nu>
To: "David Wagner" <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org, "Tasos Parisinos" <t.parisinos@sciensis.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 6c56b5a68734eff3bb82063186e8a5cf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Next time, please do a reply-all so CC's aren't dropped.

It seems you jumped halfway in, missing some background info, I'll try to
clarify some things.

On Thu, April 12, 2007 23:28, David Wagner wrote:
> Yes, Satyam Sharma is 100% correct.  Unpadded RSA makes no sense.  RSA is
> not secure if you omit the padding.  If you have a good reason why RSA
> needs to be in the kernel for security reasons, then the padding has to be
> in the kernel, too.  Putting plain unpadded RSA in the kernel seems bogus.

He is correct, I only argued that's it can still be named RSA (which Satyam
disputed), no matter what critical features are missing for a complete
infrastructure.

I don't know if you read the patch, but right now it's only a multi-precision
integer implementation, useful to implement RSA. The rest, including the
binary checking, is missing. We're pondering a bit about what, in the end,
would be useful to have in or around the kernel.


> I worry about the quality of this patch if it is using unpadded RSA.
> This is pretty elementary stuff.  No one should be implementing their
> own crypto code unless they have considerable competence and knowledge
> of cryptography.  This elementary error leaves reason to be concerned
> about whether the developer of this patch has the skills that are needed
> to write this kind of code and get it right.

As said above, the patch is only an MPI implementation, not RSA, and neither
the rest to make it useful, like a crypto API interface and padding.

So we can't really judge the developer's skills or crypto knowledge.

It does point out that having a hidden implementation can never foster
much trust, as no one can read the code and judge if it's good or not.


> People often take it personally when I tell them that they do are not
> competent to write their own crypto code, but this is not a personal
> attack.  It takes very specialized knowledge and considerable study
> before one can write your own crypto implementation from scratch and
> have a good chance that the result will be secure.  People without
> those skills shouldn't be writing their own crypto code, at least not
> if security is important, because it's too easy to get something wrong.

To a certain degree you're right, but the nice thing about open source is
that people who know better can spot errors, and if those are fixed, it
can happen that an "incompetent" person created something excellent. Maybe
not at first, but in the end. (I suspect that a good coder with no crypto
knowledge, but with feedback from experts, can implement something better
than one expert with mediocre coding skills.)

The code should be judged, not the people writing it. Besides, it isn't
always that hard to get something secure, if things are kept simple and
straightforward. E.g. writing a secure AES implementation isn't magic.
RSA is much more complex though. (Rather ironic, as the theory behind RSA
is simple, but the implementation hairy. With AES it's exactly the opposite.
The coder doesn't need to understand the algebra behind it, knowing that it
can be done with a simple table lookup is enough).

In general the tricky part is around the crypto implementation itself, how
it's used, key management, etc. (Though the border is vague, so maybe you
included all that when saying "crypto implementation".)


> (No, just reading Applied Cryptography is not good enough.)  My experience
> is that code that contains elementary errors like this is also likely
> to contain more subtle errors that are harder to spot.  In short, I'm
> not getting warm fuzzies here.

The code posted has no such errors, see above. Maybe the part that wasn't has,
who knows.


> And no, you can't just blithely push padding into user space and expect
> that to make the security issues go away.  If you are putting the
> RSA exponentiation in the kernel because you don't trust user space,
> then you have to put the padding in the kernel, too, otherwise you're
> vulnerable to attack from evil user space code.

True, but the code wasn't put into the kernel for security reasons. Why it
was remains a bit of a mystery, but it looks like it was for convenience.

Greetings,

Indan


