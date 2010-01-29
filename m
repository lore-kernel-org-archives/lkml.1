Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478Ab0A2KcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0A2KcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877Ab0A2KcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:32:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56377 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0A2KcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q4yCrQOGTMRdnL3E5u3fh/WCtzx+RbOOJBRcExrX+FSTErZhZxTfPK/N+oAuzITxyq
         I9uxeuJyPhRbJySD52yjSHbKvgxPgdxjFslu9vSnQX1HQCu/T2CuydGy9WnFf5yWCSyi
         Y6IUBK2k6Po5kV96aQT43/6GIUPPRu1PkGhTI=
MIME-Version: 1.0
In-Reply-To: <20100122155535.797688466@chello.nl>
References: <20100122155044.391857484@chello.nl>
	 <20100122155535.797688466@chello.nl>
Date: Fri, 29 Jan 2010 11:32:00 +0100
X-Google-Sender-Auth: f47124efd4e5f81b
Message-ID: <520f0cf11001290232p38140fb2sa5da1b7f8e2704cc@mail.gmail.com>
Subject: Re: [PATCH 07/10] bitops: Provide compile time HWEIGHT{8,16,32,64}
From: John Kacur <jkacur@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 4:50 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Provide compile time versions of hweight.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  include/linux/bitops.h |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> Index: linux-2.6/include/linux/bitops.h
> ===================================================================
> --- linux-2.6.orig/include/linux/bitops.h
> +++ linux-2.6/include/linux/bitops.h
> @@ -45,6 +45,20 @@ static inline unsigned long hweight_long
>        return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
>  }

I like it. Maybe provide a comment that this provides the Hamming weight, it
took me a second to realize what this was.

>
> +#define HWEIGHT8(w)                    \
> +      (        (!!((w) & (1ULL << 0))) +       \
> +       (!!((w) & (1ULL << 1))) +       \
> +       (!!((w) & (1ULL << 2))) +       \
> +       (!!((w) & (1ULL << 3))) +       \
> +       (!!((w) & (1ULL << 4))) +       \
> +       (!!((w) & (1ULL << 5))) +       \
> +       (!!((w) & (1ULL << 6))) +       \
> +       (!!((w) & (1ULL << 7))) )
> +
> +#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8(w >> 8))
> +#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16(w >> 16))
> +#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32(w >> 32))
> +
>  /**
>  * rol32 - rotate a 32-bit value left
>  * @word: value to rotate
>
> --
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
