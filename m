Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXHaJbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXHaJbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbXHaJbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:31:07 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3703 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755608AbXHaJbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:31:03 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jesper.juhl@gmail.com (Jesper Juhl), Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 13/30] net: Don't do pointless kmalloc return value casts in zd1211 driver
Cc: dsd@gentoo.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de,
       linux-wireless@vger.kernel.org
Organization: Core
In-Reply-To: <9a8748490708301320o49d8e794vc5c37ffc938006f1@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev,apana.lists.os.linux.wireless
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IR2pW-0007T2-00@gondolin.me.apana.org.au>
Date: Fri, 31 Aug 2007 17:30:18 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 30/08/2007, Daniel Drake <dsd@gentoo.org> wrote:
>> Jesper Juhl wrote:
>> > Since kmalloc() returns a void pointer there is no reason to cast
>> > its return value.
>> > This patch also removes a pointless initialization of a variable.
>>
>> NAK: adds a sparse warning
>> zd_chip.c:116:15: warning: implicit cast to nocast type
>>
> Ok, I must admit I didn't check with sparse since it seemed pointless
> - we usually never cast void pointers to other pointer types,
> specifically because the C language nicely guarantees that the right
> thing will happen without the cast.  Sometimes we have to cast them to
> integer types, su sure we need the cast there.   But what on earth
> makes a "zd_addr_t *" so special that we have to explicitly cast a
> "void *" to that type?
> 
> I see it's defined as
>  typedef u32 __nocast zd_addr_t;
> in drivers/net/wireless/zd1211rw/zd_types.h , but why the __nocast ?

Nevermind the __nocast, this looks like a bug in sparse.  Just
because a base type is __nocast, sparse shouldn't infer that a
pointer to it should also be __nocast.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
