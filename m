Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbXJYDRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbXJYDRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbXJYDRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:17:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:7386 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXJYDRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wj7AIFdXo0FKzuWTD760fGW1QHAR1itWrIxWmq5Hgm+wPTT0w2sQoQ/zUalljhoKCVlfXKvbqXaSjxyVMq4ALYvXQEQy+ufPdqgNwDiq/7uWciwhaiuEHNX3n5CuKBnDMy30BzmlcubcjtXZ3bOWMscVh4NH2nlr6/DW/PUBqhg=
Message-ID: <8bd0f97a0710242017ic80272bhec9445e5bf7891c4@mail.gmail.com>
Date: Wed, 24 Oct 2007 23:17:38 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
Cc: "Jie Zhang" <jzhang.linux@gmail.com>, "Adrian Bunk" <bunk@kernel.org>,
       bryan.wu@analog.com, linux-kernel@vger.kernel.org
In-Reply-To: <47200826.1060801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162643.GP30533@stusta.de>
	 <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com>
	 <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com>
	 <47200826.1060801@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Mike Frysinger wrote:
> > On 10/24/07, Jie Zhang <jzhang.linux@gmail.com> wrote:
> >> On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
> >>> "extern inline" will have different semantics with gcc 4.3.
> >>>
> >>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >>>
> >>> --- a/include/asm-blackfin/string.h
> >>> +++ b/include/asm-blackfin/string.h
> >>> @@ -4,7 +4,7 @@
> >>>  #ifdef __KERNEL__              /* only set these up for kernel code */
> >>>
> >>>  #define __HAVE_ARCH_STRCPY
> >>> -extern inline char *strcpy(char *dest, const char *src)
> >>> +static inline char *strcpy(char *dest, const char *src)
> >>>  {
> >>>         char *xdest = dest;
> >>>         char temp = 0;
> >> What if we compile it with gcc 4.1?
> >
> > we'll have to either use the gcc attributes to force old inline
> > behavior or use the gcc flag to force it
>
> We should probably have an extern_inline define then, assuming this is a
> function that does exist in a linkable version already -- otherwise
> "static inline" is correct.

right, we do have string versions in arch/blackfin/lib/ and we do want
the "classical" gcc behavior here with "extern static".  an
extern_inline macro in compiler.h sounds good since
__attribute__((__gnu_inline__)) doesnt exist in gcc-3.4.x (the other
version that works for Blackfin other than gcc-4.1.x).

so i guess NACK this patch since we dont want "static inline" and we
dont yet support gcc-4.3 on Blackfin.
-mike
