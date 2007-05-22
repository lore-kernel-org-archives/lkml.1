Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbXEVIzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbXEVIzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXEVIzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:55:01 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:16169 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbXEVIzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fDZht5jd5mtMoUUL13YPFp3aPczNymn4vLQFxhs0xN20ZlobvfY6wcH9VYdtQQcS6vOH4SXNbeQYLw+7ZXrBrbCsJ3d1460IXj8N0yaiBkm1niYZAcvJ2aZ6OxeQxLFp1jrTFKYrrZAdS5NW0p8vZhc5T8hrXfghOp+JMZtOUfY=
Message-ID: <4cefeab80705220154k2b02a264id7774600087a80e5@mail.gmail.com>
Date: Tue, 22 May 2007 14:24:59 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [RFC] LZO1X de/compression support
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>
In-Reply-To: <84144f020705180342j4ff44d96iea5b73c23a69df0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
	 <84144f020705180342j4ff44d96iea5b73c23a69df0f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/18/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On 5/18/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > +#define DX2(p,s1,s2) \
> > +       (((((size_t)((p)[2]) << (s2)) ^ (p)[1]) << (s1)) ^ (p)[0])
> > +#define DX3(p,s1,s2,s3) ((DX2((p)+1,s2,s3) << (s1)) ^ (p)[0])
> > +#define DMUL(a,b)      ((size_t) ((a) * (b)))
> > +#define DMS(v,s)       ((size_t) (((v) & (D_MASK >> (s))) << (s)))
> > +#define DM(v)          DMS(v,0)
> > +
> > +#define D_BITS         14
> > +#define DINDEX1(d,p)   d = DM(DMUL(0x21,DX3(p,5,5,6)) >> 5)
> > +#define DINDEX2(d,p)   d = (d & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f)
> > +#define DENTRY(p,in)   (p)
>
> Please make these static inline functions.
>

What if compiler decides not to actully inline them? In that case
there will be significant perf. hit.

> > +#define PTR(a)         ((unsigned long) (a))
> > +#define PTR_LT(a,b)    (PTR(a) < PTR(b))
> > +#define PTR_GE(a,b)    (PTR(a) >= PTR(b))
> > +#define PTR_DIFF(a,b)  (PTR(a) - PTR(b))
> > +#define pd(a,b)                ((size_t) ((a)-(b)))
>
> [snip]
>
> > +#define COPY4(dst,src) *(uint32_t *)(dst) = *(uint32_t *)(src)
>
> Please drop these.
>

Done. Please see newer version posted.

Thanks for comments.

Cheers,
Nitin
