Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbXEWBPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbXEWBPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 21:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbXEWBP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 21:15:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:19412 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbXEWBP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 21:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=spxGaH0bNi/idcG/kc17VwsN/UK0fcf1VDm9zQtCifMtVKL958VwSJUVKLC7ZLyrxYbsiXYqHynvl0oQh7umM2nThJDN7ptG1eykoREVDJoUQR2IOlkoFaaF5pcyquSaNovHpVdOipmJh6EpQuszrX8Mif2abCPJmoek45Y5ljM=
Message-ID: <a8e1da0705221815v6d2292c2ra8098e5ce83b70cc@mail.gmail.com>
Date: Wed, 23 May 2007 01:15:25 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.22-rc1-mm1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <465319C1.2080206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <465124EA.1020801@zytor.com>
	 <a8e1da0705202200u5976d14do7ec1469941bb2967@mail.gmail.com>
	 <46512821.9010905@zytor.com>
	 <a8e1da0705202239r31d03a5dyc2f0ce6a795e0124@mail.gmail.com>
	 <465138CC.3060605@zytor.com>
	 <a8e1da0705210141m4d9f0ccevde3060fefcc55537@mail.gmail.com>
	 <4651CA63.9030903@zytor.com>
	 <a8e1da0705211914rf323f90kb67482e47992b5d7@mail.gmail.com>
	 <465319C1.2080206@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have tried the patch, it works.
could you explain it for me? thanks very much.

Regards
dave

2007/5/22, H. Peter Anvin <hpa@zytor.com>:
> Could you try the attached patch for me?
>
>         -hpa
>
> diff --git a/arch/i386/boot/edd.c b/arch/i386/boot/edd.c
> index 84a0302..9697a56 100644
> --- a/arch/i386/boot/edd.c
> +++ b/arch/i386/boot/edd.c
> @@ -47,8 +47,9 @@ static int read_sector(u8 devno, u64 lba, void *buf)
>         si = (size_t)&dapa;
>         dx = devno;
>         asm("pushfl; stc; int $0x13; setc %%al; popfl"
> -           : "+a" (ax), "+S" (si), "+d" (devno)
> -           : : "ebx", "ecx", "edi");
> +           : "+a" (ax), "+S" (si), "+d" (dx)
> +           : "m" (dapa)
> +           : "ebx", "ecx", "edi", "memory");
>
>         if (!(u8)ax)
>                 return 0;       /* OK */
> @@ -59,7 +60,7 @@ static int read_sector(u8 devno, u64 lba, void *buf)
>         bx = (size_t)buf;
>         asm("pushfl; stc; int $0x13; setc %%al; popfl"
>             : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
> -           : : "esi", "edi");
> +           : : "esi", "edi", "memory");
>
>         return -(u8)ax;         /* 0 or -1 */
>  }
>
>
