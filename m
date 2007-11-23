Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbXKWMXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbXKWMXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbXKWMXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:23:10 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3134 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756209AbXKWMXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:23:08 -0500
Date: Fri, 23 Nov 2007 20:22:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tan Swee Heng <thesweeheng@gmail.com>
Cc: Linux Crypto <linux-crypto@vger.kernel.org>, dm-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] dm-crypt: Add support for stream ciphers using blkcipher interface
Message-ID: <20071123122259.GC18862@gondor.apana.org.au>
References: <fd3e431c0711211338r5b7f04e5s4466e193b3f3743f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd3e431c0711211338r5b7f04e5s4466e193b3f3743f@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 05:38:12AM +0800, Tan Swee Heng wrote:
> Current implementation of dm-crypt supports block ciphers of the form
> "template(cipher)", e.g. "cbc(aes)". It does not support stream
> ciphers of the form "cipher", e.g. "salsa20", that uses the blkcipher
> interface directly.
> 
> This patch adds support for stream ciphers using the blkcipher
> interface directly. It uses a special chainmode called "stream".
> Example of usage:
>     cryptsetup luksFormat -c salsa20-stream-plain /dev/loop0

I'd really like to have a new format altogether that does not
involve dashes as a separator.  The reason is that dash is used
as a part of the name of certain algorithms.

Once dm-crypt starts using the givcrypt interface instead of its
own IV generators, we can get away with just a single algorithm
string, of the form

	geniv(mode(block-cipher))

Obviously stream ciphers would just be

	geniv(stream-cipher)

So when that happens we can just use the format "-string" as
that's an invalid specification in the current format.

Of course we'd continue to support the current format as well
which can coexist with the new format forever.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
