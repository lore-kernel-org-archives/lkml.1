Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZCJT5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZCJT5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbZCJT5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:57:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:10329 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbZCJT5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=l2lLXH/0N683Cq2SJ8OaIXvKT0UuhTTrJIyZHECeypSEGBUMd+SAzGWQoMxAYbMfxH
         Dp8QzvzyKm4YWY/MosDTE5UiSGOCAee+ms0LnA77btl4MCFdr3rD06tR/wAxJdbVrwSN
         eFLX2q/2YHW+hrYuH5e8oFBUuEcV+S3z8ff0o=
MIME-Version: 1.0
In-Reply-To: <49B6B821.5050302@oracle.com>
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
	 <49B6B821.5050302@oracle.com>
Date: Tue, 10 Mar 2009 20:56:59 +0100
X-Google-Sender-Auth: 075ad9d6f3007b07
Message-ID: <10f740e80903101256v2cfe08a8g410c297e019d8693@mail.gmail.com>
Subject: Re: linux-next: Tree for March 10 (crypto & NLATTR)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
       David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 19:57, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Stephen Rothwell wrote:
>> Changes since 20090306:
>>
>>
>> The driver-core tree gained a build failure due to a conflict with the
>> crypto tree.  I have applied a patch to the crypto tree for today.
>
> I had several (4 of 50) randconfig builds fail with:
>
> lib/built-in.o: In function `__nla_reserve_nohdr':
> (.text+0xd08d): undefined reference to `skb_put'
> lib/built-in.o: In function `__nla_reserve':
> (.text+0xd121): undefined reference to `skb_put'
> lib/built-in.o: In function `nla_append':
> (.text+0xd493): undefined reference to `skb_put'
>
> which happens with CONFIG_NET=n, CONFIG_CRYPTO=y, CONFIG_CRYPTO_ZLIB=[my].
>
> CRYPTO_ZLIB selects NLATTR, but obviously the build of nlattr.c fails
> when CONFIG_NET=n.  Should CRYPTO_ZLIB depend on NET?
> Please don't say that CRYPTO_ZLIB should select NET.

Bummer, my fault (commit e9cc8bddaea3944fabfebb968bc88d603239beed,
netlink: Move netlink attribute parsing support to lib).

Obviously I was only worried about crypto/zlib.c needing nlattr.c
without pulling in the whole networking code, not about nlattr.c
itself needing networking functionality. But still, how could I have
missed this compile failure?

Does it sound sane to protect the routines that do call skb_put() by
#ifdef CONFIG_NET?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
