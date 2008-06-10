Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYFJCQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYFJCQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 22:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbYFJCP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 22:15:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:36041 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbYFJCPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 22:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X0uF4lzlsaEP39jnooiNhDfW1Ea+TpYfaeLdvuQC0DU2Z/mIInPMsdTr76J4lt80jR
         khIVXzjWCcGb+b//jUnCiBpXZiN88j+x5C2ai7AcQL+ctXV6SY+b16ia+Fxq9PhrgRsY
         xp5tnKES/+rB8Xeuw6BXkkT4CCgx5pCoYFS3A=
Message-ID: <86802c440806091915w273bbb3ck745886e06341eeb0@mail.gmail.com>
Date: Mon, 9 Jun 2008 19:15:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: reserve_bootmem_generic in early_res_to_bootmem
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440806091307r3c4d5e77h12e22abfe578769f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440806091307r3c4d5e77h12e22abfe578769f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 1:07 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> can you make the 64 bit still use reserve_bootmem_generic in
> early_res_to_bootmem?
>
> reserve_bootmem_generic is some smart than reserve_bootmem when numa is enabled.
>
> YH
>
> commit 3f3040c347653b93e4e82ee45bb7d41f11c10be8
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon Jun 9 15:12:20 2008 +0200
>
>    x86: reserve highmem pages via reserve_early, fix #2
>
>    fix:
>
>    arch/x86/kernel/built-in.o: In function `early_res_to_bootmem':
>    : undefined reference to `reserve_bootmem_generic'
>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index a488bd0..68aba41 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -635,7 +635,7 @@ void __init early_res_to_bootmem(u64 start, u64 end)
>                        continue;
>                printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
>                        final_start, final_end - 1, r->name);
> -               reserve_bootmem_generic(final_start, final_end - final_start,
> +               reserve_bootmem(final_start, final_end - final_start,
>                                BOOTMEM_DEFAULT);
>        }
>  }
>

or we need add reserve_bootmem_generic for 32 bit?

YH
