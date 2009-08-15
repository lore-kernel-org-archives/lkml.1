Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZHOHKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZHOHKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 03:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZHOHKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 03:10:40 -0400
Received: from claw.goop.org ([74.207.240.146]:56824 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZHOHKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 03:10:40 -0400
Message-ID: <4A865F6B.20208@goop.org>
Date: Sat, 15 Aug 2009 00:10:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: ohyama_sec@ariel-networks.com
CC: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86 : omit duplicate processing at pte_pgprot()
References: <20090809154312.62D1A378124@ns.ariel-networks.com>
In-Reply-To: <20090809154312.62D1A378124@ns.ariel-networks.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/09 08:43, ohyama_sec@ariel-networks.com wrote:
> I suggest following PATCH that omit duplicate processing of mask.
>
> pte_pgprot() macro [arch/x86/include/asm/pgtable.h] call pte_flags() [arch/x86/include/asm/pgtable_types.h] that return value is masked by PTE_FLAGS_MASK in pte_flags() function, and this macro also masks the returned value by PTE_FLAGS_MASK.
>   

It probably won't make any difference in practice, because gcc will do a
common subexpression elimination for the "& PTE_FLAGS_MASK" between the
inline function and its caller.  But it does tidy things up a bit.

> I guess that we don't have to do the mask processing at pte_pgprot() macro because it has already been masked at pte_flags().
> So, how about the following PATCH ?
>
> 	<Hiroyasu OHYAMA>
>   

Please add a proper Signed-off-by: line.

Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>

    J
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 3cc06e3..a0b454c 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -265,7 +265,7 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
>         return __pgprot(preservebits | addbits);
>          }
>
>          -#define pte_pgprot(x) __pgprot(pte_flags(x) & PTE_FLAGS_MASK)
>          +#define pte_pgprot(x) __pgprot(pte_flags(x))
>
>           #define canon_pgprot(p) __pgprot(massage_pgprot(p))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

