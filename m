Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYGYS0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYGYS0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYGYSZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:25:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:51413 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYGYSZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U8rORREblx+RQBucCh/0YungLyXLVlfb2eGw0BfhuBZH8PM/KtKgmVxRJ2nEX26ywO
         W2y6+VNt0V/uYNseP9opJT68KtRTrYVmz2KNDj2i7ojwByczUdqD9SYb0fbs/CmU3VVN
         0QkP2MA47FOzUfHWXtqM0JCVfzcXK6AtRszW8=
Subject: Re: [PATCH] byteorder: force in-place endian conversion to always
	evaluate args
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <29495f1d0807251122q1f757fbcwd7d793081915957a@mail.gmail.com>
References: <1217003621.5971.4.camel@brick>
	 <29495f1d0807251122q1f757fbcwd7d793081915957a@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 11:25:47 -0700
Message-Id: <1217010347.5971.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 11:22 -0700, Nish Aravamudan wrote:
> On 7/25/08, Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > David Miller reported breakage in ide when the in-place byteorder helpers
> >  were used as the macros do not always evaluate their args which led to
> >  an infinite loop.
> >
> >  Just make them functions to ensure they always do so.
> >
> >  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >  ---
> >   include/linux/byteorder/big_endian.h    |   60 ++++++++++++++++++++++++------
> >   include/linux/byteorder/little_endian.h |   60 ++++++++++++++++++++++++------
> >   2 files changed, 96 insertions(+), 24 deletions(-)
> >
> >  diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
> >  index 961ed4b..b53ccd0 100644
> >  --- a/include/linux/byteorder/big_endian.h
> >  +++ b/include/linux/byteorder/big_endian.h
> >  @@ -88,18 +88,54 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
> >   {
> >         return (__force __u16)*p;
> >   }
> >  -#define __cpu_to_le64s(x) __swab64s((x))
> >  -#define __le64_to_cpus(x) __swab64s((x))
> >  -#define __cpu_to_le32s(x) __swab32s((x))
> >  -#define __le32_to_cpus(x) __swab32s((x))
> >  -#define __cpu_to_le16s(x) __swab16s((x))
> >  -#define __le16_to_cpus(x) __swab16s((x))
> >  -#define __cpu_to_be64s(x) do {} while (0)
> >  -#define __be64_to_cpus(x) do {} while (0)
> >  -#define __cpu_to_be32s(x) do {} while (0)
> >  -#define __be32_to_cpus(x) do {} while (0)
> >  -#define __cpu_to_be16s(x) do {} while (0)
> >  -#define __be16_to_cpus(x) do {} while (0)
> >  +
> >  +static inline void __cpu_to_le64s(__u64 *p)
> >  +{
> >  +       __swab64s(x);
> >  +}
> 
> Shouldn't all the x's in the function bodies be p's? And I thought
> David already posted a macro version of this change along the lines of
> hpa's reply?

*sigh*

Yes they should, I sent the wrong mbox after this failed to compile
and fixed it.

Cheers,

Harvey

