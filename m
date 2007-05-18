Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbXERIyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbXERIyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXERIyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:54:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:59568 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbXERIyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AQV/NPHrC4AKhQsMlJg3jV8nVoSEuatCOEGvGckrQkT1KZLCEtbZ7iqp+pxVcco5uSNZm4C3JX/dkBewYu1Qq6wdui4LlMbWnTNGo7FM2PIQL/Kz0C85uI+inTR2st4LHHSWGymUWGokMVLdMQ8NQIgU2kFdNSDXACY0qN0qemo=
Message-ID: <a8e1da0705180154v37e8ec5fs2cc4de9417cd44d2@mail.gmail.com>
Date: Fri, 18 May 2007 08:54:01 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.22-rc1-mm1
Cc: "Andy Whitcroft" <apw@shadowen.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Steve Fox" <drfickle@us.ibm.com>,
       "Mel Gorman" <mel@csn.ul.ie>
In-Reply-To: <464B2048.7040103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have the same problem, your patch fixed it.
My gcc version is 3.4.6

>2007/5/16, H. Peter Anvin <hpa@zytor.com>:
> Andy Whitcroft wrote:
> > Getting this on both x86 and x86_64 boxes, they are the older boxen so
> > likely older compilers:
>
> Please give the gcc version number.
>
> >   CC      arch/x86_64/boot/memory.o
> > arch/i386/boot/memory.c: In function `detect_memory':
> > arch/i386/boot/memory.c:32: error: can't find a register in class `DREG'
> > while reloading `asm'
> >
> > Seems to come from git-netsetup, but that tree isn't pulled into your
> > git version of -mm so I can't be more specific.
>
> Does the following patch work for you?
>
>         -hpa
>
>
> diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
> index 8a82aa9..d7b250b 100644
> --- a/arch/i386/boot/memory.c
> +++ b/arch/i386/boot/memory.c
> @@ -30,7 +30,7 @@ static int detect_memory_e820(void)
>                 size = sizeof(struct e820entry);
>                 id = SMAP;
>                 asm("int $0x15; setc %0"
> -                   : "=dm" (err), "+b" (next), "+d" (id), "+c" (size),
> +                   : "=am" (err), "+b" (next), "+d" (id), "+c" (size),
>                       "=m" (*desc)
>                     : "D" (desc), "a" (0xe820));
>

Regards
dave
