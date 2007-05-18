Return-Path: <linux-kernel-owner+w=401wt.eu-S1762495AbXERKmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762495AbXERKmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760222AbXERKmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:42:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:48041 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760186AbXERKmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=a2v28OGM1FTrAqF9WIpV9psYXn0KqpSBTJklEdy42aDvsQ64++gRxeP6SWCgOFCew4NhWlqTpTpe2ZJcZrW8MXd0kH9wp+zbZnItnlmOLviM8+6MWpE7GzFXcFY3HzfDLGX5w2dXViAeb1gKGL/4sokirFvFyfCTk8JPGCVIGtA=
Message-ID: <84144f020705180342j4ff44d96iea5b73c23a69df0f@mail.gmail.com>
Date: Fri, 18 May 2007 13:42:20 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO1X de/compression support
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>
In-Reply-To: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
X-Google-Sender-Auth: 9de73061853d8678
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> +   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer

[snip]

So how about making that a little less verbose. Say like:

Copyright (c) 1996-2005 Markus Franz Xaver and Johannes Oberhumer

> +#define DX2(p,s1,s2) \
> +       (((((size_t)((p)[2]) << (s2)) ^ (p)[1]) << (s1)) ^ (p)[0])
> +#define DX3(p,s1,s2,s3) ((DX2((p)+1,s2,s3) << (s1)) ^ (p)[0])
> +#define DMUL(a,b)      ((size_t) ((a) * (b)))
> +#define DMS(v,s)       ((size_t) (((v) & (D_MASK >> (s))) << (s)))
> +#define DM(v)          DMS(v,0)
> +
> +#define D_BITS         14
> +#define DINDEX1(d,p)   d = DM(DMUL(0x21,DX3(p,5,5,6)) >> 5)
> +#define DINDEX2(d,p)   d = (d & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f)
> +#define DENTRY(p,in)   (p)

Please make these static inline functions.

> +#define PTR(a)         ((unsigned long) (a))
> +#define PTR_LT(a,b)    (PTR(a) < PTR(b))
> +#define PTR_GE(a,b)    (PTR(a) >= PTR(b))
> +#define PTR_DIFF(a,b)  (PTR(a) - PTR(b))
> +#define pd(a,b)                ((size_t) ((a)-(b)))

[snip]

> +#define COPY4(dst,src) *(uint32_t *)(dst) = *(uint32_t *)(src)

Please drop these.
