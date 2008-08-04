Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYHDSCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYHDSCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYHDSCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:02:39 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:26918 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYHDSCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:02:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nX8FYXuW+NK5Ngu/GfzefMYEfRCfatZdw+pPJCyKhxinRy86Xx/YCTpindk2y+nUAY
         S03Bn3ND4zSYMFcYkUASPsU4SjTswW8wVlGjTtLq9M64ct1zgtzW0086trqKIvMwbeBO
         Hc0RUK0QJRboJ8BUon8vVCqV2e3Sn8ovQyn88=
Message-ID: <40f323d00808041102s276c065fn8db6f5a79fdf7ad1@mail.gmail.com>
Date: Mon, 4 Aug 2008 20:02:37 +0200
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Cc: "Chris Mason" <chris.mason@oracle.com>, dwmw2@infradead.org,
       austin_zhang@linux.intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <E1KQ2D2-0003Fn-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217857537.29139.70.camel@think.oraclecorp.com>
	 <E1KQ2D2-0003Fn-00@gondolin.me.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 5:42 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Chris Mason <chris.mason@oracle.com> wrote:
>>
>>>From a performance point of view I'm probably reading the crypto API
>> code wrong, but it looks like my choices are to either have a long
>> standing context and use locking around the digest/hash calls to protect
>> internal crypto state, or create a new context every time and take a
>> perf hit while crypto looks up the right module.
>
> You're looking at the old hash interface.  New users should use the
> ahash interface which was only recently added to the kernel.  It
> lets you store the state in the request object which you pass to
> the algorithm on every call.  This means that you only need one
> tfm in the entire system for crc32c.
>
> BTW, don't let the a in ahash intimidate you.  It's meant to support
> synchronous implementations such as the Intel instruction just as
> well as asynchronous ones.

Since I couldn't find any ahash user in the tree (outside of tcrypt.c), can you
provide some example source code as to how to use it (especially synchonously).

For example the code for the digest_null testing would be fine.

regards,

Benoit
