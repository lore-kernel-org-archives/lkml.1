Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbXDNEbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbXDNEbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 00:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXDNEbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 00:31:09 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1351 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754177AbXDNEbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 00:31:08 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: francis.moro@gmail.com (Francis Moreau)
Subject: Re: [CRYPTO] is it really optimized ?
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Organization: Core
In-Reply-To: <38b2ab8a0704130630v4c840bd1w19f2a239f86a93b@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HcZud-0006DB-00@gondolin.me.apana.org.au>
Date: Sat, 14 Apr 2007 14:30:59 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau <francis.moro@gmail.com> wrote:
> 
> Crypto core already seems to implement a priority mechanism. But I
> don't think I'm able to say "I'd like to use this algo for encrypting
> filesystems. If another part of the kernel wants to use this algo then
> give it the generic one". This choice seems really to depend on the
> system the kernel is running.

It should be easy to restrict a crypto device so that it's used
by one specific user.  That's why we have generic names ("aes") vs.
specific ones ("aes-foo").

So if you let the priority user pick "aes-foo" instead of "aes",
and given that there is a higher priority variant of the generic
"aes" registered, the system will do exactly what you want.

The only part missing right now is the ability to change the priority
of an algorithm so that for example you can let "aes-generic" take
priority over "aes-padlock", but that should be fairly easy to add.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
