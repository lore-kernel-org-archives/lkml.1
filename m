Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbXDLVd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbXDLVd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXDLVd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:33:59 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:49288 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbXDLVd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:33:58 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Date: Thu, 12 Apr 2007 21:28:54 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <evm8am$h12$2@taverner.cs.berkeley.edu>
References: <4610D25F.7080005@ceid.upatras.gr> <1349.81.207.0.53.1176302225.squirrel@secure.samage.net> <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com> <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1176413334 17442 128.32.168.222 (12 Apr 2007 21:28:54 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 12 Apr 2007 21:28:54 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
>On Thu, April 12, 2007 11:35, Satyam Sharma wrote:
>> 1. First, sorry, I don't think an RSA implementation not conforming to
>> PKCS #1 qualifies to be called RSA at all. That is definitely a *must*
>> -- why break strong crypto algorithms such as RSA by implementing them
>> in insecure ways?
>
>It's still RSA, that it's not enough to get a complete and secure crypto
>system doesn't mean it isn't RSA anymore. Maybe you're right and having
>RSA without the rest makes no sense.

Yes, Satyam Sharma is 100% correct.  Unpadded RSA makes no sense.  RSA is
not secure if you omit the padding.  If you have a good reason why RSA
needs to be in the kernel for security reasons, then the padding has to be
in the kernel, too.  Putting plain unpadded RSA in the kernel seems bogus.

I worry about the quality of this patch if it is using unpadded RSA.
This is pretty elementary stuff.  No one should be implementing their
own crypto code unless they have considerable competence and knowledge
of cryptography.  This elementary error leaves reason to be concerned
about whether the developer of this patch has the skills that are needed
to write this kind of code and get it right.

People often take it personally when I tell them that they do are not
competent to write their own crypto code, but this is not a personal
attack.  It takes very specialized knowledge and considerable study
before one can write your own crypto implementation from scratch and
have a good chance that the result will be secure.  People without
those skills shouldn't be writing their own crypto code, at least not
if security is important, because it's too easy to get something wrong.
(No, just reading Applied Cryptography is not good enough.)  My experience
is that code that contains elementary errors like this is also likely
to contain more subtle errors that are harder to spot.  In short, I'm
not getting warm fuzzies here.

And no, you can't just blithely push padding into user space and expect
that to make the security issues go away.  If you are putting the
RSA exponentiation in the kernel because you don't trust user space,
then you have to put the padding in the kernel, too, otherwise you're
vulnerable to attack from evil user space code.

It is also not true that padding schemes change all the time.  They're
fairly stable.  Pick a reasonable modern padding scheme and leave it.
