Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYGYSWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYGYSWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYGYSWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:22:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:19195 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbYGYSWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u/HgoqdSr9vAtrxgVyujBoNvNXKQGDVF6DwMXUA2CURq4RTk4/L0wrUWsKR2V4DZ5H
         Bk0uQzDC0eYHXR554L4SYfGzuekTjkiJLD5VZvjgeoeLBWEz+PUlJC899984lu1yVVGS
         MZKoOZ5wVung2FA3+coisWgP9+60ueK3C27u8=
Message-ID: <29495f1d0807251122q1f757fbcwd7d793081915957a@mail.gmail.com>
Date: Fri, 25 Jul 2008 11:22:22 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH] byteorder: force in-place endian conversion to always evaluate args
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1217003621.5971.4.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217003621.5971.4.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/08, Harvey Harrison <harvey.harrison@gmail.com> wrote:
> David Miller reported breakage in ide when the in-place byteorder helpers
>  were used as the macros do not always evaluate their args which led to
>  an infinite loop.
>
>  Just make them functions to ensure they always do so.
>
>  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>  ---
>   include/linux/byteorder/big_endian.h    |   60 ++++++++++++++++++++++++------
>   include/linux/byteorder/little_endian.h |   60 ++++++++++++++++++++++++------
>   2 files changed, 96 insertions(+), 24 deletions(-)
>
>  diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
>  index 961ed4b..b53ccd0 100644
>  --- a/include/linux/byteorder/big_endian.h
>  +++ b/include/linux/byteorder/big_endian.h
>  @@ -88,18 +88,54 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
>   {
>         return (__force __u16)*p;
>   }
>  -#define __cpu_to_le64s(x) __swab64s((x))
>  -#define __le64_to_cpus(x) __swab64s((x))
>  -#define __cpu_to_le32s(x) __swab32s((x))
>  -#define __le32_to_cpus(x) __swab32s((x))
>  -#define __cpu_to_le16s(x) __swab16s((x))
>  -#define __le16_to_cpus(x) __swab16s((x))
>  -#define __cpu_to_be64s(x) do {} while (0)
>  -#define __be64_to_cpus(x) do {} while (0)
>  -#define __cpu_to_be32s(x) do {} while (0)
>  -#define __be32_to_cpus(x) do {} while (0)
>  -#define __cpu_to_be16s(x) do {} while (0)
>  -#define __be16_to_cpus(x) do {} while (0)
>  +
>  +static inline void __cpu_to_le64s(__u64 *p)
>  +{
>  +       __swab64s(x);
>  +}

Shouldn't all the x's in the function bodies be p's? And I thought
David already posted a macro version of this change along the lines of
hpa's reply?

Thanks,
Nish
